package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.IntPoint2D;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.specifics.HarrisCornerOptions;
import vision.exceptions.PanoramaError;

private typedef Feature = {
	final point:IntPoint2D;
	final patch:Array<Float>;
}

private typedef Match = {
	final source:IntPoint2D;
	final target:IntPoint2D;
}

/** Registers and blends an ordered sequence of overlapping images. **/
class Panorama {
	static inline var PATCH_RADIUS = 4;

	public static function stitch(images:Array<Image>):Image {
		if (images.length == 0) throw new PanoramaError("Provide at least one panorama image.");
		for (image in images)
			if (image.width == 0 || image.height == 0)
				throw new PanoramaError("Panorama images must have positive dimensions.");
		if (images.length == 1) return images[0].clone();

		final transforms:Array<Matrix2D> = [Matrix2D.IDENTITY()];
		var previous = describe(images[0]);
		for (i in 1...images.length) {
			final current = describe(images[i]);
			final transform = estimate(match(current, previous));
			if (transform == null)
				throw new PanoramaError('Could not align images ${i - 1} and ${i}.');
			transforms.push(Matrix2D.multiplyMatrices(transforms[i - 1], transform));
			previous = current;
		}
		return blend(images, transforms);
	}

	static function describe(image:Image):Array<Feature> {
		final options = new HarrisCornerOptions();
		options.borderMargin = PATCH_RADIUS;
		options.minimumDistance = 4;
		options.relativeThreshold = 0.0005;
		options.maxCorners = 450;
		final features = [];
		for (point in Harris.detectCorners(image, options)) {
			final patch = [];
			var total = 0.0;
			for (dy in -PATCH_RADIUS...PATCH_RADIUS + 1)
				for (dx in -PATCH_RADIUS...PATCH_RADIUS + 1) {
					final color = image.getUnsafePixel(point.x + dx, point.y + dy);
					final value = 0.299 * color.red + 0.587 * color.green + 0.114 * color.blue;
					patch.push(value);
					total += value;
				}
			final mean = total / patch.length;
			var energy = 0.0;
			for (i in 0...patch.length) {
				patch[i] -= mean;
				energy += patch[i] * patch[i];
			}
			if (energy < 1e-6) continue;
			final norm = Math.sqrt(energy);
			for (i in 0...patch.length) patch[i] /= norm;
			features.push({point: point, patch: patch});
		}
		return features;
	}

	static function nearest(feature:Feature, choices:Array<Feature>):Int {
		var best = -1;
		var first = Math.POSITIVE_INFINITY;
		var second = Math.POSITIVE_INFINITY;
		for (i in 0...choices.length) {
			final patch = choices[i].patch;
			var distance = 0.0;
			for (j in 0...patch.length) {
				final difference = feature.patch[j] - patch[j];
				distance += difference * difference;
			}
			if (distance < first) {
				second = first;
				first = distance;
				best = i;
			} else if (distance < second) {
				second = distance;
			}
		}
		return first < 0.64 * second ? best : -1;
	}

	static function match(source:Array<Feature>, target:Array<Feature>):Array<Match> {
		final reverse = [for (feature in target) nearest(feature, source)];
		final matches = [];
		for (i in 0...source.length) {
			final j = nearest(source[i], target);
			if (j >= 0 && reverse[j] == i) matches.push({source: source[i].point, target: target[j].point});
		}
		return matches;
	}

	static function estimate(matches:Array<Match>):Null<Matrix2D> {
		if (matches.length < 6) return null;
		var best:Array<Match> = [];
		var bestError = Math.POSITIVE_INFINITY;
		for (_ in 0...384) {
			final sample = [];
			final chosen = [];
			while (sample.length < 4) {
				final index = Std.random(matches.length);
				if (chosen.contains(index)) continue;
				chosen.push(index);
				sample.push(matches[index]);
			}
			final candidate = fit(sample);
			if (candidate == null) continue;
			final inliers = [];
			var error = 0.0;
			for (pair in matches) {
				final mapped = project(candidate, pair.source.x, pair.source.y);
				final dx = mapped.x - pair.target.x;
				final dy = mapped.y - pair.target.y;
				final squared = dx * dx + dy * dy;
				if (!(squared <= 9)) continue;
				error += squared;
				inliers.push(pair);
			}
			if (inliers.length > best.length || (inliers.length == best.length && error < bestError)) {
				best = inliers;
				bestError = error;
				if (best.length == matches.length && error < 1e-6) break;
			}
		}
		return best.length >= 6 && best.length >= matches.length * 0.25 ? fit(best) : null;
	}

	static function fit(matches:Array<Match>):Null<Matrix2D> {
		// Solve the eight projective coefficients with the last coefficient fixed to one.
		final system = [for (_ in 0...8) [for (_ in 0...9) 0.0]];
		for (pair in matches) {
			final x:Float = pair.source.x;
			final y:Float = pair.source.y;
			final u:Float = pair.target.x;
			final v:Float = pair.target.y;
			final horizontal = [x, y, 1.0, 0.0, 0.0, 0.0, -x * u, -y * u, u];
			final vertical = [0.0, 0.0, 0.0, x, y, 1.0, -x * v, -y * v, v];
			for (row in 0...8)
				for (column in 0...9)
					system[row][column] += horizontal[row] * horizontal[column] + vertical[row] * vertical[column];
		}
		for (column in 0...8) {
			var pivot = column;
			for (row in column + 1...8)
				if (Math.abs(system[row][column]) > Math.abs(system[pivot][column])) pivot = row;
			final divisor = system[pivot][column];
			if (Math.abs(divisor) < 1e-9) return null;
			final current = system[pivot];
			system[pivot] = system[column];
			system[column] = current;
			for (i in column...9) current[i] /= divisor;
			for (row in 0...8) {
				if (row == column) continue;
				final factor = system[row][column];
				for (i in column...9) system[row][i] -= factor * current[i];
			}
		}
		final matrix = new Matrix2D(3, 3, 1);
		for (i in 0...8) matrix.set(i % 3, Std.int(i / 3), system[i][8]);
		return Math.abs(matrix.getDeterminant()) < 1e-9 ? null : matrix;
	}

	static inline function depth(matrix:Matrix2D, x:Float, y:Float):Float {
		return matrix.get(0, 2) * x + matrix.get(1, 2) * y + matrix.get(2, 2);
	}

	static inline function project(matrix:Matrix2D, x:Float, y:Float):Point2D {
		final w = depth(matrix, x, y);
		return new Point2D((matrix.get(0, 0) * x + matrix.get(1, 0) * y + matrix.get(2, 0)) / w,
			(matrix.get(0, 1) * x + matrix.get(1, 1) * y + matrix.get(2, 1)) / w);
	}

	static function blend(images:Array<Image>, transforms:Array<Matrix2D>):Image {
		var left = 0.0;
		var top = 0.0;
		var right = 0.0;
		var bottom = 0.0;
		final inverse = [];
		for (i in 0...images.length) {
			final image = images[i];
			var transform = transforms[i];
			final origin = depth(transform, 0, 0);
			for (y in [0, image.height - 1])
				for (x in [0, image.width - 1]) {
					if (origin * depth(transform, x, y) <= 0)
						throw new PanoramaError("A panorama image crosses the projection horizon.");
					final p = project(transform, x, y);
					left = Math.min(left, p.x);
					top = Math.min(top, p.y);
					right = Math.max(right, p.x);
					bottom = Math.max(bottom, p.y);
				}
			inverse.push(transform.invert());
		}
		final width = Math.ceil(right - 1e-6) - Math.floor(left + 1e-6) + 1;
		final height = Math.ceil(bottom - 1e-6) - Math.floor(top + 1e-6) + 1;
		if (width <= 0 || height <= 0 || width * 1.0 * height > 64000000 #if !vision_higher_width_cap || width > 0xffff #end)
			throw new PanoramaError("The panorama bounds are too large.");
		final result = new Image(width, height);
		final startX = Math.floor(left + 1e-6);
		final startY = Math.floor(top + 1e-6);
		for (y in 0...height)
			for (x in 0...width) {
				var red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0, coverage = 0.0;
				for (i in 0...images.length) {
					final image = images[i];
					final point = project(inverse[i], x + startX, y + startY);
					final px = point.x, py = point.y;
					if (!(px >= -1e-6 && py >= -1e-6 && px <= image.width - 1 + 1e-6 && py <= image.height - 1 + 1e-6)) continue;
					final sx = Math.max(0, Math.min(px, image.width - 1));
					final sy = Math.max(0, Math.min(py, image.height - 1));
					final color = image.getFloatingPixel(sx, sy);
					final weight = 1 + Math.min(24, Math.min(Math.min(sx, image.width - 1 - sx), Math.min(sy, image.height - 1 - sy)));
					final opacity = weight * color.alphaFloat;
					red += color.red * opacity;
					green += color.green * opacity;
					blue += color.blue * opacity;
					alpha += opacity;
					coverage += weight;
				}
				if (alpha > 0)
					result.setUnsafePixel(x, y, Color.fromRGBA(Math.round(red / alpha), Math.round(green / alpha), Math.round(blue / alpha),
						Math.round(alpha * 255 / coverage)));
			}
		return result;
	}
}

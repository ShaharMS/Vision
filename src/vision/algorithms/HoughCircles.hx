package vision.algorithms;

import haxe.ds.StringMap;
import vision.ds.Circle2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.canny.CannyObject;
import vision.ds.specifics.HoughCircleOptions;

using vision.algorithms.Canny;
using vision.tools.ImageTools;

class HoughCircles {
	public static function detect(image:Image, options:HoughCircleOptions):Array<Circle2D> {
		if (image.width <= 0 || image.height <= 0) {
			return [];
		}

		var scale = resolveDp(options);
		var radiusRange = resolveRadiusRange(image, options);
		if (radiusRange.max < radiusRange.min) {
			return [];
		}

		var preparedImage = prepareImage(image, options);
		var edgeImage = detectEdges(preparedImage, options);
		if (countEdges(edgeImage) == 0) {
			return [];
		}

		var circles = collectCircles(preparedImage, edgeImage, radiusRange, scale, options, false);
		if (circles.length == 0) {
			circles = collectCircles(preparedImage, edgeImage, radiusRange, scale, options, true);
		}

		circles.sort(compareCircles);
		return suppressDuplicates(circles, options.minimumDistance);
	}

	static function collectCircles(preparedImage:Image, edgeImage:Image, radiusRange:{min:Int, max:Int}, scale:Float, options:HoughCircleOptions, useSweepFallback:Bool):Array<Circle2D> {
		var accumulatorWidth = Std.int(Math.ceil(preparedImage.width / scale));
		var accumulatorHeight = Std.int(Math.ceil(preparedImage.height / scale));
		if (accumulatorWidth <= 0 || accumulatorHeight <= 0) {
			return [];
		}

		var circles:Array<Circle2D> = [];
		for (radius in radiusRange.min...radiusRange.max + 1) {
			var accumulator = new Matrix2D(accumulatorWidth, accumulatorHeight);
			accumulator.fill(0);
			voteForRadius(preparedImage, edgeImage, accumulator, radius, scale, useSweepFallback);
			extractCircles(circles, accumulator, edgeImage, radius, scale, options);
		}
		return circles;
	}

	static function prepareImage(image:Image, options:HoughCircleOptions):Image {
		var cannyObject:CannyObject = image.clone().removeView();
		cannyObject = cannyObject.grayscale();
		if (options.blurRadius > 0) {
			var blurred = medianBlur(cast cannyObject, options.blurRadius);
			if (countEdges(blurred) > 0) {
				cannyObject = cast blurred;
			}
		}
		return cast cannyObject;
	}

	static function detectEdges(image:Image, options:HoughCircleOptions):Image {
		var cannyObject:CannyObject = image.clone().removeView();
		cannyObject = cannyObject.applySobelFilters();
		cannyObject = cannyObject.nonMaxSuppression();
		cannyObject = cannyObject.applyHysteresis(normalizeThreshold(options.cannyHighThreshold), normalizeThreshold(options.cannyLowThreshold));
		return cast cannyObject;
	}

	static function voteForRadius(source:Image, edgeImage:Image, accumulator:Matrix2D, radius:Int, scale:Float, useSweepFallback:Bool):Void {
		for (x in 0...edgeImage.width) {
			for (y in 0...edgeImage.height) {
				if (!isEdge(edgeImage.getPixel(x, y))) {
					continue;
				}

				if (useSweepFallback) {
					voteAroundEdge(accumulator, x, y, radius, scale);
					continue;
				}

				var gradient = getGradient(source, x, y);
				if (gradient.length <= 0.0001) {
					voteAroundEdge(accumulator, x, y, radius, scale);
					continue;
				}

				var directionX = gradient.x / gradient.length;
				var directionY = gradient.y / gradient.length;
				voteCenter(accumulator, x - directionX * radius, y - directionY * radius, scale);
				voteCenter(accumulator, x + directionX * radius, y + directionY * radius, scale);
			}
		}
	}

	static function voteAroundEdge(accumulator:Matrix2D, x:Int, y:Int, radius:Int, scale:Float):Void {
		var sampleCount = resolvePerimeterSampleCount(radius);
		for (sampleIndex in 0...sampleCount) {
			var angle = resolvePerimeterAngle(sampleIndex, sampleCount);
			voteCenter(accumulator, x - Math.cos(angle) * radius, y - Math.sin(angle) * radius, scale);
		}
	}

	static function extractCircles(circles:Array<Circle2D>, accumulator:Matrix2D, edgeImage:Image, radius:Int, scale:Float, options:HoughCircleOptions):Void {
		var threshold = options.centerThreshold > 0 ? options.centerThreshold : 1;
		for (x in 0...accumulator.width) {
			for (y in 0...accumulator.height) {
				var votes = accumulator.get(x, y);
				if (votes < threshold || !isPeak(accumulator, x, y, votes)) {
					continue;
				}
				var centerX = x * scale;
				var centerY = y * scale;
				if (!hasPerimeterSupport(edgeImage, centerX, centerY, radius, options)) {
					continue;
				}
				circles.push(new Circle2D(new Point2D(centerX, centerY), radius, votes));
			}
		}
	}

	static function suppressDuplicates(circles:Array<Circle2D>, minimumDistance:Float):Array<Circle2D> {
		var accepted:Array<Circle2D> = [];
		for (circle in circles) {
			if (!isSeparated(circle, accepted, minimumDistance)) {
				continue;
			}
			accepted.push(circle);
		}
		return accepted;
	}

	static function medianBlur(image:Image, radius:Int):Image {
		var kernelSize = radius * 2 + 1;
		if (kernelSize <= 1) {
			return image;
		}

		var blurred = image.clone();
		image.forEachPixel((x, y, color) -> {
			var neighbors = [for (neighbor in image.getNeighborsOfPixelIter(x, y, kernelSize)) neighbor.red];
			neighbors.sort((lhs, rhs) -> lhs - rhs);
			var gray = neighbors[Std.int(neighbors.length / 2)];
			blurred.setPixel(x, y, Color.fromRGBA(gray, gray, gray, color.alpha));
		});
		return blurred;
	}

	static function countEdges(image:Image):Int {
		var count = 0;
		image.forEachPixel((x, y, color) -> {
			if (isEdge(color)) {
				count++;
			}
		});
		return count;
	}

	static function hasPerimeterSupport(edgeImage:Image, centerX:Float, centerY:Float, radius:Int, options:HoughCircleOptions):Bool {
		var visited = new StringMap<Bool>();
		var support = 0;
		var sampleCount = resolvePerimeterSampleCount(radius);
		for (sampleIndex in 0...sampleCount) {
			var angle = resolvePerimeterAngle(sampleIndex, sampleCount);
			var sampleX = Std.int(Math.round(centerX + Math.cos(angle) * radius));
			var sampleY = Std.int(Math.round(centerY + Math.sin(angle) * radius));
			if (sampleX >= 0 && sampleX < edgeImage.width && sampleY >= 0 && sampleY < edgeImage.height) {
				var key = sampleX + ':' + sampleY;
				if (!visited.exists(key)) {
					visited.set(key, true);
					if (isEdge(edgeImage.getPixel(sampleX, sampleY))) {
						support++;
					}
				}
			}
		}
		return support >= resolveSupportThreshold(radius, options);
	}

	static function getGradient(image:Image, x:Int, y:Int):{x:Float, y:Float, length:Float} {
		var gradientX = image.getSafePixel(x + 1, y).red - image.getSafePixel(x - 1, y).red;
		var gradientY = image.getSafePixel(x, y + 1).red - image.getSafePixel(x, y - 1).red;
		var length = Math.sqrt(gradientX * gradientX + gradientY * gradientY);
		return {x: gradientX, y: gradientY, length: length};
	}

	static function isSeparated(circle:Circle2D, accepted:Array<Circle2D>, minimumDistance:Float):Bool {
		for (existing in accepted) {
			var distance = circle.center.distanceTo(existing.center);
			if (distance <= 1.0 && Math.abs(circle.radius - existing.radius) <= 1.0) {
				return false;
			}
			if (minimumDistance > 0 && distance < minimumDistance) {
				return false;
			}
		}
		return true;
	}

	static function compareCircles(lhs:Circle2D, rhs:Circle2D):Int {
		if (lhs.votes > rhs.votes) return -1;
		if (lhs.votes < rhs.votes) return 1;
		if (lhs.radius > rhs.radius) return -1;
		if (lhs.radius < rhs.radius) return 1;
		if (lhs.center.y < rhs.center.y) return -1;
		if (lhs.center.y > rhs.center.y) return 1;
		if (lhs.center.x < rhs.center.x) return -1;
		if (lhs.center.x > rhs.center.x) return 1;
		return 0;
	}

	static function isPeak(accumulator:Matrix2D, x:Int, y:Int, votes:Float):Bool {
		for (neighborX in x - 1...x + 2) {
			if (neighborX < 0 || neighborX >= accumulator.width) {
				continue;
			}
			for (neighborY in y - 1...y + 2) {
				if (neighborY < 0 || neighborY >= accumulator.height) {
					continue;
				}
				if (neighborX == x && neighborY == y) {
					continue;
				}
				var neighborVotes = accumulator.get(neighborX, neighborY);
				if (neighborVotes > votes || (neighborVotes == votes && isEarlierPeak(neighborX, neighborY, x, y))) {
					return false;
				}
			}
		}
		return true;
	}

	static inline function isEarlierPeak(neighborX:Int, neighborY:Int, x:Int, y:Int):Bool {
		return neighborX < x || (neighborX == x && neighborY < y);
	}

	static inline function voteCenter(accumulator:Matrix2D, centerX:Float, centerY:Float, scale:Float):Void {
		var x = Std.int(Math.round(centerX / scale));
		var y = Std.int(Math.round(centerY / scale));
		if (x < 0 || x >= accumulator.width || y < 0 || y >= accumulator.height) {
			return;
		}
		accumulator.set(x, y, accumulator.get(x, y) + 1);
	}

	static inline function isEdge(color:Color):Bool {
		return color.red > 0 || color.green > 0 || color.blue > 0;
	}

	static inline function resolveDp(options:HoughCircleOptions):Float {
		return options.dp >= 1 ? options.dp : 1.0;
	}

	static function resolveRadiusRange(image:Image, options:HoughCircleOptions):{min:Int, max:Int} {
		var minRadius = options.minimumRadius > 0 ? options.minimumRadius : 1;
		var maxRadius = options.maximumRadius > 0 ? options.maximumRadius : Std.int(Math.floor(Math.min(image.width, image.height) / 2));
		return {min: minRadius, max: maxRadius};
	}

	static inline function normalizeThreshold(value:Float):Float {
		if (value <= 0) {
			return 0;
		}
		var normalized = value > 1 ? value / 255 : value;
		return normalized > 1 ? 1 : normalized;
	}

	static inline function resolvePerimeterSampleCount(radius:Int):Int {
		return Std.int(Math.max(72, Math.ceil(Math.PI * 2 * Math.max(radius, 1))));
	}

	static inline function resolvePerimeterAngle(sampleIndex:Int, sampleCount:Int):Float {
		return (sampleIndex / sampleCount) * Math.PI * 2;
	}

	static inline function resolveSupportThreshold(radius:Int, options:HoughCircleOptions):Float {
		return Math.max(options.centerThreshold, radius * 2);
	}
}
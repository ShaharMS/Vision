package vision.algorithms;

import haxe.ds.IntMap;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.kmeans.ColorCluster;
import vision.exceptions.VisionException;

/** Mini-batch color clustering using exponential moving averages. **/
class EMeans {
	public static function getImageColorClusters(image:Image, clusterAmount:Int = 16, epochs:Int = 5):Array<ColorCluster> {
		if (clusterAmount <= 0 || epochs <= 0) {
			#if vision_quiet
			return [];
			#else
			throw new VisionException("Cluster amount and epochs must be positive.", "EMeans Error");
			#end
		}

		final seen = new IntMap<Bool>();
		final colors = [];
		image.forEachPixel((_, _, color) -> {
			if (!seen.exists(color)) {
				seen.set(color, true);
				colors.push(color);
			}
		});
		final size = colors.length;
		final count = Std.int(Math.min(clusterAmount, size));
		if (count == size) return [for (color in colors) new ColorCluster(color, [color])];
		if (count == 1) return [new ColorCluster(mean(colors), colors)];

		shuffle(colors);
		final running = [for (i in 0...count) new ColorSum(colors[i], 1e-10)];
		final assigned = [for (_ in 0...count) new Array<Color>()];
		final batch = [for (_ in 0...count) new ColorSum()];
		// Default batch and peak-step scaling laws from arXiv:2611.09501.
		final estimatedBatch = 0.035 * Math.pow(count, 0.13) * Math.pow(size, 0.88) * Math.pow(epochs, 0.81);
		final batchSize = Std.int(Math.min(size, Math.max(1, Math.pow(2, Math.round(Math.log(estimatedBatch) / Math.log(2))))));
		final peak = Math.min(1, 0.824 * Math.pow(count, -0.46) * Math.pow(batchSize, 0.90) * Math.pow(size, -0.45) * Math.pow(epochs, -0.11));
		final updates = epochs * Math.ceil(size / batchSize);
		var update = 0;

		for (epoch in 0...epochs) {
			shuffle(colors);
			var start = 0;
			while (start < size) {
				final end = Std.int(Math.min(start + batchSize, size));
				for (sum in batch) sum.clear();
				for (i in start...end) {
					final color = colors[i];
					final index = nearest(color, running);
					batch[index].add(color);
					if (epoch == epochs - 1) assigned[index].push(color);
				}
				final step = peak * (0.1 + 0.45 * (1 + Math.cos(Math.PI * update / Math.max(1, updates - 1))));
				for (i in 0...count) running[i].blend(batch[i], step);
				if (++update % 5 == 0) revive(running);
				start = end;
			}
		}

		return [for (group in assigned) if (group.length > 0) new ColorCluster(mean(group), group)];
	}

	static function shuffle(colors:Array<Color>):Void {
		var i = colors.length;
		while (--i > 0) {
			final j = Std.random(i + 1);
			final color = colors[i];
			colors[i] = colors[j];
			colors[j] = color;
		}
	}

	static function nearest(color:Color, sums:Array<ColorSum>):Int {
		var best = 0;
		var distance = Math.POSITIVE_INFINITY;
		for (i in 0...sums.length) {
			final sum = sums[i];
			final red = color.red - sum.red / sum.count;
			final green = color.green - sum.green / sum.count;
			final blue = color.blue - sum.blue / sum.count;
			final alpha = color.alpha - sum.alpha / sum.count;
			final current = red * red + green * green + blue * blue + alpha * alpha;
			if (current < distance) {
				best = i;
				distance = current;
			}
		}
		return best;
	}

	static function revive(sums:Array<ColorSum>):Void {
		var total = 0.0;
		for (sum in sums) total += sum.count;
		final threshold = 0.1 * total / sums.length;
		for (sum in sums) {
			if (sum.count >= threshold) continue;
			var donorWeight = 0.0;
			for (candidate in sums) if (candidate.count >= threshold) donorWeight += candidate.count;
			var ticket = Math.random() * donorWeight;
			for (donor in sums) {
				if (donor.count < threshold) continue;
				ticket -= donor.count;
				if (ticket > 0) continue;
				sum.split(donor);
				break;
			}
		}
	}

	static function mean(colors:Array<Color>):Color {
		final sum = new ColorSum();
		for (color in colors) sum.add(color);
		return Color.fromRGBA(Math.round(sum.red / sum.count), Math.round(sum.green / sum.count),
			Math.round(sum.blue / sum.count), Math.round(sum.alpha / sum.count));
	}
}

private class ColorSum {
	public var count:Float;
	public var red:Float;
	public var green:Float;
	public var blue:Float;
	public var alpha:Float;

	public function new(color:Color = 0, count:Float = 0) {
		this.count = count;
		red = color.red * count;
		green = color.green * count;
		blue = color.blue * count;
		alpha = color.alpha * count;
	}

	public function clear():Void {
		count = red = green = blue = alpha = 0;
	}

	public function add(color:Color):Void {
		count++;
		red += color.red;
		green += color.green;
		blue += color.blue;
		alpha += color.alpha;
	}

	public function blend(batch:ColorSum, step:Float):Void {
		final keep = 1 - step;
		// An empty batch must leave a usable centroid even when the step reaches one.
		if (batch.count == 0 && count * keep < 1e-100) {
			final scale = 1e-100 / count;
			red *= scale;
			green *= scale;
			blue *= scale;
			alpha *= scale;
			count = 1e-100;
			return;
		}
		count = keep * count + step * batch.count;
		red = keep * red + step * batch.red;
		green = keep * green + step * batch.green;
		blue = keep * blue + step * batch.blue;
		alpha = keep * alpha + step * batch.alpha;
	}

	public function split(donor:ColorSum):Void {
		count = donor.count *= 0.5;
		final offset = count / 256;
		red = (donor.red *= 0.5) + offset;
		green = (donor.green *= 0.5) - offset;
		blue = (donor.blue *= 0.5) + offset;
		alpha = (donor.alpha *= 0.5) - offset;
		donor.red -= offset;
		donor.green += offset;
		donor.blue -= offset;
		donor.alpha += offset;
	}
}

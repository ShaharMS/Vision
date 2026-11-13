package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;

using vision.tools.MathTools;

/** Averages pixels using the similarity of their surrounding RGB patches. **/
class NonLocalMeans {
	public static function denoise(image:Image, strength:Float, patchRadius:Int, searchRadius:Int):Image {
		final output = image.clone();
		final width = image.width;
		final height = image.height;
		if (strength == 0 || searchRadius == 0 || width == 0 || height == 0) return output;

		final count = width * height;
		final weights = [for (_ in 0...count) 1.0];
		final reds:Array<Float> = [];
		final greens:Array<Float> = [];
		final blues:Array<Float> = [];
		for (y in 0...height)
			for (x in 0...width) {
				final color = image.getUnsafePixel(x, y);
				reds.push(color.red);
				greens.push(color.green);
				blues.push(color.blue);
			}
		final stride = width + 1;
		final integral = [for (_ in 0...stride * (height + 1)) 0.0];
		final maxX = searchRadius.clamp(0, width - 1);
		final maxY = searchRadius.clamp(0, height - 1);
		final patchX = patchRadius.clamp(0, width - 1);
		final patchY = patchRadius.clamp(0, height - 1);

		for (dy in -maxY...maxY + 1) {
			for (dx in -maxX...maxX + 1) {
				if (dx == 0 && dy == 0) continue;
				// One summed-area table per displacement gives constant-time patch distances.
				for (y in 0...height) {
					var rowSum = 0.0;
					for (x in 0...width) {
						final a = image.getUnsafePixel(x, y);
						final b = image.getUnsafePixel((x + dx).clamp(0, width - 1), (y + dy).clamp(0, height - 1));
						final r = a.red - b.red;
						final g = a.green - b.green;
						final bDiff = a.blue - b.blue;
						rowSum += r * r + g * g + bDiff * bDiff;
						final index = y * stride + x + 1;
						integral[index + stride] = integral[index] + rowSum;
					}
				}

				for (y in Std.int(Math.max(0, -dy))...Std.int(Math.min(height, height - dy))) {
					final top = (y - patchY).clamp(0, height) * stride;
					final bottom = (y + patchY + 1).clamp(0, height) * stride;
					for (x in Std.int(Math.max(0, -dx))...Std.int(Math.min(width, width - dx))) {
						final left = (x - patchX).clamp(0, width);
						final right = (x + patchX + 1).clamp(0, width);
						final sum = integral[bottom + right] - integral[bottom + left] - integral[top + right] + integral[top + left];
						final distance = Math.sqrt(sum / (3.0 * (right - left) * ((bottom - top) / stride)));
						final scaled = distance / strength;
						final weight = Math.exp(-scaled * scaled);
						final sample = image.getUnsafePixel(x + dx, y + dy);
						final index = y * width + x;
						weights[index] += weight;
						reds[index] += weight * sample.red;
						greens[index] += weight * sample.green;
						blues[index] += weight * sample.blue;
					}
				}
			}
		}

		for (y in 0...height)
			for (x in 0...width) {
				final index = y * width + x;
				final weight = weights[index];
				output.setUnsafePixel(x, y, Color.fromRGBA(Math.round(reds[index] / weight), Math.round(greens[index] / weight),
					Math.round(blues[index] / weight), image.getUnsafePixel(x, y).alpha));
			}
		return output;
	}
}

package vision.algorithms;

import vision.ds.Image;
import vision.ds.accelerate.PixelStorage;

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
		final source = image.backend().readPixels();
		final target = output.backend().writePixels();
		final offset = PixelStorage.PIXEL_OFFSET;
		final reds = [for (i in 0...count) (source[offset + i * 4 + 1] : Float)];
		final greens = [for (i in 0...count) (source[offset + i * 4 + 2] : Float)];
		final blues = [for (i in 0...count) (source[offset + i * 4 + 3] : Float)];
		final stride = width + 1;
		final integral = [for (_ in 0...stride * (height + 1)) 0.0];
		final maxX = searchRadius.clamp(0, width - 1);
		final maxY = searchRadius.clamp(0, height - 1);
		final patchX = patchRadius.clamp(0, width - 1);
		final patchY = patchRadius.clamp(0, height - 1);

		final leftEdges = [for (x in 0...width) (x - patchX).clamp(0, width)];
		final rightEdges = [for (x in 0...width) (x + patchX + 1).clamp(0, width)];
		final topEdges = [for (y in 0...height) (y - patchY).clamp(0, height)];
		final bottomEdges = [for (y in 0...height) (y + patchY + 1).clamp(0, height)];
		final strengthSquared = strength * strength;

		for (dy in -maxY...maxY + 1) {
			for (dx in -maxX...maxX + 1) {
				if (dx == 0 && dy == 0) continue;
				// One summed-area table per displacement gives constant-time patch distances.
				for (y in 0...height) {
					var rowSum = 0.0;
					final row = offset + y * width * 4;
					final shiftedRow = offset + (y + dy).clamp(0, height - 1) * width * 4;
					for (x in 0...width) {
						final a = row + x * 4;
						final b = shiftedRow + (x + dx).clamp(0, width - 1) * 4;
						final r = source[a + 1] - source[b + 1];
						final g = source[a + 2] - source[b + 2];
						final bDiff = source[a + 3] - source[b + 3];
						rowSum += r * r + g * g + bDiff * bDiff;
						final index = y * stride + x + 1;
						integral[index + stride] = integral[index] + rowSum;
					}
				}

				for (y in Std.int(Math.max(0, -dy))...Std.int(Math.min(height, height - dy))) {
					final top = topEdges[y] * stride;
					final bottom = bottomEdges[y] * stride;
					for (x in Std.int(Math.max(0, -dx))...Std.int(Math.min(width, width - dx))) {
						final left = leftEdges[x];
						final right = rightEdges[x];
						final sum = integral[bottom + right] - integral[bottom + left] - integral[top + right] + integral[top + left];
						final patchArea = (right - left) * (bottomEdges[y] - topEdges[y]);
						final weight = sum == 0 ? 1.0 : Math.exp(-(sum / (3.0 * patchArea)) / strengthSquared);
						final sample = offset + ((y + dy) * width + x + dx) * 4;
						final index = y * width + x;
						weights[index] += weight;
						reds[index] += weight * source[sample + 1];
						greens[index] += weight * source[sample + 2];
						blues[index] += weight * source[sample + 3];
					}
				}
			}
		}

		for (index in 0...count) {
			final pixel = offset + index * 4;
			final weight = weights[index];
			target[pixel + 1] = Math.round(reds[index] / weight);
			target[pixel + 2] = Math.round(greens[index] / weight);
			target[pixel + 3] = Math.round(blues[index] / weight);
		}
		return output;
	}
}

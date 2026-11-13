package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.accelerate.PixelStorage;
import vision.tools.MathTools.*;

class BilinearInterpolation {
	public static function interpolate(image:Image, width:Int, height:Int):Image {
		final resized = new Image(width, height);
		if (width == 0 || height == 0) return resized;
		final sourceWidth = image.width;
		final sourceHeight = image.height;
		// Preserve the existing checked sampling behavior for an empty source.
		if (sourceWidth == 0 || sourceHeight == 0) {
			resized.setPixel(0, 0, image.getFloatingPixel(0, 0));
			return resized;
		}
		final source = image.backend().readPixels();
		final target = resized.backend().writePixels();
		final offset = PixelStorage.PIXEL_OFFSET;
		final stride = sourceWidth * 4;
		final xMultiplier = sourceWidth / width - 1 / width;
		final yMultiplier = sourceHeight / height - 1 / height;
		final columns = [for (x in 0...width) Std.int(x * xMultiplier)];
		final horizontalWeights = [for (x in 0...width) x * xMultiplier - columns[x]];

		var destination = offset;
		for (y in 0...height) {
			final sourceY = y * yMultiplier;
			final topRow = Std.int(sourceY);
			final top = offset + topRow * stride;
			final bottom = topRow + 1 < sourceHeight ? top + stride : top;
			final verticalWeight = sourceY - topRow;

			for (x in 0...width) {
				final column = columns[x];
				final left = column * 4;
				final right = column + 1 < sourceWidth ? left + 4 : left;
				final horizontalWeight = horizontalWeights[x];
				for (channel in 0...4)
					target[destination++] = interpolateChannel(
						source[top + left + channel], source[top + right + channel],
						source[bottom + left + channel], source[bottom + right + channel],
						horizontalWeight, verticalWeight);
			}
		}
		return resized;
	}

	static inline function interpolateChannel(topLeft:Int, topRight:Int, bottomLeft:Int, bottomRight:Int, x:Float, y:Float):Int {
		final top = (1 - x) * topLeft + x * topRight;
		final bottom = (1 - x) * bottomLeft + x * bottomRight;
		return Std.int((1 - y) * top + y * bottom);
	}

	public static function interpolateMissingPixels(image:Image, kernelRadiusX:Int, kernelRadiusY:Int, minX:Int, minY:Int):Image {
		
		if (kernelRadiusX == 0 && kernelRadiusY == 0) return image;

		var interpolated = image.clone();
		for (x in minX...image.width) {
			for (y in minY...image.height) {

				if (image.getPixel(x, y) !=  0x00000000) continue;

				var neighborArray = [];
				for (offX in -kernelRadiusX...kernelRadiusX + 1) {
					for (offY in -kernelRadiusY...kernelRadiusY + 1) {
						neighborArray.push(image.getSafePixel(x + offX, y + offY));
					}
				}

				neighborArray = neighborArray.filter(c -> c.toInt() != 0); // Remove empty pixels, we dont take them into account
				var sumR = 0, sumG = 0, sumB = 0, sumA = 0;
				for (color in neighborArray) {
					sumR += color.red;
					sumG += color.green;
					sumB += color.blue;
					sumA += color.alpha;
				}

				interpolated.setPixel(x, y, Color.fromRGBA(round(sumR / neighborArray.length), round(sumG / neighborArray.length), round(sumB / neighborArray.length), round(sumA / neighborArray.length)));
			}
		}

		return interpolated;
	}
}

package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import vision.exceptions.OutOfBounds;
import vision.ds.Image;
import vision.tools.MathTools.*;

class BilinearInterpolation {
	public static function interpolate(image:Image, width:Int, height:Int):Image {
		final resized = new Image(width, height);
		final xMultiplier = image.width / width - 1 / width;
		final yMultiplier = image.height / height - 1 / height;
		resized.forEachPixel((x, y, c) -> {
			final color = image.getFloatingPixel(x * xMultiplier, y * yMultiplier);
			resized.setPixel(x, y, color);			
		});

		return resized;
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

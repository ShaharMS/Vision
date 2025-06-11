package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

using vision.tools.MathTools;

/**
	An implementation of both the sobel operator & edge detection algorithms
	by [Shahar Marcus](https://www.github.com/ShaharMS)
**/
class Sobel {
	public static function convolveWithSobelOperator(image:Image):Image {
		var edgeColors:Image = new Image(image.width, image.height);
		var maxGradient = -1;

		for (i in 0...image.width) {
			for (j in 0...image.height) {
				// get the red value of the grayed pixel
				// we can "trust" .red since the value should be similar across the channels
				final pos00 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j - 1)).red;
				final pos01 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j)).red;
				final pos02 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j + 1)).red;
				final pos10 = ImageTools.grayscalePixel(image.getSafePixel(i, j - 1)).red;
				final pos11 = ImageTools.grayscalePixel(image.getSafePixel(i, j)).red;
				final pos12 = ImageTools.grayscalePixel(image.getSafePixel(i, j + 1)).red;
				final pos20 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j - 1)).red;
				final pos21 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j)).red;
				final pos22 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j + 1)).red;

				final gx = ((-3 * pos00) + (0 * pos01) + (3 * pos02)) + ((-10 * pos10) + (0 * pos11) + (10 * pos12)) + ((-3 * pos20) + (0 * pos21) + (3 * pos22));

				final gy = ((-3 * pos00) + (-10 * pos01) + (-3 * pos02)) + ((0 * pos10) + (0 * pos11) + (0 * pos12)) + ((3 * pos20) + (10 * pos21) + (3 * pos22));

				final gradientFloatValue = Math.sqrt((gx * gx) + (gy * gy));
				final gradient = Std.int(gradientFloatValue);

				if (gradient > maxGradient) maxGradient = gradient;

				final rgb:Int = Std.int(gradient * (255 / maxGradient));
				//turn into ARGB
				edgeColors.setPixel(i, j, 0xff000000 | (rgb << 16) | (rgb << 8) | rgb);
			}
		}

		return edgeColors;
	}

	/**
		What does this algorithm do?
		Basically, it takes 9 pixels chunks each time it performs a calculation, and tries to see how different the
		colors of the pixels from the left are from the right. for example, lets say this is the chunk:

			 0 ,  0 , 112
			 0 , 112, 112
			121, 112, 112

		With the naked eye, we can see that the pixels are very different from each other, and therefore, are edges.
		The way the algorithm knows it, is: its multiplying the left side by -1, the middle by 0 and the right by 1.
		Then, it multiplies each edge by 10 and each corner by 3, 
		and then adding them together:

			 0  *-3 +  0  *-10 + 121 *-3 = -363  |
			 0  * 0 + 112 * 0 + 112 * 0 =   0    | + = 1483
			112 * 3 + 112 * 10 + 112 * 3 =  1846 |

		If this value is greater than the threshold, then we declare it an edge. now, were gonna do the same thing
		for all chunks of the image, and from top to bottom too if needed.
	**/
	public static function detectEdges(image:Image, threshold:Float):Image {
		final edges = new Image(image.width, image.height, Color.fromRGBA(0, 0, 0));
		final blackAndWhite = Vision.grayscale(image.clone());
		for (x in 0...blackAndWhite.width) {
			for (y in 0...blackAndWhite.height) {
				final neighbors = [
					blackAndWhite.getSafePixel(x - 1, y - 1),
					blackAndWhite.getSafePixel(x, y - 1),
					blackAndWhite.getSafePixel(x + 1, y - 1),
					blackAndWhite.getSafePixel(x - 1, y),
					blackAndWhite.getSafePixel(x, y),
					blackAndWhite.getSafePixel(x + 1, y),
					blackAndWhite.getSafePixel(x - 1, y + 1),
					blackAndWhite.getSafePixel(x, y + 1),
					blackAndWhite.getSafePixel(x + 1, y + 1)
				];
				final sobelCalculationIterationLTR = neighbors[0].red * -3
					+ neighbors[3].red * -10 + neighbors[6].red * -3 + neighbors[2].red * 3 + neighbors[5].red * 10 + neighbors[8].red * 3;
				if (Math.abs(sobelCalculationIterationLTR) > threshold) {
					edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
					continue;
				}
				final sobelCalculationIterationTTB = neighbors[0].red * -3
					+ neighbors[1].red * -10 + neighbors[2].red * -3 + neighbors[6].red * 3 + neighbors[7].red * 10 + neighbors[8].red * 3;
				if (Math.abs(sobelCalculationIterationTTB) > threshold) {
					edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
					continue;
				}
			}
		}

		var intermediate = edges.clone();

		for (x in 0...intermediate.width) {
			for (y in 0...intermediate.height) {
				if (edges.getSafePixel(x, y).red == 0) {
					var candidate = false, X = false, Y = false;
					if (image.getSafePixel(x + 1, y).red == 255 && image.getSafePixel(x - 1, y).red == 255) {
						candidate = true;
						X = true;
					}
					if (image.getSafePixel(x, y + 1).red == 255 && image.getSafePixel(x, y - 1).red == 255) {
						candidate = true;
						Y = true;
					}

					if (candidate) {
						intermediate.setPixel(x, y, Color.fromRGBA(255, 255, 255));
						if (X) {
							if (intermediate.hasPixel(x + 1, y)) intermediate.setPixel(x + 1, y, Color.fromRGBA(0, 0, 0));
							if (intermediate.hasPixel(x - 1, y)) intermediate.setPixel(x - 1, y, Color.fromRGBA(0, 0, 0));
						}
						if (Y) {
							if (intermediate.hasPixel(x, y + 1)) intermediate.setPixel(x, y + 1, Color.fromRGBA(0, 0, 0));
							if (intermediate.hasPixel(x, y - 1)) intermediate.setPixel(x, y - 1, Color.fromRGBA(0, 0, 0));
						}
					}
				}
			}
		}

		return intermediate;
	}
}

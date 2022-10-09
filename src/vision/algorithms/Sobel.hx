package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

using vision.tools.MathTools;

/**
 * An implementation of both the sobel operator & edge detection algorithms
 * by [Shahar Marcus](https://www.github.com/ShaharMS)
 */
class Sobel {
	public static function convolveWithSobelOperator(image:Image) {
		var edgeColors:Array<Array<Int>> = [];
		var maxGradient = -1;

		for (i in 0...image.width) {
			for (j in 0...image.height) {
				final val00 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j - 1)).red;
				final val01 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j)).red;
				final val02 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j + 1)).red;
				final val10 = ImageTools.grayscalePixel(image.getSafePixel(i, j - 1)).red;
				final val11 = ImageTools.grayscalePixel(image.getSafePixel(i, j)).red;
				final val12 = ImageTools.grayscalePixel(image.getSafePixel(i, j + 1)).red;
				final val20 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j - 1)).red;
				final val21 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j)).red;
				final val22 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j + 1)).red;

				final gx = ((-3 * val00) + (0 * val01) + (3 * val02)) + ((-10 * val10) + (0 * val11) + (10 * val12)) + ((-3 * val20) + (0 * val21) + (3 * val22));

				final gy = ((-3 * val00) + (-10 * val01) + (-3 * val02)) + ((0 * val10) + (0 * val11) + (0 * val12)) + ((3 * val20) + (10 * val21) + (3 * val22));

				final gval = Math.sqrt((gx * gx) + (gy * gy));
				final g = Std.int(gval);

				if (g > maxGradient) {
					maxGradient = g;
				}

				if (edgeColors[i] == null)
					edgeColors[i] = [];
				edgeColors[i][j] = g;
			}
		}

		final scale = 255.0 / maxGradient;

		final edgeImage = new Image(image.width, image.height);
		for (i in 0...image.width) {
			for (j in 0...image.height) {
				var edgeColor = edgeColors[i][j];
				edgeColor = Std.int(edgeColor * scale);
				// RGB -> ARGB
				edgeColor = 0xff000000 | (edgeColor << 16) | (edgeColor << 8) | edgeColor;

				edgeImage.setPixel(i, j, edgeColor);
			}
		}

		return edgeImage;
	}

	static function getNeighbors(kernalSize:Int, x:Int, y:Int, image:Image):Array<Array<Color>> {
		var neighbors:Array<Array<Color>> = [];
		for (i in 0...kernalSize + 1)
			neighbors[i] = [];
		final roundedDown = Std.int((kernalSize - 1) / 2);

		for (X in -roundedDown...roundedDown + 1) {
			for (Y in -roundedDown...roundedDown + 1) {
				neighbors[X + roundedDown].push(image.getSafePixel(x + X, y + Y));
			}
		}
		return neighbors;
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
	public static function detectEdges(image:Image, threshold:Float) {
		final edges = new Image(image.width, image.height, Color.fromRGBA(0, 0, 0));
		final blacknwhite = Vision.grayscale(image.clone());
		for (x in 0...blacknwhite.width) {
			for (y in 0...blacknwhite.height) {
				final neighbors = [
					blacknwhite.getSafePixel(x - 1, y - 1),
					blacknwhite.getSafePixel(x, y - 1),
					blacknwhite.getSafePixel(x + 1, y - 1),
					blacknwhite.getSafePixel(x - 1, y),
					blacknwhite.getSafePixel(x, y),
					blacknwhite.getSafePixel(x + 1, y),
					blacknwhite.getSafePixel(x - 1, y + 1),
					blacknwhite.getSafePixel(x, y + 1),
					blacknwhite.getSafePixel(x + 1, y + 1)
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

		for (x in 1...intermediate.width - 1) {
			for (y in 1...intermediate.height - 1) {
				if (edges.getPixel(x, y).red == 0) {
					var candidate = false, X = false, Y = false;
					if (image.getPixel(x + 1, y).red == 255 && image.getPixel(x - 1, y).red == 255) {
						candidate = true;
						X = true;
					}
					if (image.getPixel(x, y + 1).red == 255 && image.getPixel(x, y - 1).red == 255) {
						candidate = true;
						Y = true;
					}

					if (candidate) {
						intermediate.setPixel(x, y, Color.fromRGBA(255, 255, 255));
						if (X) {
							intermediate.setPixel(x + 1, y, Color.fromRGBA(0, 0, 0));
							intermediate.setPixel(x - 1, y, Color.fromRGBA(0, 0, 0));
						}
						if (Y) {
							intermediate.setPixel(x, y + 1, Color.fromRGBA(0, 0, 0));
							intermediate.setPixel(x, y - 1, Color.fromRGBA(0, 0, 0));
						}
					}
				}
			}
		}

		return intermediate;
	}
}

package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

using vision.tools.MathTools;

/**
 * An implementation of both the perwitt operator & edge detection algorithms
 * by [Shahar Marcus](https://www.github.com/ShaharMS)
 */
class Perwitt {
	public static function convolveWithPerwittOperator(image:Image):Image {
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

				final gx = ((-1 * pos00) + (0 * pos01) + (1 * pos02)) + ((-2 * pos10) + (0 * pos11) + (2 * pos12)) + ((-1 * pos20) + (0 * pos21) + (1 * pos22));

				final gy = ((-1 * pos00) + (-2 * pos01) + (-1 * pos02)) + ((0 * pos10) + (0 * pos11) + (0 * pos12)) + ((1 * pos20) + (2 * pos21) + (1 * pos22));

				final gradientFloatValue = Math.sqrt((gx * gx) + (gy * gy));
				final gradient = Std.int(gradientFloatValue);

				if (gradient > maxGradient) maxGradient = gradient;

				final rgb:Int = Std.int(gradient * (255 / maxGradient));
				// turn into ARGB
				edgeColors.setPixel(i, j, 0xff000000 | (rgb << 16) | (rgb << 8) | rgb);
			}
		}

		return edgeColors;
	}

	static function getNeighbors(kernelSize:Int, x:Int, y:Int, image:Image):Array<Array<Color>> {
		var neighbors:Array<Array<Color>> = [];
		for (i in 0...kernelSize + 1)
			neighbors[i] = [];
		final roundedDown = Std.int((kernelSize - 1) / 2);

		for (X in -roundedDown...roundedDown + 1) {
			for (Y in -roundedDown...roundedDown + 1) {
				neighbors[X + roundedDown].push(image.getSafePixel(x + X, y + Y));
			}
		}
		return neighbors;
	}

	// If you came here for the explanation of the algorithm, Congrats! learning is fun :D

	/**
		What does this algorithm do?
		Basically, it takes 9 pixels chunks each time it performs a calculation, and tries to see how different the
		colors of the pixels from the left are from the right. for example, lets say this is the chunk:

			 0 ,  0 , 112
			 0 , 112, 112
			121, 112, 112

		With the naked eye, we can see that the pixels are very different from each other, and therefore, are edges.
		The way the algorithm knows it, is: its multiplying the left side by -1, the middle by 0 and the right by 1, 
		and then adding them together:

			 0  *-1 +  0  *-1 + 121 *-1 = -121 |
			 0  * 0 + 112 * 0 + 112 * 0 =   0  | + = 215
			112 * 1 + 112 * 1 + 112 * 1 =  336 |

		Now, if this value is greater than the threshold, then we declare it an edge. now, were gonna do the same thing
		for all chunks of the image, and from top to bottom too if needed.
	**/
	public static function detectEdges(image:Image, threshold:Float):Image {
		var edges = new Image(image.width, image.height, Color.fromRGBA(0, 0, 0));
		var blackAndWhite = Vision.grayscale(image.clone());
		for (x in 0...blackAndWhite.width) {
			for (y in 0...blackAndWhite.height) {
				var neighbors = [
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
				final perwittCalculationIterationLTR = neighbors[0].red * -1
					+ neighbors[3].red * -1 + neighbors[6].red * -1 + neighbors[2].red * 1 + neighbors[5].red * 1 + neighbors[8].red * 1;
				if (Math.abs(perwittCalculationIterationLTR) > threshold) {
					edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
					continue;
				}
				final perwittCalculationIterationTTB = neighbors[0].red * -1
					+ neighbors[1].red * -1 + neighbors[2].red * -1 + neighbors[6].red * 1 + neighbors[7].red * 1 + neighbors[8].red * 1;
				if (Math.abs(perwittCalculationIterationTTB) > threshold) {
					edges.setPixel(x, y, Color.fromRGBA(255, 255, 255));
					continue;
				}
			}
		}
		return edges;
	}
}

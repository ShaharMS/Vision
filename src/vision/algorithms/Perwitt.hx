package vision.algorithms;

import vision.ds.Color;
import vision.tools.ImageTools;
import Image;

using vision.tools.MathTools;

/**
 * An implementation of both the perwitt operator & edge detection algorithms
 * by [Shahar Marcus](https://www.github.com/ShaharMS)
 */
class Perwitt {
	public static function convolveWithPerwittOperator(image:Image) {
		var x = image.width;
		var y = image.height;

		var maxGval = 0;
		var edgeColors:Array<Array<Int>> = [];
		var maxGradient = -1;

		for (i in 0...x) {
			for (j in 0...y) {
				var val00 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j - 1)).red;
				var val01 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j)).red;
				var val02 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j + 1)).red;
				var val10 = ImageTools.grayscalePixel(image.getSafePixel(i, j - 1)).red;
				var val11 = ImageTools.grayscalePixel(image.getSafePixel(i, j)).red;
				var val12 = ImageTools.grayscalePixel(image.getSafePixel(i, j + 1)).red;
				var val20 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j - 1)).red;
				var val21 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j)).red;
				var val22 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j + 1)).red;

				var gx = ((-1 * val00)
					+ (0 * val01)
					+ (1 * val02))
					+ ((-2 * val10) + (0 * val11) + (2 * val12))
					+ ((-1 * val20) + (0 * val21) + (1 * val22));

				var gy = ((-1 * val00)
					+ (-2 * val01)
					+ (-1 * val02))
					+ ((0 * val10) + (0 * val11) + (0 * val12))
					+ ((1 * val20) + (2 * val21) + (1 * val22));

				var gval = Math.sqrt((gx * gx) + (gy * gy));
				var g = Std.int(gval);

				if (maxGradient < g) {
					maxGradient = g;
				}

				if (edgeColors[i] == null)
					edgeColors[i] = [];
				edgeColors[i][j] = g;
			}
		}

		var scale = 255.0 / maxGradient;

		var edgeImage = new Image(image.width, image.height);
		for (i in 0...x) {
			for (j in 0...y) {
				var edgeColor = edgeColors[i][j];
				edgeColor = Std.int(edgeColor * scale);
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
		var roundedDown = Std.int((kernalSize - 1) / 2);

		for (X in -roundedDown...roundedDown + 1) {
			for (Y in -roundedDown...roundedDown + 1) {
				if (x + X < 0 || x + X >= image.width || y + Y < 0 || y + Y >= image.height) {
					neighbors[X + roundedDown].push(0);
					continue;
				}
				neighbors[X + roundedDown].push(image.getPixel(x + X, y + Y));
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
	public static function detectEdges(image:Image, threshold:Float) {
		

			var edges = new Image(image.width, image.height, Color.fromRGBA(0, 0, 0));
			var blacknwhite = Vision.grayscale(image.clone());
			for (x in 0...blacknwhite.width) {
				for (y in 0...blacknwhite.height) {
					var neighbors = [
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

package vision.algorithms;

import vision.tools.ImageTools;
import vision.ds.Image;

/**
    An Implementation of the `Robert's Cross` operator, by [Shahar Marcus](https://www.github.com/ShaharMS).

    `Robert's Cross` is one of the first edge detection operators, first proposed in 1963 by Lawrence Roberts.

    The idea behind the Roberts cross operator is to approximate the gradient of an edge inside an image by
    computing the sum of the squares of the differences between diagonally adjacent pixels.
**/
class RobertsCross {

    public static function convolveWithRobertsCross(image:Image):Image {
		var edgeColors:Image = new Image(image.width, image.height);
		var maxGradient = 0;
		var gradients:Array<Int> = [];

		for (i in 0...image.width) {
			for (j in 0...image.height) {
				final pos00 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j - 1)).red;
				final pos02 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j + 1)).red;
				final pos20 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j - 1)).red;
				final pos22 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j + 1)).red;

				final gx = ((1 * pos00) + (0 * pos02)) + ((0 * pos20) + (-1 * pos22));
				final gy = ((0 * pos00) + (1 * pos02)) + ((-1 * pos20) + (0 * pos22));

				final gradientFloatValue = Math.sqrt((gx * gx) + (gy * gy));
				final gradient = Std.int(gradientFloatValue);
				gradients[j * image.width + i] = gradient;
				if (gradient > maxGradient) maxGradient = gradient;
			}
		}

		if (maxGradient <= 0) return edgeColors;

		for (i in 0...image.width) {
			for (j in 0...image.height) {
				final gradient = gradients[j * image.width + i];
				final rgb:Int = Std.int(gradient * (255 / maxGradient));
				edgeColors.setPixel(i, j, 0xff000000 | (rgb << 16) | (rgb << 8) | rgb);
			}
		}

		return edgeColors;
    }
}

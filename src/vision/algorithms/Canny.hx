package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.canny.CannyObject;

using vision.algorithms.Canny;
using vision.tools.MathTools;

/**
	An implementation of the canny edge detection algorithm, 
	by [ShaharMS](https://www.github.com/ShaharMS).
	
	The Canny Edge Detection is a multi-stage edge 
	detection algorithm, utilizing blurring filters 
	and multi-level thresholding.
	
	This class contains function for all 5 stages:
	 
	- `grayscale()`
	- `applyGaussian()`
	- `applySobelFilters()`
	- `nonMaxSuppression()`
	- `applyHysteresis()`
**/
class Canny {
	public static function grayscale(image:CannyObject):CannyObject {
		return Vision.grayscale(image);
	}

	public static function applyGaussian(image:CannyObject, size:Int, sigma:Float):CannyObject {
		return Vision.gaussianBlur(image, sigma, size);
	}

	public static function applySobelFilters(image:CannyObject):CannyObject {
		return Vision.sobelEdgeDiffOperator(image);
	}

	public static function nonMaxSuppression(image:CannyObject):CannyObject {
		final filtered = new Image(image.width, image.height);

		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var n = getNeighbors(3, x, y, image);
				if (n[1][1] > n[0][1] && n[1][1] > n[2][1])
					filtered.setPixel(x, y, n[1][1]);
				else
					filtered.setPixel(x, y, 0);

				if (n[1][1] > n[0][2] && n[1][1] > n[2][0])
					filtered.setPixel(x, y, n[1][1]);
				else
					filtered.setPixel(x, y, 0);

				if (n[1][1] > n[1][0] && n[1][1] > n[1][2])
					filtered.setPixel(x, y, n[1][1]);
				else
					filtered.setPixel(x, y, 0);

				if (n[1][1] > n[0][0] && n[1][1] > n[2][2])
					filtered.setPixel(x, y, n[1][1]);
				else
					filtered.setPixel(x, y, 0);
			}
		}

		return filtered;
	}

	public static function applyHysteresis(image:CannyObject, highThreshold:Float, lowThreshold:Float):CannyObject {
		final copy = image.clone();
		final isStrong = (edge:Color) -> edge.redFloat > highThreshold;
		final isCandidate = (edge:Color) -> edge.redFloat <= highThreshold && edge.redFloat >= lowThreshold;

		function traverseEdge(x, y) {
			if (x == 0 || y == 0 || x == image.width - 1 || y == image.height - 1)
				return;
			if (isStrong(copy.getPixel(x, y))) {
				final neighbors = getNeighbors(3, x, y, copy);
				for (i in 0...2) {
					for (j in 0...2) {
						if (isCandidate(neighbors[i][j])) {
							copy.setPixel(x - 1 + i, y - 1 + j, 0xFFFFFF);
							traverseEdge(x - 1 + i, y - 1 + j);
						}
					}
				}
			}
		}

		for (x in 0...image.width) {
			for (y in 0...image.height) {
				traverseEdge(x, y);
			}
		}
		// second iteration, remove weak pixels.
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				if (!isStrong(copy.getPixel(x, y)))
					copy.setPixel(x, y, 0);
			}
		}

		return copy;
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
}

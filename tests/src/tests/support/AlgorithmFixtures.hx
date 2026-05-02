package tests.support;

import vision.ds.Color;
import vision.ds.Image;

class AlgorithmFixtures {
	public static function horizontalLineImage(width:Int = 5, height:Int = 5, y:Int = 2):Image {
		var image = new Image(width, height, Color.BLACK);
		for (x in 0...width) {
			image.setPixel(x, y, Color.WHITE);
		}
		return image;
	}

	public static function verticalLineImage(width:Int = 5, height:Int = 5, x:Int = 2):Image {
		var image = new Image(width, height, Color.BLACK);
		for (y in 0...height) {
			image.setPixel(x, y, Color.WHITE);
		}
		return image;
	}

	public static function diagonalLineImage(width:Int = 5, height:Int = 5, offset:Int = 0):Image {
		var image = new Image(width, height, Color.BLACK);
		for (x in 0...width) {
			var y = x + offset;
			if (y >= 0 && y < height) {
				image.setPixel(x, y, Color.WHITE);
			}
		}
		return image;
	}

	public static function gappedHorizontalLineImage(width:Int = 7, height:Int = 5, y:Int = 2, gapStart:Int = 3, gapLength:Int = 1):Image {
		var image = new Image(width, height, Color.BLACK);
		for (x in 0...width) {
			if (x >= gapStart && x < gapStart + gapLength) {
				continue;
			}
			image.setPixel(x, y, Color.WHITE);
		}
		return image;
	}

	public static function shortHorizontalSegmentImage(width:Int = 5, height:Int = 5, startX:Int = 1, endX:Int = 2, y:Int = 2):Image {
		var image = new Image(width, height, Color.BLACK);
		for (x in startX...endX + 1) {
			image.setPixel(x, y, Color.WHITE);
		}
		return image;
	}

	public static function orthogonalGridImage(width:Int = 9, height:Int = 9, ?positions:Array<Int>):Image {
		var image = new Image(width, height, Color.BLACK);
		var gridPositions = positions == null ? [1, 4, 7] : positions;
		for (position in gridPositions) {
			for (x in 0...width) {
				image.setPixel(x, position, Color.WHITE);
			}
			for (y in 0...height) {
				image.setPixel(position, y, Color.WHITE);
			}
		}
		return image;
	}

	public static function stepEdgeImage(width:Int = 5, height:Int = 5, stepX:Int = 2):Image {
		var image = new Image(width, height, Color.BLACK);
		for (y in 0...height) {
			for (x in stepX...width) {
				image.setPixel(x, y, Color.WHITE);
			}
		}
		return image;
	}

	public static function centerPixelImage(size:Int = 3, center:Color = Color.WHITE, background:Color = Color.BLACK):Image {
		var image = new Image(size, size, background);
		var middle = Std.int(size / 2);
		image.setPixel(middle, middle, center);
		return image;
	}

	public static function nonBlackPixelCount(image:Image):Int {
		var count = 0;
		for (y in 0...image.height) {
			for (x in 0...image.width) {
				var color = image.getPixel(x, y);
				if (color.red != 0 || color.green != 0 || color.blue != 0) {
					count++;
				}
			}
		}
		return count;
	}
}
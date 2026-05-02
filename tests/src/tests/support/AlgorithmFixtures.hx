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
package tests.support;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageView;
import vision.ds.ImageViewShape;

class ManualFixtures {
	public static function tinyGradientImage():Image {
		return Factories.gradientImage(3, 3);
	}

	public static function tinyCheckerboardImage():Image {
		return Factories.checkerboardImage(4, 4, 1);
	}

	public static function coordinateColor(x:Int, y:Int, alpha:Int = 255):Color {
		return Color.fromRGBA(15 + x * 40, 25 + y * 50, 10 + (x + y) * 20, alpha);
	}

	public static function coordinateImage(width:Int = 4, height:Int = 4):Image {
		var image = new Image(width, height, 0x00000000);
		for (y in 0...height) {
			for (x in 0...width) {
				image.setPixel(x, y, coordinateColor(x, y));
			}
		}
		return image;
	}

	public static function oddSizedImage():Image {
		return coordinateImage(5, 3);
	}

	public static function interpolationImage():Image {
		var image = new Image(2, 2, 0x00000000);
		image.setPixel(0, 0, Color.fromRGBA(0, 0, 0, 255));
		image.setPixel(1, 0, Color.fromRGBA(255, 0, 0, 255));
		image.setPixel(0, 1, Color.fromRGBA(0, 255, 0, 255));
		image.setPixel(1, 1, Color.fromRGBA(0, 0, 255, 255));
		return image;
	}

	public static function alphaHeavyImage():Image {
		var image = new Image(2, 2, 0x00000000);
		image.setPixel(0, 0, coordinateColor(0, 0, 32));
		image.setPixel(1, 0, coordinateColor(1, 0, 96));
		image.setPixel(0, 1, coordinateColor(0, 1, 160));
		image.setPixel(1, 1, coordinateColor(1, 1, 224));
		return image;
	}

	public static function rectangleView(x:Int = 1, y:Int = 1, width:Int = 2, height:Int = 2, shape:ImageViewShape = RECTANGLE):ImageView {
		return {
			x: x,
			y: y,
			width: width,
			height: height,
			shape: shape,
		};
	}
}
package tests.support;

import utest.Assert;
import vision.ds.Color;
import vision.ds.Image;

class ResamplerAssertions {
	public static function uniformColor(image:Image, expected:Color):Void {
		for (y in 0...image.height) {
			for (x in 0...image.width) {
				ImageAssertions.pixelEquals(image, x, y, expected);
			}
		}
	}

	public static function opaqueGrayscale(image:Image):Void {
		for (y in 0...image.height) {
			for (x in 0...image.width) {
				var color = image.getPixel(x, y);
				Assert.equals(255, color.alpha);
				Assert.equals(color.red, color.green);
				Assert.equals(color.green, color.blue);
			}
		}
	}

	public static function blended(color:Color):Void {
		Assert.equals(255, color.alpha);
		Assert.isTrue(color.red > 0 && color.red < 255);
		Assert.isTrue(color.green > 0 && color.green < 255);
		Assert.isTrue(color.blue > 0 && color.blue < 255);
	}
}
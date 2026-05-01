package tests.support;

import utest.Assert;
import vision.ds.Color;
import vision.ds.Image;

class ImageAssertions {
	public static function hasDimensions(image:Image, width:Int, height:Int):Void {
		Assert.equals(width, image.width);
		Assert.equals(height, image.height);
	}

	public static function pixelEquals(image:Image, x:Int, y:Int, expected:Color):Void {
		Assert.equals(expected, image.getPixel(x, y));
	}
}
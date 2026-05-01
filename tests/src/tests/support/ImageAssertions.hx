package tests.support;

import utest.Assert;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageView;

class ImageAssertions {
	public static function hasDimensions(image:Image, width:Int, height:Int):Void {
		Assert.equals(width, image.width);
		Assert.equals(height, image.height);
	}

	public static function pixelEquals(image:Image, x:Int, y:Int, expected:Color):Void {
		colorEquals(expected, image.getPixel(x, y));
	}

	public static function pixelApproxEquals(image:Image, x:Int, y:Int, expected:Color, tolerance:Int = 1):Void {
		colorApproxEquals(expected, image.getPixel(x, y), tolerance);
	}

	public static function colorEquals(expected:Color, actual:Color):Void {
		Assert.equals(expected.alpha, actual.alpha);
		Assert.equals(expected.red, actual.red);
		Assert.equals(expected.green, actual.green);
		Assert.equals(expected.blue, actual.blue);
	}

	public static function colorApproxEquals(expected:Color, actual:Color, tolerance:Int = 1):Void {
		channelApproxEquals(expected.alpha, actual.alpha, tolerance);
		channelApproxEquals(expected.red, actual.red, tolerance);
		channelApproxEquals(expected.green, actual.green, tolerance);
		channelApproxEquals(expected.blue, actual.blue, tolerance);
	}

	public static function viewEquals(expected:ImageView, actual:ImageView):Void {
		Assert.equals(expected.x, actual.x);
		Assert.equals(expected.y, actual.y);
		Assert.equals(expected.width, actual.width);
		Assert.equals(expected.height, actual.height);
		Assert.equals(expected.shape, actual.shape);
	}

	public static function matrixEquals(expected:Array<Array<Int>>, image:Image):Void {
		hasDimensions(image, expected[0].length, expected.length);
		for (y in 0...expected.length) {
			for (x in 0...expected[y].length) {
				pixelEquals(image, x, y, expected[y][x]);
			}
		}
	}

	static function channelApproxEquals(expected:Int, actual:Int, tolerance:Int):Void {
		Assert.isTrue(Math.abs(expected - actual) <= tolerance);
	}
}
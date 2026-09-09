package tests.support;

import utest.Assert;
import vision.ds.Color;

class ColorAssertions {
	public static function equalsColor(expected:Int, actual:Color):Void {
		var expectedColor:Color = cast expected;
		Assert.equals(expectedColor.alpha, actual.alpha);
		Assert.equals(expectedColor.red, actual.red);
		Assert.equals(expectedColor.green, actual.green);
		Assert.equals(expectedColor.blue, actual.blue);
	}

	public static function equalsColors(expected:Array<Int>, actual:Array<Color>):Void {
		Assert.equals(expected.length, actual.length);
		for (index in 0...expected.length) {
			equalsColor(expected[index], actual[index]);
		}
	}
}

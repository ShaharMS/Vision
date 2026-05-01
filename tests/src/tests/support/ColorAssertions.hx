package tests.support;

import utest.Assert;
import vision.ds.Color;

class ColorAssertions {
	public static function equalsColor(expected:Int, actual:Color):Void {
		Assert.equals(expected, actual.toInt());
	}

	public static function equalsColors(expected:Array<Int>, actual:Array<Color>):Void {
		Assert.equals(expected.length, actual.length);
		for (index in 0...expected.length) {
			equalsColor(expected[index], actual[index]);
		}
	}
}

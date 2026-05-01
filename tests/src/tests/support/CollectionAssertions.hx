package tests.support;

import utest.Assert;
import vision.ds.ByteArray;

class CollectionAssertions {
	public static function values<T>(expected:Array<T>, actual:Array<T>):Void {
		Assert.equals(expected.length, actual.length);
		for (index in 0...expected.length) {
			Assert.equals(expected[index], actual[index]);
		}
	}

	public static function equalsArray<T>(expected:Array<T>, actual:Array<T>):Void {
		values(expected, actual);
	}

	public static function nestedValues<T>(expected:Array<Array<T>>, actual:Array<Array<T>>):Void {
		Assert.equals(expected.length, actual.length);
		for (index in 0...expected.length) {
			values(expected[index], actual[index]);
		}
	}

	public static function equalsNestedArray<T>(expected:Array<Array<T>>, actual:Array<Array<T>>):Void {
		nestedValues(expected, actual);
	}

	public static function bytes(expected:Array<Int>, actual:ByteArray):Void {
		values(expected, actual.toArray());
	}

	public static function equalsByteArray(expected:Array<Int>, actual:ByteArray):Void {
		bytes(expected, actual);
	}
}
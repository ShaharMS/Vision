package tests.support;

import utest.Assert;
import vision.ds.ByteArray;
import vision.ds.Image;

class FormatAssertions {
	public static function fixtureImage():Image {
		var image = new Image(3, 2);
		var colors = [
			[0xFF102030, 0xFF406080, 0xFF90A0B0],
			[0xFFC04020, 0xFF208040, 0xFF3040C0]
		];

		for (y in 0...colors.length) {
			for (x in 0...colors[y].length) {
				image.setPixel(x, y, colors[y][x]);
			}
		}

		return image;
	}

	public static function bytesStartWith(bytes:ByteArray, prefix:Array<Int>):Void {
		Assert.isTrue(bytes.length >= prefix.length);
		for (index in 0...prefix.length) {
			Assert.equals(prefix[index], bytes.getUInt8(index));
		}
	}

	public static function imagesEqual(expected:Image, actual:Image):Void {
		ImageAssertions.hasDimensions(actual, expected.width, expected.height);
		for (y in 0...expected.height) {
			for (x in 0...expected.width) {
				ImageAssertions.pixelEquals(actual, x, y, expected.getPixel(x, y));
			}
		}
	}

	public static function malformedBytes():ByteArray {
		return ByteArray.from([0x00, 0x11, 0x22, 0x33, 0x44], 1);
	}
}
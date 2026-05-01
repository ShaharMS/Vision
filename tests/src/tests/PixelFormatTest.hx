package tests;

import utest.Assert;
import vision.ds.ByteArray;
import vision.ds.Pixel;
import vision.ds.PixelFormat;

@:access(vision.ds.PixelFormat)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class PixelFormatTest extends utest.Test {

	@:visionTestId("vision.ds.PixelFormat.convertPixelFormat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_convertPixelFormat__default() {
		var bytes = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var from = vision.ds.PixelFormat.ARGB;
		var to = vision.ds.PixelFormat.ARGB;
		var result = vision.ds.PixelFormat.convertPixelFormat(bytes, from, to);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

}

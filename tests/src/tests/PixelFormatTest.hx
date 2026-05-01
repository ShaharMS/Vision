package tests;

import tests.support.CollectionAssertions;
import utest.Assert;
import vision.ds.ByteArray;
import vision.ds.PixelFormat;

@:access(vision.ds.PixelFormat)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class PixelFormatTest extends utest.Test {

	@:visionTestId("vision.ds.PixelFormat.convertPixelFormat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_convertPixelFormat__default() {
		var bytes = new ByteArray(4);
		bytes[0] = 1;
		bytes[1] = 2;
		bytes[2] = 3;
		bytes[3] = 4;
		var result = PixelFormat.convertPixelFormat(bytes, PixelFormat.ARGB, PixelFormat.ARGB);
		CollectionAssertions.bytes([1, 2, 3, 4], result);
	}

	@:visionTestId("vision.ds.PixelFormat.convertPixelFormat#reordersChannels")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_convertPixelFormat__reordersChannels() {
		var bytes = new ByteArray(4);
		bytes[0] = 255;
		bytes[1] = 17;
		bytes[2] = 34;
		bytes[3] = 51;
		var result = PixelFormat.convertPixelFormat(bytes, PixelFormat.ARGB, PixelFormat.RGBA);
		CollectionAssertions.bytes([17, 34, 51, 255], result);
	}
}

package tests;

import utest.Assert;
import vision.ds.ImageFormat;

@:access(vision.ds.ImageFormat)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class ImageFormatTest extends utest.Test {

	@:visionTestId("vision.ds.ImageFormat.fromString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromString__default() {
		var type = "42";
		var result = vision.ds.ImageFormat.fromString(type);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ImageFormat.fromString#tiny")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromString__tiny() {
		var type = "42";
		var result = vision.ds.ImageFormat.fromString(type);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ImageFormat.fromString#checkerboard")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromString__checkerboard() {
		var type = "42";
		var result = vision.ds.ImageFormat.fromString(type);
		Assert.notNull(result);
	}

}

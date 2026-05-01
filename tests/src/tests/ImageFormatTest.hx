package tests;

import utest.Assert;
import vision.ds.ImageFormat;

@:access(vision.ds.ImageFormat)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageFormatTest extends utest.Test {

	@:visionTestId("vision.ds.ImageFormat.fromString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromString__default() {
		Assert.equals(ImageFormat.PNG, ImageFormat.fromString("png"));
	}

	@:visionTestId("vision.ds.ImageFormat.fromString#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromString__tiny() {
		Assert.equals(ImageFormat.JPEG, ImageFormat.fromString("jpg"));
	}

	@:visionTestId("vision.ds.ImageFormat.fromString#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromString__checkerboard() {
		Assert.equals(ImageFormat.VISION, ImageFormat.fromString("raw"));
	}
}

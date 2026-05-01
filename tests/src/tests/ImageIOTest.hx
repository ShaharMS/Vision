package tests;

import utest.Assert;
import vision.formats.ImageIO;

@:access(vision.formats.ImageIO)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class ImageIOTest extends utest.Test {

	@:visionTestId("vision.formats.ImageIO.from#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_from__default() {
		var result = vision.formats.ImageIO.from;
		Assert.notNull(result);
	}

	@:visionTestId("vision.formats.ImageIO.to#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_to__default() {
		var result = vision.formats.ImageIO.to;
		Assert.notNull(result);
	}

}

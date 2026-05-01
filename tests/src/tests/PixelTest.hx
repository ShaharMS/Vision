package tests;

import utest.Assert;
import vision.ds.Color;
import vision.ds.Pixel;

@:access(vision.ds.Pixel)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class PixelTest extends utest.Test {

	@:visionTestId("vision.ds.Pixel.x#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_x__default() {
		var ctor_x = 1;
		var ctor_y = 1;
		var ctor_color = (0xFF336699 : vision.ds.Color);
		var instance = new vision.ds.Pixel(ctor_x, ctor_y, ctor_color);
		var result = instance.x;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Pixel.y#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_y__default() {
		var ctor_x = 1;
		var ctor_y = 1;
		var ctor_color = (0xFF336699 : vision.ds.Color);
		var instance = new vision.ds.Pixel(ctor_x, ctor_y, ctor_color);
		var result = instance.y;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Pixel.color#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_color__default() {
		var ctor_x = 1;
		var ctor_y = 1;
		var ctor_color = (0xFF336699 : vision.ds.Color);
		var instance = new vision.ds.Pixel(ctor_x, ctor_y, ctor_color);
		var result = instance.color;
		Assert.notNull(result);
	}

}

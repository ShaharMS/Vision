package tests;

import utest.Assert;
import vision.ds.Color;
import vision.ds.Pixel;

@:access(vision.ds.Pixel)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class PixelTest extends utest.Test {
	function createPixel():Pixel {
		return new Pixel(1, 2, 0xFF336699);
	}

	@:visionTestId("vision.ds.Pixel.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		Assert.equals(1, createPixel().x);
	}

	@:visionTestId("vision.ds.Pixel.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		Assert.equals(2, createPixel().y);
	}

	@:visionTestId("vision.ds.Pixel.color#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_color__default() {
		Assert.equals((0xFF336699 : Color), createPixel().color);
	}
}

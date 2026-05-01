package tests;

import utest.Assert;
import vision.ds.Rectangle;

@:access(vision.ds.Rectangle)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class RectangleTest extends utest.Test {
	function createRectangle():Rectangle {
		return {x: -2, y: 3, width: 5, height: 7};
	}

	@:visionTestId("vision.ds.Rectangle.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		Assert.equals(-2, createRectangle().x);
	}

	@:visionTestId("vision.ds.Rectangle.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		Assert.equals(3, createRectangle().y);
	}

	@:visionTestId("vision.ds.Rectangle.width#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_width__default() {
		Assert.equals(5, createRectangle().width);
	}

	@:visionTestId("vision.ds.Rectangle.height#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_height__default() {
		Assert.equals(7, createRectangle().height);
	}
}

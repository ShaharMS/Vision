package tests;

import utest.Assert;
import vision.ds.Rectangle;

@:access(vision.ds.Rectangle)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class RectangleTest extends utest.Test {

	@:visionTestId("vision.ds.Rectangle.x#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_x__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10} : vision.ds.Rectangle);
		var result = instance.x;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Rectangle.y#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_y__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10} : vision.ds.Rectangle);
		var result = instance.y;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Rectangle.width#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_width__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10} : vision.ds.Rectangle);
		var result = instance.width;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Rectangle.height#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_height__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10} : vision.ds.Rectangle);
		var result = instance.height;
		Assert.notNull(result);
	}

}

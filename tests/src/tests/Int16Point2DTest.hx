package tests;

import utest.Assert;
import vision.ds.Int16Point2D;

@:access(vision.ds.Int16Point2D)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class Int16Point2DTest extends utest.Test {

	@:visionTestId("vision.ds.Int16Point2D.x#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_x__default() {
		var instance = new vision.ds.Int16Point2D(0, 0);
		var result = instance.x;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Int16Point2D.y#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_y__default() {
		var instance = new vision.ds.Int16Point2D(0, 0);
		var result = instance.y;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Int16Point2D.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var instance = new vision.ds.Int16Point2D(0, 0);
		var result = instance.toString();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Int16Point2D.toPoint2D#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toPoint2D__default() {
		var instance = new vision.ds.Int16Point2D(0, 0);
		var result = instance.toPoint2D();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Int16Point2D.toIntPoint2D#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toIntPoint2D__default() {
		var instance = new vision.ds.Int16Point2D(0, 0);
		var result = instance.toIntPoint2D();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Int16Point2D.toInt#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toInt__default() {
		var instance = new vision.ds.Int16Point2D(0, 0);
		var result = instance.toInt();
		Assert.notNull(result);
	}

}

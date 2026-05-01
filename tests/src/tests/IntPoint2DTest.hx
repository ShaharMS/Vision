package tests;

import utest.Assert;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;

@:access(vision.ds.IntPoint2D)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class IntPoint2DTest extends utest.Test {

	@:visionTestId("vision.ds.IntPoint2D.x#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_x__default() {
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.x;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.IntPoint2D.y#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_y__default() {
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.y;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.IntPoint2D.toPoint2D#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toPoint2D__default() {
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.toPoint2D();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.IntPoint2D.fromPoint2D#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromPoint2D__default() {
		var p = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.ds.IntPoint2D.fromPoint2D(p);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.IntPoint2D.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.toString();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.IntPoint2D.copy#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_copy__default() {
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.copy();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.IntPoint2D.distanceTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		var point = new vision.ds.IntPoint2D(1, 1);
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.distanceTo(point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.IntPoint2D.degreesTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_degreesTo__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.degreesTo(point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.IntPoint2D.radiansTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radiansTo__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var instance = new vision.ds.IntPoint2D(0, 0);
		var result = instance.radiansTo(point);
		Assert.isFalse(Math.isNaN(result));
	}

}

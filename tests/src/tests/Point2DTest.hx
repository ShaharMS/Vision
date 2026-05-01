package tests;

import utest.Assert;
import vision.ds.Point2D;

@:access(vision.ds.Point2D)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class Point2DTest extends utest.Test {

	@:visionTestId("vision.ds.Point2D.x#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_x__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var instance = new vision.ds.Point2D(ctor_x, ctor_y);
		var result = instance.x;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point2D.y#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_y__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var instance = new vision.ds.Point2D(ctor_x, ctor_y);
		var result = instance.y;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point2D.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var instance = new vision.ds.Point2D(ctor_x, ctor_y);
		var result = instance.toString();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Point2D.copy#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_copy__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var instance = new vision.ds.Point2D(ctor_x, ctor_y);
		var result = instance.copy();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Point2D.distanceTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var instance = new vision.ds.Point2D(ctor_x, ctor_y);
		var result = instance.distanceTo(point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point2D.degreesTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_degreesTo__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var instance = new vision.ds.Point2D(ctor_x, ctor_y);
		var result = instance.degreesTo(point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point2D.radiansTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radiansTo__default() {
		var point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var instance = new vision.ds.Point2D(ctor_x, ctor_y);
		var result = instance.radiansTo(point);
		Assert.isFalse(Math.isNaN(result));
	}

}

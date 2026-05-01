package tests;

import utest.Assert;
import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.Ray2D;

@:access(vision.ds.Line2D)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class Line2DTest extends utest.Test {

	@:visionTestId("vision.ds.Line2D.fromRay2D#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_fromRay2D__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var result = vision.ds.Line2D.fromRay2D(ray);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Line2D.length#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_length__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.length;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Line2D.slope#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_slope__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.slope;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Line2D.degrees#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_degrees__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.degrees;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Line2D.radians#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radians__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.radians;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Line2D.start#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_start__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.start;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Line2D.end#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_end__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.end;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Line2D.middle#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_middle__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.middle;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Line2D.intersect#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_intersect__default() {
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.intersect(line);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Line2D.distanceTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.distanceTo(line);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Line2D.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.toString();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Line2D.toRay2D#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toRay2D__default() {
		var ctor_start = new vision.ds.Point2D(0.0, 0.0);
		var ctor_end = new vision.ds.Point2D(10.0, 0.0);
		var instance = new vision.ds.Line2D(ctor_start, ctor_end);
		var result = instance.toRay2D();
		Assert.notNull(result);
	}

}

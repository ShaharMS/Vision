package tests;

import utest.Assert;
import vision.ds.Point2D;
import vision.ds.Ray2D;

@:access(vision.ds.Ray2D)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class Ray2DTest extends utest.Test {

	@:visionTestId("vision.ds.Ray2D.from2Points#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_from2Points__default() {
		var point1 = new vision.ds.Point2D(1.0, 1.0);
		var point2 = new vision.ds.Point2D(1.0, 1.0);
		var result = vision.ds.Ray2D.from2Points(point1, point2);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Ray2D.point#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_point__default() {
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.point;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Ray2D.slope#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_slope__default() {
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.slope;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Ray2D.degrees#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_degrees__default() {
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.degrees;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Ray2D.radians#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_radians__default() {
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.radians;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Ray2D.yIntercept#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_yIntercept__default() {
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.yIntercept;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Ray2D.xIntercept#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_xIntercept__default() {
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.xIntercept;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Ray2D.getPointAtX#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getPointAtX__default() {
		var x = 1.0;
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.getPointAtX(x);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Ray2D.getPointAtY#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getPointAtY__default() {
		var y = 1.0;
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.getPointAtY(y);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Ray2D.intersect#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_intersect__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 1.0), -1.0);
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.intersect(ray);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Ray2D.distanceTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
		var ctor_point = new vision.ds.Point2D(1.0, 1.0);
		var ctor_m = 1.0;
		var ctor_degrees = null;
		var ctor_radians = null;
		var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
		var result = instance.distanceTo(ray);
		Assert.isFalse(Math.isNaN(result));
	}

}

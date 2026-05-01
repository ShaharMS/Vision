package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.Point2D;
import vision.ds.Ray2D;

@:access(vision.ds.Ray2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Ray2DTest extends utest.Test {
	function createRay():Ray2D {
		return new Ray2D(new Point2D(1, 1), 1);
	}

	function assertPoint(expectedX:Float, expectedY:Float, actual:Point2D):Void {
		ApproxAssertions.equalsFloat(expectedX, actual.x);
		ApproxAssertions.equalsFloat(expectedY, actual.y);
	}

	@:visionTestId("vision.ds.Ray2D.from2Points#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_from2Points__default() {
		var result = Ray2D.from2Points(new Point2D(1, 1), new Point2D(3, 3));
		assertPoint(1, 1, result.point);
		ApproxAssertions.equalsFloat(1, result.slope);
	}

	@:visionTestId("vision.ds.Ray2D.point#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_point__default() {
		assertPoint(1, 1, createRay().point);
	}

	@:visionTestId("vision.ds.Ray2D.slope#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_slope__default() {
		ApproxAssertions.equalsFloat(1, createRay().slope);
	}

	@:visionTestId("vision.ds.Ray2D.degrees#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_degrees__default() {
		ApproxAssertions.equalsFloat(45, createRay().degrees);
	}

	@:visionTestId("vision.ds.Ray2D.radians#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radians__default() {
		ApproxAssertions.equalsFloat(Math.PI / 4, createRay().radians);
	}

	@:visionTestId("vision.ds.Ray2D.yIntercept#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_yIntercept__default() {
		ApproxAssertions.equalsFloat(0, createRay().yIntercept);
	}

	@:visionTestId("vision.ds.Ray2D.xIntercept#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_xIntercept__default() {
		ApproxAssertions.equalsFloat(0, createRay().xIntercept);
	}

	@:visionTestId("vision.ds.Ray2D.getPointAtX#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getPointAtX__default() {
		assertPoint(3, 3, createRay().getPointAtX(3));
	}

	@:visionTestId("vision.ds.Ray2D.getPointAtY#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getPointAtY__default() {
		assertPoint(5, 5, createRay().getPointAtY(5));
	}

	@:visionTestId("vision.ds.Ray2D.intersect#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_intersect__default() {
		var result = createRay().intersect(new Ray2D(new Point2D(0, 2), -1));
		assertPoint(1, 1, result);
	}

	@:visionTestId("vision.ds.Ray2D.distanceTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		ApproxAssertions.equalsFloat(Math.sqrt(2), createRay().distanceTo(new Ray2D(new Point2D(0, 2), 1)));
	}
}

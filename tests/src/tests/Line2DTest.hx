package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.Ray2D;

@:access(vision.ds.Line2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Line2DTest extends utest.Test {
	function createLine():Line2D {
		return new Line2D(new Point2D(0, 0), new Point2D(4, 0));
	}

	function assertPoint(expectedX:Float, expectedY:Float, actual:Point2D):Void {
		ApproxAssertions.equalsFloat(expectedX, actual.x);
		ApproxAssertions.equalsFloat(expectedY, actual.y);
	}

	@:visionTestId("vision.ds.Line2D.fromRay2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromRay2D__default() {
		var result = Line2D.fromRay2D(new Ray2D(new Point2D(1, 1), 0));
		assertPoint(1, 1, result.start);
		assertPoint(2, 1, result.end);
	}

	@:visionTestId("vision.ds.Line2D.length#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_length__default() {
		ApproxAssertions.equalsFloat(4, createLine().length);
	}

	@:visionTestId("vision.ds.Line2D.slope#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_slope__default() {
		ApproxAssertions.equalsFloat(0, createLine().slope);
	}

	@:visionTestId("vision.ds.Line2D.degrees#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_degrees__default() {
		ApproxAssertions.equalsFloat(0, createLine().degrees);
	}

	@:visionTestId("vision.ds.Line2D.radians#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radians__default() {
		ApproxAssertions.equalsFloat(0, createLine().radians);
	}

	@:visionTestId("vision.ds.Line2D.start#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_start__default() {
		assertPoint(0, 0, createLine().start);
	}

	@:visionTestId("vision.ds.Line2D.end#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_end__default() {
		assertPoint(4, 0, createLine().end);
	}

	@:visionTestId("vision.ds.Line2D.middle#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_middle__default() {
		assertPoint(2, 0, createLine().middle);
	}

	@:visionTestId("vision.ds.Line2D.intersect#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_intersect__default() {
		var result = createLine().intersect(new Line2D(new Point2D(2, -1), new Point2D(2, 1)));
		assertPoint(2, 0, result);
	}

	@:visionTestId("vision.ds.Line2D.distanceTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		ApproxAssertions.equalsFloat(2, createLine().distanceTo(new Line2D(new Point2D(0, 2), new Point2D(4, 2))));
	}

	@:visionTestId("vision.ds.Line2D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals('\n (0, 0) --> (4, 0)', createLine().toString());
	}

	@:visionTestId("vision.ds.Line2D.toRay2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toRay2D__default() {
		var result = createLine().toRay2D();
		assertPoint(0, 0, result.point);
		ApproxAssertions.equalsFloat(0, result.slope);
	}
}

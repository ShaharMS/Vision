package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;

@:access(vision.ds.IntPoint2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class IntPoint2DTest extends utest.Test {
	function createPoint():IntPoint2D {
		return new IntPoint2D(-3, 4);
	}

	@:visionTestId("vision.ds.IntPoint2D.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		Assert.equals(-3, createPoint().x);
	}

	@:visionTestId("vision.ds.IntPoint2D.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		Assert.equals(4, createPoint().y);
	}

	@:visionTestId("vision.ds.IntPoint2D.toPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toPoint2D__default() {
		var result = createPoint().toPoint2D();
		ApproxAssertions.equalsFloat(-3, result.x);
		ApproxAssertions.equalsFloat(4, result.y);
	}

	@:visionTestId("vision.ds.IntPoint2D.fromPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromPoint2D__default() {
		var result = IntPoint2D.fromPoint2D(new Point2D(1.9, -2.1));
		Assert.equals(1, result.x);
		Assert.equals(-2, result.y);
	}

	@:visionTestId("vision.ds.IntPoint2D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals('(-3, 4)', createPoint().toString());
	}

	@:visionTestId("vision.ds.IntPoint2D.copy#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_copy__default() {
		var result = createPoint().copy();
		Assert.equals(-3, result.x);
		Assert.equals(4, result.y);
	}

	@:visionTestId("vision.ds.IntPoint2D.distanceTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		ApproxAssertions.equalsFloat(5, new IntPoint2D(0, 0).distanceTo(new IntPoint2D(3, 4)));
	}

	@:visionTestId("vision.ds.IntPoint2D.degreesTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_degreesTo__default() {
		ApproxAssertions.equalsFloat(90, new IntPoint2D(0, 0).degreesTo(new Point2D(0, 1)));
	}

	@:visionTestId("vision.ds.IntPoint2D.radiansTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radiansTo__default() {
		ApproxAssertions.equalsFloat(Math.PI / 2, new IntPoint2D(0, 0).radiansTo(new Point2D(0, 1)));
	}
}

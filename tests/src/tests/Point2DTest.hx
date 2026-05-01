package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.Point2D;

@:access(vision.ds.Point2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Point2DTest extends utest.Test {
	function createPoint():Point2D {
		return new Point2D(3.5, -2.25);
	}

	function assertPoint(expectedX:Float, expectedY:Float, actual:Point2D):Void {
		ApproxAssertions.equalsFloat(expectedX, actual.x);
		ApproxAssertions.equalsFloat(expectedY, actual.y);
	}

	@:visionTestId("vision.ds.Point2D.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		ApproxAssertions.equalsFloat(3.5, createPoint().x);
	}

	@:visionTestId("vision.ds.Point2D.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		ApproxAssertions.equalsFloat(-2.25, createPoint().y);
	}

	@:visionTestId("vision.ds.Point2D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals('(3.5, -2.25)', createPoint().toString());
	}

	@:visionTestId("vision.ds.Point2D.copy#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_copy__default() {
		var instance = createPoint();
		var result = instance.copy();
		assertPoint(3.5, -2.25, result);
		Assert.isFalse(result == instance);
	}

	@:visionTestId("vision.ds.Point2D.distanceTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		ApproxAssertions.equalsFloat(5, new Point2D(0, 0).distanceTo(new Point2D(3, 4)));
	}

	@:visionTestId("vision.ds.Point2D.degreesTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_degreesTo__default() {
		ApproxAssertions.equalsFloat(90, new Point2D(0, 0).degreesTo(new Point2D(0, 1)));
	}

	@:visionTestId("vision.ds.Point2D.radiansTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_radiansTo__default() {
		ApproxAssertions.equalsFloat(Math.PI / 2, new Point2D(0, 0).radiansTo(new Point2D(0, 1)));
	}
}

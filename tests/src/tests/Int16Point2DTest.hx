package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.Int16Point2D;

@:access(vision.ds.Int16Point2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Int16Point2DTest extends utest.Test {
	function createPoint():Int16Point2D {
		return new Int16Point2D(-12, 34);
	}

	@:visionTestId("vision.ds.Int16Point2D.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		Assert.equals(-12, createPoint().x);
	}

	@:visionTestId("vision.ds.Int16Point2D.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		Assert.equals(34, createPoint().y);
	}

	@:visionTestId("vision.ds.Int16Point2D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals('(-12, 34)', createPoint().toString());
	}

	@:visionTestId("vision.ds.Int16Point2D.toPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toPoint2D__default() {
		var result = createPoint().toPoint2D();
		ApproxAssertions.equalsFloat(-12, result.x);
		ApproxAssertions.equalsFloat(34, result.y);
	}

	@:visionTestId("vision.ds.Int16Point2D.toIntPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toIntPoint2D__default() {
		var result = createPoint().toIntPoint2D();
		ApproxAssertions.equalsFloat(-12, result.x);
		ApproxAssertions.equalsFloat(34, result.y);
	}

	@:visionTestId("vision.ds.Int16Point2D.toInt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toInt__default() {
		Assert.equals(131073, new Int16Point2D(1, 2).toInt());
	}
}

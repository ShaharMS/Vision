package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.UInt16Point2D;

@:access(vision.ds.UInt16Point2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class UInt16Point2DTest extends utest.Test {
	function createPoint():UInt16Point2D {
		return new UInt16Point2D(65537, 70000);
	}

	@:visionTestId("vision.ds.UInt16Point2D.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		Assert.equals(1, createPoint().x);
	}

	@:visionTestId("vision.ds.UInt16Point2D.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		Assert.equals(4464, createPoint().y);
	}

	@:visionTestId("vision.ds.UInt16Point2D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals('(1, 4464)', createPoint().toString());
	}

	@:visionTestId("vision.ds.UInt16Point2D.toPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toPoint2D__default() {
		var result = createPoint().toPoint2D();
		ApproxAssertions.equalsFloat(1, result.x);
		ApproxAssertions.equalsFloat(4464, result.y);
	}

	@:visionTestId("vision.ds.UInt16Point2D.toIntPoint2D#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toIntPoint2D__default() {
		var result = createPoint().toIntPoint2D();
		ApproxAssertions.equalsFloat(1, result.x);
		ApproxAssertions.equalsFloat(4464, result.y);
	}

	@:visionTestId("vision.ds.UInt16Point2D.toInt#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toInt__default() {
		Assert.equals(1450709556, new UInt16Point2D(0x1234, 0x5678).toInt());
	}
}

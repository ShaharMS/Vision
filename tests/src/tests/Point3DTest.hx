package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.Point3D;

@:access(vision.ds.Point3D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Point3DTest extends utest.Test {
	function createPoint():Point3D {
		return new Point3D(1, 2, 2);
	}

	@:visionTestId("vision.ds.Point3D.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		ApproxAssertions.equalsFloat(1, createPoint().x);
	}

	@:visionTestId("vision.ds.Point3D.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		ApproxAssertions.equalsFloat(2, createPoint().y);
	}

	@:visionTestId("vision.ds.Point3D.z#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_z__default() {
		ApproxAssertions.equalsFloat(2, createPoint().z);
	}

	@:visionTestId("vision.ds.Point3D.distanceTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		ApproxAssertions.equalsFloat(3, createPoint().distanceTo(new Point3D(0, 0, 0)));
	}

	@:visionTestId("vision.ds.Point3D.copy#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_copy__default() {
		var instance = createPoint();
		var result = instance.copy();
		ApproxAssertions.equalsFloat(1, result.x);
		ApproxAssertions.equalsFloat(2, result.y);
		ApproxAssertions.equalsFloat(2, result.z);
		Assert.isFalse(result == instance);
	}

	@:visionTestId("vision.ds.Point3D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals('(1, 2, 2)', createPoint().toString());
	}
}

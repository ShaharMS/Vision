package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.Point3D;
import vision.ds.TransformationMatrix2D;

@:access(vision.ds.TransformationMatrix2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class TransformationMatrix2DTest extends utest.Test {
	function createIdentity():TransformationMatrix2D {
		return Matrix2D.IDENTITY();
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.underlying#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_underlying__default() {
		Assert.equals(3, createIdentity().underlying.width);
		Assert.equals(3, createIdentity().underlying.height);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.a#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_a__default() {
		var instance = createIdentity();
		instance.a = 2;
		Assert.equals(2.0, instance.a);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.b#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_b__default() {
		var instance = createIdentity();
		instance.b = -3;
		Assert.equals(-3.0, instance.b);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.c#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_c__default() {
		var instance = createIdentity();
		instance.c = 4;
		Assert.equals(4.0, instance.c);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.d#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_d__default() {
		var instance = createIdentity();
		instance.d = 5;
		Assert.equals(5.0, instance.d);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.e#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_e__default() {
		var instance = createIdentity();
		instance.e = 6;
		Assert.equals(6.0, instance.e);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.f#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_f__default() {
		var instance = createIdentity();
		instance.f = 7;
		Assert.equals(7.0, instance.f);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.tx#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_tx__default() {
		var instance = createIdentity();
		instance.tx = 8;
		Assert.equals(8.0, instance.tx);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.ty#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_ty__default() {
		var instance = createIdentity();
		instance.ty = 9;
		Assert.equals(9.0, instance.ty);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.transformPoint#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_transformPoint__default() {
		var translated = Matrix2D.TRANSLATION(3, 4).transformPoint(new Point2D(1, 2));
		ApproxAssertions.equalsFloat(4, translated.x);
		ApproxAssertions.equalsFloat(6, translated.y);
		var identity3D = createIdentity().transformPoint(new Point3D(1, 2, 3));
		ApproxAssertions.equalsFloat(1, identity3D.x);
		ApproxAssertions.equalsFloat(2, identity3D.y);
		ApproxAssertions.equalsFloat(3, identity3D.z);
	}

}

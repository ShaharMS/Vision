package tests;

import utest.Assert;
import vision.ds.Point3D;
import vision.ds.TransformationMatrix2D;

@:access(vision.ds.TransformationMatrix2D)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class TransformationMatrix2DTest extends utest.Test {

	@:visionTestId("vision.ds.TransformationMatrix2D.underlying#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_underlying__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.underlying;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.a#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_a__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.a;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.b#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_b__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.b;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.c#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_c__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.c;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.d#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_d__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.d;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.e#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_e__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.e;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.f#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_f__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.f;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.tx#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_tx__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.tx;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.ty#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_ty__default() {
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.ty;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.TransformationMatrix2D.transformPoint#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_transformPoint__default() {
		var point = new vision.ds.Point3D(0.0, 0.0, 0.0);
		var instance = vision.ds.Matrix2D.IDENTITY();
		var result = instance.transformPoint(point);
		Assert.notNull(result);
	}

}

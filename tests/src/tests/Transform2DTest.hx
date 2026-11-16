package tests;

import tests.support.ApproxAssertions;
import tests.support.ExceptionAssertions;
import vision.ds.specifics.PointTransformationPair;
import utest.Assert;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.Point3D;
import vision.ds.Transform2D;

@:access(vision.ds.Transform2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Transform2DTest extends utest.Test {
	function createIdentity():Transform2D {
		return Transform2D.identity();
	}

	@:visionTestId("vision.ds.Transform2D.toMatrix#default")
	@:visionTestId("vision.ds.Transform2D.identity#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toMatrix__default() {
		Assert.equals(3, createIdentity().toMatrix().width);
		Assert.equals(3, createIdentity().toMatrix().height);
	}

	@:visionTestId("vision.ds.Transform2D.a#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_a__default() {
		var instance = createIdentity();
		instance.a = 2;
		Assert.equals(2.0, instance.a);
	}

	@:visionTestId("vision.ds.Transform2D.b#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_b__default() {
		var instance = createIdentity();
		instance.b = -3;
		Assert.equals(-3.0, instance.b);
	}

	@:visionTestId("vision.ds.Transform2D.c#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_c__default() {
		var instance = createIdentity();
		instance.c = 4;
		Assert.equals(4.0, instance.c);
	}

	@:visionTestId("vision.ds.Transform2D.d#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_d__default() {
		var instance = createIdentity();
		instance.d = 5;
		Assert.equals(5.0, instance.d);
	}

	@:visionTestId("vision.ds.Transform2D.e#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_e__default() {
		var instance = createIdentity();
		instance.e = 6;
		Assert.equals(6.0, instance.e);
	}

	@:visionTestId("vision.ds.Transform2D.f#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_f__default() {
		var instance = createIdentity();
		instance.f = 7;
		Assert.equals(7.0, instance.f);
	}

	@:visionTestId("vision.ds.Transform2D.tx#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_tx__default() {
		var instance = createIdentity();
		instance.tx = 8;
		Assert.equals(8.0, instance.tx);
	}

	@:visionTestId("vision.ds.Transform2D.ty#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_ty__default() {
		var instance = createIdentity();
		instance.ty = 9;
		Assert.equals(9.0, instance.ty);
	}

	@:visionTestId("vision.ds.Transform2D.apply#default")
	@:visionTestId("vision.ds.Transform2D.applyHomogeneous#identity")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_apply__default() {
		var translated = Transform2D.translation(3, 4).apply(new Point2D(1, 2));
		ApproxAssertions.equalsFloat(4, translated.x);
		ApproxAssertions.equalsFloat(6, translated.y);
		var identity3D = createIdentity().applyHomogeneous(new Point3D(1, 2, 3));
		ApproxAssertions.equalsFloat(1, identity3D.x);
		ApproxAssertions.equalsFloat(2, identity3D.y);
		ApproxAssertions.equalsFloat(3, identity3D.z);
	}


	@:visionTestId("vision.ds.Transform2D.fromMatrix#shapeAndCopy")
	function test_fromMatrix__shapeAndCopy() {
		ExceptionAssertions.throwsType(() -> Transform2D.fromMatrix(Matrix2D.identity(2)), vision.exceptions.MatrixShapeError);

		var source = Matrix2D.identity(3);
		var transform = Transform2D.fromMatrix(source);
		source.set(2, 0, 4);
		var matrix:Matrix2D = transform;
		matrix.set(2, 0, 8);
		Assert.equals(0.0, transform.tx);
	}

	@:visionTestId("vision.ds.Transform2D.apply#projectiveDivision")
	@:visionTestId("vision.ds.Transform2D.isAffine#projectiveDenominator")
	function test_apply__projectiveDivision() {
		var transform = Transform2D.fromRows([1, 0, 0], [0, 1, 0], [1, 0, 1]);
		Assert.isFalse(transform.isAffine());
		var point = transform.apply(new Point2D(1, 2));
		ApproxAssertions.equalsFloat(0.5, point.x);
		ApproxAssertions.equalsFloat(1, point.y);
		ExceptionAssertions.throwsType(() -> transform.apply(new Point2D(-1, 0)), vision.exceptions.VisionException);
	}

	@:visionTestId("vision.ds.Transform2D.then#applicationOrder")
	@:visionTestId("vision.ds.Transform2D.inverse#roundTrip")
	function test_then__applicationOrder() {
		var transform = Transform2D.translation(1, 3).then(Transform2D.scale(2, 4));
		var point = transform.apply(new Point2D(2, 1));
		ApproxAssertions.equalsFloat(6, point.x);
		ApproxAssertions.equalsFloat(16, point.y);
		var original = transform.inverse().apply(point);
		ApproxAssertions.equalsFloat(2, original.x);
		ApproxAssertions.equalsFloat(1, original.y);
	}

	@:visionTestId("vision.ds.Transform2D.rotationRadians#pivot")
	function test_rotationRadians__pivot() {
		var pivot = new Point2D(3, 4);
		var result = Transform2D.rotationRadians(Math.PI / 2, pivot).apply(new Point2D(4, 4));
		ApproxAssertions.equalsFloat(3, result.x);
		ApproxAssertions.equalsFloat(5, result.y);
	}

	function assertMatrix(expected:Array<Array<Float>>, actual:Matrix2D):Void {
		Assert.same(expected, (actual : Array<Array<Float>>));
	}

	@:visionTestId("vision.ds.Transform2D.rotationDegrees#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_rotationDegrees__default() {
		var result = Transform2D.rotationDegrees(90, new Point2D(0, 0)).apply(new Point2D(1, 0));
		ApproxAssertions.equalsFloat(0, result.x);
		ApproxAssertions.equalsFloat(1, result.y);
	}

	@:visionTestId("vision.ds.Transform2D.translation#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_translation__default() {
		var result = Transform2D.translation(3, 4);
		assertMatrix([[1.0, 0.0, 3.0], [0.0, 1.0, 4.0], [0.0, 0.0, 1.0]], result);
	}

	@:visionTestId("vision.ds.Transform2D.scale#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_scale__default() {
		assertMatrix([[2.0, 0.0, 0.0], [0.0, 3.0, 0.0], [0.0, 0.0, 1.0]], Transform2D.scale(2, 3));
	}

	@:visionTestId("vision.ds.Transform2D.shear#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_shear__default() {
		assertMatrix([[1.0, 2.0, 0.0], [3.0, 1.0, 0.0], [0.0, 0.0, 1.0]], Transform2D.shear(2, 3));
	}

	@:visionTestId("vision.ds.Transform2D.reflection#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_reflection__default() {
		var result = Transform2D.reflection(0, true, new Point2D(0, 0));
		ApproxAssertions.equalsFloat(1, result.a);
		ApproxAssertions.equalsFloat(0, result.b);
		ApproxAssertions.equalsFloat(0, result.c);
		ApproxAssertions.equalsFloat(-1, result.d);
	}

	@:visionTestId("vision.ds.Transform2D.perspective#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_perspective__default() {
		var pointPairs = [
			new PointTransformationPair(new Point2D(0, 0), new Point2D(0, 0)),
			new PointTransformationPair(new Point2D(1, 0), new Point2D(1, 0)),
			new PointTransformationPair(new Point2D(0, 1), new Point2D(0, 1)),
			new PointTransformationPair(new Point2D(1, 1), new Point2D(2, 1)),
		];
		var transform = Transform2D.perspective(pointPairs);
		Assert.isFalse(transform.isAffine());
		for (pair in pointPairs) {
			var result = transform.apply(pair.from);
			ApproxAssertions.equalsFloat(pair.to.x, result.x);
			ApproxAssertions.equalsFloat(pair.to.y, result.y);
		}
	}

	@:visionTestId("vision.ds.Transform2D.perspective#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_perspective__duplicates() {
		var pointPairs = [
			new PointTransformationPair(new Point2D(0, 0), new Point2D(1, 1)),
			new PointTransformationPair(new Point2D(0, 0), new Point2D(1, 1)),
			new PointTransformationPair(new Point2D(0, 1), new Point2D(1, 3)),
			new PointTransformationPair(new Point2D(1, 1), new Point2D(3, 2)),
		];
		ExceptionAssertions.throwsType(() -> {
			Transform2D.perspective(pointPairs);
		}, vision.exceptions.SingularMatrixError);
	}

	@:visionTestId("vision.ds.Transform2D.depth#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_depth__default() {
		var result = Transform2D.depth(2, new Point2D(5, 6)).applyHomogeneous(new Point3D(0, 0, 1));
		ApproxAssertions.equalsFloat(5, result.x);
		ApproxAssertions.equalsFloat(6, result.y);
		ApproxAssertions.equalsFloat(2, result.z);
	}

	@:visionTestId("vision.ds.Transform2D.fromRows#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromRows__default() {
		assertMatrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [0.0, 0.0, 1.0]], Transform2D.fromRows([1, 2, 3], [4, 5, 6]));
	}

	@:visionTestId("vision.ds.Transform2D.fromRows#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fromRows__duplicates() {
		assertMatrix([[2.0, 2.0, 2.0], [3.0, 3.0, 3.0], [0.0, 0.0, 1.0]], Transform2D.fromRows([2, 2, 2], [3, 3, 3]));
	}

}

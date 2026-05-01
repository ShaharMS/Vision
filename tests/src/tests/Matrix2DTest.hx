package tests;

import tests.support.ApproxAssertions;
import tests.support.CollectionAssertions;
import utest.Assert;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.Point3D;
import vision.ds.specifics.PointTransformationPair;

@:access(vision.ds.Matrix2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Matrix2DTest extends utest.Test {
	function createMatrix():Matrix2D {
		return Matrix2D.createFilled([1, 2], [3, 4]);
	}

	function assertMatrix(expected:Array<Array<Float>>, actual:Matrix2D):Void {
		CollectionAssertions.nestedValues(expected, actual.underlying.to2DArray());
	}

	@:visionTestId("vision.ds.Matrix2D.underlying#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_underlying__default() {
		CollectionAssertions.values([1.0, 2.0, 3.0, 4.0], createMatrix().underlying.inner);
	}

	@:visionTestId("vision.ds.Matrix2D.rows#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_rows__default() {
		Assert.equals(2, createMatrix().rows);
	}

	@:visionTestId("vision.ds.Matrix2D.columns#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_columns__default() {
		Assert.equals(2, createMatrix().columns);
	}

	@:visionTestId("vision.ds.Matrix2D.invert#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_invert__default() {
		var result = Matrix2D.createFilled([1, 0], [0, 1]);
		result.invert();
		assertMatrix([[1.0, 0.0], [0.0, 1.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.getDeterminant#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getDeterminant__default() {
		Assert.equals(-2.0, createMatrix().getDeterminant());
	}

	@:visionTestId("vision.ds.Matrix2D.getTrace#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getTrace__default() {
		Assert.equals(5.0, createMatrix().getTrace());
	}

	@:visionTestId("vision.ds.Matrix2D.getAverage#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getAverage__default() {
		ApproxAssertions.equalsFloat(2.5, createMatrix().getAverage());
	}

	@:visionTestId("vision.ds.Matrix2D.multiplyWithScalar#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_multiplyWithScalar__default() {
		var result = createMatrix();
		result.multiplyWithScalar(2);
		assertMatrix([[2.0, 4.0], [6.0, 8.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.clone#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_clone__default() {
		var instance = createMatrix();
		var clone = instance.clone();
		instance.set(0, 0, 9);
		assertMatrix([[1.0, 2.0], [3.0, 4.0]], clone);
	}

	@:visionTestId("vision.ds.Matrix2D.map#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_map__default() {
		var result = createMatrix().map((value) -> value + 1);
		assertMatrix([[2.0, 3.0], [4.0, 5.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.getSubMatrix#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getSubMatrix__default() {
		var result = Matrix2D.createFilled([1, 2, 3], [4, 5, 6]).getSubMatrix(1, 0, 3, 2);
		assertMatrix([[2.0, 3.0], [5.0, 6.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.getColumn#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getColumn__default() {
		CollectionAssertions.values([2.0, 4.0], createMatrix().getColumn(1));
	}

	@:visionTestId("vision.ds.Matrix2D.getRow#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getRow__default() {
		CollectionAssertions.values([3.0, 4.0], createMatrix().getRow(1));
	}

	@:visionTestId("vision.ds.Matrix2D.setColumn#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setColumn__default() {
		var instance = createMatrix();
		instance.setColumn(1, [8, 9]);
		assertMatrix([[1.0, 8.0], [3.0, 9.0]], instance);
	}

	@:visionTestId("vision.ds.Matrix2D.setColumn#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setColumn__duplicates() {
		var instance = createMatrix();
		instance.setColumn(0, [7, 7]);
		assertMatrix([[7.0, 2.0], [7.0, 4.0]], instance);
	}

	@:visionTestId("vision.ds.Matrix2D.setRow#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setRow__default() {
		var instance = createMatrix();
		instance.setRow(1, [8, 9]);
		assertMatrix([[1.0, 2.0], [8.0, 9.0]], instance);
	}

	@:visionTestId("vision.ds.Matrix2D.setRow#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setRow__duplicates() {
		var instance = createMatrix();
		instance.setRow(0, [7, 7]);
		assertMatrix([[7.0, 7.0], [3.0, 4.0]], instance);
	}

	@:visionTestId("vision.ds.Matrix2D.insertColumn#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_insertColumn__default() {
		var result = createMatrix();
		result.insertColumn(1, [8, 9]);
		assertMatrix([[1.0, 8.0, 2.0], [3.0, 9.0, 4.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.insertColumn#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_insertColumn__duplicates() {
		var result = createMatrix();
		result.insertColumn(1, [7, 7]);
		assertMatrix([[1.0, 7.0, 2.0], [3.0, 7.0, 4.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.insertRow#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_insertRow__default() {
		var result = createMatrix();
		result.insertRow(1, [8, 9]);
		assertMatrix([[1.0, 2.0], [8.0, 9.0], [3.0, 4.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.insertRow#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_insertRow__duplicates() {
		var result = createMatrix();
		result.insertRow(1, [7, 7]);
		assertMatrix([[1.0, 2.0], [7.0, 7.0], [3.0, 4.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.removeColumn#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_removeColumn__default() {
		var result = createMatrix();
		result.removeColumn(0);
		assertMatrix([[2.0], [4.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.removeRow#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_removeRow__default() {
		var result = createMatrix();
		result.removeRow(1);
		assertMatrix([[1.0, 2.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals('\n[[1, 2],\n [3, 4]]', createMatrix().toString(1, false));
	}

	@:visionTestId("vision.ds.Matrix2D.IDENTITY#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_IDENTITY__default() {
		assertMatrix([[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]], Matrix2D.IDENTITY());
	}

	@:visionTestId("vision.ds.Matrix2D.ROTATION#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_ROTATION__default() {
		var result = Matrix2D.ROTATION(90, true, new Point2D(0, 0)).transformPoint(new Point2D(1, 0));
		ApproxAssertions.equalsFloat(0, result.x);
		ApproxAssertions.equalsFloat(1, result.y);
	}

	@:visionTestId("vision.ds.Matrix2D.TRANSLATION#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_TRANSLATION__default() {
		var result = Matrix2D.TRANSLATION(3, 4);
		assertMatrix([[1.0, 0.0, 3.0], [0.0, 1.0, 4.0], [0.0, 0.0, 1.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.SCALE#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_SCALE__default() {
		assertMatrix([[2.0, 0.0, 0.0], [0.0, 3.0, 0.0], [0.0, 0.0, 1.0]], Matrix2D.SCALE(2, 3));
	}

	@:visionTestId("vision.ds.Matrix2D.SHEAR#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_SHEAR__default() {
		assertMatrix([[1.0, 2.0, 0.0], [3.0, 1.0, 0.0], [0.0, 0.0, 1.0]], Matrix2D.SHEAR(2, 3));
	}

	@:visionTestId("vision.ds.Matrix2D.REFLECTION#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_REFLECTION__default() {
		var result = Matrix2D.REFLECTION(0, true, new Point2D(0, 0));
		ApproxAssertions.equalsFloat(1, result.a);
		ApproxAssertions.equalsFloat(0, result.b);
		ApproxAssertions.equalsFloat(0, result.c);
		ApproxAssertions.equalsFloat(-1, result.d);
	}

	@:visionTestId("vision.ds.Matrix2D.PERSPECTIVE#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_PERSPECTIVE__default() {
		var pointPairs = [
			new PointTransformationPair(new Point2D(0, 0), new Point2D(0, 0)),
			new PointTransformationPair(new Point2D(1, 0), new Point2D(1, 0)),
			new PointTransformationPair(new Point2D(0, 1), new Point2D(0, 1)),
			new PointTransformationPair(new Point2D(1, 1), new Point2D(1, 1)),
		];
		var result = Matrix2D.PERSPECTIVE(pointPairs).transformPoint(new Point2D(0.5, 0.25));
		ApproxAssertions.equalsFloat(0.5, result.x, 0.01);
		ApproxAssertions.equalsFloat(0.25, result.y, 0.01);
	}

	@:visionTestId("vision.ds.Matrix2D.PERSPECTIVE#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_PERSPECTIVE__duplicates() {
		var pointPairs = [
			new PointTransformationPair(new Point2D(0, 0), new Point2D(0, 0)),
			new PointTransformationPair(new Point2D(1, 0), new Point2D(1, 0)),
			new PointTransformationPair(new Point2D(0, 1), new Point2D(0, 1)),
			new PointTransformationPair(new Point2D(1, 1), new Point2D(1, 1)),
		];
		Assert.notNull(Matrix2D.PERSPECTIVE(pointPairs));
	}

	@:visionTestId("vision.ds.Matrix2D.DEPTH#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_DEPTH__default() {
		var result = Matrix2D.DEPTH(2, new Point2D(5, 6)).transformPoint(new Point3D(0, 0, 1));
		ApproxAssertions.equalsFloat(5, result.x);
		ApproxAssertions.equalsFloat(6, result.y);
		ApproxAssertions.equalsFloat(2, result.z);
	}

	@:visionTestId("vision.ds.Matrix2D.createFilled#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_createFilled__default() {
		assertMatrix([[1.0, 2.0], [3.0, 4.0]], Matrix2D.createFilled([1, 2], [3, 4]));
	}

	@:visionTestId("vision.ds.Matrix2D.createTransformation#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_createTransformation__default() {
		assertMatrix([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [0.0, 0.0, 1.0]], Matrix2D.createTransformation([1, 2, 3], [4, 5, 6]));
	}

	@:visionTestId("vision.ds.Matrix2D.createTransformation#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_createTransformation__duplicates() {
		assertMatrix([[2.0, 2.0, 2.0], [3.0, 3.0, 3.0], [0.0, 0.0, 1.0]], Matrix2D.createTransformation([2, 2, 2], [3, 3, 3]));
	}

	@:visionTestId("vision.ds.Matrix2D.multiplyMatrices#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_multiplyMatrices__default() {
		assertMatrix([[19.0, 22.0], [43.0, 50.0]], Matrix2D.multiplyMatrices(Matrix2D.createFilled([1, 2], [3, 4]), Matrix2D.createFilled([5, 6], [7, 8])));
	}

	@:visionTestId("vision.ds.Matrix2D.addMatrices#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_addMatrices__default() {
		assertMatrix([[6.0, 8.0], [10.0, 12.0]], Matrix2D.addMatrices(Matrix2D.createFilled([1, 2], [3, 4]), Matrix2D.createFilled([5, 6], [7, 8])));
	}

	@:visionTestId("vision.ds.Matrix2D.subtractMatrices#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_subtractMatrices__default() {
		assertMatrix([[-4.0, -4.0], [-4.0, -4.0]], Matrix2D.subtractMatrices(Matrix2D.createFilled([1, 2], [3, 4]), Matrix2D.createFilled([5, 6], [7, 8])));
	}

	@:visionTestId("vision.ds.Matrix2D.divideMatrices#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_divideMatrices__default() {
		assertMatrix([[5.0, 5.0], [9.0, 9.0]], Matrix2D.divideMatrices(Matrix2D.createFilled([2, 3], [4, 5]), Matrix2D.createFilled([1, 1], [1, 1])));
	}

	@:visionTestId("vision.ds.Matrix2D.multiply#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_multiply__default() {
		var result = Matrix2D.createFilled([1, 2], [3, 4]);
		result.multiply(Matrix2D.createFilled([5, 6], [7, 8]));
		assertMatrix([[19.0, 22.0], [43.0, 50.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.add#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_add__default() {
		var result = Matrix2D.createFilled([1, 2], [3, 4]);
		result.add(Matrix2D.createFilled([5, 6], [7, 8]));
		assertMatrix([[6.0, 8.0], [10.0, 12.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.subtract#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_subtract__default() {
		var result = Matrix2D.createFilled([1, 2], [3, 4]);
		result.subtract(Matrix2D.createFilled([5, 6], [7, 8]));
		assertMatrix([[-4.0, -4.0], [-4.0, -4.0]], result);
	}

	@:visionTestId("vision.ds.Matrix2D.divide#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_divide__default() {
		var result = Matrix2D.createFilled([2, 3], [4, 5]);
		result.divide(Matrix2D.createFilled([1, 1], [1, 1]));
		assertMatrix([[5.0, 5.0], [9.0, 9.0]], result);
	}

}

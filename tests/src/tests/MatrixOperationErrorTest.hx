package tests;

import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.ds.Matrix2D;
import vision.exceptions.MatrixOperationError;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class MatrixOperationErrorTest extends utest.Test {
	@:visionTestId("vision.exceptions.MatrixOperationError.errorByType#addition")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_errorByType__describesMismatchedAddition() {
		var first = createZeroMatrix(2, 2);
		var second = createZeroMatrix(3, 1);
		var message = MatrixOperationError.errorByType("add", [first, second], cast 1);

		Assert.isTrue(message.indexOf("Cannot calculate:") == 0);
		Assert.isTrue(message.indexOf("+") != -1);
		Assert.isTrue(message.indexOf("Width & height of first matrix (") != -1);
		Assert.isTrue(message.indexOf("different from those of the second matrix (") != -1);
	}

	@:visionTestId("vision.exceptions.MatrixOperationError.new#prefix")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__wrapsOperationNameInPrefix() {
		var first = createZeroMatrix(2, 2);
		var second = createZeroMatrix(3, 1);
		var error = ExceptionAssertions.capture(
			() -> throw new MatrixOperationError("add", [first, second], cast 1)
		);

		Assert.isTrue(Std.isOfType(error, MatrixOperationError));
		Assert.isTrue(ExceptionAssertions.messageOf(error).indexOf("Matrix Add Error: Cannot calculate:") == 0);
	}

	function createZeroMatrix(width:Int, height:Int):Matrix2D {
		var matrix = new Matrix2D(width, height);
		matrix.fill(0);
		return matrix;
	}
}
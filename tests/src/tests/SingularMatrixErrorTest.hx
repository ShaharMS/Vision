package tests;

import tests.support.ExceptionAssertions;
import vision.ds.Matrix2D;
import vision.exceptions.SingularMatrixError;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class SingularMatrixErrorTest extends utest.Test {
	@:visionTestId("vision.exceptions.SingularMatrixError.new#detail")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__includesOperationSizeAndDetail() {
		var matrix = new Matrix2D(2, 2);

		ExceptionAssertions.expectMessage(
			() -> throw new SingularMatrixError(matrix, "invert", "Zero pivot encountered."),
			SingularMatrixError,
			"Singular Matrix Error: Cannot invert a singular matrix of size 2x2 because its determinant is 0. Zero pivot encountered. Provide a non-singular matrix with linearly independent rows/columns, or validate the determinant before calling this operation."
		);
	}
}
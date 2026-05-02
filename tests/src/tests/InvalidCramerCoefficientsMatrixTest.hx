package tests;

import tests.support.ExceptionAssertions;
import vision.ds.Matrix2D;
import vision.exceptions.InvalidCramerCoefficientsMatrix;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class InvalidCramerCoefficientsMatrixTest extends utest.Test {
	@:visionTestId("vision.exceptions.InvalidCramerCoefficientsMatrix.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__reportsNonSquareMatrixSize() {
		var coefficients = new Matrix2D(3, 2);

		ExceptionAssertions.expectMessage(
			() -> throw new InvalidCramerCoefficientsMatrix(coefficients),
			InvalidCramerCoefficientsMatrix,
			"Invalid Cramer Coefficients Matrix: Cramer coefficients matrix must be square (given matrix is 2x3)"
		);
	}
}
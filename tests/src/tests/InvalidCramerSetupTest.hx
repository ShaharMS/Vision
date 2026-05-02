package tests;

import tests.support.ExceptionAssertions;
import vision.ds.Matrix2D;
import vision.exceptions.InvalidCramerSetup;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class InvalidCramerSetupTest extends utest.Test {
	@:visionTestId("vision.exceptions.InvalidCramerSetup.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__reportsCoefficientAndSolutionSizes() {
		var coefficients = new Matrix2D(3, 2);

		ExceptionAssertions.expectMessage(
			() -> throw new InvalidCramerSetup(coefficients, [1.0]),
			InvalidCramerSetup,
			"Invalid Cramer Setup: Coefficients' size must match solutions' length (coefficients: 2x3, solutions: 1)"
		);
	}
}
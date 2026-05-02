package tests;

import tests.support.ApproxAssertions;
import tests.support.ExceptionAssertions;
import vision.algorithms.GaussJordan;
import vision.ds.Matrix2D;
import vision.exceptions.SingularMatrixError;

@:access(vision.algorithms.GaussJordan)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class GaussJordanTest extends utest.Test {
	@:visionTestId("vision.algorithms.GaussJordan.invert#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_invert__default() {
		var result = GaussJordan.invert(Matrix2D.createFilled([4.0, 7.0], [2.0, 6.0]));
		ApproxAssertions.equalsFloat(0.6, result.get(0, 0));
		ApproxAssertions.equalsFloat(-0.7, result.get(1, 0));
		ApproxAssertions.equalsFloat(-0.2, result.get(0, 1));
		ApproxAssertions.equalsFloat(0.4, result.get(1, 1));
	}

	@:visionTestId("vision.algorithms.GaussJordan.invert#singular")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_invert__singular() {
		ExceptionAssertions.throwsType(() -> {
			GaussJordan.invert(Matrix2D.createFilled([1.0, 2.0], [2.0, 4.0]));
		}, SingularMatrixError);
	}
}

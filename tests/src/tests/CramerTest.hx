package tests;

import tests.support.ApproxAssertions;
import tests.support.ExceptionAssertions;
import vision.algorithms.Cramer;
import vision.ds.Matrix2D;
import vision.exceptions.InvalidCramerCoefficientsMatrix;
import vision.exceptions.InvalidCramerSetup;
import vision.exceptions.SingularMatrixError;

@:access(vision.algorithms.Cramer)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class CramerTest extends utest.Test {
	function assertSolution(expected:Array<Float>, actual:Array<Float>):Void {
		for (index in 0...expected.length) {
			ApproxAssertions.equalsFloat(expected[index], actual[index]);
		}
	}

	@:visionTestId("vision.algorithms.Cramer.solveVariablesFor#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_solveVariablesFor__default() {
		var coefficients = Matrix2D.createFilled([2.0, 1.0, -1.0], [-3.0, -1.0, 2.0], [-2.0, 1.0, 2.0]);
		var result = Cramer.solveVariablesFor(coefficients, [8.0, -11.0, -3.0]);
		assertSolution([2.0, 3.0, -1.0], result);
	}

	@:visionTestId("vision.algorithms.Cramer.solveVariablesFor#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_solveVariablesFor__duplicates() {
		ExceptionAssertions.throwsType(() -> {
			Cramer.solveVariablesFor(Matrix2D.createFilled([1.0, 2.0], [1.0, 2.0]), [3.0, 3.0]);
		}, SingularMatrixError);
	}

	@:visionTestId("vision.algorithms.Cramer.solveVariablesFor#invalidShape")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_solveVariablesFor__invalidShape() {
		ExceptionAssertions.throwsType(() -> {
			Cramer.solveVariablesFor(Matrix2D.createFilled([1.0, 2.0, 3.0], [4.0, 5.0, 6.0]), [7.0, 8.0]);
		}, InvalidCramerCoefficientsMatrix);
	}

	@:visionTestId("vision.algorithms.Cramer.solveVariablesFor#invalidSetup")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_solveVariablesFor__invalidSetup() {
		ExceptionAssertions.throwsType(() -> {
			Cramer.solveVariablesFor(Matrix2D.createFilled([1.0, 0.0], [0.0, 1.0]), [1.0]);
		}, InvalidCramerSetup);
	}
}

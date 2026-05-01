package tests;

import utest.Assert;
import vision.algorithms.Cramer;
import vision.ds.Matrix2D;

@:access(vision.algorithms.Cramer)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class CramerTest extends utest.Test {

	@:visionTestId("vision.algorithms.Cramer.solveVariablesFor#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_solveVariablesFor__default() {
		var coefficients = vision.ds.Matrix2D.createFilled([1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]);
		var solutions = [1.0, 2.0, 3.0];
		var result = vision.algorithms.Cramer.solveVariablesFor(coefficients, solutions);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Cramer.solveVariablesFor#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_solveVariablesFor__duplicates() {
		var coefficients = vision.ds.Matrix2D.createFilled([1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]);
		var solutions = [1.0, 1.0, 2.0];
		var result = vision.algorithms.Cramer.solveVariablesFor(coefficients, solutions);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}

package tests;

import utest.Assert;
import vision.algorithms.GaussJordan;
import vision.ds.Matrix2D;

@:access(vision.algorithms.GaussJordan)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class GaussJordanTest extends utest.Test {

	@:visionTestId("vision.algorithms.GaussJordan.invert#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_invert__default() {
		var matrix = vision.ds.Matrix2D.createFilled([1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]);
		var result = vision.algorithms.GaussJordan.invert(matrix);
		Assert.notNull(result);
	}

}

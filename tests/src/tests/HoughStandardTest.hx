package tests;

import utest.Assert;
import vision.algorithms.Hough;
import vision.ds.Color;
import vision.ds.Image;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HoughStandardTest extends utest.Test {
	@:visionTestId("vision.algorithms.Hough.createAccumulator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_createAccumulator__default() {
		var accumulator = Hough.createAccumulator(4, 3);
		Assert.equals(4, accumulator.width);
		Assert.equals(3, accumulator.height);
		Assert.equals(0.0, accumulator.get(0, 0));
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__default() {
		var result = Hough.detectLines(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.length);
	}
}
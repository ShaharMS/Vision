package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.Canny;

@:access(vision.algorithms.Canny)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class CannyTest extends utest.Test {

	@:visionTestId("vision.algorithms.Canny.grayscale#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_grayscale__default() {
		var image = Factories.gradientImage(16, 16);
		var result = vision.algorithms.Canny.grayscale(image);
		Assert.notNull(result);
	}

	@:visionTestId("vision.algorithms.Canny.applyGaussian#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_applyGaussian__default() {
		var image = Factories.gradientImage(16, 16);
		var size = 3;
		var sigma = 1.0;
		var result = vision.algorithms.Canny.applyGaussian(image, size, sigma);
		Assert.notNull(result);
	}

	@:visionTestId("vision.algorithms.Canny.applySobelFilters#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_applySobelFilters__default() {
		var image = Factories.gradientImage(16, 16);
		var result = vision.algorithms.Canny.applySobelFilters(image);
		Assert.notNull(result);
	}

	@:visionTestId("vision.algorithms.Canny.nonMaxSuppression#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_nonMaxSuppression__default() {
		var image = Factories.gradientImage(16, 16);
		var result = vision.algorithms.Canny.nonMaxSuppression(image);
		Assert.notNull(result);
	}

	@:visionTestId("vision.algorithms.Canny.applyHysteresis#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_applyHysteresis__default() {
		var image = Factories.gradientImage(16, 16);
		var highThreshold = 1.0;
		var lowThreshold = 1.0;
		var result = vision.algorithms.Canny.applyHysteresis(image, highThreshold, lowThreshold);
		Assert.notNull(result);
	}

}

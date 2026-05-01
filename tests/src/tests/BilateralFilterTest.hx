package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.BilateralFilter;
import vision.ds.Image;

@:access(vision.algorithms.BilateralFilter)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class BilateralFilterTest extends utest.Test {

	@:visionTestId("vision.algorithms.BilateralFilter.filter#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filter__default() {
		var image = Factories.gradientImage(3, 3);
		var distanceSigma = 1.0;
		var intensitySigma = 1.0;
		var result = vision.algorithms.BilateralFilter.filter(image, distanceSigma, intensitySigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.BilateralFilter.filter#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filter__tiny() {
		var image = Factories.gradientImage(3, 3);
		var distanceSigma = 1.0;
		var intensitySigma = 1.0;
		var result = vision.algorithms.BilateralFilter.filter(image, distanceSigma, intensitySigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.BilateralFilter.filter#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filter__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var distanceSigma = 1.0;
		var intensitySigma = 1.0;
		var result = vision.algorithms.BilateralFilter.filter(image, distanceSigma, intensitySigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

}

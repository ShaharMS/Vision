package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ImageAssertions;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.Canny;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.Canny)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class CannyTest extends utest.Test {
	@:visionTestId("vision.algorithms.Canny.grayscale#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_grayscale__default() {
		var result = Canny.grayscale(new Image(1, 1, Color.fromRGBA(100, 50, 0, 255)));
		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(57, 57, 57, 255));
	}

	@:visionTestId("vision.algorithms.Canny.applyGaussian#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_applyGaussian__default() {
		var result = Canny.applyGaussian(AlgorithmFixtures.centerPixelImage(3), 3, 1.0);
		Assert.isTrue(result.getPixel(1, 1).red < 255);
		Assert.isTrue(result.getPixel(1, 1).red > 0);
		Assert.isTrue(result.getPixel(0, 1).red > 0);
	}

	@:visionTestId("vision.algorithms.Canny.applySobelFilters#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_applySobelFilters__default() {
		var result = Canny.applySobelFilters(AlgorithmFixtures.stepEdgeImage());
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(result.getPixel(1, 2).red > result.getPixel(0, 2).red);
	}

	@:visionTestId("vision.algorithms.Canny.nonMaxSuppression#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_nonMaxSuppression__default() {
		var image = new Image(3, 3, Color.fromRGBA(10, 10, 10, 255));
		image.setPixel(1, 1, Color.fromRGBA(100, 100, 100, 255));
		var result = Canny.nonMaxSuppression(image);
		ImageAssertions.pixelEquals(result, 1, 1, Color.fromRGBA(100, 100, 100, 255));
		Assert.equals(0, result.getPixel(0, 0).red);
	}

	@:visionTestId("vision.algorithms.Canny.applyHysteresis#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_applyHysteresis__default() {
		var image = new Image(3, 3, Color.BLACK);
		image.setPixel(1, 1, Color.WHITE);
		image.setPixel(1, 0, Color.fromRGBA(180, 180, 180, 255));
		image.setPixel(2, 2, Color.fromRGBA(180, 180, 180, 255));
		var result = Canny.applyHysteresis(image, 0.8, 0.5);
		ImageAssertions.pixelEquals(result, 1, 0, Color.WHITE);
		ImageAssertions.pixelEquals(result, 2, 2, Color.TRANSPARENT_COLOR);
	}
}

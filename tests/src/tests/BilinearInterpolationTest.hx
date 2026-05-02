package tests;

import tests.support.Factories;
import tests.support.ImageAssertions;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.BilinearInterpolation;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.BilinearInterpolation)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class BilinearInterpolationTest extends utest.Test {
	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolate#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__default() {
		var result = BilinearInterpolation.interpolate(ManualFixtures.interpolationImage(), 3, 3);
		ImageAssertions.hasDimensions(result, 3, 3);
		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(0, 0, 0, 255));
		ImageAssertions.pixelEquals(result, 1, 1, Color.fromRGBA(56, 56, 28, 255));
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolate#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__tiny() {
		var expected = Color.fromRGBA(12, 34, 56, 255);
		var result = BilinearInterpolation.interpolate(new Image(1, 1, expected), 1, 1);
		ResamplerAssertions.uniformColor(result, expected);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolate#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__checkerboard() {
		var result = BilinearInterpolation.interpolate(ManualFixtures.tinyCheckerboardImage(), 3, 3);
		ImageAssertions.hasDimensions(result, 3, 3);
		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(255, 255, 255, 255));
		ResamplerAssertions.opaqueGrayscale(result);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolateMissingPixels#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolateMissingPixels__default() {
		var image = new Image(3, 3, 0x00000000);
		image.setPixel(1, 0, Color.fromRGBA(120, 20, 40, 255));
		image.setPixel(0, 1, Color.fromRGBA(20, 140, 40, 255));
		image.setPixel(2, 1, Color.fromRGBA(60, 40, 200, 255));
		image.setPixel(1, 2, Color.fromRGBA(80, 100, 60, 255));
		var result = BilinearInterpolation.interpolateMissingPixels(image, 1, 1, 0, 0);
		ImageAssertions.pixelEquals(result, 1, 1, Color.fromRGBA(70, 75, 85, 255));
		ImageAssertions.pixelEquals(result, 1, 0, Color.fromRGBA(120, 20, 40, 255));
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolateMissingPixels#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolateMissingPixels__tiny() {
		var image = new Image(1, 1, Color.fromRGBA(12, 34, 56, 255));
		var result = BilinearInterpolation.interpolateMissingPixels(image, 0, 0, 0, 0);
		Assert.isTrue(result == image);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolateMissingPixels#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolateMissingPixels__checkerboard() {
		var image = Factories.checkerboardImage(3, 3, 1);
		image.setPixel(1, 1, 0x00000000);
		var result = BilinearInterpolation.interpolateMissingPixels(image, 1, 1, 0, 0);
		ImageAssertions.pixelEquals(result, 1, 1, Color.fromRGBA(128, 128, 128, 255));
	}
}

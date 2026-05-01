package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.BilinearInterpolation;
import vision.ds.Image;

@:access(vision.algorithms.BilinearInterpolation)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class BilinearInterpolationTest extends utest.Test {

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolate#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__default() {
		var image = Factories.gradientImage(3, 3);
		var width = 3;
		var height = 3;
		var result = vision.algorithms.BilinearInterpolation.interpolate(image, width, height);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolate#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__tiny() {
		var image = Factories.gradientImage(3, 3);
		var width = 3;
		var height = 3;
		var result = vision.algorithms.BilinearInterpolation.interpolate(image, width, height);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolate#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var width = 3;
		var height = 3;
		var result = vision.algorithms.BilinearInterpolation.interpolate(image, width, height);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolateMissingPixels#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolateMissingPixels__default() {
		var image = Factories.gradientImage(3, 3);
		var kernelRadiusX = 3;
		var kernelRadiusY = 3;
		var minX = 1;
		var minY = 1;
		var result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels(image, kernelRadiusX, kernelRadiusY, minX, minY);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolateMissingPixels#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolateMissingPixels__tiny() {
		var image = Factories.gradientImage(3, 3);
		var kernelRadiusX = 3;
		var kernelRadiusY = 3;
		var minX = 1;
		var minY = 1;
		var result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels(image, kernelRadiusX, kernelRadiusY, minX, minY);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.BilinearInterpolation.interpolateMissingPixels#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolateMissingPixels__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var kernelRadiusX = 3;
		var kernelRadiusY = 3;
		var minX = 1;
		var minY = 1;
		var result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels(image, kernelRadiusX, kernelRadiusY, minX, minY);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

}

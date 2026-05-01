package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.Gauss;
import vision.ds.Image;

@:access(vision.algorithms.Gauss)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class GaussTest extends utest.Test {

	@:visionTestId("vision.algorithms.Gauss.create1x1Kernel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_create1x1Kernel__default() {
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.create1x1Kernel(sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.create3x3Kernel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_create3x3Kernel__default() {
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.create3x3Kernel(sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.create5x5Kernel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_create5x5Kernel__default() {
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.create5x5Kernel(sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.create7x7Kernel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_create7x7Kernel__default() {
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.create7x7Kernel(sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.create9x9Kernel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_create9x9Kernel__default() {
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.create9x9Kernel(sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.createKernelOfSize#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_createKernelOfSize__default() {
		var size = 3;
		var sigma = 1;
		var result = vision.algorithms.Gauss.createKernelOfSize(size, sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.create2DKernelOfSize#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_create2DKernelOfSize__default() {
		var size = 3;
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.create2DKernelOfSize(size, sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.create1DKernelOfSize#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_create1DKernelOfSize__default() {
		var size = 3;
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.create1DKernelOfSize(size, sigma);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Gauss.fastBlur#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fastBlur__default() {
		var image = Factories.gradientImage(3, 3);
		var size = 3;
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.fastBlur(image, size, sigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Gauss.fastBlur#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fastBlur__tiny() {
		var image = Factories.gradientImage(3, 3);
		var size = 3;
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.fastBlur(image, size, sigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Gauss.fastBlur#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_fastBlur__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var size = 3;
		var sigma = 1.0;
		var result = vision.algorithms.Gauss.fastBlur(image, size, sigma);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

}

package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.KernelResampler;
import vision.ds.Image;

@:access(vision.algorithms.KernelResampler)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class KernelResamplerTest extends utest.Test {

	@:visionTestId("vision.algorithms.KernelResampler.resize#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_resize__default() {
		var image = Factories.gradientImage(3, 3);
		var width = 3;
		var height = 3;
		var kernelRadius = 3;
		var kernel = (arg0) -> 1.0;
		var result = vision.algorithms.KernelResampler.resize(image, width, height, kernelRadius, kernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.KernelResampler.resize#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_resize__tiny() {
		var image = Factories.gradientImage(3, 3);
		var width = 3;
		var height = 3;
		var kernelRadius = 3;
		var kernel = (arg0) -> 1.0;
		var result = vision.algorithms.KernelResampler.resize(image, width, height, kernelRadius, kernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.KernelResampler.resize#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_resize__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var width = 3;
		var height = 3;
		var kernelRadius = 3;
		var kernel = (arg0) -> 1.0;
		var result = vision.algorithms.KernelResampler.resize(image, width, height, kernelRadius, kernel);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.KernelResampler.cubicKernel#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_cubicKernel__default() {
		var t = 1.0;
		var b = 1.0;
		var c = 1.0;
		var result = vision.algorithms.KernelResampler.cubicKernel(t, b, c);
		Assert.isFalse(Math.isNaN(result));
	}

}

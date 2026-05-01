package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.Laplace;
import vision.ds.Image;

@:access(vision.algorithms.Laplace)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class LaplaceTest extends utest.Test {

	@:visionTestId("vision.algorithms.Laplace.convolveWithLaplacianOperator#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithLaplacianOperator__default() {
		var image = Factories.gradientImage(3, 3);
		var positive = false;
		var result = vision.algorithms.Laplace.convolveWithLaplacianOperator(image, positive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Laplace.convolveWithLaplacianOperator#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithLaplacianOperator__tiny() {
		var image = Factories.gradientImage(3, 3);
		var positive = false;
		var result = vision.algorithms.Laplace.convolveWithLaplacianOperator(image, positive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Laplace.convolveWithLaplacianOperator#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithLaplacianOperator__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var positive = false;
		var result = vision.algorithms.Laplace.convolveWithLaplacianOperator(image, positive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Laplace.laplacianOfGaussian#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussian__default() {
		var image = Factories.gradientImage(3, 3);
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var sigma = 1.0;
		var threshold = 1.0;
		var positive = false;
		var result = vision.algorithms.Laplace.laplacianOfGaussian(image, kernelSize, sigma, threshold, positive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Laplace.laplacianOfGaussian#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussian__tiny() {
		var image = Factories.gradientImage(3, 3);
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var sigma = 1.0;
		var threshold = 1.0;
		var positive = false;
		var result = vision.algorithms.Laplace.laplacianOfGaussian(image, kernelSize, sigma, threshold, positive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Laplace.laplacianOfGaussian#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussian__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var kernelSize = vision.ds.gaussian.GaussianKernelSize.X5;
		var sigma = 1.0;
		var threshold = 1.0;
		var positive = false;
		var result = vision.algorithms.Laplace.laplacianOfGaussian(image, kernelSize, sigma, threshold, positive);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

}

package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.Laplace;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.gaussian.GaussianKernelSize;

@:access(vision.algorithms.Laplace)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class LaplaceTest extends utest.Test {
	@:visionTestId("vision.algorithms.Laplace.convolveWithLaplacianOperator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithLaplacianOperator__default() {
		var result = Laplace.convolveWithLaplacianOperator(AlgorithmFixtures.centerPixelImage(3), false);
		Assert.equals(204, result.getPixel(1, 1).red);
		Assert.equals(204, result.getPixel(1, 1).green);
		Assert.equals(204, result.getPixel(1, 1).blue);
	}

	@:visionTestId("vision.algorithms.Laplace.convolveWithLaplacianOperator#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithLaplacianOperator__tiny() {
		var result = Laplace.convolveWithLaplacianOperator(new Image(3, 3, Color.BLACK), false);
		Assert.equals(0, AlgorithmFixtures.nonBlackPixelCount(result));
	}

	@:visionTestId("vision.algorithms.Laplace.convolveWithLaplacianOperator#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithLaplacianOperator__checkerboard() {
		var result = Laplace.convolveWithLaplacianOperator(ManualFixtures.tinyCheckerboardImage(), false);
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}

	@:visionTestId("vision.algorithms.Laplace.laplacianOfGaussian#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussian__default() {
		var result = Laplace.laplacianOfGaussian(AlgorithmFixtures.centerPixelImage(5), GaussianKernelSize.X3, 1.0, 1.0, false);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}

	@:visionTestId("vision.algorithms.Laplace.laplacianOfGaussian#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussian__tiny() {
		var result = Laplace.laplacianOfGaussian(new Image(3, 3, Color.BLACK), GaussianKernelSize.X3, 1.0, 1.0, false);
		Assert.equals(0, AlgorithmFixtures.nonBlackPixelCount(result));
	}

	@:visionTestId("vision.algorithms.Laplace.laplacianOfGaussian#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_laplacianOfGaussian__checkerboard() {
		var result = Laplace.laplacianOfGaussian(ManualFixtures.tinyCheckerboardImage(), GaussianKernelSize.X3, 1.0, 1.0, false);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}
}

package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ImageAssertions;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.Sobel;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.Sobel)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class SobelTest extends utest.Test {
	@:visionTestId("vision.algorithms.Sobel.convolveWithSobelOperator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithSobelOperator__default() {
		var result = Sobel.convolveWithSobelOperator(AlgorithmFixtures.stepEdgeImage());
		ImageAssertions.hasDimensions(result, 5, 5);
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(result.getPixel(1, 2).red > result.getPixel(0, 2).red);
	}

	@:visionTestId("vision.algorithms.Sobel.convolveWithSobelOperator#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithSobelOperator__tiny() {
		var result = Sobel.convolveWithSobelOperator(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.getPixel(1, 1).red);
		Assert.equals(0, result.getPixel(1, 1).green);
		Assert.equals(0, result.getPixel(1, 1).blue);
		Assert.equals(0, result.getPixel(1, 1).alpha);
	}

	@:visionTestId("vision.algorithms.Sobel.convolveWithSobelOperator#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithSobelOperator__checkerboard() {
		var result = Sobel.convolveWithSobelOperator(ManualFixtures.tinyCheckerboardImage());
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}

	@:visionTestId("vision.algorithms.Sobel.detectEdges#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__default() {
		var result = Sobel.detectEdges(AlgorithmFixtures.stepEdgeImage(), 100);
		ImageAssertions.pixelEquals(result, 1, 2, Color.WHITE);
		ImageAssertions.pixelEquals(result, 0, 0, Color.BLACK);
	}

	@:visionTestId("vision.algorithms.Sobel.detectEdges#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__tiny() {
		var result = Sobel.detectEdges(new Image(3, 3, Color.BLACK), 100);
		Assert.equals(0, AlgorithmFixtures.nonBlackPixelCount(result));
	}

	@:visionTestId("vision.algorithms.Sobel.detectEdges#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__checkerboard() {
		var result = Sobel.detectEdges(ManualFixtures.tinyCheckerboardImage(), 100);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}
}

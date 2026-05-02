package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ImageAssertions;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.Perwitt;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.Perwitt)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class PerwittTest extends utest.Test {
	@:visionTestId("vision.algorithms.Perwitt.convolveWithPerwittOperator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithPerwittOperator__default() {
		var result = Perwitt.convolveWithPerwittOperator(AlgorithmFixtures.stepEdgeImage());
		ImageAssertions.hasDimensions(result, 5, 5);
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(result.getPixel(1, 2).red > result.getPixel(0, 2).red);
	}

	@:visionTestId("vision.algorithms.Perwitt.convolveWithPerwittOperator#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithPerwittOperator__tiny() {
		var result = Perwitt.convolveWithPerwittOperator(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.getPixel(1, 1).alpha);
	}

	@:visionTestId("vision.algorithms.Perwitt.convolveWithPerwittOperator#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithPerwittOperator__checkerboard() {
		var result = Perwitt.convolveWithPerwittOperator(ManualFixtures.tinyCheckerboardImage());
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}

	@:visionTestId("vision.algorithms.Perwitt.detectEdges#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__default() {
		var result = Perwitt.detectEdges(AlgorithmFixtures.stepEdgeImage(), 100);
		ImageAssertions.pixelEquals(result, 1, 2, Color.WHITE);
		ImageAssertions.pixelEquals(result, 0, 0, Color.BLACK);
	}

	@:visionTestId("vision.algorithms.Perwitt.detectEdges#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__tiny() {
		var result = Perwitt.detectEdges(new Image(3, 3, Color.BLACK), 100);
		Assert.equals(0, AlgorithmFixtures.nonBlackPixelCount(result));
	}

	@:visionTestId("vision.algorithms.Perwitt.detectEdges#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__checkerboard() {
		var result = Perwitt.detectEdges(ManualFixtures.tinyCheckerboardImage(), 100);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}
}

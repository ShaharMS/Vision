package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.Sobel;
import vision.ds.Image;

@:access(vision.algorithms.Sobel)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class SobelTest extends utest.Test {

	@:visionTestId("vision.algorithms.Sobel.convolveWithSobelOperator#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithSobelOperator__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.algorithms.Sobel.convolveWithSobelOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Sobel.convolveWithSobelOperator#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithSobelOperator__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.algorithms.Sobel.convolveWithSobelOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Sobel.convolveWithSobelOperator#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithSobelOperator__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.algorithms.Sobel.convolveWithSobelOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Sobel.detectEdges#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__default() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.algorithms.Sobel.detectEdges(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Sobel.detectEdges#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__tiny() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.algorithms.Sobel.detectEdges(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Sobel.detectEdges#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var threshold = 1.0;
		var result = vision.algorithms.Sobel.detectEdges(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

}

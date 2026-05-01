package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.Perwitt;
import vision.ds.Image;

@:access(vision.algorithms.Perwitt)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class PerwittTest extends utest.Test {

	@:visionTestId("vision.algorithms.Perwitt.convolveWithPerwittOperator#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithPerwittOperator__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.algorithms.Perwitt.convolveWithPerwittOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Perwitt.convolveWithPerwittOperator#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithPerwittOperator__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.algorithms.Perwitt.convolveWithPerwittOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Perwitt.convolveWithPerwittOperator#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithPerwittOperator__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.algorithms.Perwitt.convolveWithPerwittOperator(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Perwitt.detectEdges#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__default() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.algorithms.Perwitt.detectEdges(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Perwitt.detectEdges#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__tiny() {
		var image = Factories.gradientImage(3, 3);
		var threshold = 1.0;
		var result = vision.algorithms.Perwitt.detectEdges(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.Perwitt.detectEdges#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectEdges__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var threshold = 1.0;
		var result = vision.algorithms.Perwitt.detectEdges(image, threshold);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

}

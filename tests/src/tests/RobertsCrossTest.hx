package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.RobertsCross;
import vision.ds.Image;

@:access(vision.algorithms.RobertsCross)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class RobertsCrossTest extends utest.Test {

	@:visionTestId("vision.algorithms.RobertsCross.convolveWithRobertsCross#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithRobertsCross__default() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.algorithms.RobertsCross.convolveWithRobertsCross(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.RobertsCross.convolveWithRobertsCross#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithRobertsCross__tiny() {
		var image = Factories.gradientImage(3, 3);
		var result = vision.algorithms.RobertsCross.convolveWithRobertsCross(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

	@:visionTestId("vision.algorithms.RobertsCross.convolveWithRobertsCross#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithRobertsCross__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var result = vision.algorithms.RobertsCross.convolveWithRobertsCross(image);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
	}

}

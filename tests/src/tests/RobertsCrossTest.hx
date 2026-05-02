package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.RobertsCross;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.RobertsCross)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class RobertsCrossTest extends utest.Test {
	@:visionTestId("vision.algorithms.RobertsCross.convolveWithRobertsCross#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithRobertsCross__default() {
		var result = RobertsCross.convolveWithRobertsCross(AlgorithmFixtures.stepEdgeImage());
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}

	@:visionTestId("vision.algorithms.RobertsCross.convolveWithRobertsCross#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithRobertsCross__tiny() {
		var result = RobertsCross.convolveWithRobertsCross(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.getPixel(1, 1).alpha);
	}

	@:visionTestId("vision.algorithms.RobertsCross.convolveWithRobertsCross#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_convolveWithRobertsCross__checkerboard() {
		var result = RobertsCross.convolveWithRobertsCross(ManualFixtures.tinyCheckerboardImage());
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}
}

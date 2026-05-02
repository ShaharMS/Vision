package tests;

import tests.support.Factories;
import tests.support.ImageAssertions;
import tests.support.ResamplerAssertions;
import utest.Assert;
import vision.algorithms.BilateralFilter;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.BilateralFilter)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class BilateralFilterTest extends utest.Test {
	@:visionTestId("vision.algorithms.BilateralFilter.filter#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filter__default() {
		var expected = Color.fromRGBA(90, 120, 150, 255);
		var result = BilateralFilter.filter(new Image(3, 3, expected), 1.0, 1.0);
		ResamplerAssertions.uniformColor(result, expected);
	}

	@:visionTestId("vision.algorithms.BilateralFilter.filter#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filter__tiny() {
		var expected = Color.fromRGBA(20, 40, 60, 255);
		var result = BilateralFilter.filter(new Image(1, 1, expected), 1.0, 1.0);
		ResamplerAssertions.uniformColor(result, expected);
	}

	@:visionTestId("vision.algorithms.BilateralFilter.filter#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_filter__checkerboard() {
		var result = BilateralFilter.filter(Factories.checkerboardImage(3, 3, 1), 1.0, 1.0);
		ImageAssertions.hasDimensions(result, 3, 3);
		ResamplerAssertions.opaqueGrayscale(result);
		Assert.isTrue(result.getPixel(1, 1).red > result.getPixel(0, 1).red);
	}
}

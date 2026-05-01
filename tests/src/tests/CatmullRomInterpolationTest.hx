package tests;

import tests.support.Factories;
import utest.Assert;
import vision.algorithms.CatmullRomInterpolation;
import vision.ds.Image;

@:access(vision.algorithms.CatmullRomInterpolation)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class CatmullRomInterpolationTest extends utest.Test {

	@:visionTestId("vision.algorithms.CatmullRomInterpolation.interpolate#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__default() {
		var image = Factories.gradientImage(3, 3);
		var width = 3;
		var height = 3;
		var result = vision.algorithms.CatmullRomInterpolation.interpolate(image, width, height);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.CatmullRomInterpolation.interpolate#tiny")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__tiny() {
		var image = Factories.gradientImage(3, 3);
		var width = 3;
		var height = 3;
		var result = vision.algorithms.CatmullRomInterpolation.interpolate(image, width, height);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

	@:visionTestId("vision.algorithms.CatmullRomInterpolation.interpolate#checkerboard")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__checkerboard() {
		var image = Factories.checkerboardImage(8, 8, 2);
		var width = 3;
		var height = 3;
		var result = vision.algorithms.CatmullRomInterpolation.interpolate(image, width, height);
		Assert.notNull(result);
		Assert.isTrue(result.width > 0);
		Assert.isTrue(result.height > 0);
		Assert.equals(width, result.width);
		Assert.equals(height, result.height);
	}

}

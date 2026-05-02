package tests;

import tests.support.ImageAssertions;
import tests.support.ManualFixtures;
import tests.support.ResamplerAssertions;
import vision.algorithms.CatmullRomInterpolation;
import vision.ds.Color;
import vision.ds.Image;

@:access(vision.algorithms.CatmullRomInterpolation)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class CatmullRomInterpolationTest extends utest.Test {
	@:visionTestId("vision.algorithms.CatmullRomInterpolation.interpolate#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__default() {
		var result = CatmullRomInterpolation.interpolate(ManualFixtures.interpolationImage(), 3, 3);
		ImageAssertions.hasDimensions(result, 3, 3);
		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(0, 0, 0, 255));
		ResamplerAssertions.blended(result.getPixel(1, 1));
	}

	@:visionTestId("vision.algorithms.CatmullRomInterpolation.interpolate#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__tiny() {
		var expected = Color.fromRGBA(12, 34, 56, 255);
		var result = CatmullRomInterpolation.interpolate(new Image(1, 1, expected), 1, 1);
		ResamplerAssertions.uniformColor(result, expected);
	}

	@:visionTestId("vision.algorithms.CatmullRomInterpolation.interpolate#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_interpolate__checkerboard() {
		var result = CatmullRomInterpolation.interpolate(ManualFixtures.tinyCheckerboardImage(), 3, 3);
		ImageAssertions.hasDimensions(result, 3, 3);
		ImageAssertions.pixelEquals(result, 0, 0, Color.fromRGBA(255, 255, 255, 255));
		ResamplerAssertions.opaqueGrayscale(result);
	}
}

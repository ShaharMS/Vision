package tests;

import tests.support.ColorAssertions;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.TextureSynthesisError;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class TextureSynthesisTest extends utest.Test {
	@:visionTestId("vision.Vision.synthesizeTexture#frequency")
	function test_synthesizeTexture__favorsFrequentColors() {
		final sample = new Image(8, 8, Color.BLUE);
		sample.setPixel(0, 0, Color.RED);
		final texture = Vision.synthesizeTexture(sample, 8, 5, 1, 12, 0.1);
		Assert.equals(8, texture.width);
		Assert.equals(5, texture.height);
		var blue = 0;
		texture.forEachPixel((_, _, color) -> {
			if (color.blue == 255) blue++;
			else ColorAssertions.equalsColor(Color.RED, color);
		});
		Assert.isTrue(blue >= 38);
	}

	@:visionTestId("vision.Vision.synthesizeTexture#singleColor")
	function test_synthesizeTexture__preservesAlpha() {
		final color = Color.fromRGBA(20, 40, 60, 80);
		final texture = Vision.synthesizeTexture(new Image(3, 3, color), 5, 4);
		texture.forEachPixel((_, _, pixel) -> ColorAssertions.equalsColor(color, pixel));
	}

	@:visionTestId("vision.Vision.synthesizeTexture#invalidTemperature")
	function test_synthesizeTexture__requiresPositiveTemperature() {
		ExceptionAssertions.throwsType(() -> {
			Vision.synthesizeTexture(new Image(3, 3), 5, 4, 3, 1, 0);
		}, TextureSynthesisError);
	}
}

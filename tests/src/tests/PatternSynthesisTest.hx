package tests;

import utest.Assert;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class PatternSynthesisTest extends utest.Test {
	@:visionTestId("vision.Vision.synthesizePattern#overlap")
	function test_synthesizePattern__preservesOverlaps() {
		final sample = new Image(3, 3);
		for (y in 0...3)
			for (x in 0...3)
				sample.setPixel(x, y, (x + y) % 2 == 0 ? Color.BLACK : Color.WHITE);
		final result = Vision.synthesizePattern(sample, 9, 7);
		Assert.equals(9, result.width);
		Assert.equals(7, result.height);
		for (y in 0...result.height)
			for (x in 0...result.width) {
				final color = result.getPixel(x, y);
				Assert.isTrue(color == Color.BLACK || color == Color.WHITE);
				if (x > 0) Assert.isTrue(color != result.getPixel(x - 1, y));
				if (y > 0) Assert.isTrue(color != result.getPixel(x, y - 1));
			}
	}
}

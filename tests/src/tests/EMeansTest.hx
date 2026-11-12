package tests;

import utest.Assert;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class EMeansTest extends utest.Test {
	@:visionTestId("vision.Vision.emeansGroupImageColors#distinctColors")
	function test_emeansGroupImageColors__distinctColors() {
		final image = new Image(32, 1);
		for (x in 0...32) image.setPixel(x, 0, Color.fromRGBA(x * 8, x * 8, x * 8));
		final groups = Vision.emeansGroupImageColors(image, 4);
		final seen = new haxe.ds.IntMap<Bool>();
		Assert.isTrue(groups.length > 0 && groups.length <= 4);
		for (group in groups)
			for (color in group.items) {
				Assert.isFalse(seen.exists(color));
				seen.set(color, true);
			}
		for (color in image.toArray()) Assert.isTrue(seen.exists(color));
	}

	@:visionTestId("vision.Vision.emeansPosterize#oneColor")
	function test_emeansPosterize__oneColor() {
		final image = new Image(3, 1, Color.BLACK);
		image.setPixel(2, 0, Color.WHITE);
		final result = Vision.emeansPosterize(image, 1);
		for (x in 0...3) Assert.equals(Color.fromRGBA(128, 128, 128), result.getPixel(x, 0));
		Assert.equals(Color.WHITE, image.getPixel(2, 0));
	}
}

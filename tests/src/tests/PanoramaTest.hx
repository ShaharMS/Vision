package tests;

import utest.Assert;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class PanoramaTest extends utest.Test {
	@:visionTestId("vision.Vision.stitchPanorama#overlappingCrops")
	function test_stitchPanorama__overlappingCrops() {
		final scene = new Image(154, 72);
		var state = 313;
		for (y in 0...scene.height)
			for (x in 0...scene.width) {
				state = (state * 107 + 31) % 65521;
				final tone = state % 256;
				scene.setPixel(x, y, Color.fromRGBA(tone, tone, tone));
			}

		final photos = [for (offset in [0, 31, 62]) {
			final photo = new Image(92, scene.height);
			for (y in 0...photo.height)
				for (x in 0...photo.width)
					photo.setPixel(x, y, scene.getPixel(x + offset, y));
			photo;
		}];
		final stitched = Vision.stitchPanorama(photos);
		Assert.equals(scene.width, stitched.width);
		Assert.equals(scene.height, stitched.height);
		for (x in [0, 46, 85, 124, 153])
			Assert.isTrue(Math.abs(scene.getPixel(x, 32).red - stitched.getPixel(x, 32).red) <= 1);
	}
}

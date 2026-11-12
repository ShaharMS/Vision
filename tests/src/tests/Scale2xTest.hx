package tests;

import utest.Assert;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class Scale2xTest extends utest.Test {
	@:visionTestId("vision.Vision.rescale#diagonal")
	function test_rescale__diagonal() {
		final image = new Image(3, 3, Color.BLACK);
		image.setPixel(1, 0, Color.WHITE);
		image.setPixel(0, 1, Color.WHITE);
		final result = Vision.rescale(image);
		Assert.equals(6, result.width);
		Assert.equals(6, result.height);
		Assert.equals(Color.WHITE, result.getPixel(2, 2));
		Assert.equals(Color.BLACK, result.getPixel(3, 2));
		Assert.equals(Color.BLACK, result.getPixel(2, 3));
		Assert.equals(Color.BLACK, result.getPixel(3, 3));
	}

	@:visionTestId("vision.Vision.rescale#cornerSupport")
	function test_rescale__cornerSupport() {
		final image = new Image(3, 3, Color.BLACK);
		image.setPixel(0, 0, Color.WHITE);
		image.setPixel(0, 1, Color.WHITE);
		image.setPixel(1, 2, Color.RED);
		image.setPixel(2, 0, Color.BLUE);

		final extended = Vision.rescale(image);
		final standard = Vision.rescale(image, false);
		Assert.equals(Color.WHITE, extended.getPixel(2, 2));
		Assert.equals(Color.BLACK, standard.getPixel(2, 2));
		Assert.equals(Color.BLACK, extended.getPixel(3, 2));
	}

	@:visionTestId("vision.Vision.rescale#singlePixel")
	function test_rescale__singlePixel() {
		final color = Color.fromRGBA(10, 20, 30, 40);
		final result = Vision.rescale(new Image(1, 1, color));
		Assert.equals(2, result.width);
		Assert.equals(2, result.height);
		for (pixel in result.toArray()) Assert.equals(color, pixel);
	}
}

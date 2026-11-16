package tests;

#if (cpp && !cppia && vision_webp)
import haxe.crypto.Base64;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.ds.Image;
import vision.ds.ImageAnimation;
import vision.exceptions.ImageSavingFailed;
import vision.formats.ImageIO;
import vision.formats._internal.images.webp.WebpContainer;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class LossyWebpTest extends utest.Test {
	@:visionTestId("vision.formats.from.FromBytes.webp#vp8Fixture")
	function test_webp__decodesExternalVp8() {
		final bytes = Base64.decode("UklGRkAAAABXRUJQVlA4IDQAAAAwAgCdASoIAAgAAMASJaACdLoB+AH4AARoAAD++kXL/3easNN39a3/9aOfron+tHP/WVgA");
		final image = ImageIO.from.bytes.webp(bytes);
		Assert.equals(8, image.width);
		Assert.equals(8, image.height);
		final pixel = image.getPixel(4, 4);
		Assert.isTrue(pixel.red > 240 && pixel.green < 10 && pixel.blue < 10);
		Assert.equals(255, pixel.alpha);
	}

	@:visionTestId("vision.formats.to.ToBytes.webp#lossy")
	function test_webp__encodesVp8WithAlpha() {
		final image = new Image(16, 16, 0x8044aacc);
		final bytes = ImageIO.to.bytes.webp(image, 90);
		final chunks = [];
		WebpContainer.read(bytes, (tag, _, _) -> chunks.push(tag));
		Assert.same(["VP8X", "ALPH", "VP8 "], chunks);
		final decoded = ImageIO.from.bytes.webp(bytes);
		Assert.equals(16, decoded.width);
		Assert.equals(16, decoded.height);
		final pixel = decoded.getPixel(8, 8);
		Assert.equals(128, pixel.alpha);
		Assert.floatEquals(0x44, pixel.red, 6);
		Assert.floatEquals(0xaa, pixel.green, 6);
		Assert.floatEquals(0xcc, pixel.blue, 6);
		ExceptionAssertions.throwsType(() -> ImageIO.to.bytes.webp(image, -1), ImageSavingFailed);
	}

	@:visionTestId("vision.formats.to.ToBytes.webpAnimation#lossy")
	function test_webpAnimation__preservesTimingAndAlpha() {
		final animation = new ImageAnimation([
			{image: new Image(12, 12, 0xffcc8422), duration: 60},
			{image: new Image(12, 12, 0x8044aacc), duration: 140}
		], 3, 0xff001122);
		final bytes = ImageIO.to.bytes.webpAnimation(animation, 90);
		final decoded = ImageIO.from.bytes.webpAnimation(bytes);
		Assert.equals(2, decoded.frames.length);
		Assert.equals(3, decoded.loopCount);
		Assert.equals(animation.background.toInt(), decoded.background.toInt());
		Assert.equals(60, decoded.frames[0].duration);
		Assert.equals(140, decoded.frames[1].duration);
		Assert.floatEquals(0xcc, decoded.frames[0].image.getPixel(6, 6).red, 6);
		final pixel = decoded.frames[1].image.getPixel(6, 6);
		Assert.equals(128, pixel.alpha);
		Assert.floatEquals(0xaa, pixel.green, 6);
	}
}
#end

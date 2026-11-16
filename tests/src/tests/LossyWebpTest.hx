package tests;

import haxe.crypto.Base64;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.ImageLoadingFailed;
import vision.formats.ImageIO;

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

	@:visionTestId("vision.formats.from.FromBytes.webp#lossyAlpha")
	function test_webp__decodesLossyWithCompressedAlpha() {
		final bytes = Base64.decode("UklGRsgAAABXRUJQVlA4WAoAAAAQAAAAEQAAEwAAQUxQSBkAAAABuQpE9D+gppEU6F5U4d8aLWXEBOQetz0VAFZQOCCIAAAA8AQAnQEqEgAUAD4tEIZCoaEN+gAMAWJZizAAvnZ3Zj+AbyyMAAeyZdgBD1AnRcsAAP7/vVdbNn9D61FWptKRDB8/ZWP+I+Kb99206prv2gVCu/KXYJ41Nd8RfBMD+gw3PrwR+4/iC/6i5kdiEw5BNRk8FNW2Jh9AvLPXaELlPCX4wASIACSAAA==");
		final image = ImageIO.from.bytes.webp(bytes);
		Assert.equals(18, image.width);
		Assert.equals(20, image.height);
		for (y in 0...20)
			for (x in 0...18) Assert.equals(60 + x * 6 + y * 3, image.getPixel(x, y).alpha);
		final pixel = image.getPixel(11, 8);
		Assert.floatEquals(132, pixel.red, 12);
		Assert.floatEquals(88, pixel.green, 12);
		Assert.floatEquals(60, pixel.blue, 12);
		// Leave the RIFF lengths consistent while truncating the VP8 tokens.
		final truncated = bytes.sub(0, bytes.length - 32);
		truncated.setInt32(4, truncated.length - 8);
		truncated.setInt32(68, truncated.length - 72);
		ExceptionAssertions.throwsType(() -> ImageIO.from.bytes.webp(truncated), ImageLoadingFailed);
	}

	@:visionTestId("vision.formats.from.FromBytes.webpAnimation#lossy")
	function test_webpAnimation__decodesLossyAnimation() {
		final bytes = Base64.decode("UklGRrgBAABXRUJQVlA4WAoAAAASAAAAEQAAEwAAQU5JTQYAAAD/////AwBBTk1GwgAAAAAAAAAAABEAABMAAMgAAAJBTFBIGQAAAAG5CkT0P6CmkRToXlTh3xotZcQE5B63PRUAVlA4IIgAAADwBACdASoSABQAPi0QhkKhoQ36AAwBYlmLMAC+dndmP4BvLIwAB7Jl2AEPUCdFywAA/v+9V1s2f0PrUVam0pEMHz9lY/4j4pv33bTqmu/aBUK78pdgnjU13xF8EwP6DDc+vBH7j+IL/qLmR2ITDkE1GTwU1bYmH0C8s9doQuU8JfjABIgAJIAAQU5NRsIAAAAAAAAAAAARAAATAADIAAACQUxQSBkAAAABuQpE9D+gppEU6F5U4d8aLWXEBOQetz0VAFZQOCCIAAAAMAUAnQEqEgAUAD4tEIZCoaEN+gAMAWJZgCxHxx8P4x+QHDNjAAHsmXYAQ7UMod7cckYA/v7+WXTxPDicbkkHuDp0LHD/8wsO4pDsi+v7+vf9/3LTerOdK7tBLACY+3zQQ9ghXOJkNoQHa2PO+vqre7IWClIIliFzvhSg6gD9/AAcmAElABgAAA==");
		final decoded = ImageIO.from.bytes.webpAnimation(bytes);
		Assert.equals(2, decoded.frames.length);
		Assert.equals(3, decoded.loopCount);
		Assert.equals(200, decoded.frames[0].duration);
		Assert.equals(200, decoded.frames[1].duration);
		final first = decoded.frames[0].image.getPixel(11, 8);
		final second = decoded.frames[1].image.getPixel(11, 8);
		Assert.equals(150, first.alpha);
		Assert.equals(150, second.alpha);
		Assert.floatEquals(132, first.red, 12);
		Assert.floatEquals(172, second.red, 12);
	}
}

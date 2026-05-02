package tests;

import tests.support.FormatAssertions;
import utest.Assert;
import vision.formats.ImageIO;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageIOTest extends utest.Test {
	@:visionTestId("vision.formats.ImageIO.from#singleton")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_from__singletonAccessor() {
		Assert.isTrue(ImageIO.from == ImageIO.from);
	}

	@:visionTestId("vision.formats.ImageIO.to#singleton")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_to__singletonAccessor() {
		Assert.isTrue(ImageIO.to == ImageIO.to);
	}

	@:visionTestId("vision.formats.ImageIO.from#pngRoundTrip")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_from__pngRoundTripThroughStatics() {
		var expected = FormatAssertions.fixtureImage();
		var bytes = ImageIO.to.bytes.png(expected);
		var actual = ImageIO.from.bytes.png(bytes);

		FormatAssertions.bytesStartWith(bytes, [0x89, 0x50, 0x4E, 0x47]);
		FormatAssertions.imagesEqual(expected, actual);
	}

	@:visionTestId("vision.formats.ImageIO.to#bmpRoundTrip")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_to__bmpRoundTripThroughStatics() {
		var expected = FormatAssertions.fixtureImage();
		var bytes = ImageIO.to.bytes.bmp(expected);
		var actual = ImageIO.from.bytes.bmp(bytes);

		FormatAssertions.bytesStartWith(bytes, [0x42, 0x4D]);
		FormatAssertions.imagesEqual(expected, actual);
	}
}

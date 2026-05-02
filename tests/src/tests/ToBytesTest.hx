package tests;

import tests.support.Factories;
import tests.support.FormatAssertions;
import utest.Assert;
import vision.formats.ImageIO;
import vision.formats.to.ToBytes;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class ToBytesTest extends utest.Test {
	@:visionTestId("vision.formats.to.ToBytes.png#roundTrip")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__roundTrip() {
		var expected = FormatAssertions.fixtureImage();
		var bytes = new ToBytes().png(expected);

		FormatAssertions.bytesStartWith(bytes, [0x89, 0x50, 0x4E, 0x47]);
		FormatAssertions.imagesEqual(expected, ImageIO.from.bytes.png(bytes));
	}

	@:visionTestId("vision.formats.to.ToBytes.bmp#roundTrip")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__roundTrip() {
		var expected = FormatAssertions.fixtureImage();
		var bytes = new ToBytes().bmp(expected);

		FormatAssertions.bytesStartWith(bytes, [0x42, 0x4D]);
		FormatAssertions.imagesEqual(expected, ImageIO.from.bytes.bmp(bytes));
	}

	@:visionTestId("vision.formats.to.ToBytes.jpeg#signature")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_jpeg__writesJpegSignature() {
		var bytes = new ToBytes().jpeg(Factories.checkerboardImage(8, 8, 2));

		Assert.isTrue(bytes.length > 4);
		FormatAssertions.bytesStartWith(bytes, [0xFF, 0xD8]);
	}
}

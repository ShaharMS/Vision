package tests;

import tests.support.Factories;
import tests.support.ExceptionAssertions;
import tests.support.FormatAssertions;
import tests.support.ColorAssertions;
import utest.Assert;
import vision.ds.Image;
import vision.ds.ImageAnimation;
import vision.ds.Color;
import vision.exceptions.ImageSavingFailed;
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
		#if (python || cs)
		ExceptionAssertions.throwsType(() -> new ToBytes().png(expected), ImageSavingFailed);
		#else
		var bytes = new ToBytes().png(expected);

		FormatAssertions.bytesStartWith(bytes, [0x89, 0x50, 0x4E, 0x47]);
		FormatAssertions.imagesEqual(expected, ImageIO.from.bytes.png(bytes));
		#end
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
	@:visionTestId("vision.formats.to.ToBytes.jpeg#partialBlocks")
	function test_jpeg__roundTripsPartialBlocks() {
		final bytes = ImageIO.to.bytes.jpeg(new Image(13, 9, Color.fromRGBA(36, 118, 200, 80)), 95);
		final result = ImageIO.from.bytes.jpeg(bytes);
		Assert.equals(13, result.width);
		Assert.equals(9, result.height);
		final last = result.getPixel(12, 8);
		Assert.equals(255, last.alpha);
		Assert.floatEquals(36, last.red, 2);
		Assert.floatEquals(118, last.green, 2);
		Assert.floatEquals(200, last.blue, 2);
	}

	@:visionTestId("vision.formats.to.ToBytes.jpeg#invalidQuality")
	function test_jpeg__rejectsInvalidQuality() {
		ExceptionAssertions.throwsType(() -> new ToBytes().jpeg(new Image(1, 1), 0), ImageSavingFailed);
	}
	@:visionTestId("vision.formats.to.ToBytes.webp#lossless")
	function test_webp__preservesPixelsIncludingHiddenRgb() {
		final image = new Image(3, 2, Color.fromRGBA(26, 83, 172, 0));
		image.setPixel(1, 0, Color.fromRGBA(201, 125, 8, 128));
		image.setPixel(2, 1, Color.fromRGBA(41, 0, 73, 255));
		final bytes = ImageIO.to.bytes.webp(image);
		FormatAssertions.bytesStartWith(bytes, [82, 73, 70, 70]);
		final actual = ImageIO.from.bytes.webp(bytes);
		Assert.equals(3, actual.width);
		Assert.equals(2, actual.height);
		for (y in 0...image.height)
			for (x in 0...image.width) ColorAssertions.equalsColor(image.getPixel(x, y), actual.getPixel(x, y));
	}
	@:visionTestId("vision.formats.to.ToBytes.webpAnimation#roundTrip")
	function test_webpAnimation__preservesPixelsAndTiming() {
		final first = new Image(3, 2, Color.fromRGBA(20, 60, 80, 128));
		final second = new Image(3, 2, Color.fromRGBA(180, 40, 120, 0));
		final animation = new ImageAnimation([{image: first, duration: 45}, {image: second, duration: 80}], 3, Color.BLUE);
		final result = ImageIO.from.bytes.webpAnimation(ImageIO.to.bytes.webpAnimation(animation));
		Assert.equals(3, result.loopCount);
		ColorAssertions.equalsColor(Color.BLUE, result.background);
		Assert.equals(2, result.frames.length);
		Assert.equals(45, result.frames[0].duration);
		Assert.equals(80, result.frames[1].duration);
		Assert.equals(0, first.exportToBytes().compare(result.frames[0].image.exportToBytes()));
		Assert.equals(0, second.exportToBytes().compare(result.frames[1].image.exportToBytes()));
	}
}

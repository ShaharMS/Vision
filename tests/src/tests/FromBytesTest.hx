package tests;

import haxe.crypto.Base64;
import tests.support.ExceptionAssertions;
import tests.support.FormatAssertions;
import tests.support.ColorAssertions;
import utest.Assert;
import vision.exceptions.ImageLoadingFailed;
import vision.formats.ImageIO;
import vision.formats.from.FromBytes;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class FromBytesTest extends utest.Test {
	@:visionTestId("vision.formats.from.FromBytes.png#roundTrip")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_png__roundTrip() {
		#if (python || cs)
		Assert.pass();
		#else
		var expected = FormatAssertions.fixtureImage();
		var bytes = ImageIO.to.bytes.png(expected);
		var actual = new FromBytes().png(bytes);
		FormatAssertions.imagesEqual(expected, actual);
		#end
	}

	@:visionTestId("vision.formats.from.FromBytes.bmp#roundTrip")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_bmp__roundTrip() {
		var expected = FormatAssertions.fixtureImage();
		var bytes = ImageIO.to.bytes.bmp(expected);
		var actual = new FromBytes().bmp(bytes);
		FormatAssertions.imagesEqual(expected, actual);
	}

	@:visionTestId("vision.formats.from.FromBytes.png#invalidHeader")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_png__invalidHeaderThrows() {
		ExceptionAssertions.throwsType(() -> new FromBytes().png(FormatAssertions.malformedBytes()), ImageLoadingFailed);
	}

	@:visionTestId("vision.formats.from.FromBytes.bmp#invalidHeader")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_bmp__invalidHeaderThrows() {
		ExceptionAssertions.throwsType(() -> new FromBytes().bmp(FormatAssertions.malformedBytes()), ImageLoadingFailed);
	}

	@:visionTestId("vision.formats.from.FromBytes.jpeg#invalidHeader")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_jpeg__invalidHeaderThrows() {
		ExceptionAssertions.throwsType(() -> new FromBytes().jpeg(FormatAssertions.malformedBytes()), ImageLoadingFailed);
	}
	@:visionTestId("vision.formats.from.FromBytes.jpeg#progressive")
	function test_jpeg__decodesProgressiveScans() {
		final baseline = Base64.decode(
			"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQ" +
			"ERMUFRUVDA8XGBYUGBIUFRT/wAALCAAFAAcBAREA/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgED" +
			"AwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RF" +
			"RkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJ" +
			"ytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/9oACAEBAAA/APP/ANk74e6b9hi4/wCWZ/h9q//Z");
		final progressive = Base64.decode(
			"/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsKCwsNDhIQDQ4RDgsLEBYQ" +
			"ERMUFRUVDA8XGBYUGBIUFRT/wgALCAAFAAcBAREA/8QAFAABAAAAAAAAAAAAAAAAAAAABv/aAAgBAQAAAAE//8QAFxAAAwEA" +
			"AAAAAAAAAAAAAAAAAwUGEv/aAAgBAQABBQKTXjx//8QAFhAAAwAAAAAAAAAAAAAAAAAAAAFx/9oACAEBAAY/AlD/xAAVEAEB" +
			"AAAAAAAAAAAAAAAAAAAA0f/aAAgBAQABPyGOP//aAAgBAQAAABB//8QAFxAAAwEAAAAAAAAAAAAAAAAAADFBof/aAAgBAQAB" +
			"PxBRrB//2Q==");
		final expected = ImageIO.from.bytes.jpeg(baseline);
		final actual = ImageIO.from.bytes.jpeg(progressive);
		Assert.equals(7, actual.width);
		Assert.equals(5, actual.height);
		FormatAssertions.imagesEqual(expected, actual);
	}
	@:visionTestId("vision.formats.from.FromBytes.jpeg#cmyk")
	function test_jpeg__decodesAdobeCmyk() {
		final bytes = Base64.decode(
			"/9j/7gAOQWRvYmUAZAAAAAAA/9sAQwABAQEBAQEBAQEBAQEBAgIDAgICAgIEAwMCAwUEBQUFBAQEBQYHBgUFBwYEBAYJBgcI" +
			"CAgICAUGCQoJCAoHCAgI/8AAFAgAAgADBEMRAE0RAFkRAEsRAP/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//E" +
			"ALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNRYQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2" +
			"Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrC" +
			"w8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/aAA4EQwBNAFkASwAAPwD+mCvsivi+v6YK/9k=");
		final image = ImageIO.from.bytes.jpeg(bytes);
		Assert.equals(3, image.width);
		Assert.equals(2, image.height);
		final color = image.getPixel(2, 1);
		Assert.floatEquals(163, color.red, 1);
		Assert.floatEquals(122, color.green, 1);
		Assert.floatEquals(82, color.blue, 1);
		Assert.equals(255, color.alpha);
	}

	@:visionTestId("vision.formats.from.FromBytes.webp#paletteAlpha")
	function test_webp__decodesPaletteAndAlpha() {
		final bytes = Base64.decode("UklGRkwAAABXRUJQVlA4TD8AAAAvEgAEEBegpm0DFl+h0SkQSBRiH24esWCiPrausAQCCVT+Cisd8swrmGUkqTuGbR9tZZb+ASL63wNJSJZ0TxgA");
		final image = ImageIO.from.bytes.webp(bytes);
		Assert.equals(19, image.width);
		Assert.equals(17, image.height);
		ColorAssertions.equalsColor(0x32e62348, image.getPixel(0, 0));
		ColorAssertions.equalsColor(0xff101ec8, image.getPixel(1, 0));
		ColorAssertions.equalsColor(0x0078460a, image.getPixel(2, 0));
	}

	@:visionTestId("vision.formats.from.FromBytes.webp#invalidHeader")
	function test_webp__rejectsInvalidContainer() {
		ExceptionAssertions.throwsType(() -> ImageIO.from.bytes.webp(FormatAssertions.malformedBytes()), ImageLoadingFailed);
	}

	#if vision_quiet
	@:visionTestId("vision.formats.from.FromBytes#quiet-invalid-images")
	function test_quiet__invalidImagesReturnTransparentPlaceholder() {
		for (image in [new FromBytes().png(FormatAssertions.malformedBytes()), new FromBytes().bmp(FormatAssertions.malformedBytes())]) {
			Assert.equals(1, image.width);
			Assert.equals(1, image.height);
			Assert.equals(0, image.getPixel(0, 0).alpha);
		}
	}
	#end

}

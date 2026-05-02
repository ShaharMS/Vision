package tests;

import tests.support.ExceptionAssertions;
import tests.support.FormatAssertions;
import vision.exceptions.Unimplemented;
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
		var expected = FormatAssertions.fixtureImage();
		var bytes = ImageIO.to.bytes.png(expected);
		var actual = new FromBytes().png(bytes);
		FormatAssertions.imagesEqual(expected, actual);
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
		ExceptionAssertions.throwsAny(() -> new FromBytes().png(FormatAssertions.malformedBytes()));
	}

	@:visionTestId("vision.formats.from.FromBytes.bmp#invalidHeader")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_bmp__invalidHeaderThrows() {
		ExceptionAssertions.throwsAny(() -> new FromBytes().bmp(FormatAssertions.malformedBytes()));
	}

	@:visionTestId("vision.formats.from.FromBytes.jpeg#unimplementedOnInterp")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_jpeg__unimplementedOnInterp() {
		ExceptionAssertions.throwsType(() -> new FromBytes().jpeg(FormatAssertions.malformedBytes()), Unimplemented);
	}
}

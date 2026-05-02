package tests;

import tests.support.ExceptionAssertions;
import vision.exceptions.InvalidHeapsPixelFormat;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class InvalidHeapsPixelFormatTest extends utest.Test {
	@:visionTestId("vision.exceptions.InvalidHeapsPixelFormat.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__reportsReceivedFormat() {
		ExceptionAssertions.expectMessage(
			() -> throw new InvalidHeapsPixelFormat("RGBA"),
			InvalidHeapsPixelFormat,
			"Invalid Heaps Pixel Format: FrameworkImageIO.fromHeapsPixels expects pixels in ARGB format, but received RGBA. Convert the source pixels to ARGB before calling this method."
		);
	}
}
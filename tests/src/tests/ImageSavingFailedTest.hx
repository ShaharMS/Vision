package tests;

import tests.support.ExceptionAssertions;
import vision.ds.ImageFormat;
import vision.exceptions.ImageSavingFailed;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageSavingFailedTest extends utest.Test {
	@:visionTestId("vision.exceptions.ImageSavingFailed.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__usesHumanReadableFormatName() {
		ExceptionAssertions.expectMessage(
			() -> throw new ImageSavingFailed(ImageFormat.JPEG, "out of memory"),
			ImageSavingFailed,
			"JPEG Saving Failed: out of memory"
		);
	}
}
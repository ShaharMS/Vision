package tests;

import tests.support.ExceptionAssertions;
import vision.ds.ImageFormat;
import vision.exceptions.ImageLoadingFailed;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageLoadingFailedTest extends utest.Test {
	@:visionTestId("vision.exceptions.ImageLoadingFailed.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__usesHumanReadableFormatName() {
		ExceptionAssertions.expectMessage(
			() -> throw new ImageLoadingFailed(ImageFormat.PNG, "bad header"),
			ImageLoadingFailed,
			"PNG Loading Failed: bad header"
		);
	}
}
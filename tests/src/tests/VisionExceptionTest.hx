package tests;

import tests.support.ExceptionAssertions;
import vision.exceptions.VisionException;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class VisionExceptionTest extends utest.Test {
	@:visionTestId("vision.exceptions.VisionException.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__storesTypePrefixedMessage() {
		ExceptionAssertions.expectMessage(
			() -> throw new VisionException("broken", "Custom Error"),
			VisionException,
			"Custom Error: broken"
		);
	}
}
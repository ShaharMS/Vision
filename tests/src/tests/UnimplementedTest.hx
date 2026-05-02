package tests;

import tests.support.ExceptionAssertions;
import vision.exceptions.Unimplemented;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class UnimplementedTest extends utest.Test {
	@:visionTestId("vision.exceptions.Unimplemented.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__reportsMissingMethodName() {
		ExceptionAssertions.expectMessage(
			() -> throw new Unimplemented("Vision.magic"),
			Unimplemented,
			"Unimplemented Method: Vision.magic is not yet implemented"
		);
	}
}
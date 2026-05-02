package tests;

import haxe.Exception;
import tests.support.ExceptionAssertions;
import vision.exceptions.MultithreadFailure;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class MultithreadFailureTest extends utest.Test {
	@:visionTestId("vision.exceptions.MultithreadFailure.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__reportsThreadNumberAndReason() {
		ExceptionAssertions.expectMessage(
			() -> throw new MultithreadFailure(3, new Exception("boom")),
			MultithreadFailure,
			"Multithreading Failure: Thread number #3 failed: boom"
		);
	}
}
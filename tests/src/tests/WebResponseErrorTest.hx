package tests;

import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.WebResponseError;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class WebResponseErrorTest extends utest.Test {
	@:visionTestId("vision.exceptions.WebResponseError.new#messageAndField")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__storesMessageAndField() {
		var error = ExceptionAssertions.capture(() -> throw new WebResponseError("https://example.com", "404"));

		Assert.isTrue(Std.isOfType(error, WebResponseError));
		Assert.equals("Web Response Error: Website https://example.com returned an error message - 404", ExceptionAssertions.messageOf(error));
		Assert.equals("404", cast(error, WebResponseError).error);
	}
}
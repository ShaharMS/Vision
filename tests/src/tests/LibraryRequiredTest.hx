package tests;

import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.LibraryRequired;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class LibraryRequiredTest extends utest.Test {
	@:visionTestId("vision.exceptions.LibraryRequired.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__mentionsLibraryAndDependencies() {
		var error = ExceptionAssertions.capture(
			() -> throw new LibraryRequired("format", ["png", "bmp"], "vision.formats.to.ToBytes.png")
		);
		var message = ExceptionAssertions.messageOf(error);

		Assert.isTrue(Std.isOfType(error, LibraryRequired));
		Assert.isTrue(message.indexOf("Missing Library Required: The function vision.formats.to.ToBytes.png requires the `format` haxelib.") == 0);
		Assert.isTrue(message.indexOf("--library format") != -1);
		Assert.isTrue(message.indexOf("--library png") != -1);
		Assert.isTrue(message.indexOf("--library bmp") != -1);
	}
}
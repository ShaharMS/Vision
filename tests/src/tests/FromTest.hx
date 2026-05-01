package tests;

import utest.Assert;
import vision.formats.from.From;

@:access(vision.formats.from.From)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class FromTest extends utest.Test {

	@:visionTestId("vision.formats.from.From.bytes#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_bytes__default() {
		var instance = new vision.formats.from.From();
		var result = instance.bytes;
		Assert.notNull(result);
	}

	@:visionTestId("vision.formats.from.From.framework#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_framework__default() {
		var instance = new vision.formats.from.From();
		var result = instance.framework;
		Assert.notNull(result);
	}

}

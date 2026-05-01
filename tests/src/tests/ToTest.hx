package tests;

import utest.Assert;
import vision.formats.to.To;

@:access(vision.formats.to.To)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class ToTest extends utest.Test {

	@:visionTestId("vision.formats.to.To.bytes#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_bytes__default() {
		var instance = new vision.formats.to.To();
		var result = instance.bytes;
		Assert.notNull(result);
	}

	@:visionTestId("vision.formats.to.To.framework#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_framework__default() {
		var instance = new vision.formats.to.To();
		var result = instance.framework;
		Assert.notNull(result);
	}

}

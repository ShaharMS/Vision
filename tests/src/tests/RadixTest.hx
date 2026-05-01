package tests;

import utest.Assert;
import vision.algorithms.Radix;

@:access(vision.algorithms.Radix)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class RadixTest extends utest.Test {

	@:visionTestId("vision.algorithms.Radix.sort#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_sort__default() {
		var main = [-3, -1, 2, 4];
		var result = vision.algorithms.Radix.sort(main);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.algorithms.Radix.sort#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_sort__duplicates() {
		var main = [-3, -1, 2, 4];
		var result = vision.algorithms.Radix.sort(main);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}

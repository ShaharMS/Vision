package tests;

import tests.support.CollectionAssertions;
import vision.algorithms.Radix;

@:access(vision.algorithms.Radix)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class RadixTest extends utest.Test {
	@:visionTestId("vision.algorithms.Radix.sort#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_sort__default() {
		var values:Array<Int> = [2, -3, 4, -1];
		CollectionAssertions.values([-3, -1, 2, 4], Radix.sort(values));
	}

	@:visionTestId("vision.algorithms.Radix.sort#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_sort__duplicates() {
		var values:Array<Int> = [3, -5, 0, 3, -1, 9, -5];
		CollectionAssertions.values([-5, -5, -1, 0, 3, 3, 9], Radix.sort(values));
	}
}

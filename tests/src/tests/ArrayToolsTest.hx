package tests;

import tests.support.ApproxAssertions;
import utest.Assert;
import vision.tools.ArrayTools;

@:access(vision.tools.ArrayTools)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ArrayToolsTest extends utest.Test {
	function assertIntArray(expected:Array<Int>, actual:Array<Int>):Void {
		Assert.equals(expected.length, actual.length);
		for (index in 0...expected.length) {
			Assert.equals(expected[index], actual[index]);
		}
	}

	function assertNestedIntArray(expected:Array<Array<Int>>, actual:Array<Array<Int>>):Void {
		Assert.equals(expected.length, actual.length);
		for (index in 0...expected.length) {
			assertIntArray(expected[index], actual[index]);
		}
	}

	@:visionTestId("vision.tools.ArrayTools.flatten#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_flatten__default() {
		assertIntArray([1, 2, 3, 4], ArrayTools.flatten([[1, 2], [3, 4]]));
	}

	@:visionTestId("vision.tools.ArrayTools.flatten#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_flatten__duplicates() {
		assertIntArray([1, 1, 2, 2], ArrayTools.flatten([[1, 1], [2, 2]]));
	}

	@:visionTestId("vision.tools.ArrayTools.flatten#empty")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_flatten__empty() {
		assertIntArray([], ArrayTools.flatten([]));
	}

	@:visionTestId("vision.tools.ArrayTools.raise#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_raise__default() {
		assertNestedIntArray([[1, 2], [3, 4]], ArrayTools.raise([1, 2, 3, 4], 2));
	}

	@:visionTestId("vision.tools.ArrayTools.raise#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_raise__duplicates() {
		assertNestedIntArray([[1, 2], [2, 4]], ArrayTools.raise([1, 2, 2, 4], 2));
	}

	@:visionTestId("vision.tools.ArrayTools.raise#predicateClosesArray")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_raise__predicateClosesArray() {
		var result = ArrayTools.raise([1, 0, 2, 0, 3], false, value -> value == 0);
		assertNestedIntArray([[1, 0], [2, 0], [3]], result);
	}

	@:visionTestId("vision.tools.ArrayTools.raise#predicateOpensArray")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_raise__predicateOpensArray() {
		var result = ArrayTools.raise([0, 1, 2, 0, 3], true, value -> value == 0);
		assertNestedIntArray([[0, 1, 2], [0, 3]], result);
	}

	@:visionTestId("vision.tools.ArrayTools.min#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_min__default() {
		var values:Array<Int> = [4, 1, 3, 2];
		Assert.equals(1, ArrayTools.min(values));
	}

	@:visionTestId("vision.tools.ArrayTools.min#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_min__duplicates() {
		var values:Array<Int> = [3, 1, 1, 4];
		Assert.equals(1, ArrayTools.min(values));
	}

	@:visionTestId("vision.tools.ArrayTools.min#empty")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_min__empty() {
		var values:Array<Int> = [];
		Assert.equals(null, ArrayTools.min(values));
	}

	@:visionTestId("vision.tools.ArrayTools.min#valueFunction")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_min__valueFunction() {
		var result = ArrayTools.min([
			{name: "high", score: 4.0},
			{name: "low", score: 1.5},
			{name: "mid", score: 3.0}
		], item -> item.score);
		Assert.equals("low", result.name);
	}

	@:visionTestId("vision.tools.ArrayTools.max#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_max__default() {
		var values:Array<Int> = [4, 1, 3, 2];
		Assert.equals(4, ArrayTools.max(values));
	}

	@:visionTestId("vision.tools.ArrayTools.max#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_max__duplicates() {
		var values:Array<Int> = [1, 4, 4, 2];
		Assert.equals(4, ArrayTools.max(values));
	}

	@:visionTestId("vision.tools.ArrayTools.max#valueFunction")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_max__valueFunction() {
		var result = ArrayTools.max([
			{name: "low", score: 1.0},
			{name: "high", score: 4.5},
			{name: "mid", score: 3.0}
		], item -> item.score);
		Assert.equals("high", result.name);
	}

	@:visionTestId("vision.tools.ArrayTools.average#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_average__default() {
		var values:Array<Int> = [1, 2, 3, 4];
		ApproxAssertions.equalsFloat(2.5, ArrayTools.average(values));
	}

	@:visionTestId("vision.tools.ArrayTools.average#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_average__duplicates() {
		var values:Array<Int> = [1, 2, 2, 4];
		ApproxAssertions.equalsFloat(2.25, ArrayTools.average(values));
	}

	@:visionTestId("vision.tools.ArrayTools.median#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_median__default() {
		var values:Array<Int> = [4, 1, 3, 2];
		Assert.equals(3, ArrayTools.median(values));
	}

	@:visionTestId("vision.tools.ArrayTools.median#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_median__duplicates() {
		var values:Array<Int> = [4, 2, 2, 1];
		Assert.equals(2, ArrayTools.median(values));
	}

	@:visionTestId("vision.tools.ArrayTools.median#copiesInput")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_median__copiesInput() {
		var values:Array<Int> = [4, 1, 3, 2];
		Assert.equals(3, ArrayTools.median(values));
		assertIntArray([4, 1, 3, 2], values);
	}

	@:visionTestId("vision.tools.ArrayTools.distanceTo#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		var array = [1, 4, 9, 10];
		var nearResult = ArrayTools.distanceTo(array, [2, 2, 10, 15], (left, right) -> Math.abs(right - left));
		var farResult = ArrayTools.distanceTo(array, [100, 200, 300, 400], (left, right) -> Math.abs(right - left));
		ApproxAssertions.equalsFloat(9, nearResult);
		ApproxAssertions.equalsFloat(976, farResult);
		Assert.notEquals(nearResult, farResult);
	}

	@:visionTestId("vision.tools.ArrayTools.distanceTo#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distanceTo__duplicates() {
		var array = [1, 1, 2, 2];
		var closeResult = ArrayTools.distanceTo(array, [1, 2, 2, 3], (left, right) -> Math.abs(right - left));
		var farResult = ArrayTools.distanceTo(array, [9, 9, 9, 9], (left, right) -> Math.abs(right - left));
		ApproxAssertions.equalsFloat(2, closeResult);
		ApproxAssertions.equalsFloat(30, farResult);
		Assert.notEquals(closeResult, farResult);
	}

	@:visionTestId("vision.tools.ArrayTools.flatMap#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_flatMap__default() {
		assertIntArray([1, -1, 2, -2, 3, -3], ArrayTools.flatMap([1, 2, 3], value -> [value, -value]));
	}

	@:visionTestId("vision.tools.ArrayTools.flatMap#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_flatMap__duplicates() {
		assertIntArray([1, 1, 2, 2, 2, 2], ArrayTools.flatMap([1, 2, 2], value -> [value, value]));
	}

	@:visionTestId("vision.tools.ArrayTools.flatMap#empty")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_flatMap__empty() {
		assertIntArray([], ArrayTools.flatMap([], value -> [value]));
	}

	@:visionTestId("vision.tools.ArrayTools.distinct#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distinct__default() {
		assertIntArray([1, 2, 3, 4], ArrayTools.distinct([1, 2, 3, 4]));
	}

	@:visionTestId("vision.tools.ArrayTools.distinct#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distinct__duplicates() {
		assertIntArray([2, 1, 3], ArrayTools.distinct([2, 1, 2, 3, 1]));
	}

	@:visionTestId("vision.tools.ArrayTools.distinct#empty")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_distinct__empty() {
		assertIntArray([], ArrayTools.distinct([]));
	}
}

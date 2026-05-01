package tests;

import utest.Assert;
import vision.tools.ArrayTools;

@:access(vision.tools.ArrayTools)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class ArrayToolsTest extends utest.Test {

	@:visionTestId("vision.tools.ArrayTools.flatten#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_flatten__default() {
		var array = [[1, 2], [3, 4]];
		var result = vision.tools.ArrayTools.flatten(array);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.flatten#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_flatten__duplicates() {
		var array = [[1, 1], [2, 2]];
		var result = vision.tools.ArrayTools.flatten(array);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.flatten#empty")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_flatten__empty() {
		var array = [];
		var result = vision.tools.ArrayTools.flatten(array);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.raise#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_raise__default() {
		var array = [1, 2, 3, 4];
		var delimiter = 1;
		var result = vision.tools.ArrayTools.raise(array, delimiter);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.raise#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_raise__duplicates() {
		var array = [1, 2, 2, 4];
		var delimiter = 1;
		var result = vision.tools.ArrayTools.raise(array, delimiter);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.min#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_min__default() {
		var values = [1, 2, 3, 4];
		var result = vision.tools.ArrayTools.min(values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ArrayTools.min#duplicates")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_min__duplicates() {
		var values = [1, 2, 2, 4];
		var result = vision.tools.ArrayTools.min(values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ArrayTools.max#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_max__default() {
		var values = [1, 2, 3, 4];
		var result = vision.tools.ArrayTools.max(values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ArrayTools.max#duplicates")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_max__duplicates() {
		var values = [1, 2, 2, 4];
		var result = vision.tools.ArrayTools.max(values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ArrayTools.average#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_average__default() {
		var values = [1, 2, 3, 4];
		var result = vision.tools.ArrayTools.average(values);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.ArrayTools.average#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_average__duplicates() {
		var values = [1, 2, 2, 4];
		var result = vision.tools.ArrayTools.average(values);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.ArrayTools.median#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_median__default() {
		var values = [1, 2, 3, 4];
		var result = vision.tools.ArrayTools.median(values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ArrayTools.median#duplicates")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_median__duplicates() {
		var values = [1, 2, 2, 4];
		var result = vision.tools.ArrayTools.median(values);
		Assert.notNull(result);
	}

	@:visionTestId("vision.tools.ArrayTools.distanceTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		var array = [1, 2, 3, 4];
		var to = [1, 2, 3, 4];
		var distanceFunction = (arg0, arg1) -> Math.abs((cast arg1 : Float) - (cast arg0 : Float));
		var result = vision.tools.ArrayTools.distanceTo(array, to, distanceFunction);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.ArrayTools.distanceTo#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceTo__duplicates() {
		var array = [1, 2, 2, 4];
		var to = [1, 2, 2, 4];
		var distanceFunction = (arg0, arg1) -> Math.abs((cast arg1 : Float) - (cast arg0 : Float));
		var result = vision.tools.ArrayTools.distanceTo(array, to, distanceFunction);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.tools.ArrayTools.flatMap#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_flatMap__default() {
		var array = [1, 2, 3, 4];
		var mappingFunction = (arg0) -> [arg0];
		var result = vision.tools.ArrayTools.flatMap(array, mappingFunction);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.flatMap#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_flatMap__duplicates() {
		var array = [1, 2, 2, 4];
		var mappingFunction = (arg0) -> [arg0];
		var result = vision.tools.ArrayTools.flatMap(array, mappingFunction);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.flatMap#empty")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_flatMap__empty() {
		var array = [];
		var mappingFunction = (arg0) -> [arg0];
		var result = vision.tools.ArrayTools.flatMap(array, mappingFunction);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.distinct#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distinct__default() {
		var array = [1, 2, 3, 4];
		var result = vision.tools.ArrayTools.distinct(array);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.distinct#duplicates")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distinct__duplicates() {
		var array = [1, 2, 2, 4];
		var result = vision.tools.ArrayTools.distinct(array);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.tools.ArrayTools.distinct#empty")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distinct__empty() {
		var array = [];
		var result = vision.tools.ArrayTools.distinct(array);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}

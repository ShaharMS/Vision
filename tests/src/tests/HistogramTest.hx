package tests;

import utest.Assert;
import vision.ds.Histogram;

@:access(vision.ds.Histogram)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class HistogramTest extends utest.Test {

	@:visionTestId("vision.ds.Histogram.length#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_length__default() {
		var instance = (function() { var histogram = new vision.ds.Histogram(); histogram.increment(1); histogram.increment(2); histogram.increment(2); return histogram; })();
		var result = instance.length;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Histogram.median#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_median__default() {
		var instance = (function() { var histogram = new vision.ds.Histogram(); histogram.increment(1); histogram.increment(2); histogram.increment(2); return histogram; })();
		var result = instance.median;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Histogram.increment#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_increment__default() {
		var cell = 1;
		var instance = (function() { var histogram = new vision.ds.Histogram(); histogram.increment(1); histogram.increment(2); histogram.increment(2); return histogram; })();
		var result = instance.increment(cell);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Histogram.decrement#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_decrement__default() {
		var cell = 1;
		var instance = (function() { var histogram = new vision.ds.Histogram(); histogram.increment(1); histogram.increment(2); histogram.increment(2); return histogram; })();
		var result = instance.decrement(cell);
		Assert.notNull(result);
	}

}

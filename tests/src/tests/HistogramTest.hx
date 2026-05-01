package tests;

import utest.Assert;
import vision.ds.Histogram;

@:access(vision.ds.Histogram)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class HistogramTest extends utest.Test {
	function createHistogram():Histogram {
		var histogram = new Histogram();
		histogram.increment(1);
		histogram.increment(2);
		histogram.increment(2);
		return histogram;
	}

	@:visionTestId("vision.ds.Histogram.length#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_length__default() {
		Assert.equals(3, createHistogram().length);
	}

	@:visionTestId("vision.ds.Histogram.median#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_median__default() {
		Assert.equals(2, createHistogram().median);
	}

	@:visionTestId("vision.ds.Histogram.increment#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_increment__default() {
		var instance = createHistogram();
		var result = instance.increment(5);
		Assert.equals(1, instance.underlying[5]);
		Assert.equals(instance, result);
	}

	@:visionTestId("vision.ds.Histogram.decrement#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_decrement__default() {
		var instance = createHistogram();
		var result = instance.decrement(2);
		Assert.equals(1, instance.underlying[2]);
		Assert.equals(instance, result);
	}
}

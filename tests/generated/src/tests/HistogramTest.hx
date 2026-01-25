package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Histogram;
import haxe.ds.IntMap;

@:access(vision.ds.Histogram)
class HistogramTest extends utest.Test {

    function test_new_creates_empty_histogram() {
        var histogram = new Histogram();
        Assert.notNull(histogram);
        Assert.equals(0, histogram.length);
    }

    function test_increment_single_cell() {
        var histogram = new Histogram();
        histogram.increment(5);
        // Length should be 6 (indices 0-5)
        Assert.equals(6, histogram.length);
        // Underlying value should be 1
        Assert.equals(1, histogram.underlying[5]);
    }

    function test_increment_multiple_times() {
        var histogram = new Histogram();
        histogram.increment(3);
        histogram.increment(3);
        histogram.increment(3);
        Assert.equals(3, histogram.underlying[3]);
    }

    function test_increment_returns_self_for_chaining() {
        var histogram = new Histogram();
        var result = histogram.increment(5);
        Assert.equals(histogram, result);
    }

    function test_increment_chained() {
        var histogram = new Histogram();
        histogram.increment(1).increment(2).increment(3);
        Assert.equals(1, histogram.underlying[1]);
        Assert.equals(1, histogram.underlying[2]);
        Assert.equals(1, histogram.underlying[3]);
    }

    function test_decrement_single_cell() {
        var histogram = new Histogram();
        histogram.increment(5);
        histogram.increment(5);
        histogram.decrement(5);
        Assert.equals(1, histogram.underlying[5]);
    }

    function test_decrement_to_negative() {
        var histogram = new Histogram();
        histogram.decrement(3);
        Assert.equals(-1, histogram.underlying[3]);
    }

    function test_decrement_returns_self_for_chaining() {
        var histogram = new Histogram();
        histogram.increment(5);
        var result = histogram.decrement(5);
        Assert.equals(histogram, result);
    }

    function test_length_empty() {
        var histogram = new Histogram();
        Assert.equals(0, histogram.length);
    }

    function test_length_sparse() {
        var histogram = new Histogram();
        histogram.increment(10);
        // Underlying array has length 11 (indices 0-10)
        Assert.equals(11, histogram.length);
    }

    function test_length_multiple_cells() {
        var histogram = new Histogram();
        histogram.increment(5);
        histogram.increment(15);
        // Underlying array has length 16 (indices 0-15)
        Assert.equals(16, histogram.length);
    }

    function test_median_single_value() {
        var histogram = new Histogram();
        histogram.increment(42);
        Assert.equals(42, histogram.median);
    }

    function test_median_odd_count() {
        var histogram = new Histogram();
        // Values: [10, 10, 10, 20, 20] - median is 10
        histogram.increment(10);
        histogram.increment(10);
        histogram.increment(10);
        histogram.increment(20);
        histogram.increment(20);
        Assert.equals(10, histogram.median);
    }

    function test_median_even_count() {
        var histogram = new Histogram();
        // Values: [10, 10, 10, 20, 20, 30] - 6 elements, middle at index 3
        histogram.increment(10);
        histogram.increment(10);
        histogram.increment(10);
        histogram.increment(20);
        histogram.increment(20);
        histogram.increment(30);
        // Expanded: [10, 10, 10, 20, 20, 30], median at floor((6-0)/2) = 3 -> 20
        Assert.equals(20, histogram.median);
    }

    function test_median_uniform_distribution() {
        var histogram = new Histogram();
        // One of each: 1, 2, 3, 4, 5 -> median is 3
        for (i in 1...6) {
            histogram.increment(i);
        }
        Assert.equals(3, histogram.median);
    }

}

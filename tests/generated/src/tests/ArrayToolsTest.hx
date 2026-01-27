package tests;

import utest.Assert;
import utest.Async;
import vision.tools.ArrayTools;
import haxe.Int64;
import haxe.extern.EitherType;
import haxe.ds.ArraySort;
import vision.algorithms.Radix;
import vision.tools.MathTools.*;

@:access(vision.tools.ArrayTools)
class ArrayToolsTest extends utest.Test {

    // Shared test fixtures
    static var testImage:vision.ds.Image;
    static var blackImage:vision.ds.Image;
    static var gradientImage:vision.ds.Image;

    public function setup() {
        if (testImage == null) {
            testImage = new vision.ds.Image(100, 100);
            blackImage = new vision.ds.Image(100, 100, 0xFF000000);
            gradientImage = createGradientImage(100, 100);
        }
    }

    static function createGradientImage(w:Int, h:Int):vision.ds.Image {
        var img = new vision.ds.Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                var r = Std.int((x / w) * 255);
                var g = Std.int((y / h) * 255);
                var b = Std.int(((x + y) / (w + h)) * 255);
                img.setPixel(x, y, vision.ds.Color.fromRGBA(r, g, b, 255));
            }
        }
        return img;
    }

    function test_flatten() {
        var array:Array<Array<Int>> = [[1, 2], [3, 4], [5]];
        var result = vision.tools.ArrayTools.flatten(array);
        Assert.notNull(result);
        Assert.equals(5, result.length);
        Assert.equals(1, result[0]);
        Assert.equals(5, result[4]);
    }

    function test_raise() {
        var array = [1, 2, 3, 4, 5, 6];
        var delimiter = 2;
        var result = vision.tools.ArrayTools.raise(array, delimiter);
        Assert.notNull(result);
        Assert.equals(3, result.length); // 6 elements / 2 = 3 subarrays
        Assert.equals(2, result[0].length);
    }

    function test_raise_with_predicate() {
        // Split array when we hit a negative number
        var array = [1, 2, -1, 3, 4, -1, 5];
        var result = vision.tools.ArrayTools.raise(array, false, (x) -> x < 0);
        Assert.notNull(result);
        // Should split into: [1,2,-1], [3,4,-1], [5]
        Assert.equals(3, result.length);
    }

    function test_raise_predicate_opens_array() {
        // Split array at each 0, with 0 opening each subarray
        var array = [0, 1, 2, 0, 3, 4];
        var result = vision.tools.ArrayTools.raise(array, true, (x) -> x == 0);
        Assert.notNull(result);
        Assert.equals(2, result.length);
        Assert.equals(0, result[0][0]); // First element of first subarray is 0
        Assert.equals(0, result[1][0]); // First element of second subarray is 0
    }

    function test_min() {
        var values = [5, 2, 8, 1, 9];
        var result = vision.tools.ArrayTools.min(values);
        Assert.equals(1, result);
    }

    function test_min_1() {
        var values = [{v: 5}, {v: 2}, {v: 8}];
        var valueFunction = (item:{v:Int}) -> item.v;
        var result = vision.tools.ArrayTools.min(values, valueFunction);
        Assert.equals(2, result.v);
    }

    function test_max() {
        var values = [5, 2, 8, 1, 9];
        var result = vision.tools.ArrayTools.max(values);
        Assert.equals(9, result);
    }

    function test_max_1() {
        var values = [{v: 5}, {v: 2}, {v: 8}];
        var valueFunction = (item:{v:Int}) -> item.v;
        var result = vision.tools.ArrayTools.max(values, valueFunction);
        Assert.equals(8, result.v);
    }

    function test_average() {
        var values = [2.0, 4.0, 6.0, 8.0];
        var result = vision.tools.ArrayTools.average(values);
        Assert.equals(5.0, result);
    }

    function test_median() {
        var values = [1.0, 2.0, 3.0, 4.0, 5.0];
        var result = vision.tools.ArrayTools.median(values);
        Assert.equals(3.0, result);
    }

    function test_median_even() {
        // Vision's median implementation uses floor(length/2) for even arrays
        // So for [1, 2, 3, 4], it returns element at index 2, which is 3
        var values = [1.0, 2.0, 3.0, 4.0];
        var result = vision.tools.ArrayTools.median(values);
        Assert.equals(3.0, result); // index floor(4/2) = 2 -> value 3
    }

    function test_distanceTo() {
        // Calculate total distance along a path of points
        var array = [0.0, 1.0, 3.0, 6.0]; // distances: 1, 2, 3 = total 6
        var distanceFunction = (a:Float, b:Float) -> Math.abs(b - a);
        var result = vision.tools.ArrayTools.distanceTo(array, array, distanceFunction);
        Assert.floatEquals(6.0, result);
    }

    function test_distanceTo_single_element() {
        var array = [5.0];
        var distanceFunction = (a:Float, b:Float) -> Math.abs(b - a);
        var result = vision.tools.ArrayTools.distanceTo(array, array, distanceFunction);
        Assert.floatEquals(0.0, result); // No pairs to measure
    }

    function test_distinct() {
        var array = [1, 2, 2, 3, 3, 3, 4];
        var result = vision.tools.ArrayTools.distinct(array);
        Assert.notNull(result);
        Assert.equals(4, result.length); // [1, 2, 3, 4]
    }

    function test_flatMap() {
        // flatMap: map each element to an array, then flatten
        var array = [1, 2, 3];
        var result = vision.tools.ArrayTools.flatMap(array, (x) -> [x, x * 10]);
        Assert.equals(6, result.length); // [1, 10, 2, 20, 3, 30]
        Assert.equals(1, result[0]);
        Assert.equals(10, result[1]);
        Assert.equals(2, result[2]);
        Assert.equals(20, result[3]);
    }

    function test_min_empty_array() {
        var values:Array<Int> = [];
        var result = vision.tools.ArrayTools.min(values);
        #if (hl || cppia || cpp || java || jvm || cs)
        Assert.equals(0, result);
        #else
        Assert.isNull(result); // Empty array returns null/first element
        #end
    }

    function test_max_negative_values() {
        var values = [-5, -2, -8, -1, -9];
        var result = vision.tools.ArrayTools.max(values);
        Assert.equals(-1, result);
    }

    function test_average_single_value() {
        var values = [42.0];
        var result = vision.tools.ArrayTools.average(values);
        Assert.floatEquals(42.0, result);
    }

    function test_flatten_empty() {
        var array:Array<Array<Int>> = [];
        var result = vision.tools.ArrayTools.flatten(array);
        Assert.equals(0, result.length);
    }

    function test_flatten_nested_empty() {
        var array:Array<Array<Int>> = [[], [], []];
        var result = vision.tools.ArrayTools.flatten(array);
        Assert.equals(0, result.length);
    }

}

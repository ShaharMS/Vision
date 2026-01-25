package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Point2D;
import vision.tools.MathTools;

@:access(vision.ds.Point2D)
class Point2DTest extends utest.Test {

    function test_constructor_default() {
        var point = new Point2D();
        Assert.floatEquals(0.0, point.x);
        Assert.floatEquals(0.0, point.y);
    }

    function test_constructor_with_values() {
        var point = new Point2D(3.5, 4.5);
        Assert.floatEquals(3.5, point.x);
        Assert.floatEquals(4.5, point.y);
    }

    function test_struct_init() {
        var point:Point2D = {x: 10.0, y: 20.0};
        Assert.floatEquals(10.0, point.x);
        Assert.floatEquals(20.0, point.y);
    }

    function test_toString() {
        var point = new Point2D(3.5, 4.5);
        var result = point.toString();
        Assert.notNull(result);
        Assert.isTrue(result.indexOf("3.5") >= 0);
        Assert.isTrue(result.indexOf("4.5") >= 0);
    }

    function test_copy() {
        var original = new Point2D(10.0, 20.0);
        var copied = original.copy();
        Assert.floatEquals(10.0, copied.x);
        Assert.floatEquals(20.0, copied.y);
    }

    function test_copy_is_independent() {
        var original = new Point2D(10.0, 20.0);
        var copied = original.copy();
        copied.x = 999.0;
        Assert.floatEquals(10.0, original.x); // Original unchanged
    }

    function test_distanceTo_345_triangle() {
        var origin = new Point2D(0.0, 0.0);
        var point = new Point2D(3.0, 4.0);
        Assert.floatEquals(5.0, origin.distanceTo(point));
    }

    function test_distanceTo_same_point() {
        var point = new Point2D(5.0, 5.0);
        Assert.floatEquals(0.0, point.distanceTo(point));
    }

    function test_distanceTo_horizontal() {
        var p1 = new Point2D(0.0, 0.0);
        var p2 = new Point2D(10.0, 0.0);
        Assert.floatEquals(10.0, p1.distanceTo(p2));
    }

    function test_distanceTo_vertical() {
        var p1 = new Point2D(0.0, 0.0);
        var p2 = new Point2D(0.0, 7.0);
        Assert.floatEquals(7.0, p1.distanceTo(p2));
    }

    function test_degreesTo_right() {
        var origin = new Point2D(0.0, 0.0);
        var right = new Point2D(1.0, 0.0);
        Assert.floatEquals(0.0, origin.degreesTo(right));
    }

    function test_degreesTo_up() {
        var origin = new Point2D(0.0, 0.0);
        var up = new Point2D(0.0, 1.0);
        Assert.floatEquals(90.0, origin.degreesTo(up));
    }

    function test_radiansTo_right() {
        var origin = new Point2D(0.0, 0.0);
        var right = new Point2D(1.0, 0.0);
        Assert.floatEquals(0.0, origin.radiansTo(right));
    }

    function test_x_is_mutable() {
        var point = new Point2D(0.0, 0.0);
        point.x = 42.5;
        Assert.floatEquals(42.5, point.x);
    }

    function test_y_is_mutable() {
        var point = new Point2D(0.0, 0.0);
        point.y = 99.9;
        Assert.floatEquals(99.9, point.y);
    }

    function test_negative_coordinates() {
        var point = new Point2D(-5.5, -10.2);
        Assert.floatEquals(-5.5, point.x);
        Assert.floatEquals(-10.2, point.y);
    }

}

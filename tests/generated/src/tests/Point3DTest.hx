package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Point3D;
import vision.tools.MathTools;

@:access(vision.ds.Point3D)
class Point3DTest extends utest.Test {

    // ============================================================
    // Constructor Tests
    // ============================================================

    function test_constructor_basic() {
        var point = new Point3D(1.0, 2.0, 3.0);
        Assert.floatEquals(1.0, point.x);
        Assert.floatEquals(2.0, point.y);
        Assert.floatEquals(3.0, point.z);
    }

    function test_constructor_zero() {
        var point = new Point3D(0.0, 0.0, 0.0);
        Assert.floatEquals(0.0, point.x);
        Assert.floatEquals(0.0, point.y);
        Assert.floatEquals(0.0, point.z);
    }

    function test_constructor_negative() {
        var point = new Point3D(-5.0, -10.0, -15.0);
        Assert.floatEquals(-5.0, point.x);
        Assert.floatEquals(-10.0, point.y);
        Assert.floatEquals(-15.0, point.z);
    }

    function test_constructor_fractional() {
        var point = new Point3D(1.5, 2.75, 3.125);
        Assert.floatEquals(1.5, point.x);
        Assert.floatEquals(2.75, point.y);
        Assert.floatEquals(3.125, point.z);
    }

    function test_structInit() {
        var point:Point3D = {x: 10.0, y: 20.0, z: 30.0};
        Assert.floatEquals(10.0, point.x);
        Assert.floatEquals(20.0, point.y);
        Assert.floatEquals(30.0, point.z);
    }

    // ============================================================
    // Mutability Tests
    // ============================================================

    function test_mutability_x() {
        var point = new Point3D(1.0, 2.0, 3.0);
        point.x = 100.0;
        Assert.floatEquals(100.0, point.x);
        Assert.floatEquals(2.0, point.y);
        Assert.floatEquals(3.0, point.z);
    }

    function test_mutability_y() {
        var point = new Point3D(1.0, 2.0, 3.0);
        point.y = 200.0;
        Assert.floatEquals(1.0, point.x);
        Assert.floatEquals(200.0, point.y);
        Assert.floatEquals(3.0, point.z);
    }

    function test_mutability_z() {
        var point = new Point3D(1.0, 2.0, 3.0);
        point.z = 300.0;
        Assert.floatEquals(1.0, point.x);
        Assert.floatEquals(2.0, point.y);
        Assert.floatEquals(300.0, point.z);
    }

    // ============================================================
    // distanceTo Tests
    // ============================================================

    function test_distanceTo_simple() {
        var point = new Point3D(1.0, 2.0, 2.0);
        var origin = new Point3D(0.0, 0.0, 0.0);
        var result = origin.distanceTo(point);
        Assert.floatEquals(3.0, result); // sqrt(1 + 4 + 4) = 3
    }

    function test_distanceTo_samePoint() {
        var point1 = new Point3D(5.0, 5.0, 5.0);
        var point2 = new Point3D(5.0, 5.0, 5.0);
        var result = point1.distanceTo(point2);
        Assert.floatEquals(0.0, result);
    }

    function test_distanceTo_axisAligned_x() {
        var point1 = new Point3D(0.0, 0.0, 0.0);
        var point2 = new Point3D(10.0, 0.0, 0.0);
        Assert.floatEquals(10.0, point1.distanceTo(point2));
    }

    function test_distanceTo_axisAligned_y() {
        var point1 = new Point3D(0.0, 0.0, 0.0);
        var point2 = new Point3D(0.0, 7.0, 0.0);
        Assert.floatEquals(7.0, point1.distanceTo(point2));
    }

    function test_distanceTo_axisAligned_z() {
        var point1 = new Point3D(0.0, 0.0, 0.0);
        var point2 = new Point3D(0.0, 0.0, 4.0);
        Assert.floatEquals(4.0, point1.distanceTo(point2));
    }

    function test_distanceTo_symmetric() {
        var point1 = new Point3D(1.0, 2.0, 3.0);
        var point2 = new Point3D(4.0, 5.0, 6.0);
        // Distance should be the same regardless of direction
        Assert.floatEquals(point1.distanceTo(point2), point2.distanceTo(point1));
    }

    function test_distanceTo_negative_coordinates() {
        var point1 = new Point3D(-3.0, -4.0, 0.0);
        var origin = new Point3D(0.0, 0.0, 0.0);
        Assert.floatEquals(5.0, origin.distanceTo(point1)); // 3-4-5 triangle
    }

    // ============================================================
    // copy Tests
    // ============================================================

    function test_copy_values() {
        var original = new Point3D(5.0, 10.0, 15.0);
        var copied = original.copy();
        Assert.floatEquals(5.0, copied.x);
        Assert.floatEquals(10.0, copied.y);
        Assert.floatEquals(15.0, copied.z);
    }

    function test_copy_independence() {
        var original = new Point3D(5.0, 10.0, 15.0);
        var copied = original.copy();
        // Modify original
        original.x = 100.0;
        original.y = 200.0;
        original.z = 300.0;
        // Copy should remain unchanged
        Assert.floatEquals(5.0, copied.x);
        Assert.floatEquals(10.0, copied.y);
        Assert.floatEquals(15.0, copied.z);
    }

    function test_copy_negative() {
        var original = new Point3D(-1.0, -2.0, -3.0);
        var copied = original.copy();
        Assert.floatEquals(-1.0, copied.x);
        Assert.floatEquals(-2.0, copied.y);
        Assert.floatEquals(-3.0, copied.z);
    }

    // ============================================================
    // toString Tests
    // ============================================================

    function test_toString_format() {
        var point = new Point3D(1.0, 2.0, 3.0);
        var result = point.toString();
        Assert.equals("(1, 2, 3)", result);
    }

    function test_toString_negative() {
        var point = new Point3D(-1.0, -2.0, -3.0);
        var result = point.toString();
        Assert.equals("(-1, -2, -3)", result);
    }

    function test_toString_zero() {
        var point = new Point3D(0.0, 0.0, 0.0);
        var result = point.toString();
        Assert.equals("(0, 0, 0)", result);
    }

    function test_toString_fractional() {
        var point = new Point3D(1.5, 2.5, 3.5);
        var result = point.toString();
        Assert.equals("(1.5, 2.5, 3.5)", result);
    }

}

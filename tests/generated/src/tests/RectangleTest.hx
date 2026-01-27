package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Rectangle;

@:access(vision.ds.Rectangle)
class RectangleTest extends utest.Test {

    // ============================================================
    // Constructor Tests
    // ============================================================

    function test_constructor_basic() {
        var rect:Rectangle = {x: 10, y: 20, width: 100, height: 50};
        Assert.equals(10, rect.x);
        Assert.equals(20, rect.y);
        Assert.equals(100, rect.width);
        Assert.equals(50, rect.height);
    }

    function test_constructor_zero() {
        var rect:Rectangle = {x: 0, y: 0, width: 0, height: 0};
        Assert.equals(0, rect.x);
        Assert.equals(0, rect.y);
        Assert.equals(0, rect.width);
        Assert.equals(0, rect.height);
    }

    function test_constructor_negativePosition() {
        var rect:Rectangle = {x: -10, y: -20, width: 100, height: 50};
        Assert.equals(-10, rect.x);
        Assert.equals(-20, rect.y);
        Assert.equals(100, rect.width);
        Assert.equals(50, rect.height);
    }

    // ============================================================
    // StructInit Tests
    // ============================================================

    function test_structInit() {
        var rect:Rectangle = {x: 5, y: 10, width: 200, height: 150};
        Assert.equals(5, rect.x);
        Assert.equals(10, rect.y);
        Assert.equals(200, rect.width);
        Assert.equals(150, rect.height);
    }

    function test_structInit_largeValues() {
        var rect:Rectangle = {x: 1000, y: 2000, width: 1920, height: 1080};
        Assert.equals(1000, rect.x);
        Assert.equals(2000, rect.y);
        Assert.equals(1920, rect.width);
        Assert.equals(1080, rect.height);
    }

    // ============================================================
    // Mutability Tests
    // ============================================================

    function test_mutability_x() {
        var rect:Rectangle = {x: 10, y: 20, width: 100, height: 50};
        rect.x = 999;
        Assert.equals(999, rect.x);
        Assert.equals(20, rect.y);
        Assert.equals(100, rect.width);
        Assert.equals(50, rect.height);
    }

    function test_mutability_y() {
        var rect:Rectangle = {x: 10, y: 20, width: 100, height: 50};
        rect.y = 888;
        Assert.equals(10, rect.x);
        Assert.equals(888, rect.y);
        Assert.equals(100, rect.width);
        Assert.equals(50, rect.height);
    }

    function test_mutability_width() {
        var rect:Rectangle = {x: 10, y: 20, width: 100, height: 50};
        rect.width = 500;
        Assert.equals(10, rect.x);
        Assert.equals(20, rect.y);
        Assert.equals(500, rect.width);
        Assert.equals(50, rect.height);
    }

    function test_mutability_height() {
        var rect:Rectangle = {x: 10, y: 20, width: 100, height: 50};
        rect.height = 300;
        Assert.equals(10, rect.x);
        Assert.equals(20, rect.y);
        Assert.equals(100, rect.width);
        Assert.equals(300, rect.height);
    }

    // ============================================================
    // Typical Use Case Tests
    // ============================================================

    function test_screenRegion() {
        // Typical use: define a region of an image
        var roi:Rectangle = {x: 100, y: 100, width: 640, height: 480};
        Assert.equals(100, roi.x);
        Assert.equals(100, roi.y);
        Assert.equals(640, roi.width);
        Assert.equals(480, roi.height);
    }

    function test_boundingBox() {
        // A rectangle representing a bounding box
        var bbox:Rectangle = {x: 50, y: 75, width: 200, height: 150};
        // Right edge
        var rightEdge = bbox.x + bbox.width;
        Assert.equals(250, rightEdge);
        // Bottom edge
        var bottomEdge = bbox.y + bbox.height;
        Assert.equals(225, bottomEdge);
    }

    function test_area_calculation() {
        var rect:Rectangle = {x: 0, y: 0, width: 10, height: 20};
        var area = rect.width * rect.height;
        Assert.equals(200, area);
    }

    function test_square() {
        var square:Rectangle = {x: 0, y: 0, width: 100, height: 100};
        Assert.equals(square.width, square.height);
    }

}

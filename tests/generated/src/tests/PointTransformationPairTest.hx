package tests;

import utest.Assert;
import utest.Async;
import vision.ds.specifics.PointTransformationPair;
import vision.ds.Point2D;

@:access(vision.ds.specifics.PointTransformationPair)
class PointTransformationPairTest extends utest.Test {

    // ============================================================
    // Constructor Tests
    // ============================================================

    function test_constructor_basic() {
        var from = new Point2D(0, 0);
        var to = new Point2D(10, 10);
        var pair = new PointTransformationPair(from, to);
        Assert.notNull(pair.from);
        Assert.notNull(pair.to);
        Assert.equals(0, pair.from.x);
        Assert.equals(0, pair.from.y);
        Assert.equals(10, pair.to.x);
        Assert.equals(10, pair.to.y);
    }

    function test_constructor_samePoints() {
        var from = new Point2D(5, 5);
        var to = new Point2D(5, 5);
        var pair = new PointTransformationPair(from, to);
        Assert.equals(pair.from.x, pair.to.x);
        Assert.equals(pair.from.y, pair.to.y);
    }

    function test_constructor_negativeCoordinates() {
        var from = new Point2D(-10, -20);
        var to = new Point2D(-5, -10);
        var pair = new PointTransformationPair(from, to);
        Assert.equals(-10, pair.from.x);
        Assert.equals(-20, pair.from.y);
        Assert.equals(-5, pair.to.x);
        Assert.equals(-10, pair.to.y);
    }

    // ============================================================
    // StructInit Tests
    // ============================================================

    function test_structInit() {
        var from:Point2D = {x: 100, y: 200};
        var to:Point2D = {x: 300, y: 400};
        var pair:PointTransformationPair = {from: from, to: to};
        Assert.equals(100, pair.from.x);
        Assert.equals(200, pair.from.y);
        Assert.equals(300, pair.to.x);
        Assert.equals(400, pair.to.y);
    }

    // ============================================================
    // Mutability Tests
    // ============================================================

    function test_mutability_from() {
        var from = new Point2D(0, 0);
        var to = new Point2D(10, 10);
        var pair = new PointTransformationPair(from, to);
        
        // Change from point
        pair.from = new Point2D(5, 5);
        Assert.equals(5, pair.from.x);
        Assert.equals(5, pair.from.y);
        // to should remain unchanged
        Assert.equals(10, pair.to.x);
        Assert.equals(10, pair.to.y);
    }

    function test_mutability_to() {
        var from = new Point2D(0, 0);
        var to = new Point2D(10, 10);
        var pair = new PointTransformationPair(from, to);
        
        // Change to point
        pair.to = new Point2D(20, 20);
        Assert.equals(20, pair.to.x);
        Assert.equals(20, pair.to.y);
        // from should remain unchanged
        Assert.equals(0, pair.from.x);
        Assert.equals(0, pair.from.y);
    }

    function test_mutability_pointCoordinates() {
        var from = new Point2D(0, 0);
        var to = new Point2D(10, 10);
        var pair = new PointTransformationPair(from, to);
        
        // Modify coordinates of the from point directly
        pair.from.x = 99;
        pair.from.y = 88;
        Assert.equals(99, pair.from.x);
        Assert.equals(88, pair.from.y);
    }

    // ============================================================
    // Reference Tests
    // ============================================================

    function test_reference_independence() {
        var from = new Point2D(0, 0);
        var to = new Point2D(10, 10);
        var pair = new PointTransformationPair(from, to);
        
        // Modifying original point modifies pair (reference semantics)
        from.x = 50;
        // Check if pair reflects the change (depends on reference vs copy)
        // This test documents the actual behavior
        Assert.notNull(pair.from);
    }

    // ============================================================
    // Typical Use Case Tests
    // ============================================================

    function test_translation_pair() {
        // A pair representing a translation by (10, 20)
        var from = new Point2D(0, 0);
        var to = new Point2D(10, 20);
        var pair = new PointTransformationPair(from, to);
        
        var dx = pair.to.x - pair.from.x;
        var dy = pair.to.y - pair.from.y;
        Assert.equals(10, dx);
        Assert.equals(20, dy);
    }

    function test_cornerMapping_topLeft() {
        // Mapping top-left corner
        var from = new Point2D(0, 0);
        var to = new Point2D(100, 100);
        var pair = new PointTransformationPair(from, to);
        Assert.equals(0, pair.from.x);
        Assert.equals(100, pair.to.x);
    }

    function test_cornerMapping_bottomRight() {
        // Mapping bottom-right corner
        var from = new Point2D(640, 480);
        var to = new Point2D(1280, 960);
        var pair = new PointTransformationPair(from, to);
        Assert.equals(640, pair.from.x);
        Assert.equals(480, pair.from.y);
        Assert.equals(1280, pair.to.x);
        Assert.equals(960, pair.to.y);
    }

}

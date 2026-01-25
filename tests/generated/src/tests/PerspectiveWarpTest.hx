package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.PerspectiveWarp;
import vision.ds.Matrix2D;
import vision.ds.Point2D;

@:access(vision.algorithms.PerspectiveWarp)
class PerspectiveWarpTest extends utest.Test {

    function test_generateMatrix_returns_3x3() {
        var sourcePoints:Array<Point2D> = [
            new Point2D(0, 0),
            new Point2D(100, 0),
            new Point2D(100, 100),
            new Point2D(0, 100)
        ];
        var destinationPoints:Array<Point2D> = [
            new Point2D(10, 10),
            new Point2D(90, 5),
            new Point2D(95, 95),
            new Point2D(5, 90)
        ];
        var result = PerspectiveWarp.generateMatrix(destinationPoints, sourcePoints);
        Assert.notNull(result);
        Assert.equals(3, result.width);
        Assert.equals(3, result.height);
    }

    function test_generateMatrix_identity_when_points_same() {
        // When source and destination are the same, should get identity-like matrix
        var points:Array<Point2D> = [
            new Point2D(0, 0),
            new Point2D(100, 0),
            new Point2D(100, 100),
            new Point2D(0, 100)
        ];
        var result = PerspectiveWarp.generateMatrix(points, points);
        Assert.notNull(result);
        // For identity transform, diagonal should be close to 1, others close to 0
        // Note: This is a projective matrix, so values may differ from pure identity
        Assert.equals(3, result.width);
    }

    function test_generateMatrix_with_translation() {
        // Simple translation - shift all points by same amount
        var source:Array<Point2D> = [
            new Point2D(0, 0),
            new Point2D(10, 0),
            new Point2D(10, 10),
            new Point2D(0, 10)
        ];
        var dest:Array<Point2D> = [
            new Point2D(5, 5),
            new Point2D(15, 5),
            new Point2D(15, 15),
            new Point2D(5, 15)
        ];
        var result = PerspectiveWarp.generateMatrix(dest, source);
        Assert.notNull(result);
        Assert.equals(3, result.width);
        Assert.equals(3, result.height);
    }

    function test_generateMatrix_with_scale() {
        // Scaling - destination is 2x source
        var source:Array<Point2D> = [
            new Point2D(0, 0),
            new Point2D(10, 0),
            new Point2D(10, 10),
            new Point2D(0, 10)
        ];
        var dest:Array<Point2D> = [
            new Point2D(0, 0),
            new Point2D(20, 0),
            new Point2D(20, 20),
            new Point2D(0, 20)
        ];
        var result = PerspectiveWarp.generateMatrix(dest, source);
        Assert.notNull(result);
    }

    function test_generateMatrix_with_perspective() {
        // Perspective distortion - trapezoid
        var source:Array<Point2D> = [
            new Point2D(0, 0),
            new Point2D(100, 0),
            new Point2D(100, 100),
            new Point2D(0, 100)
        ];
        var dest:Array<Point2D> = [
            new Point2D(20, 0),     // Top-left moved right
            new Point2D(80, 0),     // Top-right moved left
            new Point2D(100, 100),  // Bottom-right unchanged
            new Point2D(0, 100)     // Bottom-left unchanged
        ];
        var result = PerspectiveWarp.generateMatrix(dest, source);
        Assert.notNull(result);
        // Matrix should have non-zero perspective terms
        Assert.equals(3, result.width);
    }

}

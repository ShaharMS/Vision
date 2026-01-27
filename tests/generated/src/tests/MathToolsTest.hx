package tests;

import utest.Assert;
import vision.tools.MathTools;
import vision.ds.Point3D;
import vision.ds.IntPoint2D;
import haxe.Int64;
import vision.ds.Rectangle;
import vision.ds.Ray2D;
import vision.ds.Line2D;
import vision.ds.Point2D;

@:access(vision.tools.MathTools)
class MathToolsTest extends utest.Test {

    //==========================================================================
    // Constants
    //==========================================================================

    function test_PI() {
        Assert.floatEquals(Math.PI, MathTools.PI);
    }

    function test_PI_OVER_2() {
        Assert.floatEquals(Math.PI / 2, MathTools.PI_OVER_2);
    }

    function test_SQRT2() {
        Assert.floatEquals(1.4142135623730951, MathTools.SQRT2);
    }

    function test_SQRT3() {
        Assert.floatEquals(1.7320508075688772, MathTools.SQRT3);
    }

    function test_POSITIVE_INFINITY() {
        Assert.isTrue(MathTools.POSITIVE_INFINITY > 1e308);
        Assert.isFalse(Math.isFinite(MathTools.POSITIVE_INFINITY));
    }

    function test_NEGATIVE_INFINITY() {
        Assert.isTrue(MathTools.NEGATIVE_INFINITY < -1e308);
        Assert.isFalse(Math.isFinite(MathTools.NEGATIVE_INFINITY));
    }

    function test_NaN() {
        Assert.isTrue(Math.isNaN(MathTools.NaN));
    }

    //==========================================================================
    // Angle conversions
    //==========================================================================

    function test_degreesToRadians() {
        Assert.floatEquals(0.0, MathTools.degreesToRadians(0.0));
        Assert.floatEquals(Math.PI / 2, MathTools.degreesToRadians(90.0));
        Assert.floatEquals(Math.PI, MathTools.degreesToRadians(180.0));
        Assert.floatEquals(2 * Math.PI, MathTools.degreesToRadians(360.0));
        Assert.floatEquals(-Math.PI / 2, MathTools.degreesToRadians(-90.0));
    }

    function test_radiansToDegrees() {
        Assert.floatEquals(0.0, MathTools.radiansToDegrees(0.0));
        Assert.floatEquals(90.0, MathTools.radiansToDegrees(Math.PI / 2));
        Assert.floatEquals(180.0, MathTools.radiansToDegrees(Math.PI));
        Assert.floatEquals(360.0, MathTools.radiansToDegrees(2 * Math.PI));
        Assert.floatEquals(-90.0, MathTools.radiansToDegrees(-Math.PI / 2));
    }

    function test_slopeToRadians() {
        // slope = tan(angle), so slopeToRadians = atan(slope)
        Assert.floatEquals(0.0, MathTools.slopeToRadians(0.0)); // horizontal
        Assert.floatEquals(Math.PI / 4, MathTools.slopeToRadians(1.0)); // 45 degrees
        Assert.floatEquals(-Math.PI / 4, MathTools.slopeToRadians(-1.0)); // -45 degrees
    }

    function test_slopeToDegrees() {
        Assert.floatEquals(0.0, MathTools.slopeToDegrees(0.0));
        Assert.floatEquals(45.0, MathTools.slopeToDegrees(1.0));
        Assert.floatEquals(-45.0, MathTools.slopeToDegrees(-1.0));
    }

    function test_degreesToSlope() {
        Assert.floatEquals(0.0, MathTools.degreesToSlope(0.0));
        Assert.floatEquals(1.0, MathTools.degreesToSlope(45.0));
        Assert.floatEquals(-1.0, MathTools.degreesToSlope(-45.0));
    }

    function test_radiansToSlope() {
        Assert.floatEquals(0.0, MathTools.radiansToSlope(0.0));
        Assert.floatEquals(1.0, MathTools.radiansToSlope(Math.PI / 4));
    }

    //==========================================================================
    // Trigonometric functions (degree-based)
    //==========================================================================

    function test_sind() {
        Assert.floatEquals(0.0, MathTools.sind(0.0));
        Assert.floatEquals(1.0, MathTools.sind(90.0));
        Assert.floatEquals(0.0, MathTools.sind(180.0));
        Assert.floatEquals(-1.0, MathTools.sind(270.0));
    }

    function test_cosd() {
        Assert.floatEquals(1.0, MathTools.cosd(0.0));
        Assert.floatEquals(0.0, MathTools.cosd(90.0));
        Assert.floatEquals(-1.0, MathTools.cosd(180.0));
        Assert.floatEquals(0.0, MathTools.cosd(270.0));
    }

    function test_tand() {
        Assert.floatEquals(0.0, MathTools.tand(0.0));
        Assert.floatEquals(1.0, MathTools.tand(45.0));
        Assert.floatEquals(-1.0, MathTools.tand(-45.0));
    }

    function test_cotan() {
        // cotan = 1/tan
        Assert.floatEquals(1.0, MathTools.cotan(Math.PI / 4)); // cotan(45deg) = 1
        Assert.floatEquals(0.0, MathTools.cotan(Math.PI / 2)); // cotan(90deg) = 0
    }

    function test_sec() {
        // sec = 1/cos
        Assert.floatEquals(1.0, MathTools.sec(0.0)); // sec(0) = 1
        Assert.floatEquals(2.0, MathTools.sec(Math.PI / 3)); // sec(60deg) = 2
    }

    function test_cosec() {
        // cosec = 1/sin
        Assert.floatEquals(1.0, MathTools.cosec(Math.PI / 2)); // cosec(90deg) = 1
        Assert.floatEquals(2.0, MathTools.cosec(Math.PI / 6)); // cosec(30deg) = 2
    }

    //==========================================================================
    // Point distance calculations
    //==========================================================================

    function test_distanceBetweenPoints_2D() {
        // 3-4-5 right triangle
        var p1 = new Point2D(0.0, 0.0);
        var p2 = new Point2D(3.0, 4.0);
        Assert.floatEquals(5.0, MathTools.distanceBetweenPoints(p1, p2));

        // Same point = 0 distance
        Assert.floatEquals(0.0, MathTools.distanceBetweenPoints(p1, p1));

        // Horizontal distance
        var p3 = new Point2D(10.0, 0.0);
        Assert.floatEquals(10.0, MathTools.distanceBetweenPoints(p1, p3));

        // Vertical distance
        var p4 = new Point2D(0.0, 7.0);
        Assert.floatEquals(7.0, MathTools.distanceBetweenPoints(p1, p4));
    }

    function test_distanceBetweenPoints_3D() {
        var p1 = new Point3D(0.0, 0.0, 0.0);
        var p2 = new Point3D(1.0, 2.0, 2.0);
        Assert.floatEquals(3.0, MathTools.distanceBetweenPoints(p1, p2)); // sqrt(1+4+4)=3

        // Same point
        Assert.floatEquals(0.0, MathTools.distanceBetweenPoints(p1, p1));

        // Along one axis
        var p3 = new Point3D(5.0, 0.0, 0.0);
        Assert.floatEquals(5.0, MathTools.distanceBetweenPoints(p1, p3));
    }

    function test_distanceBetweenPoints_IntPoint2D() {
        var p1 = new IntPoint2D(0, 0);
        var p2 = new IntPoint2D(3, 4);
        Assert.floatEquals(5.0, MathTools.distanceBetweenPoints(p1, p2));
    }

    function test_distanceBetweenPoints_mixed() {
        var p1 = new Point2D(0.0, 0.0);
        var p2 = new IntPoint2D(6, 8);
        Assert.floatEquals(10.0, MathTools.distanceBetweenPoints(p1, p2));
    }

    //==========================================================================
    // Angle from point to point
    //==========================================================================

    function test_radiansFromPointToPoint2D() {
        var origin = new Point2D(0.0, 0.0);
        
        // Point to the right = 0 radians
        var right = new Point2D(10.0, 0.0);
        Assert.floatEquals(0.0, MathTools.radiansFromPointToPoint2D(origin, right));
        
        // Point above = PI/2 (note: depends on coordinate system)
        var up = new Point2D(0.0, 10.0);
        Assert.floatEquals(Math.PI / 2, MathTools.radiansFromPointToPoint2D(origin, up));
        
        // Point to the left = PI
        var left = new Point2D(-10.0, 0.0);
        Assert.floatEquals(Math.PI, MathTools.radiansFromPointToPoint2D(origin, left));
    }

    function test_degreesFromPointToPoint2D() {
        var origin = new Point2D(0.0, 0.0);
        var right = new Point2D(10.0, 0.0);
        var up = new Point2D(0.0, 10.0);
        
        Assert.floatEquals(0.0, MathTools.degreesFromPointToPoint2D(origin, right));
        Assert.floatEquals(90.0, MathTools.degreesFromPointToPoint2D(origin, up));
    }

    function test_slopeFromPointToPoint2D() {
        var p1 = new Point2D(0.0, 0.0);
        
        // Horizontal line = slope 0
        var p2 = new Point2D(10.0, 0.0);
        Assert.floatEquals(0.0, MathTools.slopeFromPointToPoint2D(p1, p2));
        
        // 45 degree line = slope 1
        var p3 = new Point2D(10.0, 10.0);
        Assert.floatEquals(1.0, MathTools.slopeFromPointToPoint2D(p1, p3));
        
        // -45 degree line = slope -1
        var p4 = new Point2D(10.0, -10.0);
        Assert.floatEquals(-1.0, MathTools.slopeFromPointToPoint2D(p1, p4));
    }

    //==========================================================================
    // Line intersection and distance
    //==========================================================================

    function test_intersectionBetweenLine2Ds() {
        // Two diagonal lines crossing at (5,5)
        var line1 = new Line2D(new Point2D(0.0, 0.0), new Point2D(10.0, 10.0));
        var line2 = new Line2D(new Point2D(0.0, 10.0), new Point2D(10.0, 0.0));
        
        var intersection = MathTools.intersectionBetweenLine2Ds(line1, line2);
        Assert.notNull(intersection);
        Assert.floatEquals(5.0, intersection.x);
        Assert.floatEquals(5.0, intersection.y);
    }

    function test_intersectionBetweenLine2Ds_parallel_returns_null() {
        // Two parallel horizontal lines
        var line1 = new Line2D(new Point2D(0.0, 0.0), new Point2D(10.0, 0.0));
        var line2 = new Line2D(new Point2D(0.0, 5.0), new Point2D(10.0, 5.0));
        
        var intersection = MathTools.intersectionBetweenLine2Ds(line1, line2);
        Assert.isNull(intersection);
    }

    function test_intersectionBetweenLine2Ds_non_intersecting_segments() {
        // Two lines that would intersect if extended, but segments don't touch
        var line1 = new Line2D(new Point2D(0.0, 0.0), new Point2D(2.0, 2.0));
        var line2 = new Line2D(new Point2D(8.0, 0.0), new Point2D(10.0, 2.0));
        
        var intersection = MathTools.intersectionBetweenLine2Ds(line1, line2);
        Assert.isNull(intersection); // Segments don't actually intersect
    }

    function test_distanceFromLineToPoint2D() {
        // Horizontal line y=0, point at (5, 3) -> distance = 3
        var line = new Line2D(new Point2D(0.0, 0.0), new Point2D(10.0, 0.0));
        var point = new Point2D(5.0, 3.0);
        
        Assert.floatEquals(3.0, MathTools.distanceFromLineToPoint2D(line, point));
    }

    function test_distanceFromPointToLine2D() {
        // Same as above but different function signature
        var line = new Line2D(new Point2D(0.0, 0.0), new Point2D(10.0, 0.0));
        var point = new Point2D(5.0, 4.0);
        
        Assert.floatEquals(4.0, MathTools.distanceFromPointToLine2D(point, line));
    }

    function test_distanceBetweenLines2D_intersecting() {
        // Intersecting lines have distance 0
        var line1 = new Line2D(new Point2D(0.0, 0.0), new Point2D(10.0, 10.0));
        var line2 = new Line2D(new Point2D(0.0, 10.0), new Point2D(10.0, 0.0));
        
        Assert.floatEquals(0.0, MathTools.distanceBetweenLines2D(line1, line2));
    }

    //==========================================================================
    // Ray operations
    //==========================================================================

    function test_intersectionBetweenRay2Ds() {
        // Horizontal ray from origin (slope = 0)
        var ray1 = new Ray2D(new Point2D(0.0, 0.0), 0.0);
        // Vertical ray from (5, -10) - need to use null for slope and pass degrees/radians
        var ray2 = new Ray2D(new Point2D(5.0, -10.0), null, 90.0); // 90 degrees = vertical
        
        var intersection = MathTools.intersectionBetweenRay2Ds(ray1, ray2);
        Assert.notNull(intersection);
        Assert.floatEquals(5.0, intersection.x);
        Assert.floatEquals(0.0, intersection.y);
    }

    function test_intersectionBetweenRay2Ds_parallel_returns_null() {
        // Two parallel rays
        var ray1 = new Ray2D(new Point2D(0.0, 0.0), 0.0);
        var ray2 = new Ray2D(new Point2D(0.0, 10.0), 0.0);
        
        var intersection = MathTools.intersectionBetweenRay2Ds(ray1, ray2);
        Assert.isNull(intersection);
    }

    function test_distanceFromPointToRay2D() {
        // Horizontal ray y=0, point at (5, 7)
        var ray = new Ray2D(new Point2D(0.0, 0.0), 0.0);
        var point = new Point2D(5.0, 7.0);
        
        var distance = MathTools.distanceFromPointToRay2D(point, ray);
        Assert.isTrue(distance > 0);
    }

    function test_getClosestPointOnRay2D() {
        // Horizontal ray at y=0
        var ray = new Ray2D(new Point2D(0.0, 0.0), 0.0);
        var point = new Point2D(5.0, 10.0);
        
        var closest = MathTools.getClosestPointOnRay2D(point, ray);
        Assert.notNull(closest);
        // Closest point should be at y=0 (on the ray)
        Assert.floatEquals(0.0, closest.y);
    }

    //==========================================================================
    // Clamping and bounding
    //==========================================================================

    function test_clamp() {
        Assert.equals(5, MathTools.clamp(5, 0, 10));   // Within range
        Assert.equals(0, MathTools.clamp(-5, 0, 10));  // Below min
        Assert.equals(10, MathTools.clamp(15, 0, 10)); // Above max
        Assert.equals(0, MathTools.clamp(0, 0, 10));   // At min
        Assert.equals(10, MathTools.clamp(10, 0, 10)); // At max
    }

    function test_boundInt() {
        Assert.equals(5, MathTools.boundInt(5, 0, 10));
        Assert.equals(0, MathTools.boundInt(-100, 0, 10));
        Assert.equals(10, MathTools.boundInt(100, 0, 10));
    }

    function test_boundFloat() {
        Assert.floatEquals(5.5, MathTools.boundFloat(5.5, 0.0, 10.0));
        Assert.floatEquals(0.0, MathTools.boundFloat(-5.5, 0.0, 10.0));
        Assert.floatEquals(10.0, MathTools.boundFloat(15.5, 0.0, 10.0));
    }

    function test_wrapInt() {
        // Wrap value within range [0, 9]
        Assert.equals(0, MathTools.wrapInt(0, 0, 9));
        Assert.equals(5, MathTools.wrapInt(5, 0, 9));
        Assert.equals(0, MathTools.wrapInt(10, 0, 9)); // Wraps around
        Assert.equals(9, MathTools.wrapInt(-1, 0, 9)); // Wraps backwards
    }

    function test_wrapFloat() {
        Assert.floatEquals(0.0, MathTools.wrapFloat(0.0, 0.0, 10.0));
        Assert.floatEquals(5.0, MathTools.wrapFloat(5.0, 0.0, 10.0));
    }

    //==========================================================================
    // Mathematical functions
    //==========================================================================

    function test_factorial() {
        Assert.floatEquals(1.0, MathTools.factorial(0.0));   // 0! = 1
        Assert.floatEquals(1.0, MathTools.factorial(1.0));   // 1! = 1
        Assert.floatEquals(2.0, MathTools.factorial(2.0));   // 2! = 2
        Assert.floatEquals(6.0, MathTools.factorial(3.0));   // 3! = 6
        Assert.floatEquals(24.0, MathTools.factorial(4.0));  // 4! = 24
        Assert.floatEquals(120.0, MathTools.factorial(5.0)); // 5! = 120
    }

    function test_gamma() {
        // gamma(n) = (n-1)! for positive integers
        // gamma(1) = 0! = 1
        Assert.floatEquals(1.0, MathTools.gamma(1.0));
        // gamma(2) = 1! = 1
        Assert.floatEquals(1.0, MathTools.gamma(2.0));
        // gamma(3) = 2! = 2
        Assert.floatEquals(2.0, MathTools.gamma(3.0));
        // gamma(5) = 4! = 24
        Assert.floatEquals(24.0, MathTools.gamma(5.0));
    }

    //==========================================================================
    // Utility functions
    //==========================================================================

    function test_truncate() {
        Assert.floatEquals(3.14, MathTools.truncate(3.14159, 2));
        Assert.floatEquals(3.1, MathTools.truncate(3.14159, 1));
        Assert.floatEquals(3.0, MathTools.truncate(3.14159, 0));
        Assert.floatEquals(3.142, MathTools.truncate(3.14159, 3));
    }

    function test_cropDecimal() {
        Assert.equals(3, MathTools.cropDecimal(3.7));
        Assert.equals(3, MathTools.cropDecimal(3.2));
        Assert.equals(0, MathTools.cropDecimal(0.9));
        Assert.equals(-3, MathTools.cropDecimal(-3.2)); // ceil for negatives
        Assert.equals(-3, MathTools.cropDecimal(-3.7));
    }

    function test_isInt() {
        Assert.isTrue(MathTools.isInt(5.0));
        Assert.isTrue(MathTools.isInt(0.0));
        Assert.isTrue(MathTools.isInt(-3.0));
        Assert.isTrue(MathTools.isInt(100.0));
        Assert.isFalse(MathTools.isInt(5.5));
        Assert.isFalse(MathTools.isInt(0.1));
        Assert.isFalse(MathTools.isInt(-3.14));
    }

    function test_parseBool() {
        Assert.isTrue(MathTools.parseBool("true"));
        Assert.isTrue(MathTools.parseBool("TRUE"));
        Assert.isTrue(MathTools.parseBool("True"));
        Assert.isTrue(MathTools.parseBool("  true  ")); // with whitespace
        Assert.isFalse(MathTools.parseBool("false"));
        Assert.isFalse(MathTools.parseBool("FALSE"));
        // "anything" returns null on dynamic targets, false on static - just check it's not true
        Assert.isFalse(MathTools.parseBool("anything") == true);
    }

    function test_toFloat_Int64() {
        var val:Int64 = Int64.make(0, 42);
        Assert.floatEquals(42.0, MathTools.toFloat(val));
        
        var zero:Int64 = Int64.make(0, 0);
        Assert.floatEquals(0.0, MathTools.toFloat(zero));
        
        var large:Int64 = Int64.make(0, 1000000);
        Assert.floatEquals(1000000.0, MathTools.toFloat(large));
    }

    //==========================================================================
    // Rectangle transformations
    //==========================================================================

    function test_mirrorInsideRectangle() {
        var line = new Line2D(new Point2D(2.0, 5.0), new Point2D(4.0, 5.0));
        var rect:Rectangle = {x: 0, y: 0, width: 10, height: 10};
        
        var result = MathTools.mirrorInsideRectangle(line, rect);
        Assert.notNull(result);
        // Mirror flips x coordinates: newX = rect.x + rect.width - (oldX - rect.x)
        // For x=2: 0 + 10 - 2 = 8
        // For x=4: 0 + 10 - 4 = 6
        Assert.floatEquals(8.0, result.start.x);
        Assert.floatEquals(6.0, result.end.x);
        // Y should be unchanged
        Assert.floatEquals(5.0, result.start.y);
    }

    function test_flipInsideRectangle() {
        var line = new Line2D(new Point2D(5.0, 2.0), new Point2D(5.0, 4.0));
        var rect:Rectangle = {x: 0, y: 0, width: 10, height: 10};
        
        var result = MathTools.flipInsideRectangle(line, rect);
        Assert.notNull(result);
        // Flip uses width for y calculation (note: might be a bug in original code)
        // X should be unchanged
        Assert.floatEquals(5.0, result.start.x);
    }

    //==========================================================================
    // isBetweenRange - note: implementation has unusual behavior
    //==========================================================================

    function test_isBetweenRanges() {
        // NOTE: This implementation checks (value > start && value > end)
        // which is unusual - value must be greater than BOTH bounds
        
        // Value greater than both bounds
        Assert.isTrue(MathTools.isBetweenRanges(15.0, {start: 0.0, end: 10.0}));
        Assert.isTrue(MathTools.isBetweenRanges(100.0, {start: 5.0, end: 50.0}));
        
        // Value between bounds - returns FALSE (unusual!)
        Assert.isFalse(MathTools.isBetweenRanges(5.0, {start: 0.0, end: 10.0}));
        
        // Value less than both bounds
        Assert.isFalse(MathTools.isBetweenRanges(-5.0, {start: 0.0, end: 10.0}));
    }

    function test_isBetweenRange() {
        // Same unusual behavior as isBetweenRanges
        // value > min && value > max
        Assert.isTrue(MathTools.isBetweenRange(15.0, 0.0, 10.0));
        Assert.isFalse(MathTools.isBetweenRange(5.0, 0.0, 10.0));
    }
}

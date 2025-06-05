package tests;

import TestResult;
import TestStatus;

import vision.tools.MathTools;
import haxe.ds.Either;
import vision.ds.Point3D;
import vision.ds.Matrix2D;
import vision.ds.IntPoint2D;
import haxe.ds.Vector;
import vision.algorithms.Radix;
import haxe.Int64;
import haxe.ds.ArraySort;
import vision.ds.Rectangle;
import vision.ds.Ray2D;
import vision.ds.Line2D;
import vision.ds.Point2D;

@:access(vision.tools.MathTools)
class MathToolsTests {
    public static function vision_tools_MathTools__PI__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.PI;
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.PI",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__PI_OVER_2__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.PI_OVER_2;
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.PI_OVER_2",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__NEGATIVE_INFINITY__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.NEGATIVE_INFINITY;
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.NEGATIVE_INFINITY",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__POSITIVE_INFINITY__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.POSITIVE_INFINITY;
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.POSITIVE_INFINITY",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__NaN__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.NaN;
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.NaN",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__SQRT2__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.SQRT2;
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.SQRT2",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__SQRT3__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.SQRT3;
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.SQRT3",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__wrapInt__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0;
			var min = 0;
			var max = 0;
			
            result = vision.tools.MathTools.wrapInt(value, min, max);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.wrapInt",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__wrapFloat__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0.0;
			var min = 0.0;
			var max = 0.0;
			
            result = vision.tools.MathTools.wrapFloat(value, min, max);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.wrapFloat",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__truncate__ShouldWork():TestResult {
        var result = null;
        try {
            var num = 0.0;
			var numbersAfterDecimal = 0;
			
            result = vision.tools.MathTools.truncate(num, numbersAfterDecimal);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.truncate",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__toFloat__ShouldWork():TestResult {
        var result = null;
        try {
            var value:Int64 = null;
			
            result = vision.tools.MathTools.toFloat(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.toFloat",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__tand__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.tand(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.tand",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__tan__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.tan(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.tan",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__sqrt__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.sqrt(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.sqrt",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__slopeToRadians__ShouldWork():TestResult {
        var result = null;
        try {
            var slope = 0.0;
			
            result = vision.tools.MathTools.slopeToRadians(slope);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.slopeToRadians",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__slopeToDegrees__ShouldWork():TestResult {
        var result = null;
        try {
            var slope = 0.0;
			
            result = vision.tools.MathTools.slopeToDegrees(slope);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.slopeToDegrees",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__slopeFromPointToPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            result = vision.tools.MathTools.slopeFromPointToPoint2D(point1, point2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__sind__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.sind(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.sind",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__sin__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.sin(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.sin",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__secd__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.secd(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.secd",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__sec__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.sec(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.sec",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__round__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.round(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.round",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__random__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.random();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.random",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__radiansToSlope__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.radiansToSlope(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.radiansToSlope",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__radiansToDegrees__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.radiansToDegrees(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.radiansToDegrees",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            result = vision.tools.MathTools.radiansFromPointToPoint2D(point1, point2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToLine2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            result = vision.tools.MathTools.radiansFromPointToLine2D(point, line);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.radiansFromPointToLine2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__radiansFromLineToPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var point = new vision.ds.Point2D(0, 0);
			
            result = vision.tools.MathTools.radiansFromLineToPoint2D(line, point);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.radiansFromLineToPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__pow__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			var exp = 0.0;
			
            result = vision.tools.MathTools.pow(v, exp);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.pow",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__parseInt__ShouldWork():TestResult {
        var result = null;
        try {
            var s = "";
			
            result = vision.tools.MathTools.parseInt(s);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.parseInt",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__parseFloat__ShouldWork():TestResult {
        var result = null;
        try {
            var s = "";
			
            result = vision.tools.MathTools.parseFloat(s);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.parseFloat",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__parseBool__ShouldWork():TestResult {
        var result = null;
        try {
            var s = "";
			
            result = vision.tools.MathTools.parseBool(s);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.parseBool",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__mirrorInsideRectangle__ShouldWork():TestResult {
        var result = null;
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var rect:Rectangle = null;
			
            result = vision.tools.MathTools.mirrorInsideRectangle(line, rect);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.mirrorInsideRectangle",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__log__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.log(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.log",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__isNaN__ShouldWork():TestResult {
        var result = null;
        try {
            var f = 0.0;
			
            result = vision.tools.MathTools.isNaN(f);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.isNaN",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__isInt__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.isInt(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.isInt",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__isFinite__ShouldWork():TestResult {
        var result = null;
        try {
            var f = 0.0;
			
            result = vision.tools.MathTools.isFinite(f);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.isFinite",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__isBetweenRanges__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0.0;
			var ranges:{start:Float, end:Float} = null;
			
            result = vision.tools.MathTools.isBetweenRanges(value, ranges);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.isBetweenRanges",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__isBetweenRange__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0.0;
			var min = 0.0;
			var max = 0.0;
			
            result = vision.tools.MathTools.isBetweenRange(value, min, max);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.isBetweenRange",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__invertInsideRectangle__ShouldWork():TestResult {
        var result = null;
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var rect:Rectangle = null;
			
            result = vision.tools.MathTools.invertInsideRectangle(line, rect);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.invertInsideRectangle",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__intersectionBetweenRay2Ds__ShouldWork():TestResult {
        var result = null;
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var ray2 = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            result = vision.tools.MathTools.intersectionBetweenRay2Ds(ray, ray2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.intersectionBetweenRay2Ds",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__intersectionBetweenLine2Ds__ShouldWork():TestResult {
        var result = null;
        try {
            var line1 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var line2 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            result = vision.tools.MathTools.intersectionBetweenLine2Ds(line1, line2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.intersectionBetweenLine2Ds",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__get_SQRT3__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.get_SQRT3();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.get_SQRT3",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__get_SQRT2__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.get_SQRT2();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.get_SQRT2",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__get_POSITIVE_INFINITY__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.get_POSITIVE_INFINITY();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.get_POSITIVE_INFINITY",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__get_PI_OVER_2__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.get_PI_OVER_2();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.get_PI_OVER_2",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__get_PI__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.get_PI();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.get_PI",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__get_NaN__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.get_NaN();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.get_NaN",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__get_NEGATIVE_INFINITY__ShouldWork():TestResult {
        var result = null;
        try {
            
            result = vision.tools.MathTools.get_NEGATIVE_INFINITY();
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.get_NEGATIVE_INFINITY",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__getClosestPointOnRay2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            result = vision.tools.MathTools.getClosestPointOnRay2D(point, ray);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.getClosestPointOnRay2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__gamma__ShouldWork():TestResult {
        var result = null;
        try {
            var x = 0.0;
			
            result = vision.tools.MathTools.gamma(x);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.gamma",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__fround__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.fround(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.fround",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__floor__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.floor(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.floor",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__flipInsideRectangle__ShouldWork():TestResult {
        var result = null;
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var rect:Rectangle = null;
			
            result = vision.tools.MathTools.flipInsideRectangle(line, rect);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.flipInsideRectangle",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__findPointAtDistanceUsingY__ShouldWork():TestResult {
        var result = null;
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var startYPos = 0.0;
			var distance = 0.0;
			var goPositive = false;
			
            result = vision.tools.MathTools.findPointAtDistanceUsingY(ray, startYPos, distance, goPositive);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.findPointAtDistanceUsingY",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__findPointAtDistanceUsingX__ShouldWork():TestResult {
        var result = null;
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var startXPos = 0.0;
			var distance = 0.0;
			var goPositive = false;
			
            result = vision.tools.MathTools.findPointAtDistanceUsingX(ray, startXPos, distance, goPositive);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.findPointAtDistanceUsingX",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__ffloor__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.ffloor(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.ffloor",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__fceil__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.fceil(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.fceil",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__factorial__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0.0;
			
            result = vision.tools.MathTools.factorial(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.factorial",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__exp__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.exp(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.exp",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__distanceFromRayToPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var point = new vision.ds.Point2D(0, 0);
			
            result = vision.tools.MathTools.distanceFromRayToPoint2D(ray, point);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.distanceFromRayToPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__distanceFromPointToRay2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            result = vision.tools.MathTools.distanceFromPointToRay2D(point, ray);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.distanceFromPointToRay2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__distanceFromPointToLine2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            result = vision.tools.MathTools.distanceFromPointToLine2D(point, line);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.distanceFromPointToLine2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__distanceFromLineToPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var point = new vision.ds.Point2D(0, 0);
			
            result = vision.tools.MathTools.distanceFromLineToPoint2D(line, point);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.distanceFromLineToPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__distanceBetweenRays2D__ShouldWork():TestResult {
        var result = null;
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var ray2 = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            result = vision.tools.MathTools.distanceBetweenRays2D(ray, ray2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.distanceBetweenRays2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__distanceBetweenPoints__ShouldWork():TestResult {
        var result = null;
        try {
            var point1:Point3D = null;
			var point2:Point3D = null;
			
            result = vision.tools.MathTools.distanceBetweenPoints(point1, point2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.distanceBetweenPoints",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__distanceBetweenLines2D__ShouldWork():TestResult {
        var result = null;
        try {
            var line1 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var line2 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            result = vision.tools.MathTools.distanceBetweenLines2D(line1, line2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.distanceBetweenLines2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__degreesToSlope__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.degreesToSlope(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.degreesToSlope",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__degreesToRadians__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.degreesToRadians(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.degreesToRadians",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__degreesFromPointToPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            result = vision.tools.MathTools.degreesFromPointToPoint2D(point1, point2);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__cropDecimal__ShouldWork():TestResult {
        var result = null;
        try {
            var number = 0.0;
			
            result = vision.tools.MathTools.cropDecimal(number);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.cropDecimal",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__cotand__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.cotand(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.cotand",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__cotan__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.cotan(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.cotan",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__cosecd__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.cosecd(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.cosecd",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__cosec__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.cosec(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.cosec",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__cosd__ShouldWork():TestResult {
        var result = null;
        try {
            var degrees = 0.0;
			
            result = vision.tools.MathTools.cosd(degrees);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.cosd",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__cos__ShouldWork():TestResult {
        var result = null;
        try {
            var radians = 0.0;
			
            result = vision.tools.MathTools.cos(radians);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.cos",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__clamp__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0;
			var mi = 0;
			var ma = 0;
			
            result = vision.tools.MathTools.clamp(value, mi, ma);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.clamp",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__ceil__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.ceil(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.ceil",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__boundInt__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0;
			var min = 0;
			var max = 0;
			
            result = vision.tools.MathTools.boundInt(value, min, max);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.boundInt",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__boundFloat__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0.0;
			var min = 0.0;
			var max = 0.0;
			
            result = vision.tools.MathTools.boundFloat(value, min, max);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.boundFloat",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__atan2__ShouldWork():TestResult {
        var result = null;
        try {
            var y = 0.0;
			var x = 0.0;
			
            result = vision.tools.MathTools.atan2(y, x);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.atan2",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__atan__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.atan(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.atan",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__asin__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.asin(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.asin",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__acos__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.acos(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.acos",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__abs__ShouldWork():TestResult {
        var result = null;
        try {
            var v = 0.0;
			
            result = vision.tools.MathTools.abs(v);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.abs",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
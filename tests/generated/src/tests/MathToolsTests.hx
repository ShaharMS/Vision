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
            result = vision.tools.MathTools.wrapInt((null : Int), (null : Int), (null : Int));
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
            result = vision.tools.MathTools.wrapFloat((null : Float), (null : Float), (null : Float));
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
            result = vision.tools.MathTools.truncate((null : Float), (null : Int));
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
            result = vision.tools.MathTools.toFloat((null : Int64));
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
            result = vision.tools.MathTools.tand((null : Float));
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
            result = vision.tools.MathTools.tan((null : Float));
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
            result = vision.tools.MathTools.sqrt((null : Float));
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
            result = vision.tools.MathTools.slopeToRadians((null : Float));
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
            result = vision.tools.MathTools.slopeToDegrees((null : Float));
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
            result = vision.tools.MathTools.slopeFromPointToPoint2D((null : IntPoint2D), (null : Point2D));
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
            result = vision.tools.MathTools.sind((null : Float));
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
            result = vision.tools.MathTools.sin((null : Float));
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
            result = vision.tools.MathTools.secd((null : Float));
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
            result = vision.tools.MathTools.sec((null : Float));
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
            result = vision.tools.MathTools.round((null : Float));
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.round",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__radiansToSlope__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.radiansToSlope((null : Float));
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
            result = vision.tools.MathTools.radiansToDegrees((null : Float));
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
            result = vision.tools.MathTools.radiansFromPointToPoint2D((null : IntPoint2D), (null : Point2D));
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
            result = vision.tools.MathTools.radiansFromPointToLine2D((null : IntPoint2D), (null : Line2D));
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
            result = vision.tools.MathTools.radiansFromLineToPoint2D((null : Line2D), (null : Point2D));
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
            result = vision.tools.MathTools.pow((null : Float), (null : Float));
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
            result = vision.tools.MathTools.parseInt((null : String));
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
            result = vision.tools.MathTools.parseFloat((null : String));
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
            result = vision.tools.MathTools.parseBool((null : String));
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
            result = vision.tools.MathTools.mirrorInsideRectangle((null : Line2D), (null : Rectangle));
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
            result = vision.tools.MathTools.log((null : Float));
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
            result = vision.tools.MathTools.isNaN((null : Float));
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
            result = vision.tools.MathTools.isInt((null : Float));
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
            result = vision.tools.MathTools.isFinite((null : Float));
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
            result = vision.tools.MathTools.isBetweenRanges((null : Float), (null : {start:Float, end:Float}));
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
            result = vision.tools.MathTools.isBetweenRange((null : Float), (null : Float), (null : Float));
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
            result = vision.tools.MathTools.invertInsideRectangle((null : Line2D), (null : Rectangle));
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
            result = vision.tools.MathTools.intersectionBetweenRay2Ds((null : Ray2D), (null : Ray2D));
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
            result = vision.tools.MathTools.intersectionBetweenLine2Ds((null : Line2D), (null : Line2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.intersectionBetweenLine2Ds",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_MathTools__getClosestPointOnRay2D__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.tools.MathTools.getClosestPointOnRay2D((null : IntPoint2D), (null : Ray2D));
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
            result = vision.tools.MathTools.gamma((null : Float));
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
            result = vision.tools.MathTools.fround((null : Float));
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
            result = vision.tools.MathTools.floor((null : Float));
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
            result = vision.tools.MathTools.flipInsideRectangle((null : Line2D), (null : Rectangle));
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
            result = vision.tools.MathTools.findPointAtDistanceUsingY((null : Ray2D), (null : Float), (null : Float), (null : Bool));
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
            result = vision.tools.MathTools.findPointAtDistanceUsingX((null : Ray2D), (null : Float), (null : Float), (null : Bool));
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
            result = vision.tools.MathTools.ffloor((null : Float));
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
            result = vision.tools.MathTools.fceil((null : Float));
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
            result = vision.tools.MathTools.factorial((null : Float));
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
            result = vision.tools.MathTools.exp((null : Float));
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
            result = vision.tools.MathTools.distanceFromRayToPoint2D((null : Ray2D), (null : Point2D));
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
            result = vision.tools.MathTools.distanceFromPointToRay2D((null : IntPoint2D), (null : Ray2D));
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
            result = vision.tools.MathTools.distanceFromPointToLine2D((null : IntPoint2D), (null : Line2D));
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
            result = vision.tools.MathTools.distanceFromLineToPoint2D((null : Line2D), (null : Point2D));
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
            result = vision.tools.MathTools.distanceBetweenRays2D((null : Ray2D), (null : Ray2D));
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
            result = vision.tools.MathTools.distanceBetweenPoints((null : Point3D), (null : Point3D));
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
            result = vision.tools.MathTools.distanceBetweenLines2D((null : Line2D), (null : Line2D));
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
            result = vision.tools.MathTools.degreesToSlope((null : Float));
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
            result = vision.tools.MathTools.degreesToRadians((null : Float));
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
            result = vision.tools.MathTools.degreesFromPointToPoint2D((null : IntPoint2D), (null : Point2D));
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
            result = vision.tools.MathTools.cropDecimal((null : Float));
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
            result = vision.tools.MathTools.cotand((null : Float));
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
            result = vision.tools.MathTools.cotan((null : Float));
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
            result = vision.tools.MathTools.cosecd((null : Float));
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
            result = vision.tools.MathTools.cosec((null : Float));
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
            result = vision.tools.MathTools.cosd((null : Float));
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
            result = vision.tools.MathTools.cos((null : Float));
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
            result = vision.tools.MathTools.clamp((null : Int), (null : Int), (null : Int));
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
            result = vision.tools.MathTools.ceil((null : Float));
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
            result = vision.tools.MathTools.boundInt((null : Int), (null : Int), (null : Int));
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
            result = vision.tools.MathTools.boundFloat((null : Float), (null : Float), (null : Float));
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
            result = vision.tools.MathTools.atan2((null : Float), (null : Float));
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
            result = vision.tools.MathTools.atan((null : Float));
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
            result = vision.tools.MathTools.asin((null : Float));
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
            result = vision.tools.MathTools.acos((null : Float));
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
            result = vision.tools.MathTools.abs((null : Float));
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.MathTools.abs",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_tools_MathTools__wrapInt__ShouldWork, 
		vision_tools_MathTools__wrapFloat__ShouldWork, 
		vision_tools_MathTools__truncate__ShouldWork, 
		vision_tools_MathTools__toFloat__ShouldWork, 
		vision_tools_MathTools__tand__ShouldWork, 
		vision_tools_MathTools__tan__ShouldWork, 
		vision_tools_MathTools__sqrt__ShouldWork, 
		vision_tools_MathTools__slopeToRadians__ShouldWork, 
		vision_tools_MathTools__slopeToDegrees__ShouldWork, 
		vision_tools_MathTools__slopeFromPointToPoint2D__ShouldWork, 
		vision_tools_MathTools__sind__ShouldWork, 
		vision_tools_MathTools__sin__ShouldWork, 
		vision_tools_MathTools__secd__ShouldWork, 
		vision_tools_MathTools__sec__ShouldWork, 
		vision_tools_MathTools__round__ShouldWork, 
		vision_tools_MathTools__radiansToSlope__ShouldWork, 
		vision_tools_MathTools__radiansToDegrees__ShouldWork, 
		vision_tools_MathTools__radiansFromPointToPoint2D__ShouldWork, 
		vision_tools_MathTools__radiansFromPointToLine2D__ShouldWork, 
		vision_tools_MathTools__radiansFromLineToPoint2D__ShouldWork, 
		vision_tools_MathTools__pow__ShouldWork, 
		vision_tools_MathTools__parseInt__ShouldWork, 
		vision_tools_MathTools__parseFloat__ShouldWork, 
		vision_tools_MathTools__parseBool__ShouldWork, 
		vision_tools_MathTools__mirrorInsideRectangle__ShouldWork, 
		vision_tools_MathTools__log__ShouldWork, 
		vision_tools_MathTools__isNaN__ShouldWork, 
		vision_tools_MathTools__isInt__ShouldWork, 
		vision_tools_MathTools__isFinite__ShouldWork, 
		vision_tools_MathTools__isBetweenRanges__ShouldWork, 
		vision_tools_MathTools__isBetweenRange__ShouldWork, 
		vision_tools_MathTools__invertInsideRectangle__ShouldWork, 
		vision_tools_MathTools__intersectionBetweenRay2Ds__ShouldWork, 
		vision_tools_MathTools__intersectionBetweenLine2Ds__ShouldWork, 
		vision_tools_MathTools__getClosestPointOnRay2D__ShouldWork, 
		vision_tools_MathTools__gamma__ShouldWork, 
		vision_tools_MathTools__fround__ShouldWork, 
		vision_tools_MathTools__floor__ShouldWork, 
		vision_tools_MathTools__flipInsideRectangle__ShouldWork, 
		vision_tools_MathTools__findPointAtDistanceUsingY__ShouldWork, 
		vision_tools_MathTools__findPointAtDistanceUsingX__ShouldWork, 
		vision_tools_MathTools__ffloor__ShouldWork, 
		vision_tools_MathTools__fceil__ShouldWork, 
		vision_tools_MathTools__factorial__ShouldWork, 
		vision_tools_MathTools__exp__ShouldWork, 
		vision_tools_MathTools__distanceFromRayToPoint2D__ShouldWork, 
		vision_tools_MathTools__distanceFromPointToRay2D__ShouldWork, 
		vision_tools_MathTools__distanceFromPointToLine2D__ShouldWork, 
		vision_tools_MathTools__distanceFromLineToPoint2D__ShouldWork, 
		vision_tools_MathTools__distanceBetweenRays2D__ShouldWork, 
		vision_tools_MathTools__distanceBetweenPoints__ShouldWork, 
		vision_tools_MathTools__distanceBetweenLines2D__ShouldWork, 
		vision_tools_MathTools__degreesToSlope__ShouldWork, 
		vision_tools_MathTools__degreesToRadians__ShouldWork, 
		vision_tools_MathTools__degreesFromPointToPoint2D__ShouldWork, 
		vision_tools_MathTools__cropDecimal__ShouldWork, 
		vision_tools_MathTools__cotand__ShouldWork, 
		vision_tools_MathTools__cotan__ShouldWork, 
		vision_tools_MathTools__cosecd__ShouldWork, 
		vision_tools_MathTools__cosec__ShouldWork, 
		vision_tools_MathTools__cosd__ShouldWork, 
		vision_tools_MathTools__cos__ShouldWork, 
		vision_tools_MathTools__clamp__ShouldWork, 
		vision_tools_MathTools__ceil__ShouldWork, 
		vision_tools_MathTools__boundInt__ShouldWork, 
		vision_tools_MathTools__boundFloat__ShouldWork, 
		vision_tools_MathTools__atan2__ShouldWork, 
		vision_tools_MathTools__atan__ShouldWork, 
		vision_tools_MathTools__asin__ShouldWork, 
		vision_tools_MathTools__acos__ShouldWork, 
		vision_tools_MathTools__abs__ShouldWork, 
		vision_tools_MathTools__PI__ShouldWork, 
		vision_tools_MathTools__PI_OVER_2__ShouldWork, 
		vision_tools_MathTools__NEGATIVE_INFINITY__ShouldWork, 
		vision_tools_MathTools__POSITIVE_INFINITY__ShouldWork, 
		vision_tools_MathTools__NaN__ShouldWork, 
		vision_tools_MathTools__SQRT2__ShouldWork, 
		vision_tools_MathTools__SQRT3__ShouldWork];
}
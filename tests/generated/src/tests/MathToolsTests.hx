package tests;

import TestResult;
import TestStatus;

import vision.tools.MathTools;
import vision.ds.Point3D;
import vision.ds.IntPoint2D;
import haxe.Int64;
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

    public static function vision_tools_MathTools__distanceFromRayToPoint2D_Ray2D_Point2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__intersectionBetweenRay2Ds_Ray2D_Ray2D_Point2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__distanceBetweenRays2D_Ray2D_Ray2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__findPointAtDistanceUsingX_Ray2D_Float_Float_Bool_Point2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__findPointAtDistanceUsingY_Ray2D_Float_Float_Bool_Point2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__distanceFromLineToPoint2D_Line2D_Point2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__distanceBetweenLines2D_Line2D_Line2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__radiansFromLineToPoint2D_Line2D_Point2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__intersectionBetweenLine2Ds_Line2D_Line2D_Point2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__mirrorInsideRectangle_Line2D_Rectangle_Line2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__flipInsideRectangle_Line2D_Rectangle_Line2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__invertInsideRectangle_Line2D_Rectangle_Line2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__distanceFromPointToRay2D_Point2D_Ray2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.Point2D(0, 0);
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

    public static function vision_tools_MathTools__distanceFromPointToLine2D_Point2D_Line2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.Point2D(0, 0);
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

    public static function vision_tools_MathTools__radiansFromPointToLine2D_Point2D_Line2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.Point2D(0, 0);
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

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_Point2D_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
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

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_Point2D_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
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

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_Point2D_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
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

    public static function vision_tools_MathTools__distanceBetweenPoints_Point2D_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
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

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__distanceBetweenPoints_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__getClosestPointOnRay2D_Point2D_Ray2D_Point2D__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.Point2D(0, 0);
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

    public static function vision_tools_MathTools__distanceFromPointToRay2D_IntPoint2D_Ray2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__distanceFromPointToLine2D_IntPoint2D_Line2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__radiansFromPointToLine2D_IntPoint2D_Line2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__distanceBetweenPoints_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
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

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__distanceBetweenPoints_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
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

    public static function vision_tools_MathTools__getClosestPointOnRay2D_IntPoint2D_Ray2D_Point2D__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__distanceBetweenPoints_Point3D_Point3D_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__clamp_Int_Int_Int_Int__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__isBetweenRanges_Float_startFloatendFloat_Bool__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__isBetweenRange_Float_Float_Float_Bool__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__wrapInt_Int_Int_Int_Int__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__wrapFloat_Float_Float_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__boundInt_Int_Int_Int_Int__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__boundFloat_Float_Float_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__gamma_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__factorial_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__slopeToDegrees_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__slopeToRadians_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__degreesToSlope_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__degreesToRadians_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__radiansToDegrees_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__radiansToSlope_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__cotan_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__cosec_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__sec_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__sind_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__cosd_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__tand_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__cotand_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__cosecd_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__secd_Float_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__truncate_Float_Int_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__cropDecimal_Float_Int__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__isInt_Float_Bool__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__toFloat_Int64_Float__ShouldWork():TestResult {
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

    public static function vision_tools_MathTools__parseBool_String_Bool__ShouldWork():TestResult {
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


}
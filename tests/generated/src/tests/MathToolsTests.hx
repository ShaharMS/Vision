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
        try {
            var result = vision.tools.MathTools.PI;

            return {
                testName: "vision.tools.MathTools.PI",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.PI",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__PI_OVER_2__ShouldWork():TestResult {
        try {
            var result = vision.tools.MathTools.PI_OVER_2;

            return {
                testName: "vision.tools.MathTools.PI_OVER_2",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.PI_OVER_2",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__NEGATIVE_INFINITY__ShouldWork():TestResult {
        try {
            var result = vision.tools.MathTools.NEGATIVE_INFINITY;

            return {
                testName: "vision.tools.MathTools.NEGATIVE_INFINITY",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.NEGATIVE_INFINITY",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__POSITIVE_INFINITY__ShouldWork():TestResult {
        try {
            var result = vision.tools.MathTools.POSITIVE_INFINITY;

            return {
                testName: "vision.tools.MathTools.POSITIVE_INFINITY",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.POSITIVE_INFINITY",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__NaN__ShouldWork():TestResult {
        try {
            var result = vision.tools.MathTools.NaN;

            return {
                testName: "vision.tools.MathTools.NaN",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.NaN",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__SQRT2__ShouldWork():TestResult {
        try {
            var result = vision.tools.MathTools.SQRT2;

            return {
                testName: "vision.tools.MathTools.SQRT2",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.SQRT2",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__SQRT3__ShouldWork():TestResult {
        try {
            var result = vision.tools.MathTools.SQRT3;

            return {
                testName: "vision.tools.MathTools.SQRT3",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.SQRT3",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceFromRayToPoint2D_Ray2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var point = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.distanceFromRayToPoint2D(ray, point);

            return {
                testName: "vision.tools.MathTools.distanceFromRayToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceFromRayToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__intersectionBetweenRay2Ds_Ray2D_Ray2D_Point2D__ShouldWork():TestResult {
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var ray2 = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var result = vision.tools.MathTools.intersectionBetweenRay2Ds(ray, ray2);

            return {
                testName: "vision.tools.MathTools.intersectionBetweenRay2Ds",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.intersectionBetweenRay2Ds",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceBetweenRays2D_Ray2D_Ray2D_Float__ShouldWork():TestResult {
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var ray2 = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var result = vision.tools.MathTools.distanceBetweenRays2D(ray, ray2);

            return {
                testName: "vision.tools.MathTools.distanceBetweenRays2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceBetweenRays2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__findPointAtDistanceUsingX_Ray2D_Float_Float_Bool_Point2D__ShouldWork():TestResult {
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var startXPos = 0.0;
			var distance = 0.0;
			var goPositive = false;
			
            var result = vision.tools.MathTools.findPointAtDistanceUsingX(ray, startXPos, distance, goPositive);

            return {
                testName: "vision.tools.MathTools.findPointAtDistanceUsingX",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.findPointAtDistanceUsingX",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__findPointAtDistanceUsingY_Ray2D_Float_Float_Bool_Point2D__ShouldWork():TestResult {
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			var startYPos = 0.0;
			var distance = 0.0;
			var goPositive = false;
			
            var result = vision.tools.MathTools.findPointAtDistanceUsingY(ray, startYPos, distance, goPositive);

            return {
                testName: "vision.tools.MathTools.findPointAtDistanceUsingY",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.findPointAtDistanceUsingY",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceFromLineToPoint2D_Line2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var point = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.distanceFromLineToPoint2D(line, point);

            return {
                testName: "vision.tools.MathTools.distanceFromLineToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceFromLineToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceBetweenLines2D_Line2D_Line2D_Float__ShouldWork():TestResult {
        try {
            var line1 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var line2 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var result = vision.tools.MathTools.distanceBetweenLines2D(line1, line2);

            return {
                testName: "vision.tools.MathTools.distanceBetweenLines2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceBetweenLines2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansFromLineToPoint2D_Line2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var point = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.radiansFromLineToPoint2D(line, point);

            return {
                testName: "vision.tools.MathTools.radiansFromLineToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansFromLineToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__intersectionBetweenLine2Ds_Line2D_Line2D_Point2D__ShouldWork():TestResult {
        try {
            var line1 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var line2 = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var result = vision.tools.MathTools.intersectionBetweenLine2Ds(line1, line2);

            return {
                testName: "vision.tools.MathTools.intersectionBetweenLine2Ds",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.intersectionBetweenLine2Ds",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__mirrorInsideRectangle_Line2D_Rectangle_Line2D__ShouldWork():TestResult {
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var rect:Rectangle = null;
			
            var result = vision.tools.MathTools.mirrorInsideRectangle(line, rect);

            return {
                testName: "vision.tools.MathTools.mirrorInsideRectangle",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.mirrorInsideRectangle",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__flipInsideRectangle_Line2D_Rectangle_Line2D__ShouldWork():TestResult {
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var rect:Rectangle = null;
			
            var result = vision.tools.MathTools.flipInsideRectangle(line, rect);

            return {
                testName: "vision.tools.MathTools.flipInsideRectangle",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.flipInsideRectangle",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__invertInsideRectangle_Line2D_Rectangle_Line2D__ShouldWork():TestResult {
        try {
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			var rect:Rectangle = null;
			
            var result = vision.tools.MathTools.invertInsideRectangle(line, rect);

            return {
                testName: "vision.tools.MathTools.invertInsideRectangle",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.invertInsideRectangle",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceFromPointToRay2D_Point2D_Ray2D_Float__ShouldWork():TestResult {
        try {
            var point = new vision.ds.Point2D(0, 0);
			var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var result = vision.tools.MathTools.distanceFromPointToRay2D(point, ray);

            return {
                testName: "vision.tools.MathTools.distanceFromPointToRay2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceFromPointToRay2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceFromPointToLine2D_Point2D_Line2D_Float__ShouldWork():TestResult {
        try {
            var point = new vision.ds.Point2D(0, 0);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var result = vision.tools.MathTools.distanceFromPointToLine2D(point, line);

            return {
                testName: "vision.tools.MathTools.distanceFromPointToLine2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceFromPointToLine2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToLine2D_Point2D_Line2D_Float__ShouldWork():TestResult {
        try {
            var point = new vision.ds.Point2D(0, 0);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var result = vision.tools.MathTools.radiansFromPointToLine2D(point, line);

            return {
                testName: "vision.tools.MathTools.radiansFromPointToLine2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansFromPointToLine2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_Point2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.radiansFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_Point2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.degreesFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_Point2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.slopeFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceBetweenPoints_Point2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.distanceBetweenPoints(point1, point2);

            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.radiansFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.degreesFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.slopeFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceBetweenPoints_Point2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.distanceBetweenPoints(point1, point2);

            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__getClosestPointOnRay2D_Point2D_Ray2D_Point2D__ShouldWork():TestResult {
        try {
            var point = new vision.ds.Point2D(0, 0);
			var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var result = vision.tools.MathTools.getClosestPointOnRay2D(point, ray);

            return {
                testName: "vision.tools.MathTools.getClosestPointOnRay2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.getClosestPointOnRay2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceFromPointToRay2D_IntPoint2D_Ray2D_Float__ShouldWork():TestResult {
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var result = vision.tools.MathTools.distanceFromPointToRay2D(point, ray);

            return {
                testName: "vision.tools.MathTools.distanceFromPointToRay2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceFromPointToRay2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceFromPointToLine2D_IntPoint2D_Line2D_Float__ShouldWork():TestResult {
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var result = vision.tools.MathTools.distanceFromPointToLine2D(point, line);

            return {
                testName: "vision.tools.MathTools.distanceFromPointToLine2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceFromPointToLine2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToLine2D_IntPoint2D_Line2D_Float__ShouldWork():TestResult {
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var result = vision.tools.MathTools.radiansFromPointToLine2D(point, line);

            return {
                testName: "vision.tools.MathTools.radiansFromPointToLine2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansFromPointToLine2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.radiansFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.degreesFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.slopeFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceBetweenPoints_IntPoint2D_IntPoint2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.IntPoint2D(0, 0);
			
            var result = vision.tools.MathTools.distanceBetweenPoints(point1, point2);

            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansFromPointToPoint2D_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.radiansFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__degreesFromPointToPoint2D_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.degreesFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.degreesFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__slopeFromPointToPoint2D_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.slopeFromPointToPoint2D(point1, point2);

            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.slopeFromPointToPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceBetweenPoints_IntPoint2D_Point2D_Float__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.IntPoint2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.tools.MathTools.distanceBetweenPoints(point1, point2);

            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__getClosestPointOnRay2D_IntPoint2D_Ray2D_Point2D__ShouldWork():TestResult {
        try {
            var point = new vision.ds.IntPoint2D(0, 0);
			var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var result = vision.tools.MathTools.getClosestPointOnRay2D(point, ray);

            return {
                testName: "vision.tools.MathTools.getClosestPointOnRay2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.getClosestPointOnRay2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__distanceBetweenPoints_Point3D_Point3D_Float__ShouldWork():TestResult {
        try {
            var point1:Point3D = null;
			var point2:Point3D = null;
			
            var result = vision.tools.MathTools.distanceBetweenPoints(point1, point2);

            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.distanceBetweenPoints",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__clamp_Int_Int_Int_Int__ShouldWork():TestResult {
        try {
            var value = 0;
			var mi = 0;
			var ma = 0;
			
            var result = vision.tools.MathTools.clamp(value, mi, ma);

            return {
                testName: "vision.tools.MathTools.clamp",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.clamp",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__isBetweenRanges_Float_startFloatendFloat_Bool__ShouldWork():TestResult {
        try {
            var value = 0.0;
			var ranges:{start:Float, end:Float} = null;
			
            var result = vision.tools.MathTools.isBetweenRanges(value, ranges);

            return {
                testName: "vision.tools.MathTools.isBetweenRanges",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.isBetweenRanges",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__isBetweenRange_Float_Float_Float_Bool__ShouldWork():TestResult {
        try {
            var value = 0.0;
			var min = 0.0;
			var max = 0.0;
			
            var result = vision.tools.MathTools.isBetweenRange(value, min, max);

            return {
                testName: "vision.tools.MathTools.isBetweenRange",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.isBetweenRange",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__wrapInt_Int_Int_Int_Int__ShouldWork():TestResult {
        try {
            var value = 0;
			var min = 0;
			var max = 0;
			
            var result = vision.tools.MathTools.wrapInt(value, min, max);

            return {
                testName: "vision.tools.MathTools.wrapInt",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.wrapInt",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__wrapFloat_Float_Float_Float_Float__ShouldWork():TestResult {
        try {
            var value = 0.0;
			var min = 0.0;
			var max = 0.0;
			
            var result = vision.tools.MathTools.wrapFloat(value, min, max);

            return {
                testName: "vision.tools.MathTools.wrapFloat",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.wrapFloat",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__boundInt_Int_Int_Int_Int__ShouldWork():TestResult {
        try {
            var value = 0;
			var min = 0;
			var max = 0;
			
            var result = vision.tools.MathTools.boundInt(value, min, max);

            return {
                testName: "vision.tools.MathTools.boundInt",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.boundInt",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__boundFloat_Float_Float_Float_Float__ShouldWork():TestResult {
        try {
            var value = 0.0;
			var min = 0.0;
			var max = 0.0;
			
            var result = vision.tools.MathTools.boundFloat(value, min, max);

            return {
                testName: "vision.tools.MathTools.boundFloat",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.boundFloat",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__gamma_Float_Float__ShouldWork():TestResult {
        try {
            var x = 0.0;
			
            var result = vision.tools.MathTools.gamma(x);

            return {
                testName: "vision.tools.MathTools.gamma",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.gamma",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__factorial_Float_Float__ShouldWork():TestResult {
        try {
            var value = 0.0;
			
            var result = vision.tools.MathTools.factorial(value);

            return {
                testName: "vision.tools.MathTools.factorial",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.factorial",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__slopeToDegrees_Float_Float__ShouldWork():TestResult {
        try {
            var slope = 0.0;
			
            var result = vision.tools.MathTools.slopeToDegrees(slope);

            return {
                testName: "vision.tools.MathTools.slopeToDegrees",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.slopeToDegrees",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__slopeToRadians_Float_Float__ShouldWork():TestResult {
        try {
            var slope = 0.0;
			
            var result = vision.tools.MathTools.slopeToRadians(slope);

            return {
                testName: "vision.tools.MathTools.slopeToRadians",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.slopeToRadians",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__degreesToSlope_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.degreesToSlope(degrees);

            return {
                testName: "vision.tools.MathTools.degreesToSlope",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.degreesToSlope",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__degreesToRadians_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.degreesToRadians(degrees);

            return {
                testName: "vision.tools.MathTools.degreesToRadians",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.degreesToRadians",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansToDegrees_Float_Float__ShouldWork():TestResult {
        try {
            var radians = 0.0;
			
            var result = vision.tools.MathTools.radiansToDegrees(radians);

            return {
                testName: "vision.tools.MathTools.radiansToDegrees",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansToDegrees",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__radiansToSlope_Float_Float__ShouldWork():TestResult {
        try {
            var radians = 0.0;
			
            var result = vision.tools.MathTools.radiansToSlope(radians);

            return {
                testName: "vision.tools.MathTools.radiansToSlope",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.radiansToSlope",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__cotan_Float_Float__ShouldWork():TestResult {
        try {
            var radians = 0.0;
			
            var result = vision.tools.MathTools.cotan(radians);

            return {
                testName: "vision.tools.MathTools.cotan",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.cotan",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__cosec_Float_Float__ShouldWork():TestResult {
        try {
            var radians = 0.0;
			
            var result = vision.tools.MathTools.cosec(radians);

            return {
                testName: "vision.tools.MathTools.cosec",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.cosec",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__sec_Float_Float__ShouldWork():TestResult {
        try {
            var radians = 0.0;
			
            var result = vision.tools.MathTools.sec(radians);

            return {
                testName: "vision.tools.MathTools.sec",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.sec",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__sind_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.sind(degrees);

            return {
                testName: "vision.tools.MathTools.sind",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.sind",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__cosd_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.cosd(degrees);

            return {
                testName: "vision.tools.MathTools.cosd",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.cosd",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__tand_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.tand(degrees);

            return {
                testName: "vision.tools.MathTools.tand",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.tand",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__cotand_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.cotand(degrees);

            return {
                testName: "vision.tools.MathTools.cotand",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.cotand",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__cosecd_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.cosecd(degrees);

            return {
                testName: "vision.tools.MathTools.cosecd",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.cosecd",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__secd_Float_Float__ShouldWork():TestResult {
        try {
            var degrees = 0.0;
			
            var result = vision.tools.MathTools.secd(degrees);

            return {
                testName: "vision.tools.MathTools.secd",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.secd",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__truncate_Float_Int_Float__ShouldWork():TestResult {
        try {
            var num = 0.0;
			var numbersAfterDecimal = 0;
			
            var result = vision.tools.MathTools.truncate(num, numbersAfterDecimal);

            return {
                testName: "vision.tools.MathTools.truncate",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.truncate",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__cropDecimal_Float_Int__ShouldWork():TestResult {
        try {
            var number = 0.0;
			
            var result = vision.tools.MathTools.cropDecimal(number);

            return {
                testName: "vision.tools.MathTools.cropDecimal",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.cropDecimal",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__isInt_Float_Bool__ShouldWork():TestResult {
        try {
            var v = 0.0;
			
            var result = vision.tools.MathTools.isInt(v);

            return {
                testName: "vision.tools.MathTools.isInt",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.isInt",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__toFloat_Int64_Float__ShouldWork():TestResult {
        try {
            var value:Int64 = null;
			
            var result = vision.tools.MathTools.toFloat(value);

            return {
                testName: "vision.tools.MathTools.toFloat",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.toFloat",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_tools_MathTools__parseBool_String_Bool__ShouldWork():TestResult {
        try {
            var s = "";
			
            var result = vision.tools.MathTools.parseBool(s);

            return {
                testName: "vision.tools.MathTools.parseBool",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.tools.MathTools.parseBool",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
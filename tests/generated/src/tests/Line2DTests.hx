package tests;

import TestResult;
import TestStatus;

import vision.ds.Line2D;
import vision.tools.MathTools;

@:access(vision.ds.Line2D)
class Line2DTests {
    public static function vision_ds_Line2D__length__ShouldWork():TestResult {
        try {
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Line2D(start, end);
            var result = object.length;
        
            return {
                testName: "vision.ds.Line2D#length",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Line2D#length",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Line2D__middle__ShouldWork():TestResult {
        try {
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Line2D(start, end);
            var result = object.middle;
        
            return {
                testName: "vision.ds.Line2D#middle",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Line2D#middle",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Line2D__fromRay2D_Ray2D_Line2D__ShouldWork():TestResult {
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var result = vision.ds.Line2D.fromRay2D(ray);

            return {
                testName: "vision.ds.Line2D.fromRay2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Line2D.fromRay2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Line2D__intersect_Line2D_Point2D__ShouldWork():TestResult {
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var object = new vision.ds.Line2D(start, end);
            var result = object.intersect(line);
            
            return {
                testName: "vision.ds.Line2D#intersect",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Line2D#intersect",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Line2D__distanceTo_Line2D_Float__ShouldWork():TestResult {
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var object = new vision.ds.Line2D(start, end);
            var result = object.distanceTo(line);
            
            return {
                testName: "vision.ds.Line2D#distanceTo",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Line2D#distanceTo",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Line2D__toString__String__ShouldWork():TestResult {
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            
            var object = new vision.ds.Line2D(start, end);
            var result = object.toString();
            
            return {
                testName: "vision.ds.Line2D#toString",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Line2D#toString",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Line2D__toRay2D__Ray2D__ShouldWork():TestResult {
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            
            var object = new vision.ds.Line2D(start, end);
            var result = object.toRay2D();
            
            return {
                testName: "vision.ds.Line2D#toRay2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Line2D#toRay2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
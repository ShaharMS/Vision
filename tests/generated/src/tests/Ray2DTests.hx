package tests;

import TestResult;
import TestStatus;

import vision.ds.Ray2D;
import vision.tools.MathTools;

@:access(vision.ds.Ray2D)
class Ray2DTests {
    public static function vision_ds_Ray2D__yIntercept__ShouldWork():TestResult {
        try {
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            var result = object.yIntercept;
        
            return {
                testName: "vision.ds.Ray2D#yIntercept",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Ray2D#yIntercept",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Ray2D__xIntercept__ShouldWork():TestResult {
        try {
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            var result = object.xIntercept;
        
            return {
                testName: "vision.ds.Ray2D#xIntercept",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Ray2D#xIntercept",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Ray2D__from2Points_Point2D_Point2D_Ray2D__ShouldWork():TestResult {
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            var result = vision.ds.Ray2D.from2Points(point1, point2);

            return {
                testName: "vision.ds.Ray2D.from2Points",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Ray2D.from2Points",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Ray2D__getPointAtX_Float_Point2D__ShouldWork():TestResult {
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var x = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            var result = object.getPointAtX(x);
            
            return {
                testName: "vision.ds.Ray2D#getPointAtX",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Ray2D#getPointAtX",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Ray2D__getPointAtY_Float_Point2D__ShouldWork():TestResult {
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var y = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            var result = object.getPointAtY(y);
            
            return {
                testName: "vision.ds.Ray2D#getPointAtY",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Ray2D#getPointAtY",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Ray2D__intersect_Ray2D_Point2D__ShouldWork():TestResult {
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            var result = object.intersect(ray);
            
            return {
                testName: "vision.ds.Ray2D#intersect",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Ray2D#intersect",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Ray2D__distanceTo_Ray2D_Float__ShouldWork():TestResult {
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            var result = object.distanceTo(ray);
            
            return {
                testName: "vision.ds.Ray2D#distanceTo",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Ray2D#distanceTo",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
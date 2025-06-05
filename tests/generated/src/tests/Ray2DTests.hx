package tests;

import TestResult;
import TestStatus;

import vision.ds.Ray2D;
import vision.tools.MathTools;

@:access(vision.ds.Ray2D)
class Ray2DTests {
    public static function vision_ds_Ray2D__yIntercept__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            result = object.yIntercept;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Ray2D#yIntercept",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Ray2D__xIntercept__ShouldWork():TestResult {
        var result = null;
        try {
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            result = object.xIntercept;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Ray2D#xIntercept",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Ray2D__from2Points__ShouldWork():TestResult {
        var result = null;
        try {
            var point1 = new vision.ds.Point2D(0, 0);
			var point2 = new vision.ds.Point2D(0, 0);
			
            result = vision.ds.Ray2D.from2Points(point1, point2);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Ray2D.from2Points",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Ray2D__intersect__ShouldWork():TestResult {
        var result = null;
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            result = object.intersect(ray);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Ray2D#intersect",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Ray2D__getPointAtY__ShouldWork():TestResult {
        var result = null;
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var y = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            result = object.getPointAtY(y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Ray2D#getPointAtY",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Ray2D__getPointAtX__ShouldWork():TestResult {
        var result = null;
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var x = 0.0;
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            result = object.getPointAtX(x);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Ray2D#getPointAtX",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Ray2D__distanceTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var point = new vision.ds.Point2D(0, 0);
			var m = 0.0;
			var degrees = 0.0;
			var radians = 0.0;
			
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            var object = new vision.ds.Ray2D(point, m, degrees, radians);
            result = object.distanceTo(ray);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Ray2D#distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
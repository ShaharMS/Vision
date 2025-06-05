package tests;

import TestResult;
import TestStatus;

import vision.ds.Line2D;
import vision.tools.MathTools;

@:access(vision.ds.Line2D)
class Line2DTests {
    public static function vision_ds_Line2D__length__ShouldWork():TestResult {
        var result = null;
        try {
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Line2D(start, end);
            result = object.length;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Line2D#length",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Line2D__middle__ShouldWork():TestResult {
        var result = null;
        try {
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Line2D(start, end);
            result = object.middle;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Line2D#middle",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Line2D__fromRay2D__ShouldWork():TestResult {
        var result = null;
        try {
            var ray = new vision.ds.Ray2D({x: 0, y: 0}, 1);
			
            result = vision.ds.Line2D.fromRay2D(ray);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Line2D.fromRay2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Line2D__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            
            var object = new vision.ds.Line2D(start, end);
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Line2D#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Line2D__toRay2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            
            var object = new vision.ds.Line2D(start, end);
            result = object.toRay2D();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Line2D#toRay2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Line2D__intersect__ShouldWork():TestResult {
        var result = null;
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var object = new vision.ds.Line2D(start, end);
            result = object.intersect(line);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Line2D#intersect",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Line2D__distanceTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var start = new vision.ds.Point2D(0, 0);
			var end = new vision.ds.Point2D(0, 0);
			
            var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var object = new vision.ds.Line2D(start, end);
            result = object.distanceTo(line);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Line2D#distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
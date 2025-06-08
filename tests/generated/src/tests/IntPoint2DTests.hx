package tests;

import TestResult;
import TestStatus;

import vision.ds.IntPoint2D;
import vision.tools.MathTools;
import vision.ds.Point2D;
import haxe.Int64;

@:access(vision.ds.IntPoint2D)
class IntPoint2DTests {
    public static function vision_ds_IntPoint2D__x__ShouldWork():TestResult {
        var result = null;
        try {
            var x = 0;
			var y = 0;
			
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.x;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#x",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__y__ShouldWork():TestResult {
        var result = null;
        try {
            var x = 0;
			var y = 0;
			
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.y;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#y",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__fromPoint2D_Point2D_IntPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            var p = new vision.ds.Point2D(0, 0);
			
            result = vision.ds.IntPoint2D.fromPoint2D(p);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D.fromPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__toPoint2D__Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0;
			var y = 0;
			
            
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.toPoint2D();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#toPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__toString__String__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0;
			var y = 0;
			
            
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__copy__IntPoint2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0;
			var y = 0;
			
            
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.copy();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#copy",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__distanceTo_IntPoint2D_Float__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0;
			var y = 0;
			
            var point = new vision.ds.IntPoint2D(0, 0);
			
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.distanceTo(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__degreesTo_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0;
			var y = 0;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.degreesTo(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#degreesTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__radiansTo_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0;
			var y = 0;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.IntPoint2D(x, y);
            result = object.radiansTo(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#radiansTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
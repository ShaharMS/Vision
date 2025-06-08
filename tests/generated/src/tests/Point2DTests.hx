package tests;

import TestResult;
import TestStatus;

import vision.ds.Point2D;
import vision.tools.MathTools;

@:access(vision.ds.Point2D)
class Point2DTests {
    public static function vision_ds_Point2D__toString__String__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0.0;
			var y = 0.0;
			
            
            var object = new vision.ds.Point2D(x, y);
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point2D__copy__Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0.0;
			var y = 0.0;
			
            
            var object = new vision.ds.Point2D(x, y);
            result = object.copy();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#copy",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point2D__distanceTo_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0.0;
			var y = 0.0;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Point2D(x, y);
            result = object.distanceTo(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point2D__degreesTo_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0.0;
			var y = 0.0;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Point2D(x, y);
            result = object.degreesTo(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#degreesTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point2D__radiansTo_Point2D_Float__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0.0;
			var y = 0.0;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.Point2D(x, y);
            result = object.radiansTo(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#radiansTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
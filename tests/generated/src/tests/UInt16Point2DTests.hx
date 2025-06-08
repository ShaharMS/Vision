package tests;

import TestResult;
import TestStatus;

import vision.ds.UInt16Point2D;


@:access(vision.ds.UInt16Point2D)
class UInt16Point2DTests {
    public static function vision_ds_UInt16Point2D__x__ShouldWork():TestResult {
        var result = null;
        try {
            var X = 0;
			var Y = 0;
			
            var object = new vision.ds.UInt16Point2D(X, Y);
            result = object.x;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.UInt16Point2D#x",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_UInt16Point2D__y__ShouldWork():TestResult {
        var result = null;
        try {
            var X = 0;
			var Y = 0;
			
            var object = new vision.ds.UInt16Point2D(X, Y);
            result = object.y;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.UInt16Point2D#y",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_UInt16Point2D__toString__String__ShouldWork():TestResult {
        var result = null;
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.UInt16Point2D#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_UInt16Point2D__toPoint2D__Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            result = object.toPoint2D();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.UInt16Point2D#toPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_UInt16Point2D__toIntPoint2D__Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            result = object.toIntPoint2D();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.UInt16Point2D#toIntPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_UInt16Point2D__toInt__Int__ShouldWork():TestResult {
        var result = null;
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            result = object.toInt();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.UInt16Point2D#toInt",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
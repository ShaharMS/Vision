package tests;

import TestResult;
import TestStatus;

import vision.ds.UInt16Point2D;


@:access(vision.ds.UInt16Point2D)
class UInt16Point2DTests {
    public static function vision_ds_UInt16Point2D__x__ShouldWork():TestResult {
        try {
            var X = 0;
			var Y = 0;
			
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.x;
        
            return {
                testName: "vision.ds.UInt16Point2D#x",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#x",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__y__ShouldWork():TestResult {
        try {
            var X = 0;
			var Y = 0;
			
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.y;
        
            return {
                testName: "vision.ds.UInt16Point2D#y",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#y",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toString__String__ShouldWork():TestResult {
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toString();
            
            return {
                testName: "vision.ds.UInt16Point2D#toString",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toString",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toPoint2D__Point2D__ShouldWork():TestResult {
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toPoint2D();
            
            return {
                testName: "vision.ds.UInt16Point2D#toPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toIntPoint2D__Point2D__ShouldWork():TestResult {
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toIntPoint2D();
            
            return {
                testName: "vision.ds.UInt16Point2D#toIntPoint2D",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toIntPoint2D",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toInt__Int__ShouldWork():TestResult {
        try { 
            var X = 0;
			var Y = 0;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toInt();
            
            return {
                testName: "vision.ds.UInt16Point2D#toInt",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toInt",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
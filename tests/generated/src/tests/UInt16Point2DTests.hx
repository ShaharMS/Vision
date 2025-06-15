package tests;

import vision.ds.IntPoint2D;
import vision.ds.Point2D;
import TestResult;
import TestStatus;

import vision.ds.UInt16Point2D;


@:access(vision.ds.UInt16Point2D)
class UInt16Point2DTests {
    public static function vision_ds_UInt16Point2D__x__ShouldWork():TestResult {
        try {
            var X = 15;
			var Y = 0;
			
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.x;
        
            return {
                testName: "vision.ds.UInt16Point2D#x",
                returned: result,
                expected: 15,
                status: TestStatus.of(result == 15)
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#x",
                returned: e,
                expected: 15,
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__y__ShouldWork():TestResult {
        try {
            var X = 0;
			var Y = 87;
			
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.y;
        
            return {
                testName: "vision.ds.UInt16Point2D#y",
                returned: result,
                expected: 87,
                status: TestStatus.of(result == 87)
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#y",
                returned: e,
                expected: 87,
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toString__String__ShouldWork():TestResult {
        try { 
            var X = 12;
			var Y = -1;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toString();
            
            return {
                testName: "vision.ds.UInt16Point2D#toString",
                returned: result,
                expected: "(12, 65535)",
                status: TestStatus.of(result == "(12, 65535)")
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toString",
                returned: e,
                expected: "(12, 65535)",
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toPoint2D__Point2D__ShouldWork():TestResult {
        try { 
            var X = 5;
			var Y = 7;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toPoint2D();
            
            return {
                testName: "vision.ds.UInt16Point2D#toPoint2D",
                returned: result,
                expected: new Point2D(5, 7),
                status: TestStatus.of([result.x, result.y], [5, 7])
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toPoint2D",
                returned: e,
                expected: new Point2D(5, 7),
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toIntPoint2D__Point2D__ShouldWork():TestResult {
        try { 
            var X = 6;
			var Y = 6;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toIntPoint2D();
            
            return {
                testName: "vision.ds.UInt16Point2D#toIntPoint2D",
                returned: result,
                expected: new IntPoint2D(6, 6),
                status: TestStatus.of([result.x, result.y], [6, 6])
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toIntPoint2D",
                returned: e,
                expected: new IntPoint2D(6, 6),
                status: Failure
            }
        }
    }

    public static function vision_ds_UInt16Point2D__toInt__Int__ShouldWork():TestResult {
        try { 
            var X = 1;
			var Y = 1;
			
            
            var object = new vision.ds.UInt16Point2D(X, Y);
            var result = object.toInt();
            
            return {
                testName: "vision.ds.UInt16Point2D#toInt",
                returned: result,
                expected: 0x00010001,
                status: TestStatus.of(result == 0x00010001)
            }
        } catch (e) {
            return {
                testName: "vision.ds.UInt16Point2D#toInt",
                returned: e,
                expected: 0x00010001,
                status: Failure
            }
        }
    }


}
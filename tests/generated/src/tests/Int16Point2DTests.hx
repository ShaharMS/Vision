package tests;

import TestResult;
import TestStatus;

import vision.ds.Int16Point2D;
import vision.tools.MathTools;

class Int16Point2DTests {
    public static function vision_ds_Int16Point2D__x__ShouldWork():TestResult {
        var result = null;
        try {
            var object = new vision.ds.Int16Point2D((null : Int), (null : Int));
            result = object.x;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Int16Point2D#x",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Int16Point2D__y__ShouldWork():TestResult {
        var result = null;
        try {
            var object = new vision.ds.Int16Point2D((null : Int), (null : Int));
            result = object.y;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Int16Point2D#y",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Int16Point2D__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Int16Point2D((null : Int), (null : Int));
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Int16Point2D#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Int16Point2D__toPoint2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Int16Point2D((null : Int), (null : Int));
            result = object.toPoint2D();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Int16Point2D#toPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Int16Point2D__toIntPoint2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Int16Point2D((null : Int), (null : Int));
            result = object.toIntPoint2D();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Int16Point2D#toIntPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Int16Point2D__toInt__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Int16Point2D((null : Int), (null : Int));
            result = object.toInt();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Int16Point2D#toInt",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_ds_Int16Point2D__toString__ShouldWork, 
		vision_ds_Int16Point2D__toPoint2D__ShouldWork, 
		vision_ds_Int16Point2D__toIntPoint2D__ShouldWork, 
		vision_ds_Int16Point2D__toInt__ShouldWork, 
		vision_ds_Int16Point2D__x__ShouldWork, 
		vision_ds_Int16Point2D__y__ShouldWork];
}
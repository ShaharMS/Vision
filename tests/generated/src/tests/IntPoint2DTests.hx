package tests;

import TestResult;
import TestStatus;

import vision.ds.IntPoint2D;
import vision.tools.MathTools;
import vision.ds.Point2D;
import haxe.Int64;

class IntPoint2DTests {
    public static function vision_ds_IntPoint2D__x__ShouldWork():TestResult {
        var result = null;
        try {
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
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
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
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

    public static function vision_ds_IntPoint2D__fromPoint2D__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.ds.IntPoint2D.fromPoint2D((null : Point2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D.fromPoint2D",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
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

    public static function vision_ds_IntPoint2D__toPoint2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
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

    public static function vision_ds_IntPoint2D__radiansTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
            result = object.radiansTo((null : Point2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#radiansTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__distanceTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
            result = object.distanceTo((null : IntPoint2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__degreesTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
            result = object.degreesTo((null : Point2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.IntPoint2D#degreesTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_IntPoint2D__copy__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.IntPoint2D((null : Int), (null : Int));
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

    public static var tests = [
		vision_ds_IntPoint2D__fromPoint2D__ShouldWork, 
		vision_ds_IntPoint2D__toString__ShouldWork, 
		vision_ds_IntPoint2D__toPoint2D__ShouldWork, 
		vision_ds_IntPoint2D__radiansTo__ShouldWork, 
		vision_ds_IntPoint2D__distanceTo__ShouldWork, 
		vision_ds_IntPoint2D__degreesTo__ShouldWork, 
		vision_ds_IntPoint2D__copy__ShouldWork, 
		vision_ds_IntPoint2D__x__ShouldWork, 
		vision_ds_IntPoint2D__y__ShouldWork];
}
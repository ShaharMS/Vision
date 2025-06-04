package tests;

import TestResult;
import TestStatus;

import vision.ds.Point2D;
import vision.tools.MathTools;

class Point2DTests {
    public static function vision_ds_Point2D__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point2D((null : Float), (null : Float));
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

    public static function vision_ds_Point2D__radiansTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point2D((null : Float), (null : Float));
            result = object.radiansTo((null : Point2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#radiansTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point2D__distanceTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point2D((null : Float), (null : Float));
            result = object.distanceTo((null : Point2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point2D__degreesTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point2D((null : Float), (null : Float));
            result = object.degreesTo((null : Point2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point2D#degreesTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point2D__copy__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point2D((null : Float), (null : Float));
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

    public static var tests = [
		vision_ds_Point2D__toString__ShouldWork, 
		vision_ds_Point2D__radiansTo__ShouldWork, 
		vision_ds_Point2D__distanceTo__ShouldWork, 
		vision_ds_Point2D__degreesTo__ShouldWork, 
		vision_ds_Point2D__copy__ShouldWork];
}
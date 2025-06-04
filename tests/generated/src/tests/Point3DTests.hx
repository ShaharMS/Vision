package tests;

import TestResult;
import TestStatus;

import vision.ds.Point3D;
import vision.tools.MathTools;

class Point3DTests {
    public static function vision_ds_Point3D__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point3D((null : Float), (null : Float), (null : Float));
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point3D#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point3D__distanceTo__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point3D((null : Float), (null : Float), (null : Float));
            result = object.distanceTo((null : Point3D));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point3D#distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Point3D__copy__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Point3D((null : Float), (null : Float), (null : Float));
            result = object.copy();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Point3D#copy",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_ds_Point3D__toString__ShouldWork, 
		vision_ds_Point3D__distanceTo__ShouldWork, 
		vision_ds_Point3D__copy__ShouldWork];
}
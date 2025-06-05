package tests;

import TestResult;
import TestStatus;

import vision.ds.Point3D;
import vision.tools.MathTools;

@:access(vision.ds.Point3D)
class Point3DTests {
    public static function vision_ds_Point3D__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            var x = 0.0;
			var y = 0.0;
			var z = 0.0;
			
            
            var object = new vision.ds.Point3D(x, y, z);
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
            var x = 0.0;
			var y = 0.0;
			var z = 0.0;
			
            var point:Point3D = null;
			
            var object = new vision.ds.Point3D(x, y, z);
            result = object.distanceTo(point);
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
            var x = 0.0;
			var y = 0.0;
			var z = 0.0;
			
            
            var object = new vision.ds.Point3D(x, y, z);
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


}
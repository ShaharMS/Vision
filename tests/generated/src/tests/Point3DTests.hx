package tests;

import TestResult;
import TestStatus;

import vision.ds.Point3D;
import vision.tools.MathTools;

@:access(vision.ds.Point3D)
class Point3DTests {
    public static function vision_ds_Point3D__distanceTo_Point3D_Float__ShouldWork():TestResult {
        try { 
            var x = 0.0;
			var y = 0.0;
			var z = 0.0;
			
            var point = new Point3D(1, 1, 1);
			
            var object = new vision.ds.Point3D(x, y, z);
            var result = object.distanceTo(point);
            
            return {
                testName: "vision.ds.Point3D#distanceTo",
                returned: result,
                expected: MathTools.SQRT3,
                status: TestStatus.of(result == MathTools.SQRT3)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point3D#distanceTo",
                returned: e,
                expected: MathTools.SQRT3,
                status: Failure
            }
        }
    }

    public static function vision_ds_Point3D__copy__Point3D__ShouldWork():TestResult {
        try { 
            var x = 0.1;
			var y = 0.2;
			var z = 0.3;
			
            
            var object = new vision.ds.Point3D(x, y, z);
            var result = object.copy();
            
            return {
                testName: "vision.ds.Point3D#copy",
                returned: result,
                expected: new Point3D(0.1, 0.2, 0.3),
                status: TestStatus.of([result.x, result.y, result.z], [0.1, 0.2, 0.3])
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point3D#copy",
                returned: e,
                expected: new Point3D(0.1, 0.2, 0.3),
                status: Failure
            }
        }
    }

    public static function vision_ds_Point3D__toString__String__ShouldWork():TestResult {
        try { 
            var x = 0.1;
			var y = 0.2;
			var z = 0.3;
			
            
            var object = new vision.ds.Point3D(x, y, z);
            var result = object.toString();
            
            return {
                testName: "vision.ds.Point3D#toString",
                returned: result,
                expected: "(0.1, 0.2, 0.3)",
                status: TestStatus.of(result == "(0.1, 0.2, 0.3)")
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point3D#toString",
                returned: e,
                expected: "(0.1, 0.2, 0.3)",
                status: Failure
            }
        }
    }
}
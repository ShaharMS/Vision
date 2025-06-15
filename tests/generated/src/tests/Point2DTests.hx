package tests;

import TestResult;
import TestStatus;

import vision.ds.Point2D;
import vision.tools.MathTools;

@:access(vision.ds.Point2D)
class Point2DTests {
    public static function vision_ds_Point2D__toString__String__ShouldWork():TestResult {
        try { 
            var x = 0.1;
			var y = 0.2;
			
            
            var object = new vision.ds.Point2D(x, y);
            var result = object.toString();
            
            return {
                testName: "vision.ds.Point2D#toString",
                returned: result,
                expected: "(0.1, 0.2)",
                status: TestStatus.of(result == "(0.1, 0.2)")
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point2D#toString",
                returned: e,
                expected: "(0.1, 0.2)",
                status: Failure
            }
        }
    }

    public static function vision_ds_Point2D__copy__Point2D__ShouldWork():TestResult {
        try { 
            var x = 1.0;
			var y = 0.1;
			
            
            var object = new vision.ds.Point2D(x, y);
            var result = object.copy();
            
            return {
                testName: "vision.ds.Point2D#copy",
                returned: result,
                expected: new Point2D(1, 0.1),
                status: TestStatus.of([result.x, result.y], [1, 0.1])
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point2D#copy",
                returned: e,
                expected: new Point2D(1, 0.1),
                status: Failure
            }
        }
    }

    public static function vision_ds_Point2D__distanceTo_Point2D_Float__ShouldWork():TestResult {
        try { 
            var x = 0.0;
			var y = 0.0;
			
            var point = new vision.ds.Point2D(1, 1);
			
            var object = new vision.ds.Point2D(x, y);
            var result = object.distanceTo(point);
            
            return {
                testName: "vision.ds.Point2D#distanceTo",
                returned: result,
                expected: MathTools.SQRT2,
                status: TestStatus.of(result == MathTools.SQRT2)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point2D#distanceTo",
                returned: e,
                expected: MathTools.SQRT2,
                status: Failure
            }
        }
    }

    public static function vision_ds_Point2D__degreesTo_Point2D_Float__ShouldWork():TestResult {
        try { 
            var x = 0.0;
			var y = 0.0;
			
            var point = new vision.ds.Point2D(2, 1);
			
            var object = new vision.ds.Point2D(x, y);
            var result = object.degreesTo(point);
            
            return {
                testName: "vision.ds.Point2D#degreesTo",
                returned: result,
                expected: 30,
                status: TestStatus.of(result == 30)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point2D#degreesTo",
                returned: e,
                expected: 30,
                status: Failure
            }
        }
    }

    public static function vision_ds_Point2D__radiansTo_Point2D_Float__ShouldWork():TestResult {
        try { 
            var x = 0.0;
			var y = 0.0;
			
            var point = new vision.ds.Point2D(2, 1);
			
            var object = new vision.ds.Point2D(x, y);
            var result = object.radiansTo(point);
            
            return {
                testName: "vision.ds.Point2D#radiansTo",
                returned: result,
                expected: 30 * MathTools.PI / 180,
                status: TestStatus.of(result == 30 * MathTools.PI / 180)
            }
        } catch (e) {
            return {
                testName: "vision.ds.Point2D#radiansTo",
                returned: e,
                expected: 30 * MathTools.PI / 180,
                status: Failure
            }
        }
    }


}
package tests;

import TestResult;
import TestStatus;

import vision.ds.TransformationMatrix2D;
import vision.ds.Matrix2D;
import vision.ds.Point3D;

@:access(vision.ds.TransformationMatrix2D)
class TransformationMatrix2DTests {
    public static function vision_ds_TransformationMatrix2D__underlying__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.underlying;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#underlying",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#underlying",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__a__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.a;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#a",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#a",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__b__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.b;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#b",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#b",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__c__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.c;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#c",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#c",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__d__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.d;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#d",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#d",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__e__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.e;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#e",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#e",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__f__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.f;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#f",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#f",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__tx__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.tx;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#tx",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#tx",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__ty__ShouldWork():TestResult {
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.ty;
        
            return {
                testName: "vision.ds.TransformationMatrix2D#ty",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#ty",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__transformPoint_Point3D_Point3D__ShouldWork():TestResult {
        try { 
            var m:Matrix2D = null;
			
            var point:Point3D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.transformPoint(point);
            
            return {
                testName: "vision.ds.TransformationMatrix2D#transformPoint",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#transformPoint",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_TransformationMatrix2D__transformPoint_Point2D_Point2D__ShouldWork():TestResult {
        try { 
            var m:Matrix2D = null;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.TransformationMatrix2D(m);
            var result = object.transformPoint(point);
            
            return {
                testName: "vision.ds.TransformationMatrix2D#transformPoint",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.TransformationMatrix2D#transformPoint",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
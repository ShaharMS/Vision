package tests;

import TestResult;
import TestStatus;

import vision.ds.TransformationMatrix2D;
import vision.ds.Matrix2D;
import vision.ds.Point3D;

@:access(vision.ds.TransformationMatrix2D)
class TransformationMatrix2DTests {
    public static function vision_ds_TransformationMatrix2D__underlying__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.underlying;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#underlying",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__a__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.a;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#a",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__b__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.b;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#b",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__c__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.c;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#c",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__d__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.d;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#d",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__e__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.e;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#e",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__f__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.f;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#f",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__tx__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.tx;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#tx",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__ty__ShouldWork():TestResult {
        var result = null;
        try {
            var m:Matrix2D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.ty;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#ty",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__transformPoint_Point3D_Point3D__ShouldWork():TestResult {
        var result = null;
        try { 
            var m:Matrix2D = null;
			
            var point:Point3D = null;
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.transformPoint(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#transformPoint",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_TransformationMatrix2D__transformPoint_Point2D_Point2D__ShouldWork():TestResult {
        var result = null;
        try { 
            var m:Matrix2D = null;
			
            var point = new vision.ds.Point2D(0, 0);
			
            var object = new vision.ds.TransformationMatrix2D(m);
            result = object.transformPoint(point);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.TransformationMatrix2D#transformPoint",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
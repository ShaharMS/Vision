package tests;

import TestResult;
import TestStatus;

import vision.ds.Matrix2D;
import vision.algorithms.PerspectiveWarp;
import vision.ds.specifics.PointTransformationPair;
import vision.exceptions.MatrixOperationError;
import vision.algorithms.GaussJordan;
import vision.ds.Array2D;
import vision.tools.MathTools.*;

@:access(vision.ds.Matrix2D)
class Matrix2DTests {
    public static function vision_ds_Matrix2D__underlying__ShouldWork():TestResult {
        try {
            var width = 2;
			var height = 2;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.underlying;
        
            return {
                testName: "vision.ds.Matrix2D#underlying",
                returned: result,
                expected: new Array2D(width, height, 2),
                status: TestStatus.of(result, new Array2D(width, height, 0))
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#underlying",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__rows__ShouldWork():TestResult {
        try {
            var width = 0;
			var height = 0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.rows;
        
            return {
                testName: "vision.ds.Matrix2D#rows",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#rows",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__columns__ShouldWork():TestResult {
        try {
            var width = 0;
			var height = 0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.columns;
        
            return {
                testName: "vision.ds.Matrix2D#columns",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#columns",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__IDENTITY__TransformationMatrix2D__ShouldWork():TestResult {
        try {
            
            var result = vision.ds.Matrix2D.IDENTITY();

            return {
                testName: "vision.ds.Matrix2D.IDENTITY",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.IDENTITY",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__ROTATION_Float_Bool_Point2D_TransformationMatrix2D__ShouldWork():TestResult {
        try {
            var angle = 0.0;
			var degrees = false;
			var origin = new vision.ds.Point2D(0, 0);
			
            var result = vision.ds.Matrix2D.ROTATION(angle, degrees, origin);

            return {
                testName: "vision.ds.Matrix2D.ROTATION",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.ROTATION",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__TRANSLATION_Float_Float_TransformationMatrix2D__ShouldWork():TestResult {
        try {
            var x = 0.0;
			var y = 0.0;
			
            var result = vision.ds.Matrix2D.TRANSLATION(x, y);

            return {
                testName: "vision.ds.Matrix2D.TRANSLATION",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.TRANSLATION",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__SCALE_Float_Float_TransformationMatrix2D__ShouldWork():TestResult {
        try {
            var scaleX = 0.0;
			var scaleY = 0.0;
			
            var result = vision.ds.Matrix2D.SCALE(scaleX, scaleY);

            return {
                testName: "vision.ds.Matrix2D.SCALE",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.SCALE",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__SHEAR_Float_Float_TransformationMatrix2D__ShouldWork():TestResult {
        try {
            var shearX = 0.0;
			var shearY = 0.0;
			
            var result = vision.ds.Matrix2D.SHEAR(shearX, shearY);

            return {
                testName: "vision.ds.Matrix2D.SHEAR",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.SHEAR",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__REFLECTION_Float_Bool_Point2D_TransformationMatrix2D__ShouldWork():TestResult {
        try {
            var angle = 0.0;
			var degrees = false;
			var origin = new vision.ds.Point2D(0, 0);
			
            var result = vision.ds.Matrix2D.REFLECTION(angle, degrees, origin);

            return {
                testName: "vision.ds.Matrix2D.REFLECTION",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.REFLECTION",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__PERSPECTIVE_ArrayPointTransformationPair_TransformationMatrix2D__ShouldWork():TestResult {
        try {
            var pointPairs = [];
			
            var result = vision.ds.Matrix2D.PERSPECTIVE(pointPairs);

            return {
                testName: "vision.ds.Matrix2D.PERSPECTIVE",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.PERSPECTIVE",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__DEPTH_Float_Point2D_TransformationMatrix2D__ShouldWork():TestResult {
        try {
            var z = 0.0;
			var towards = new vision.ds.Point2D(0, 0);
			
            var result = vision.ds.Matrix2D.DEPTH(z, towards);

            return {
                testName: "vision.ds.Matrix2D.DEPTH",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.DEPTH",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__createFilled_ArrayFloat_Matrix2D__ShouldWork():TestResult {
        try {
            var rows = [];
			
            var result = vision.ds.Matrix2D.createFilled(rows);

            return {
                testName: "vision.ds.Matrix2D.createFilled",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.createFilled",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__createTransformation_ArrayFloat_ArrayFloat_ArrayFloat_Matrix2D__ShouldWork():TestResult {
        try {
            var xRow = [];
			var yRow = [];
			var homogeneousRow = [];
			
            var result = vision.ds.Matrix2D.createTransformation(xRow, yRow, homogeneousRow);

            return {
                testName: "vision.ds.Matrix2D.createTransformation",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.createTransformation",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__multiplyMatrices_Matrix2D_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try {
            var a:Matrix2D = null;
			var b:Matrix2D = null;
			
            var result = vision.ds.Matrix2D.multiplyMatrices(a, b);

            return {
                testName: "vision.ds.Matrix2D.multiplyMatrices",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.multiplyMatrices",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__addMatrices_Matrix2D_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try {
            var a:Matrix2D = null;
			var b:Matrix2D = null;
			
            var result = vision.ds.Matrix2D.addMatrices(a, b);

            return {
                testName: "vision.ds.Matrix2D.addMatrices",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.addMatrices",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__subtractMatrices_Matrix2D_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try {
            var a:Matrix2D = null;
			var b:Matrix2D = null;
			
            var result = vision.ds.Matrix2D.subtractMatrices(a, b);

            return {
                testName: "vision.ds.Matrix2D.subtractMatrices",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.subtractMatrices",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__divideMatrices_Matrix2D_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try {
            var a:Matrix2D = null;
			var b:Matrix2D = null;
			
            var result = vision.ds.Matrix2D.divideMatrices(a, b);

            return {
                testName: "vision.ds.Matrix2D.divideMatrices",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D.divideMatrices",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__invert__Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.invert();
            
            return {
                testName: "vision.ds.Matrix2D#invert",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#invert",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__getDeterminant__Float__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.getDeterminant();
            
            return {
                testName: "vision.ds.Matrix2D#getDeterminant",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#getDeterminant",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__getTrace__Float__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.getTrace();
            
            return {
                testName: "vision.ds.Matrix2D#getTrace",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#getTrace",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__getAverage__Float__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.getAverage();
            
            return {
                testName: "vision.ds.Matrix2D#getAverage",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#getAverage",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__multiplyWithScalar_Float_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var scalar = 0.0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.multiplyWithScalar(scalar);
            
            return {
                testName: "vision.ds.Matrix2D#multiplyWithScalar",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#multiplyWithScalar",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__clone__Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.clone();
            
            return {
                testName: "vision.ds.Matrix2D#clone",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#clone",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__map_FloatFloat_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var mappingFunction = (_) -> null;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.map(mappingFunction);
            
            return {
                testName: "vision.ds.Matrix2D#map",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#map",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__getSubMatrix_Int_Int_Int_Int_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var fromX = 0;
			var fromY = 0;
			var toX = 0;
			var toY = 0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.getSubMatrix(fromX, fromY, toX, toY);
            
            return {
                testName: "vision.ds.Matrix2D#getSubMatrix",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#getSubMatrix",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__getColumn_Int_ArrayFloat__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var x = 0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.getColumn(x);
            
            return {
                testName: "vision.ds.Matrix2D#getColumn",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#getColumn",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__getRow_Int_ArrayFloat__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var y = 0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.getRow(y);
            
            return {
                testName: "vision.ds.Matrix2D#getRow",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#getRow",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__setColumn__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var x = 0;
			var arr = [];
			
            var object = new vision.ds.Matrix2D(width, height);
            object.setColumn(x, arr);
            
            return {
                testName: "vision.ds.Matrix2D#setColumn",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#setColumn",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__setRow__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var y = 0;
			var arr = [];
			
            var object = new vision.ds.Matrix2D(width, height);
            object.setRow(y, arr);
            
            return {
                testName: "vision.ds.Matrix2D#setRow",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#setRow",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__insertColumn_Int_ArrayFloat_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var x = 0;
			var arr = [];
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.insertColumn(x, arr);
            
            return {
                testName: "vision.ds.Matrix2D#insertColumn",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#insertColumn",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__insertRow_Int_ArrayFloat_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var y = 0;
			var arr = [];
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.insertRow(y, arr);
            
            return {
                testName: "vision.ds.Matrix2D#insertRow",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#insertRow",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__removeColumn_Int_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var x = 0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.removeColumn(x);
            
            return {
                testName: "vision.ds.Matrix2D#removeColumn",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#removeColumn",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__removeRow_Int_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var y = 0;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.removeRow(y);
            
            return {
                testName: "vision.ds.Matrix2D#removeRow",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#removeRow",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__toString_Int_Bool_String__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var precision = 0;
			var pretty = false;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.toString(precision, pretty);
            
            return {
                testName: "vision.ds.Matrix2D#toString",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#toString",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__multiply_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var b:Matrix2D = null;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.multiply(b);
            
            return {
                testName: "vision.ds.Matrix2D#multiply",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#multiply",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__add_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var b:Matrix2D = null;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.add(b);
            
            return {
                testName: "vision.ds.Matrix2D#add",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#add",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__subtract_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var b:Matrix2D = null;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.subtract(b);
            
            return {
                testName: "vision.ds.Matrix2D#subtract",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#subtract",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Matrix2D__divide_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try { 
            var width = 0;
			var height = 0;
			
            var b:Matrix2D = null;
			
            var object = new vision.ds.Matrix2D(width, height);
            var result = object.divide(b);
            
            return {
                testName: "vision.ds.Matrix2D#divide",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Matrix2D#divide",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
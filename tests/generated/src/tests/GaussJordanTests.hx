package tests;

import TestResult;
import TestStatus;

import vision.algorithms.GaussJordan;
import vision.ds.Matrix2D;

@:access(vision.algorithms.GaussJordan)
class GaussJordanTests {
    public static function vision_algorithms_GaussJordan__swapRows__ShouldWork():TestResult {
        var result = null;
        try {
            var matrix = [];
			var row1 = 0;
			var row2 = 0;
			
            result = vision.algorithms.GaussJordan.swapRows(matrix, row1, row2);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.GaussJordan.swapRows",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_GaussJordan__invert__ShouldWork():TestResult {
        var result = null;
        try {
            var matrix:Matrix2D = null;
			
            result = vision.algorithms.GaussJordan.invert(matrix);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.GaussJordan.invert",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_GaussJordan__extractMatrix__ShouldWork():TestResult {
        var result = null;
        try {
            var matrix:Matrix2D = null;
			var rows = 0;
			var columns = [];
			
            result = vision.algorithms.GaussJordan.extractMatrix(matrix, rows, columns);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.GaussJordan.extractMatrix",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_GaussJordan__createIdentityMatrix__ShouldWork():TestResult {
        var result = null;
        try {
            var size = 0;
			
            result = vision.algorithms.GaussJordan.createIdentityMatrix(size);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.GaussJordan.createIdentityMatrix",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_GaussJordan__augmentMatrix__ShouldWork():TestResult {
        var result = null;
        try {
            var matrix = [];
			var augmentation = [];
			
            result = vision.algorithms.GaussJordan.augmentMatrix(matrix, augmentation);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.GaussJordan.augmentMatrix",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_GaussJordan__swapRows__ShouldWork, 
		vision_algorithms_GaussJordan__invert__ShouldWork, 
		vision_algorithms_GaussJordan__extractMatrix__ShouldWork, 
		vision_algorithms_GaussJordan__createIdentityMatrix__ShouldWork, 
		vision_algorithms_GaussJordan__augmentMatrix__ShouldWork];
}
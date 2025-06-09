package tests;

import TestResult;
import TestStatus;

import vision.algorithms.GaussJordan;
import vision.ds.Matrix2D;

@:access(vision.algorithms.GaussJordan)
class GaussJordanTests {
    public static function vision_algorithms_GaussJordan__invert_Matrix2D_Matrix2D__ShouldWork():TestResult {
        try {
            var matrix:Matrix2D = null;
			
            var result = vision.algorithms.GaussJordan.invert(matrix);

            return {
                testName: "vision.algorithms.GaussJordan.invert",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.GaussJordan.invert",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
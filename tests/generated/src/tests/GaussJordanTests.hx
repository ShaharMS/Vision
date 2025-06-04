package tests;

import TestResult;
import TestStatus;

import vision.algorithms.GaussJordan;
import vision.ds.Matrix2D;

class GaussJordanTests {
    public static function vision_algorithms_GaussJordan__invert__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.GaussJordan.invert((null : Matrix2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.GaussJordan.invert",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_GaussJordan__invert__ShouldWork];
}
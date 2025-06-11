package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Cramer;
import vision.exceptions.InvalidCramerSetup;
import vision.exceptions.InvalidCramerCoefficientsMatrix;
import vision.ds.Matrix2D;

@:access(vision.algorithms.Cramer)
class CramerTests {
    public static function vision_algorithms_Cramer__solveVariablesFor_Matrix2D_ArrayFloat_ArrayFloat__ShouldWork():TestResult {
        try {
            var coefficients:Matrix2D = null;
			var solutions = [];
			
            var result = vision.algorithms.Cramer.solveVariablesFor(coefficients, solutions);

            return {
                testName: "vision.algorithms.Cramer.solveVariablesFor",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Cramer.solveVariablesFor",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
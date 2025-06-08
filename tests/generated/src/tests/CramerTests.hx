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
        var result = null;
        try {
            var coefficients:Matrix2D = null;
			var solutions = [];
			
            result = vision.algorithms.Cramer.solveVariablesFor(coefficients, solutions);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Cramer.solveVariablesFor",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
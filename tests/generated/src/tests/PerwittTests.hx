package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Perwitt;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

class PerwittTests {
    public static function vision_algorithms_Perwitt__detectEdges__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Perwitt.detectEdges((null : Image), (null : Float));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Perwitt.detectEdges",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Perwitt__convolveWithPerwittOperator__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Perwitt.convolveWithPerwittOperator((null : Image));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Perwitt.convolveWithPerwittOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_Perwitt__detectEdges__ShouldWork, 
		vision_algorithms_Perwitt__convolveWithPerwittOperator__ShouldWork];
}
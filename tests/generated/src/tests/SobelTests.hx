package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Sobel;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

class SobelTests {
    public static function vision_algorithms_Sobel__detectEdges__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Sobel.detectEdges((null : Image), (null : Float));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Sobel.detectEdges",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Sobel__convolveWithSobelOperator__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Sobel.convolveWithSobelOperator((null : Image));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Sobel.convolveWithSobelOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_Sobel__detectEdges__ShouldWork, 
		vision_algorithms_Sobel__convolveWithSobelOperator__ShouldWork];
}
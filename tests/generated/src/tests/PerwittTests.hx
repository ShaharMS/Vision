package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Perwitt;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.Perwitt)
class PerwittTests {
    public static function vision_algorithms_Perwitt__detectEdges__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            result = vision.algorithms.Perwitt.detectEdges(image, threshold);
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
            var image = new vision.ds.Image(100, 100);
			
            result = vision.algorithms.Perwitt.convolveWithPerwittOperator(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Perwitt.convolveWithPerwittOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
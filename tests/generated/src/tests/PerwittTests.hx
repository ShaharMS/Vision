package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Perwitt;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.Perwitt)
class PerwittTests {
    public static function vision_algorithms_Perwitt__convolveWithPerwittOperator_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.algorithms.Perwitt.convolveWithPerwittOperator(image);

            return {
                testName: "vision.algorithms.Perwitt.convolveWithPerwittOperator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Perwitt.convolveWithPerwittOperator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Perwitt__detectEdges_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            var result = vision.algorithms.Perwitt.detectEdges(image, threshold);

            return {
                testName: "vision.algorithms.Perwitt.detectEdges",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Perwitt.detectEdges",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Sobel;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.Sobel)
class SobelTests {
    public static function vision_algorithms_Sobel__convolveWithSobelOperator_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.algorithms.Sobel.convolveWithSobelOperator(image);

            return {
                testName: "vision.algorithms.Sobel.convolveWithSobelOperator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Sobel.convolveWithSobelOperator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Sobel__detectEdges_Image_Float_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            var result = vision.algorithms.Sobel.detectEdges(image, threshold);

            return {
                testName: "vision.algorithms.Sobel.detectEdges",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Sobel.detectEdges",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
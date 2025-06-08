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
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			
            result = vision.algorithms.Sobel.convolveWithSobelOperator(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Sobel.convolveWithSobelOperator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Sobel__detectEdges_Image_Float_Image__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0.0;
			
            result = vision.algorithms.Sobel.detectEdges(image, threshold);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Sobel.detectEdges",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
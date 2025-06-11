package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Canny;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.canny.CannyObject;

@:access(vision.algorithms.Canny)
class CannyTests {
    public static function vision_algorithms_Canny__grayscale_CannyObject_CannyObject__ShouldWork():TestResult {
        try {
            var image:CannyObject = null;
			
            var result = vision.algorithms.Canny.grayscale(image);

            return {
                testName: "vision.algorithms.Canny.grayscale",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Canny.grayscale",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Canny__applyGaussian_CannyObject_Int_Float_CannyObject__ShouldWork():TestResult {
        try {
            var image:CannyObject = null;
			var size = 0;
			var sigma = 0.0;
			
            var result = vision.algorithms.Canny.applyGaussian(image, size, sigma);

            return {
                testName: "vision.algorithms.Canny.applyGaussian",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Canny.applyGaussian",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Canny__applySobelFilters_CannyObject_CannyObject__ShouldWork():TestResult {
        try {
            var image:CannyObject = null;
			
            var result = vision.algorithms.Canny.applySobelFilters(image);

            return {
                testName: "vision.algorithms.Canny.applySobelFilters",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Canny.applySobelFilters",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Canny__nonMaxSuppression_CannyObject_CannyObject__ShouldWork():TestResult {
        try {
            var image:CannyObject = null;
			
            var result = vision.algorithms.Canny.nonMaxSuppression(image);

            return {
                testName: "vision.algorithms.Canny.nonMaxSuppression",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Canny.nonMaxSuppression",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Canny__applyHysteresis_CannyObject_Float_Float_CannyObject__ShouldWork():TestResult {
        try {
            var image:CannyObject = null;
			var highThreshold = 0.0;
			var lowThreshold = 0.0;
			
            var result = vision.algorithms.Canny.applyHysteresis(image, highThreshold, lowThreshold);

            return {
                testName: "vision.algorithms.Canny.applyHysteresis",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Canny.applyHysteresis",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
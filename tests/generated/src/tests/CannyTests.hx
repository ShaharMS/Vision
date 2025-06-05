package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Canny;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.canny.CannyObject;

@:access(vision.algorithms.Canny)
class CannyTests {
    public static function vision_algorithms_Canny__nonMaxSuppression__ShouldWork():TestResult {
        var result = null;
        try {
            var image:CannyObject = null;
			
            result = vision.algorithms.Canny.nonMaxSuppression(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Canny.nonMaxSuppression",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Canny__grayscale__ShouldWork():TestResult {
        var result = null;
        try {
            var image:CannyObject = null;
			
            result = vision.algorithms.Canny.grayscale(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Canny.grayscale",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Canny__applySobelFilters__ShouldWork():TestResult {
        var result = null;
        try {
            var image:CannyObject = null;
			
            result = vision.algorithms.Canny.applySobelFilters(image);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Canny.applySobelFilters",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Canny__applyHysteresis__ShouldWork():TestResult {
        var result = null;
        try {
            var image:CannyObject = null;
			var highThreshold = 0.0;
			var lowThreshold = 0.0;
			
            result = vision.algorithms.Canny.applyHysteresis(image, highThreshold, lowThreshold);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Canny.applyHysteresis",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_Canny__applyGaussian__ShouldWork():TestResult {
        var result = null;
        try {
            var image:CannyObject = null;
			var size = 0;
			var sigma = 0.0;
			
            result = vision.algorithms.Canny.applyGaussian(image, size, sigma);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Canny.applyGaussian",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
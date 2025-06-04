package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Canny;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.canny.CannyObject;

class CannyTests {
    public static function vision_algorithms_Canny__nonMaxSuppression__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.Canny.nonMaxSuppression((null : CannyObject));
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
            result = vision.algorithms.Canny.grayscale((null : CannyObject));
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
            result = vision.algorithms.Canny.applySobelFilters((null : CannyObject));
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
            result = vision.algorithms.Canny.applyHysteresis((null : CannyObject), (null : Float), (null : Float));
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
            result = vision.algorithms.Canny.applyGaussian((null : CannyObject), (null : Int), (null : Float));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Canny.applyGaussian",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_Canny__nonMaxSuppression__ShouldWork, 
		vision_algorithms_Canny__grayscale__ShouldWork, 
		vision_algorithms_Canny__applySobelFilters__ShouldWork, 
		vision_algorithms_Canny__applyHysteresis__ShouldWork, 
		vision_algorithms_Canny__applyGaussian__ShouldWork];
}
package tests;

import TestResult;
import TestStatus;

import vision.algorithms.BilinearInterpolation;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.exceptions.OutOfBounds;
import vision.ds.Image;
import vision.tools.MathTools.*;

class BilinearInterpolationTests {
    public static function vision_algorithms_BilinearInterpolation__interpolateMissingPixels__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels((null : Image), (null : Int), (null : Int), (null : Int), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.BilinearInterpolation.interpolateMissingPixels",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_BilinearInterpolation__interpolate__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.BilinearInterpolation.interpolate((null : Image), (null : Int), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.BilinearInterpolation.interpolate",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_BilinearInterpolation__interpolateMissingPixels__ShouldWork, 
		vision_algorithms_BilinearInterpolation__interpolate__ShouldWork];
}
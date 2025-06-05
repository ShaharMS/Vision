package tests;

import TestResult;
import TestStatus;

import vision.algorithms.BilinearInterpolation;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.exceptions.OutOfBounds;
import vision.ds.Image;
import vision.tools.MathTools.*;

@:access(vision.algorithms.BilinearInterpolation)
class BilinearInterpolationTests {
    public static function vision_algorithms_BilinearInterpolation__interpolateMissingPixels__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var kernelRadiusX = 0;
			var kernelRadiusY = 0;
			var minX = 0;
			var minY = 0;
			
            result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels(image, kernelRadiusX, kernelRadiusY, minX, minY);
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
            var image = new vision.ds.Image(100, 100);
			var width = 0;
			var height = 0;
			
            result = vision.algorithms.BilinearInterpolation.interpolate(image, width, height);
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
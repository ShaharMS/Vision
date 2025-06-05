package tests;

import TestResult;
import TestStatus;

import vision.algorithms.BilateralFilter;
import haxe.ds.Vector;
import vision.ds.Color;
import vision.ds.Array2D;
import vision.ds.Image;

@:access(vision.algorithms.BilateralFilter)
class BilateralFilterTests {
    public static function vision_algorithms_BilateralFilter__filter__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var distanceSigma = 0.0;
			var intensitySigma = 0.0;
			
            result = vision.algorithms.BilateralFilter.filter(image, distanceSigma, intensitySigma);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.BilateralFilter.filter",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
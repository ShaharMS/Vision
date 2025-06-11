package tests;

import TestResult;
import TestStatus;

import vision.algorithms.SimpleHough;
import vision.ds.Color;
import vision.ds.Ray2D;
import vision.ds.Image;

@:access(vision.algorithms.SimpleHough)
class SimpleHoughTests {
    public static function vision_algorithms_SimpleHough__detectLines_Image_Int_ArrayRay2D__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var threshold = 0;
			
            var result = vision.algorithms.SimpleHough.detectLines(image, threshold);

            return {
                testName: "vision.algorithms.SimpleHough.detectLines",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.SimpleHough.detectLines",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_SimpleHough__mapLines_Image_ArrayRay2D_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var rays = [];
			
            var result = vision.algorithms.SimpleHough.mapLines(image, rays);

            return {
                testName: "vision.algorithms.SimpleHough.mapLines",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.SimpleHough.mapLines",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
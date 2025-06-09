package tests;

import TestResult;
import TestStatus;

import vision.algorithms.RobertsCross;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.RobertsCross)
class RobertsCrossTests {
    public static function vision_algorithms_RobertsCross__convolveWithRobertsCross_Image_Image__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			
            var result = vision.algorithms.RobertsCross.convolveWithRobertsCross(image);

            return {
                testName: "vision.algorithms.RobertsCross.convolveWithRobertsCross",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.RobertsCross.convolveWithRobertsCross",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
package tests;

import TestResult;
import TestStatus;

import vision.algorithms.RobertsCross;
import vision.tools.ImageTools;
import vision.ds.Image;

class RobertsCrossTests {
    public static function vision_algorithms_RobertsCross__convolveWithRobertsCross__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.RobertsCross.convolveWithRobertsCross((null : Image));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.RobertsCross.convolveWithRobertsCross",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_RobertsCross__convolveWithRobertsCross__ShouldWork];
}
package tests;

import TestResult;
import TestStatus;

import vision.algorithms.SimpleLineDetector;
import vision.tools.MathTools;
import vision.ds.Int16Point2D;
import vision.ds.Line2D;
import vision.ds.Image;
import vision.ds.IntPoint2D;

class SimpleLineDetectorTests {
    public static function vision_algorithms_SimpleLineDetector__lineCoveragePercentage__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.SimpleLineDetector.lineCoveragePercentage((null : Image), (null : Line2D));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.SimpleLineDetector.lineCoveragePercentage",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_algorithms_SimpleLineDetector__findLineFromPoint__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.SimpleLineDetector.findLineFromPoint((null : Image), (null : Int16Point2D), (null : Float), (null : Bool), (null : Bool));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.SimpleLineDetector.findLineFromPoint",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_SimpleLineDetector__lineCoveragePercentage__ShouldWork, 
		vision_algorithms_SimpleLineDetector__findLineFromPoint__ShouldWork];
}
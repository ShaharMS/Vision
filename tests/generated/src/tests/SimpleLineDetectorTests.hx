package tests;

import TestResult;
import TestStatus;

import vision.algorithms.SimpleLineDetector;
import vision.tools.MathTools;
import vision.ds.Int16Point2D;
import vision.ds.Line2D;
import vision.ds.Image;
import vision.ds.IntPoint2D;

@:access(vision.algorithms.SimpleLineDetector)
class SimpleLineDetectorTests {
    public static function vision_algorithms_SimpleLineDetector__lineCoveragePercentage__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            result = vision.algorithms.SimpleLineDetector.lineCoveragePercentage(image, line);
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
            var image = new vision.ds.Image(100, 100);
			var point = new vision.ds.Int16Point2D(0, 0);
			var minLineLength = 0.0;
			var preferTTB = false;
			var preferRTL = false;
			
            result = vision.algorithms.SimpleLineDetector.findLineFromPoint(image, point, minLineLength, preferTTB, preferRTL);
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
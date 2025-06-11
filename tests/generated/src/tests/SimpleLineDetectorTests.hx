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
    public static function vision_algorithms_SimpleLineDetector__findLineFromPoint_Image_Int16Point2D_Float_Bool_Bool_Line2D__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var point = new vision.ds.Int16Point2D(0, 0);
			var minLineLength = 0.0;
			var preferTTB = false;
			var preferRTL = false;
			
            var result = vision.algorithms.SimpleLineDetector.findLineFromPoint(image, point, minLineLength, preferTTB, preferRTL);

            return {
                testName: "vision.algorithms.SimpleLineDetector.findLineFromPoint",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.SimpleLineDetector.findLineFromPoint",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_SimpleLineDetector__lineCoveragePercentage_Image_Line2D_Float__ShouldWork():TestResult {
        try {
            var image = new vision.ds.Image(100, 100);
			var line = new vision.ds.Line2D({x: 0, y: 0}, {x: 10, y: 10});
			
            var result = vision.algorithms.SimpleLineDetector.lineCoveragePercentage(image, line);

            return {
                testName: "vision.algorithms.SimpleLineDetector.lineCoveragePercentage",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.SimpleLineDetector.lineCoveragePercentage",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_SimpleLineDetector__correctLines_ArrayLine2D_Float_Float_ArrayLine2D__ShouldWork():TestResult {
        try {
            var lines = [];
			var distanceThreshold = 0.0;
			var degError = 0.0;
			
            var result = vision.algorithms.SimpleLineDetector.correctLines(lines, distanceThreshold, degError);

            return {
                testName: "vision.algorithms.SimpleLineDetector.correctLines",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.SimpleLineDetector.correctLines",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
package tests;

import TestResult;
import TestStatus;

import vision.algorithms.PerspectiveWarp;
import vision.ds.Matrix2D;
import vision.ds.Point2D;

class PerspectiveWarpTests {
    public static function vision_algorithms_PerspectiveWarp__generateMatrix__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.PerspectiveWarp.generateMatrix((null : Array), (null : Array));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.PerspectiveWarp.generateMatrix",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_PerspectiveWarp__generateMatrix__ShouldWork];
}
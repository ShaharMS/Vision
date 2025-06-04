package tests;

import TestResult;
import TestStatus;

import vision.algorithms.SimpleHough;
import vision.ds.Color;
import vision.ds.Ray2D;
import vision.ds.Image;

class SimpleHoughTests {
    public static function vision_algorithms_SimpleHough__mapLines__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.SimpleHough.mapLines((null : Image), (null : Array));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.SimpleHough.mapLines",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_SimpleHough__mapLines__ShouldWork];
}
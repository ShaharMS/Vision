package tests;

import TestResult;
import TestStatus;

import vision.algorithms.SimpleHough;
import vision.ds.Color;
import vision.ds.Ray2D;
import vision.ds.Image;

@:access(vision.algorithms.SimpleHough)
class SimpleHoughTests {
    public static function vision_algorithms_SimpleHough__mapLines__ShouldWork():TestResult {
        var result = null;
        try {
            var image = new vision.ds.Image(100, 100);
			var rays = [];
			
            result = vision.algorithms.SimpleHough.mapLines(image, rays);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.SimpleHough.mapLines",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
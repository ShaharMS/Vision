package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Radix;
import vision.tools.ArrayTools;
import haxe.extern.EitherType;
import haxe.Int64;

@:access(vision.algorithms.Radix)
class RadixTests {
    public static function vision_algorithms_Radix__sort__ShouldWork():TestResult {
        var result = null;
        try {
            var main = [];
			
            result = vision.algorithms.Radix.sort(main);
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.Radix.sort",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
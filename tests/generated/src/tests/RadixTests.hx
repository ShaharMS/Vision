package tests;

import TestResult;
import TestStatus;

import vision.algorithms.Radix;
import vision.tools.ArrayTools;
import haxe.extern.EitherType;
import haxe.Int64;

@:access(vision.algorithms.Radix)
class RadixTests {
    public static function vision_algorithms_Radix__sort_ArrayInt_ArrayInt__ShouldWork():TestResult {
        try {
            var main = [];
			
            var result = vision.algorithms.Radix.sort(main);

            return {
                testName: "vision.algorithms.Radix.sort",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Radix.sort",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Radix__sort_ArrayUInt_ArrayUInt__ShouldWork():TestResult {
        try {
            var main = [];
			
            var result = vision.algorithms.Radix.sort(main);

            return {
                testName: "vision.algorithms.Radix.sort",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Radix.sort",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Radix__sort_ArrayInt64_ArrayInt64__ShouldWork():TestResult {
        try {
            var main = [];
			
            var result = vision.algorithms.Radix.sort(main);

            return {
                testName: "vision.algorithms.Radix.sort",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Radix.sort",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
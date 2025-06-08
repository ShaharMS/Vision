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

    public static function vision_algorithms_Radix__sort_ArrayUInt_ArrayUInt__ShouldWork():TestResult {
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

    public static function vision_algorithms_Radix__sort_ArrayInt64_ArrayInt64__ShouldWork():TestResult {
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
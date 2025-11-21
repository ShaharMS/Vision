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
            var main = [-23, 32, 0, 2341, -55, 324350135, -2349512];
			
            var result = vision.algorithms.Radix.sort(main);

            return {
                testName: "vision.algorithms.Radix.sort",
                returned: result,
                expected: [-2349512, -55, -23, 0, 32, 2341, 324350135],
                status: TestStatus.of(result, [-2349512, -55, -23, 0, 32, 2341, 324350135])
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Radix.sort",
                returned: e,
                expected: [-2349512, -55, -23, 0, 32, 2341, 324350135],
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Radix__sort_ArrayUInt_ArrayUInt__ShouldWork():TestResult {
        try {
            var main:Array<UInt> = [0, 123, 5, 432, 7, 9, 1234];
			
            var result = vision.algorithms.Radix.sort(main);

            return {
                testName: "vision.algorithms.Radix.sort",
                returned: result,
                expected: [0, 5, 7, 9, 123, 1234, 432],
                status: TestStatus.of(result, [0, 5, 7, 9, 123, 1234, 432])
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Radix.sort",
                returned: e,
                expected: [0, 5, 7, 9, 123, 1234, 432],
                status: Failure
            }
        }
    }

    public static function vision_algorithms_Radix__sort_ArrayInt64_ArrayInt64__ShouldWork():TestResult {
        try {
            var main:Array<Int64> = [0, 32403258122i64, -532874197498234i64, 235981, -352, -4, 214];
			
            var result = vision.algorithms.Radix.sort(main);

            return {
                testName: "vision.algorithms.Radix.sort",
                returned: result,
                expected: [-532874197498234i64, -352, -4, 0, 214, 235981, 32403258122i64],
                status: TestStatus.of(result, [-532874197498234i64, -352, -4, 0, 214, 235981, 32403258122i64])
            }
        } catch (e) {
            return {
                testName: "vision.algorithms.Radix.sort",
                returned: e,
                expected: [-532874197498234i64, -352, -4, 0, 214, 235981, 32403258122i64],
                status: Failure
            }
        }
    }


}
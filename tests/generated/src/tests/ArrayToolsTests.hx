package tests;

import TestResult;
import TestStatus;

import vision.tools.ArrayTools;
import haxe.Int64;
import haxe.extern.EitherType;
import haxe.ds.ArraySort;
import vision.algorithms.Radix;
import vision.tools.MathTools.*;

@:access(vision.tools.ArrayTools)
class ArrayToolsTests {
    public static function vision_tools_ArrayTools__flatten_Array_ArrayT__ShouldWork():TestResult {
        try {
            var array = [[1, 2, 3], [4, 5, 6], [7, 8, 9]];
			
            var result = vision.tools.ArrayTools.flatten(array);

            return {
                testName: "vision.tools.ArrayTools.flatten",
                returned: result,
                expected: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                status: TestStatus.of(result, [1, 2, 3, 4, 5, 6, 7, 8, 9])
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.flatten",
                returned: e,
                expected: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__raise_ArrayT_Int_ArrayArrayT__ShouldWork():TestResult {
        try {
            var array = [1, 2, 3, 4, 5, 6, 7, 8, 9];
			var delimiter = 4;
			
            var result = vision.tools.ArrayTools.raise(array, delimiter);

            return {
                testName: "vision.tools.ArrayTools.raise",
                returned: result,
                expected: [[1, 2, 3, 4], [5, 6, 7, 8], [9]],
                status: TestStatus.of(result, [[1, 2, 3, 4], [5, 6, 7, 8], [9]])
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.raise",
                returned: e,
                expected: [[1, 2, 3, 4], [5, 6, 7, 8], [9]],
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__raise_ArrayT_Bool_TBool_ArrayArrayT__ShouldWork():TestResult {
        try {
            var array = [1, 2, 3, 4, 5, 6, 7, 8, 9];
			var predicate = (number) -> number % 3 == 0;
			
            var result1 = vision.tools.ArrayTools.raise(array, false, predicate);
            var result2 = vision.tools.ArrayTools.raise(array, true, predicate);
            return {
                testName: "vision.tools.ArrayTools.raise",
                returned: '${result1}, then: ${result2}',
                expected: '[[1, 2, 3], [4, 5, 6], [7, 8, 9]], then: [[1, 2], [3, 4, 5], [6, 7, 8], [9]]',
                status: TestStatus.multiple(
                    TestStatus.of(result1, [[1, 2, 3], [4, 5, 6], [7, 8, 9]]),
                    TestStatus.of(result2, [[1, 2], [3, 4, 5], [6, 7, 8], [9]])
                )
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.raise",
                returned: e,
                expected: '[[1, 2, 3], [4, 5, 6], [7, 8, 9]], then: [[1, 2], [3, 4, 5], [6, 7, 8], [9]]',
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__min_ArrayInt64_Int64__ShouldWork():TestResult {
        try {
            var values:Array<Int64> = [Int64.make(123, 1231), Int64.make(953882, 93241), Int64.make(0, 1231), Int64.make(1, 9876812)];
			
            var result = vision.tools.ArrayTools.min(values);

            return {
                testName: "vision.tools.ArrayTools.min",
                returned: result,
                expected: Int64.make(0, 1231),
                status: TestStatus.of(result == Int64.make(0, 1231))
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.min",
                returned: e,
                expected: Int64.make(0, 1231),
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__min_ArrayT_TFloat_T__ShouldWork():TestResult {
        try {
            var values = ["hey", "whats", "up", "fellas?"];
			var valueFunction = (string) -> string.length;
			
            var result = vision.tools.ArrayTools.min(values, valueFunction);

            return {
                testName: "vision.tools.ArrayTools.min",
                returned: result,
                expected: "up",
                status: TestStatus.of(result == "up")
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.min",
                returned: e,
                expected: "up",
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__max_ArrayInt64_Int64__ShouldWork():TestResult {
        try {
            var values = [Int64.make(123, 1231), Int64.make(953882, 93241), Int64.make(0, 1231), Int64.make(1, 9876812)];
			
            var result = vision.tools.ArrayTools.max(values);

            return {
                testName: "vision.tools.ArrayTools.max",
                returned: result,
                expected: Int64.make(953882, 93241),
                status: TestStatus.of(result == Int64.make(953882, 93241))
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.max",
                returned: e,
                expected: Int64.make(953882, 93241),
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__max_ArrayT_TFloat_T__ShouldWork():TestResult {
        try {
            var values = ["hey", "whats", "up", "fellas?"];
			var valueFunction = (string) -> string.length;
			
            var result = vision.tools.ArrayTools.max(values, valueFunction);

            return {
                testName: "vision.tools.ArrayTools.max",
                returned: result,
                expected: "fellas?",
                status: TestStatus.of(result == "fellas?")
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.max",
                returned: e,
                expected: "fellas?",
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__average_ArrayInt64_Float__ShouldWork():TestResult {
        try {
            var values = [Int64.make(123, 1231), Int64.make(953882, 93241), Int64.make(0, 1231), Int64.make(1, 9876812)];
			
            var result = vision.tools.ArrayTools.average(values);

            return {
                testName: "vision.tools.ArrayTools.average",
                returned: result,
                expected: 238500,
                status: TestStatus.of(result == 238500)
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.average",
                returned: e,
                expected: 238500,
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__median_ArrayInt_Int__ShouldWork():TestResult {
        try {
            var values = [1, 1, 2, 2, 3, 3, 3, 3, 3];
			
            var result = vision.tools.ArrayTools.median(values);

            return {
                testName: "vision.tools.ArrayTools.median",
                returned: result,
                expected: 3,
                status: TestStatus.of(result == 3)
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.median",
                returned: e,
                expected: 3,
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__median_ArrayInt64_Int64__ShouldWork():TestResult {
        try {
            var values = [Int64.make(0, 1), Int64.make(0, 1), Int64.make(0, 2), Int64.make(0, 2), Int64.make(0, 3), Int64.make(0, 3), Int64.make(0, 3), Int64.make(0, 3), Int64.make(0, 3)];
			
            var result = vision.tools.ArrayTools.median(values);

            return {
                testName: "vision.tools.ArrayTools.median",
                returned: result,
                expected: Int64.make(0, 3),
                status: TestStatus.of(result == Int64.make(0, 3))
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.median",
                returned: e,
                expected: Int64.make(0, 3),
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__median_ArrayFloat_Float__ShouldWork():TestResult {
        try {
            var values = [0.1, 0.1, 0.2, 0.2, 0.3, 0.3, 0.3, 0.3, 0.3];
			
            var result = vision.tools.ArrayTools.median(values);

            return {
                testName: "vision.tools.ArrayTools.median",
                returned: result,
                expected: 0.3,
                status: TestStatus.of(result == 0.3)
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.median",
                returned: e,
                expected: 0.3,
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__distanceTo__ShouldWork():TestResult {
        try {
            var array = ["hey", "whats", "up", "fellas?"];
			var to = ["tung", "tung", "tung", "sahur"];
			var distanceFunction = (str1, str2) -> str2.length - str1.length;
			
            var result = vision.tools.ArrayTools.distanceTo(array, to, distanceFunction);

            return {
                testName: "vision.tools.ArrayTools.distanceTo",
                returned: result,
                expected: 0,
                status: TestStatus.of(result == 0)
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.distanceTo",
                returned: e,
                expected: 0,
                status: Failure
            }
        }
    }

    public static function vision_tools_ArrayTools__distinct_ArrayT_ArrayT__ShouldWork():TestResult {
        try {
            var array = [0, 0, 0, 1, 1, 1, 2, 2, 2];
			
            var result = vision.tools.ArrayTools.distinct(array);

            return {
                testName: "vision.tools.ArrayTools.distinct",
                returned: result,
                expected: [0, 1, 2],
                status: TestStatus.of(result, [0, 1, 2])
            }
        } catch (e) {
            return {
                testName: "vision.tools.ArrayTools.distinct",
                returned: e,
                expected: [0, 1, 2],
                status: Failure
            }
        }
    }


}
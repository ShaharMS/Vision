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
        var result = null;
        try {
            var array = [];
			
            result = vision.tools.ArrayTools.flatten(array);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.flatten",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__raise_ArrayT_Int_ArrayArrayT__ShouldWork():TestResult {
        var result = null;
        try {
            var array = [];
			var delimiter = 0;
			
            result = vision.tools.ArrayTools.raise(array, delimiter);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.raise",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__raise_ArrayT_Bool_TBool_ArrayArrayT__ShouldWork():TestResult {
        var result = null;
        try {
            var array = [];
			var predicateOpensArray = false;
			var predicate = (_) -> null;
			
            result = vision.tools.ArrayTools.raise(array, predicateOpensArray, predicate);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.raise",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__min_ArrayInt64_Int64__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			
            result = vision.tools.ArrayTools.min(values);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.min",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__min_ArrayT_TFloat_T__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			var valueFunction = (_) -> null;
			
            result = vision.tools.ArrayTools.min(values, valueFunction);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.min",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__max_ArrayInt64_Int64__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			
            result = vision.tools.ArrayTools.max(values);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.max",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__max_ArrayT_TFloat_T__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			var valueFunction = (_) -> null;
			
            result = vision.tools.ArrayTools.max(values, valueFunction);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.max",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__average_ArrayInt64_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			
            result = vision.tools.ArrayTools.average(values);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.average",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__median_ArrayInt_Int__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			
            result = vision.tools.ArrayTools.median(values);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.median",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__median_ArrayInt64_Int64__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			
            result = vision.tools.ArrayTools.median(values);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.median",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__median_ArrayFloat_Float__ShouldWork():TestResult {
        var result = null;
        try {
            var values = [];
			
            result = vision.tools.ArrayTools.median(values);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.median",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__distanceTo__ShouldWork():TestResult {
        var result = null;
        try {
            var array = [];
			var to = [];
			var distanceFunction = (_, _) -> null;
			
            vision.tools.ArrayTools.distanceTo(array, to, distanceFunction);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__distinct_ArrayT_ArrayT__ShouldWork():TestResult {
        var result = null;
        try {
            var array = [];
			
            result = vision.tools.ArrayTools.distinct(array);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.distinct",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
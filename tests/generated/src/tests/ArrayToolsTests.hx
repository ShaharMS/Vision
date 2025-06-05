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
    public static function vision_tools_ArrayTools__min__ShouldWork():TestResult {
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

    public static function vision_tools_ArrayTools__median__ShouldWork():TestResult {
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

    public static function vision_tools_ArrayTools__max__ShouldWork():TestResult {
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

    public static function vision_tools_ArrayTools__distanceTo__ShouldWork():TestResult {
        var result = null;
        try {
            var array = [];
			var to = [];
			var distanceFunction = (_, _) -> null;
			
            result = vision.tools.ArrayTools.distanceTo(array, to, distanceFunction);
        } catch (e) {
            
        }

        return {
            testName: "vision.tools.ArrayTools.distanceTo",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_tools_ArrayTools__average__ShouldWork():TestResult {
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


}
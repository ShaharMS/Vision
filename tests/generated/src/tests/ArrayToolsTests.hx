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

    public static var tests = [
		vision_tools_ArrayTools__median__ShouldWork];
}
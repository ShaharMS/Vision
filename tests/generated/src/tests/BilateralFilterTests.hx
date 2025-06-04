package tests;

import TestResult;
import TestStatus;

import vision.algorithms.BilateralFilter;
import haxe.ds.Vector;
import vision.ds.Color;
import vision.ds.Array2D;
import vision.ds.Image;

class BilateralFilterTests {
    public static function vision_algorithms_BilateralFilter__filter__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.algorithms.BilateralFilter.filter((null : Image), (null : Float), (null : Float));
        } catch (e) {
            
        }

        return {
            testName: "vision.algorithms.BilateralFilter.filter",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_algorithms_BilateralFilter__filter__ShouldWork];
}
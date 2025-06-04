package tests;

import TestResult;
import TestStatus;

import vision.ds.Histogram;
import haxe.ds.IntMap;

class HistogramTests {
    public static function vision_ds_Histogram__length__ShouldWork():TestResult {
        var result = null;
        try {
            var object = new vision.ds.Histogram();
            result = object.length;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Histogram#length",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Histogram__median__ShouldWork():TestResult {
        var result = null;
        try {
            var object = new vision.ds.Histogram();
            result = object.median;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Histogram#median",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Histogram__increment__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Histogram();
            result = object.increment((null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Histogram#increment",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Histogram__decrement__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Histogram();
            result = object.decrement((null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Histogram#decrement",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_ds_Histogram__increment__ShouldWork, 
		vision_ds_Histogram__decrement__ShouldWork, 
		vision_ds_Histogram__length__ShouldWork, 
		vision_ds_Histogram__median__ShouldWork];
}
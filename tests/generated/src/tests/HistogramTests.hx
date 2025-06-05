package tests;

import TestResult;
import TestStatus;

import vision.ds.Histogram;
import haxe.ds.IntMap;

@:access(vision.ds.Histogram)
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
            
            var cell = 0;
			
            var object = new vision.ds.Histogram();
            result = object.increment(cell);
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
            
            var cell = 0;
			
            var object = new vision.ds.Histogram();
            result = object.decrement(cell);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Histogram#decrement",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
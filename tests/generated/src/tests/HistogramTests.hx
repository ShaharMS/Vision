package tests;

import TestResult;
import TestStatus;

import vision.ds.Histogram;
import haxe.ds.IntMap;

@:access(vision.ds.Histogram)
class HistogramTests {
    public static function vision_ds_Histogram__length__ShouldWork():TestResult {
        try {
            
            var object = new vision.ds.Histogram();
            var result = object.length;
        
            return {
                testName: "vision.ds.Histogram#length",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Histogram#length",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Histogram__median__ShouldWork():TestResult {
        try {
            
            var object = new vision.ds.Histogram();
            var result = object.median;
        
            return {
                testName: "vision.ds.Histogram#median",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Histogram#median",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Histogram__increment_Int_Histogram__ShouldWork():TestResult {
        try { 
            
            var cell = 0;
			
            var object = new vision.ds.Histogram();
            var result = object.increment(cell);
            
            return {
                testName: "vision.ds.Histogram#increment",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Histogram#increment",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Histogram__decrement_Int_Histogram__ShouldWork():TestResult {
        try { 
            
            var cell = 0;
			
            var object = new vision.ds.Histogram();
            var result = object.decrement(cell);
            
            return {
                testName: "vision.ds.Histogram#decrement",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Histogram#decrement",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
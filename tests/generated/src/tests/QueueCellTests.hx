package tests;

import TestResult;
import TestStatus;

import vision.ds.QueueCell;


@:access(vision.ds.QueueCell)
class QueueCellTests {
    public static function vision_ds_QueueCell__getValue__T__ShouldWork():TestResult {
        try { 
            var value = 0;
			var next = new vision.ds.QueueCell<Int>(0, null, null);
			var previous = new vision.ds.QueueCell<Int>(0, null, null);
			
            
            var object = new vision.ds.QueueCell(value, next, previous);
            var result = object.getValue();
            
            return {
                testName: "vision.ds.QueueCell#getValue",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.QueueCell#getValue",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
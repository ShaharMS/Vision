package tests;

import TestResult;
import TestStatus;

import vision.ds.QueueCell;


class QueueCellTests {
    public static function vision_ds_QueueCell__getValue__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.QueueCell((null : T), (null : QueueCell), (null : QueueCell));
            result = object.getValue();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.QueueCell#getValue",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_ds_QueueCell__getValue__ShouldWork];
}
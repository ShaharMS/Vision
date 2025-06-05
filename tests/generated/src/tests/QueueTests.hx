package tests;

import TestResult;
import TestStatus;

import vision.ds.Queue;


@:access(vision.ds.Queue)
class QueueTests {
    public static function vision_ds_Queue__last__ShouldWork():TestResult {
        var result = null;
        try {
            
            var object = new vision.ds.Queue();
            result = object.last;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Queue#last",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Queue__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            
            
            var object = new vision.ds.Queue();
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Queue#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Queue__has__ShouldWork():TestResult {
        var result = null;
        try { 
            
            var value = 0;
			
            var object = new vision.ds.Queue();
            result = object.has(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Queue#has",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Queue__enqueue__ShouldWork():TestResult {
        var result = null;
        try { 
            
            var value = 0;
			
            var object = new vision.ds.Queue();
            result = object.enqueue(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Queue#enqueue",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Queue__dequeue__ShouldWork():TestResult {
        var result = null;
        try { 
            
            
            var object = new vision.ds.Queue();
            result = object.dequeue();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Queue#dequeue",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_ds_Queue__toString__ShouldWork, 
		vision_ds_Queue__has__ShouldWork, 
		vision_ds_Queue__enqueue__ShouldWork, 
		vision_ds_Queue__dequeue__ShouldWork, 
		vision_ds_Queue__last__ShouldWork];
}
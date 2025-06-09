package tests;

import TestResult;
import TestStatus;

import vision.ds.Queue;


@:access(vision.ds.Queue)
class QueueTests {
    public static function vision_ds_Queue__last__ShouldWork():TestResult {
        try {
            
            var object = new vision.ds.Queue();
            var result = object.last;
        
            return {
                testName: "vision.ds.Queue#last",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Queue#last",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Queue__iterator__IteratorT__ShouldWork():TestResult {
        try { 
            
            
            var object = new vision.ds.Queue();
            var result = object.iterator();
            
            return {
                testName: "vision.ds.Queue#iterator",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Queue#iterator",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Queue__dequeue__T__ShouldWork():TestResult {
        try { 
            
            
            var object = new vision.ds.Queue();
            var result = object.dequeue();
            
            return {
                testName: "vision.ds.Queue#dequeue",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Queue#dequeue",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Queue__enqueue_T_T__ShouldWork():TestResult {
        try { 
            
            var value = 0;
			
            var object = new vision.ds.Queue();
            var result = object.enqueue(value);
            
            return {
                testName: "vision.ds.Queue#enqueue",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Queue#enqueue",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Queue__has_T_Bool__ShouldWork():TestResult {
        try { 
            
            var value = 0;
			
            var object = new vision.ds.Queue();
            var result = object.has(value);
            
            return {
                testName: "vision.ds.Queue#has",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Queue#has",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_Queue__toString__String__ShouldWork():TestResult {
        try { 
            
            
            var object = new vision.ds.Queue();
            var result = object.toString();
            
            return {
                testName: "vision.ds.Queue#toString",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.Queue#toString",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
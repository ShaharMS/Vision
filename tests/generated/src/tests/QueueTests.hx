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

    public static function vision_ds_Queue__iterator__IteratorT__ShouldWork():TestResult {
        var result = null;
        try { 
            
            
            var object = new vision.ds.Queue();
            result = object.iterator();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Queue#iterator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Queue__dequeue__T__ShouldWork():TestResult {
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

    public static function vision_ds_Queue__enqueue_T_T__ShouldWork():TestResult {
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

    public static function vision_ds_Queue__has_T_Bool__ShouldWork():TestResult {
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

    public static function vision_ds_Queue__toString__String__ShouldWork():TestResult {
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


}
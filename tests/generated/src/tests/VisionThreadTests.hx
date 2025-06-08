package tests;

import TestResult;
import TestStatus;

import vision.helpers.VisionThread;
import vision.exceptions.MultithreadFailure;
import haxe.Exception;

@:access(vision.helpers.VisionThread)
class VisionThreadTests {
    public static function vision_helpers_VisionThread__create_VoidVoid_VisionThread__ShouldWork():TestResult {
        var result = null;
        try {
            var job = () -> return;
			
            result = vision.helpers.VisionThread.create(job);
        } catch (e) {
            
        }

        return {
            testName: "vision.helpers.VisionThread.create",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_helpers_VisionThread__start__ShouldWork():TestResult {
        var result = null;
        try { 
            var job = () -> return;
			
            
            var object = new vision.helpers.VisionThread(job);
            object.start();
        } catch (e) {
            
        }

        return {
            testName: "vision.helpers.VisionThread#start",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
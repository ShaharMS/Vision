package tests;

import TestResult;
import TestStatus;

import vision.helpers.VisionThread;
import vision.exceptions.MultithreadFailure;
import haxe.Exception;

@:access(vision.helpers.VisionThread)
class VisionThreadTests {
    public static function vision_helpers_VisionThread__create_VoidVoid_VisionThread__ShouldWork():TestResult {
        try {
            var job = () -> return;
			
            var result = vision.helpers.VisionThread.create(job);

            return {
                testName: "vision.helpers.VisionThread.create",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.helpers.VisionThread.create",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
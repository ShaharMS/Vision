package tests;

import TestResult;
import TestStatus;

import vision.ds.ImageView;
import vision.ds.ImageViewShape;

@:access(vision.ds.ImageView)
class ImageViewTests {
    public static function vision_ds_ImageView__toString__String__ShouldWork():TestResult {
        try { 
            
            
            var object = ({} : ImageView);
            var result = object.toString();
            
            return {
                testName: "vision.ds.ImageView#toString",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ImageView#toString",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
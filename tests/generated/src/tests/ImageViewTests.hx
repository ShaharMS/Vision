package tests;

import TestResult;
import TestStatus;

import vision.ds.ImageView;
import vision.ds.ImageViewShape;

@:access(vision.ds.ImageView)
class ImageViewTests {
    public static function vision_ds_ImageView__toString__String__ShouldWork():TestResult {
        var result = null;
        try { 
            
            
            var object:ImageView = {x: 0, y: 0, width: 0, height: 0, shape: RECTANGLE};
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ImageView#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
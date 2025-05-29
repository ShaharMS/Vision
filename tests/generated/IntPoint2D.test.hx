package;

import vision.exceptions.Unimplemented;
import TestResult;

class IntPoint2D {
    public function vision_ds_IntPoint2D__x__ShouldWork():TestResult {

        var object = new vision.ds.IntPoint2D();
        var result = object.x;

        throw new Unimplemented("vision_ds_IntPoint2D__x__ShouldWork Not Implemented");

        return {
            testName: "vision.ds.IntPoint2D#x",
            result: result,
            expected: null,
            success: null
        }
    }

    public function vision_ds_IntPoint2D__y__ShouldWork():TestResult {

        var object = new vision.ds.IntPoint2D();
        var result = object.y;

        throw new Unimplemented("vision_ds_IntPoint2D__y__ShouldWork Not Implemented");

        return {
            testName: "vision.ds.IntPoint2D#y",
            result: result,
            expected: null,
            success: null
        }
    }

    public function vision_ds_IntPoint2D__fromPoint2D__ShouldWork():TestResult {

        var result = vision.ds.IntPoint2D.fromPoint2D(null);

        throw new Unimplemented("vision_ds_IntPoint2D__fromPoint2D__ShouldWork Not Implemented");

        return {
            testName: "vision.ds.IntPoint2D.fromPoint2D",
            result: result,
            expected: null,
            success: null
        }
    }

    public function vision_ds_IntPoint2D__radiansTo__ShouldWork():TestResult {

        var object = new vision.ds.IntPoint2D();
        var result = object.radiansTo(X6);

        throw new Unimplemented("vision_ds_IntPoint2D__radiansTo__ShouldWork Not Implemented");

        return {
            testName: "vision.ds.IntPoint2D#radiansTo",
            result: result,
            expected: null,
            success: null
        }
    }

    public function vision_ds_IntPoint2D__distanceTo__ShouldWork():TestResult {

        var object = new vision.ds.IntPoint2D();
        var result = object.distanceTo(X6);

        throw new Unimplemented("vision_ds_IntPoint2D__distanceTo__ShouldWork Not Implemented");

        return {
            testName: "vision.ds.IntPoint2D#distanceTo",
            result: result,
            expected: null,
            success: null
        }
    }

    public function vision_ds_IntPoint2D__degreesTo__ShouldWork():TestResult {

        var object = new vision.ds.IntPoint2D();
        var result = object.degreesTo(X6);

        throw new Unimplemented("vision_ds_IntPoint2D__degreesTo__ShouldWork Not Implemented");

        return {
            testName: "vision.ds.IntPoint2D#degreesTo",
            result: result,
            expected: null,
            success: null
        }
    }

    public var tests = [
		{testFunction: vision_ds_IntPoint2D__fromPoint2D__ShouldWork, testName: "vision_ds_IntPoint2D__fromPoint2D__ShouldWork"}, 
		{testFunction: vision_ds_IntPoint2D__radiansTo__ShouldWork, testName: "vision_ds_IntPoint2D__radiansTo__ShouldWork"}, 
		{testFunction: vision_ds_IntPoint2D__distanceTo__ShouldWork, testName: "vision_ds_IntPoint2D__distanceTo__ShouldWork"}, 
		{testFunction: vision_ds_IntPoint2D__degreesTo__ShouldWork, testName: "vision_ds_IntPoint2D__degreesTo__ShouldWork"}, 
		{testFunction: vision_ds_IntPoint2D__x__ShouldWork, testName: "vision_ds_IntPoint2D__x__ShouldWork"}, 
		{testFunction: vision_ds_IntPoint2D__y__ShouldWork, testName: "vision_ds_IntPoint2D__y__ShouldWork"}];
    
    public function new() {}
}
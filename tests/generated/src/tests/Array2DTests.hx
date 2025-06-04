package tests;

import TestResult;
import TestStatus;

import vision.ds.Array2D;


class Array2DTests {
    public static function vision_ds_Array2D__length__ShouldWork():TestResult {
        var result = null;
        try {
            var object = new vision.ds.Array2D((null : Int), (null : Int), (null : T));
            result = object.length;
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#length",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__toString__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Array2D((null : Int), (null : Int), (null : T));
            result = object.toString();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#toString",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__setMultiple__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Array2D((null : Int), (null : Int), (null : T));
            result = object.setMultiple((null : Array), (null : T));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#setMultiple",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__set__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Array2D((null : Int), (null : Int), (null : T));
            result = object.set((null : Int), (null : Int), (null : T));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#set",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__iterator__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Array2D((null : Int), (null : Int), (null : T));
            result = object.iterator();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#iterator",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__get__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.Array2D((null : Int), (null : Int), (null : T));
            result = object.get((null : Int), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#get",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_ds_Array2D__toString__ShouldWork, 
		vision_ds_Array2D__setMultiple__ShouldWork, 
		vision_ds_Array2D__set__ShouldWork, 
		vision_ds_Array2D__iterator__ShouldWork, 
		vision_ds_Array2D__get__ShouldWork, 
		vision_ds_Array2D__length__ShouldWork];
}
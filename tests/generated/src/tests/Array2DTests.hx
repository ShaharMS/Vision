package tests;

import TestResult;
import TestStatus;

import vision.ds.Array2D;
import haxe.iterators.ArrayIterator;

@:access(vision.ds.Array2D)
class Array2DTests {
    public static function vision_ds_Array2D__length__ShouldWork():TestResult {
        var result = null;
        try {
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
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

    public static function vision_ds_Array2D__get_Int_Int_T__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            var x = 0;
			var y = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            result = object.get(x, y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#get",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__set__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            var x = 0;
			var y = 0;
			var val = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            object.set(x, y, val);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#set",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__setMultiple__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            var points = [];
			var val = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            object.setMultiple(points, val);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#setMultiple",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__row_Int_ArrayT__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            var y = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            result = object.row(y);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#row",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__column_Int_ArrayT__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            var x = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            result = object.column(x);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#column",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__iterator__ArrayIteratorT__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
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

    public static function vision_ds_Array2D__fill_T_Array2DT__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            var value = 0;
			
            var object = new vision.ds.Array2D(width, height, fillWith);
            result = object.fill(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#fill",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__clone__Array2DT__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
            result = object.clone();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#clone",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_Array2D__toString__String__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
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

    public static function vision_ds_Array2D__to2DArray__ArrayArrayT__ShouldWork():TestResult {
        var result = null;
        try { 
            var width = 0;
			var height = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.Array2D(width, height, fillWith);
            result = object.to2DArray();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.Array2D#to2DArray",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
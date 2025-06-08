package tests;

import TestResult;
import TestStatus;

import vision.ds.ByteArray;
import haxe.Int64;
import vision.tools.MathTools;
import haxe.Serializer;
import haxe.io.Bytes;

@:access(vision.ds.ByteArray)
class ByteArrayTests {
    public static function vision_ds_ByteArray__from_Int_ByteArray__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0;
			
            result = vision.ds.ByteArray.from(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray.from",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__from_Int64_ByteArray__ShouldWork():TestResult {
        var result = null;
        try {
            var value:Int64 = null;
			
            result = vision.ds.ByteArray.from(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray.from",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__from_Float_ByteArray__ShouldWork():TestResult {
        var result = null;
        try {
            var value = 0.0;
			
            result = vision.ds.ByteArray.from(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray.from",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__from_Bool_ByteArray__ShouldWork():TestResult {
        var result = null;
        try {
            var value = false;
			
            result = vision.ds.ByteArray.from(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray.from",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__from_String_haxeioEncoding_ByteArray__ShouldWork():TestResult {
        var result = null;
        try {
            var value = "";
			var encoding:haxe.io.Encoding = null;
			
            result = vision.ds.ByteArray.from(value, encoding);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray.from",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__from_Dynamic_ByteArray__ShouldWork():TestResult {
        var result = null;
        try {
            var value:Dynamic = null;
			
            result = vision.ds.ByteArray.from(value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray.from",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__setUInt8__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var v = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setUInt8(pos, v);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setUInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__getUInt8_Int_Int__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            result = object.getUInt8(pos);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getUInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__setUInt32__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var value:UInt = null;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setUInt32(pos, value);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setUInt32",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__getUInt32_Int_UInt__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            result = object.getUInt32(pos);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getUInt32",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__setInt8__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var v = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setInt8(pos, v);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__getInt8_Int_Int__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            result = object.getInt8(pos);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__setBytes__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var array = vision.ds.ByteArray.from(0);
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setBytes(pos, array);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setBytes",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__getBytes_Int_Int_ByteArray__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var length = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            result = object.getBytes(pos, length);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getBytes",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__resize__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var length = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.resize(length);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#resize",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__concat_ByteArray_ByteArray__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            var array = vision.ds.ByteArray.from(0);
			
            var object = new vision.ds.ByteArray(length, fillWith);
            result = object.concat(array);
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#concat",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__isEmpty__Bool__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.ByteArray(length, fillWith);
            result = object.isEmpty();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#isEmpty",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__toArray__ArrayInt__ShouldWork():TestResult {
        var result = null;
        try { 
            var length = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.ByteArray(length, fillWith);
            result = object.toArray();
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#toArray",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }


}
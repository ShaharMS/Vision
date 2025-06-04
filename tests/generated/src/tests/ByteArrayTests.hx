package tests;

import TestResult;
import TestStatus;

import vision.ds.ByteArray;
import haxe.Int64;
import vision.tools.MathTools;
import haxe.Serializer;
import haxe.io.BytesData;
import haxe.io.Bytes;

class ByteArrayTests {
    public static function vision_ds_ByteArray__from__ShouldWork():TestResult {
        var result = null;
        try {
            result = vision.ds.ByteArray.from((null : Dynamic));
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
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.setUInt8((null : Int), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setUInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__setUInt32__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.setUInt32((null : Int), (null : UInt));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setUInt32",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__setInt8__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.setInt8((null : Int), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__setBytes__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.setBytes((null : Int), (null : ByteArray));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#setBytes",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__resize__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.resize((null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#resize",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__isEmpty__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
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

    public static function vision_ds_ByteArray__getUInt8__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.getUInt8((null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getUInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__getUInt32__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.getUInt32((null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getUInt32",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__getInt8__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.getInt8((null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getInt8",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__getBytes__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.getBytes((null : Int), (null : Int));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#getBytes",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static function vision_ds_ByteArray__concat__ShouldWork():TestResult {
        var result = null;
        try { 
            var object = new vision.ds.ByteArray((null : Int), (null : Int));
            result = object.concat((null : ByteArray));
        } catch (e) {
            
        }

        return {
            testName: "vision.ds.ByteArray#concat",
            returned: result,
            expected: null,
            status: Unimplemented
        }
    }

    public static var tests = [
		vision_ds_ByteArray__from__ShouldWork, 
		vision_ds_ByteArray__setUInt8__ShouldWork, 
		vision_ds_ByteArray__setUInt32__ShouldWork, 
		vision_ds_ByteArray__setInt8__ShouldWork, 
		vision_ds_ByteArray__setBytes__ShouldWork, 
		vision_ds_ByteArray__resize__ShouldWork, 
		vision_ds_ByteArray__isEmpty__ShouldWork, 
		vision_ds_ByteArray__getUInt8__ShouldWork, 
		vision_ds_ByteArray__getUInt32__ShouldWork, 
		vision_ds_ByteArray__getInt8__ShouldWork, 
		vision_ds_ByteArray__getBytes__ShouldWork, 
		vision_ds_ByteArray__concat__ShouldWork];
}
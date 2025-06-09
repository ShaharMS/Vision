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
        try {
            var value = 0;
			
            var result = vision.ds.ByteArray.from(value);

            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_Int64_ByteArray__ShouldWork():TestResult {
        try {
            var value:Int64 = null;
			
            var result = vision.ds.ByteArray.from(value);

            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_Float_ByteArray__ShouldWork():TestResult {
        try {
            var value = 0.0;
			
            var result = vision.ds.ByteArray.from(value);

            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_Bool_ByteArray__ShouldWork():TestResult {
        try {
            var value = false;
			
            var result = vision.ds.ByteArray.from(value);

            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_String_haxeioEncoding_ByteArray__ShouldWork():TestResult {
        try {
            var value = "";
			var encoding:haxe.io.Encoding = null;
			
            var result = vision.ds.ByteArray.from(value, encoding);

            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_Dynamic_ByteArray__ShouldWork():TestResult {
        try {
            var value:Dynamic = null;
			
            var result = vision.ds.ByteArray.from(value);

            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setUInt8__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var v = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setUInt8(pos, v);
            
            return {
                testName: "vision.ds.ByteArray#setUInt8",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setUInt8",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getUInt8_Int_Int__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.getUInt8(pos);
            
            return {
                testName: "vision.ds.ByteArray#getUInt8",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getUInt8",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setUInt32__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var value:UInt = null;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setUInt32(pos, value);
            
            return {
                testName: "vision.ds.ByteArray#setUInt32",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setUInt32",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getUInt32_Int_UInt__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.getUInt32(pos);
            
            return {
                testName: "vision.ds.ByteArray#getUInt32",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getUInt32",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setInt8__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var v = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setInt8(pos, v);
            
            return {
                testName: "vision.ds.ByteArray#setInt8",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setInt8",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getInt8_Int_Int__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.getInt8(pos);
            
            return {
                testName: "vision.ds.ByteArray#getInt8",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getInt8",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setBytes__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var array = vision.ds.ByteArray.from(0);
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setBytes(pos, array);
            
            return {
                testName: "vision.ds.ByteArray#setBytes",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setBytes",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getBytes_Int_Int_ByteArray__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var length = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.getBytes(pos, length);
            
            return {
                testName: "vision.ds.ByteArray#getBytes",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getBytes",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__resize__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var length = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.resize(length);
            
            return {
                testName: "vision.ds.ByteArray#resize",
                returned: null,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#resize",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__concat_ByteArray_ByteArray__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var array = vision.ds.ByteArray.from(0);
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.concat(array);
            
            return {
                testName: "vision.ds.ByteArray#concat",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#concat",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__isEmpty__Bool__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.isEmpty();
            
            return {
                testName: "vision.ds.ByteArray#isEmpty",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#isEmpty",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__toArray__ArrayInt__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.toArray();
            
            return {
                testName: "vision.ds.ByteArray#toArray",
                returned: result,
                expected: null,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#toArray",
                returned: e,
                expected: null,
                status: Failure
            }
        }
    }


}
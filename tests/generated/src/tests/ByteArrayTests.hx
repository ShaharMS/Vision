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
            var value = 0x00010000;
			
            var result = vision.ds.ByteArray.from(value);

            var expected = new ByteArray(4);
            expected.write(2, 1);
            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: expected,
                status: TestStatus.of(result, expected)
            }
        } catch (e) {
            var expected = new ByteArray(4);
            expected.write(2, 1);
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: expected,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_Int64_ByteArray__ShouldWork():TestResult {
        try {
            var value:Int64 = Int64.make(1, 1);
			
            var result = vision.ds.ByteArray.from(value);

            var expected = new ByteArray(8);
            expected.write(0, 1);
            expected.write(4, 1);
            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: expected,
                status: TestStatus.of(result, expected)
            }
        } catch (e) {
            var expected = new ByteArray(8);
            expected.write(0, 1);
            expected.write(4, 1);
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: expected,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_Float_ByteArray__ShouldWork():TestResult {
        try {
            var value = 1.1;
			
            var result = vision.ds.ByteArray.from(value);

            var expected = new ByteArray(8);
            expected.setDouble(0, 1.1);
            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: expected,
                status: TestStatus.of(result, expected)
            }
        } catch (e) {
            var expected = new ByteArray(8);
            expected.setDouble(0, 1.1);
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: expected,
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
                expected: new ByteArray(1, 0),
                status: TestStatus.of(result, new ByteArray(1, 0))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: new ByteArray(1, 0),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_String_haxeioEncoding_ByteArray__ShouldWork():TestResult {
        try {
            var value = "Hello There!";
			var encoding:haxe.io.Encoding = UTF8;
			
            var result = vision.ds.ByteArray.from(value, encoding);

            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: Bytes.ofString("Hello There!", UTF8),
                status: TestStatus.of(result, Bytes.ofString("Hello There!", UTF8))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: Bytes.ofString("Hello There!", UTF8),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__from_Dynamic_ByteArray__ShouldWork():TestResult {
        try {
            var value:Dynamic = {hey: "There!"};
			
            var result = vision.ds.ByteArray.from(value);

            var expected = Bytes.ofString(Serializer.run(value));
            return {
                testName: "vision.ds.ByteArray.from",
                returned: result,
                expected: expected,
                status: TestStatus.of(result, expected)
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray.from",
                returned: e,
                expected: Bytes.ofString(Serializer.run({hey: "There!"})),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setUInt8__ShouldWork():TestResult {
        try { 
            var length = 1;
			var fillWith = 0;
			
            var pos = 0;
			var v = 65;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setUInt8(pos, v);
            
            return {
                testName: "vision.ds.ByteArray#setUInt8",
                returned: object,
                expected: ByteArray.from([65], 1),
                status: TestStatus.of(object, ByteArray.from([65], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setUInt8",
                returned: e,
                expected: ByteArray.from([65], 1),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getUInt8_Int_Int__ShouldWork():TestResult {
        try { 
            var length = 1;
			var fillWith = 34;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.getUInt8(pos);
            
            return {
                testName: "vision.ds.ByteArray#getUInt8",
                returned: result,
                expected: 34,
                status: TestStatus.of(result == 34)
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getUInt8",
                returned: e,
                expected: 34,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setUInt32__ShouldWork():TestResult {
        try { 
            var length = 4;
			var fillWith = 0;
			
            var pos = 0;
			var value:UInt = 0xFF763400;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setUInt32(pos, value);
            
            return {
                testName: "vision.ds.ByteArray#setUInt32",
                returned: object,
                expected: ByteArray.from([0xFF, 0x76, 0x34, 0x00], 1),
                status: TestStatus.of(object, ByteArray.from([0xFF, 0x76, 0x34, 0x00], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setUInt32",
                returned: e,
                expected: ByteArray.from([0xFF, 0x76, 0x34, 0x00], 1),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getUInt32_Int_UInt__ShouldWork():TestResult {
        try { 
            var length = 4;
			var fillWith = 0x0019F43E;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.getUInt32(pos);
            
            return {
                testName: "vision.ds.ByteArray#getUInt32",
                returned: result,
                expected: 0x0019F43E,
                status: Unimplemented
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getUInt32",
                returned: e,
                expected: 0x0019F43E,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setInt8__ShouldWork():TestResult {
        try { 
            var length = 0;
			var fillWith = 0;
			
            var pos = 0;
			var v = 99;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setInt8(pos, v);
            
            return {
                testName: "vision.ds.ByteArray#setInt8",
                returned: object,
                expected: ByteArray.from([99], 1),
                status: TestStatus.of(object, ByteArray.from([99], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setInt8",
                returned: e,
                expected: ByteArray.from([99], 1),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getInt8_Int_Int__ShouldWork():TestResult {
        try { 
            var length = 1;
			var fillWith = 193;
			
            var pos = 0;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.getInt8(pos);
            
            return {
                testName: "vision.ds.ByteArray#getInt8",
                returned: result,
                expected: 193,
                status: TestStatus.of(result == 193)
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getInt8",
                returned: e,
                expected: 193,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__setBytes__ShouldWork():TestResult {
        try { 
            var length = 5;
			var fillWith = 1;
			
            var pos = 1;
			var array = vision.ds.ByteArray.from([2, 3, 4, 5], 1);
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.setBytes(pos, array);
            
            return {
                testName: "vision.ds.ByteArray#setBytes",
                returned: object,
                expected: ByteArray.from([1, 2, 3, 4, 5], 1),
                status: TestStatus.of(object, ByteArray.from([1, 2, 3, 4, 5], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#setBytes",
                returned: e,
                expected: ByteArray.from([1, 2, 3, 4, 5], 1),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__getBytes_Int_Int_ByteArray__ShouldWork():TestResult {
        try { 
            var pos = 1;
			var length = 3;
			
            var object = ByteArray.from([1, 2, 3, 4, 5], 1);
            var result = object.getBytes(pos, length);
            
            return {
                testName: "vision.ds.ByteArray#getBytes",
                returned: result,
                expected: ByteArray.from([2, 3, 4], 1),
                status: TestStatus.of(result, ByteArray.from([2, 3, 4], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#getBytes",
                returned: e,
                expected: ByteArray.from([2, 3, 4], 1),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__resize__ShouldWork():TestResult {
        try { 
            var length = 4;
			var fillWith = 2;
			
            var length = 5;
			
            var object = new vision.ds.ByteArray(length, fillWith);
            object.resize(length);
            
            return {
                testName: "vision.ds.ByteArray#resize",
                returned: object,
                expected: ByteArray.from([2, 2, 2, 2, 0], 1),
                status: TestStatus.of(object, ByteArray.from([2, 2, 2, 2, 0], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#resize",
                returned: e,
                expected: ByteArray.from([2, 2, 2, 2, 0], 1),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__concat_ByteArray_ByteArray__ShouldWork():TestResult {
        try { 
            var length = 2;
			var fillWith = 0xEE;
			
            var array = vision.ds.ByteArray.from(0xF1F2F3F4);
			
            var object = new vision.ds.ByteArray(length, fillWith);
            var result = object.concat(array);
            
            return {
                testName: "vision.ds.ByteArray#concat",
                returned: result,
                expected: ByteArray.from([0xEE, 0xEE, 0xF1, 0xF2, 0xF3, 0xF4], 1),
                status: TestStatus.of(result, ByteArray.from([0xEE, 0xEE, 0xF1, 0xF2, 0xF3, 0xF4], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#concat",
                returned: e,
                expected: ByteArray.from([0xEE, 0xEE, 0xF1, 0xF2, 0xF3, 0xF4], 1),
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
                expected: true,
                status: TestStatus.of(result == true)
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#isEmpty",
                returned: e,
                expected: true,
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__toArray__ArrayInt__ShouldWork():TestResult {
        try { 
            var object = ByteArray.from(0x34E1B2AA);
            var result = object.toArray();
            
            return {
                testName: "vision.ds.ByteArray#toArray",
                returned: result,
                expected: ByteArray.from([0x34, 0xE1, 0xB2, 0xAA], 1),
                status: TestStatus.of(result, ByteArray.from([0x34, 0xE1, 0xB2, 0xAA], 1))
            }
        } catch (e) {
            return {
                testName: "vision.ds.ByteArray#toArray",
                returned: e,
                expected: ByteArray.from([0x34, 0xE1, 0xB2, 0xAA], 1),
                status: Failure
            }
        }
    }

    public static function vision_ds_ByteArray__fromArray__ByteArray__ShouldWork():TestResult {
        try { 
            var value = [0x01, 0xEE10, 0xFF8709, 0x12345678];
			
            var result = ByteArray.from(value);
            
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
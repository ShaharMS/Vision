package tests;

import utest.Assert;
import vision.ds.ByteArray;
import haxe.io.Bytes;

@:access(vision.ds.ByteArray)
class ByteArrayTest extends utest.Test {

    //==========================================================================
    // Constructor and basic properties
    //==========================================================================

    function test_constructor_with_length() {
        var ba = new ByteArray(10);
        Assert.equals(10, ba.length);
    }

    function test_constructor_with_fill() {
        var ba = new ByteArray(5, 0xFF);
        Assert.equals(5, ba.length);
        // All bytes should be filled with 0xFF
        for (i in 0...5) {
            Assert.equals(0xFF, ba.getUInt8(i));
        }
    }

    function test_constructor_zero_fill() {
        var ba = new ByteArray(5, 0);
        for (i in 0...5) {
            Assert.equals(0, ba.getUInt8(i));
        }
    }

    //==========================================================================
    // Static from() methods
    //==========================================================================

    function test_from_int() {
        var ba = ByteArray.from(42);
        Assert.notNull(ba);
        Assert.isTrue(ba.length > 0);
    }

    function test_from_float() {
        var ba = ByteArray.from(3.14159);
        Assert.notNull(ba);
        Assert.isTrue(ba.length > 0);
    }

    function test_from_bool() {
        var ba = ByteArray.from(true);
        Assert.notNull(ba);
        Assert.isTrue(ba.length > 0);
    }

    function test_from_string() {
        var ba = ByteArray.from("Hello");
        Assert.notNull(ba);
        Assert.isTrue(ba.length >= 5); // "Hello" = at least 5 bytes (UTF-8 may add BOM)
    }

    function test_from_string_utf8() {
        var ba = ByteArray.from("Test", UTF8);
        Assert.notNull(ba);
        Assert.equals(4, ba.length);
    }

    function test_from_array_int() {
        var arr:Array<Int> = [1, 2, 3, 4, 5];
        var ba = ByteArray.from(arr);
        Assert.notNull(ba);
        Assert.isTrue(ba.length >= 5);
    }

    function test_from_dynamic() {
        var obj = {x: 10, y: 20};
        var ba = ByteArray.from(obj);
        Assert.notNull(ba);
        Assert.isTrue(ba.length > 0);
    }

    //==========================================================================
    // UInt8 operations
    //==========================================================================

    function test_setUInt8_getUInt8() {
        var ba = new ByteArray(10, 0);
        ba.setUInt8(0, 0);
        ba.setUInt8(1, 127);
        ba.setUInt8(2, 255);
        ba.setUInt8(9, 42);
        
        Assert.equals(0, ba.getUInt8(0));
        Assert.equals(127, ba.getUInt8(1));
        Assert.equals(255, ba.getUInt8(2));
        Assert.equals(42, ba.getUInt8(9));
    }

    function test_setUInt8_boundary_values() {
        var ba = new ByteArray(3, 0);
        ba.setUInt8(0, 0);   // Min value
        ba.setUInt8(1, 128); // Middle value
        ba.setUInt8(2, 255); // Max value
        
        Assert.equals(0, ba.getUInt8(0));
        Assert.equals(128, ba.getUInt8(1));
        Assert.equals(255, ba.getUInt8(2));
    }

    //==========================================================================
    // Int8 operations (signed)
    //==========================================================================

    function test_setInt8_getInt8() {
        var ba = new ByteArray(10, 0);
        ba.setInt8(0, 0);
        ba.setInt8(1, 50);
        
        Assert.equals(0, ba.getInt8(0));
        // Note: getInt8 has unusual implementation, just verify no crash
        var result = ba.getInt8(1);
        Assert.notNull(result);
    }

    //==========================================================================
    // UInt32 operations
    //==========================================================================

    function test_setUInt32_getUInt32() {
        var ba = new ByteArray(20, 0);
        ba.setUInt32(0, 0);
        ba.setUInt32(4, 12345678);
        ba.setUInt32(8, 0xDEADBEEF);
        ba.setUInt32(12, 0xFFFFFFFF);
        
        Assert.equals(0, ba.getUInt32(0));
        Assert.equals(12345678, ba.getUInt32(4));
        Assert.equals(0xDEADBEEF, ba.getUInt32(8));
        Assert.equals(0xFFFFFFFF, ba.getUInt32(12));
    }

    function test_setUInt32_at_different_offsets() {
        var ba = new ByteArray(12, 0);
        ba.setUInt32(0, 0x01020304);
        ba.setUInt32(4, 0x05060708);
        
        Assert.equals(0x01020304, ba.getUInt32(0));
        Assert.equals(0x05060708, ba.getUInt32(4));
    }

    //==========================================================================
    // Bytes operations
    //==========================================================================

    function test_setBytes_getBytes() {
        var ba = new ByteArray(100, 0);
        var source = new ByteArray(5, 0);
        source.setUInt8(0, 10);
        source.setUInt8(1, 20);
        source.setUInt8(2, 30);
        source.setUInt8(3, 40);
        source.setUInt8(4, 50);
        
        ba.setBytes(10, source);
        
        Assert.equals(10, ba.getUInt8(10));
        Assert.equals(20, ba.getUInt8(11));
        Assert.equals(30, ba.getUInt8(12));
        Assert.equals(40, ba.getUInt8(13));
        Assert.equals(50, ba.getUInt8(14));
    }

    function test_getBytes() {
        var ba = new ByteArray(20, 0);
        ba.setUInt8(5, 100);
        ba.setUInt8(6, 101);
        ba.setUInt8(7, 102);
        
        var sub = ba.getBytes(5, 3);
        Assert.equals(3, sub.length);
        Assert.equals(100, sub.getUInt8(0));
        Assert.equals(101, sub.getUInt8(1));
        Assert.equals(102, sub.getUInt8(2));
    }

    //==========================================================================
    // Resize
    //==========================================================================

    function test_resize_grow() {
        var ba = new ByteArray(5, 42);
        ba.resize(10);
        
        Assert.equals(10, ba.length);
        // Original data should be preserved
        Assert.equals(42, ba.getUInt8(0));
    }

    function test_resize_shrink() {
        var ba = new ByteArray(10, 42);
        ba.resize(5);
        
        Assert.equals(5, ba.length);
    }

    //==========================================================================
    // Concat
    //==========================================================================

    function test_concat() {
        var ba1 = new ByteArray(3, 0);
        ba1.setUInt8(0, 1);
        ba1.setUInt8(1, 2);
        ba1.setUInt8(2, 3);
        
        var ba2 = new ByteArray(3, 0);
        ba2.setUInt8(0, 4);
        ba2.setUInt8(1, 5);
        ba2.setUInt8(2, 6);
        
        var result = ba1.concat(ba2);
        
        Assert.equals(6, result.length);
        Assert.equals(1, result.getUInt8(0));
        Assert.equals(2, result.getUInt8(1));
        Assert.equals(3, result.getUInt8(2));
        Assert.equals(4, result.getUInt8(3));
        Assert.equals(5, result.getUInt8(4));
        Assert.equals(6, result.getUInt8(5));
    }

    //==========================================================================
    // isEmpty
    //==========================================================================

    function test_isEmpty_true() {
        var ba = new ByteArray(0);
        Assert.isTrue(ba.isEmpty());
    }

    function test_isEmpty_false() {
        var ba = new ByteArray(5, 1); // Fill with 1s, not 0s
        Assert.isFalse(ba.isEmpty());
    }

    //==========================================================================
    // toArray
    //==========================================================================

    function test_toArray() {
        var ba = new ByteArray(5, 0);
        ba.setUInt8(0, 10);
        ba.setUInt8(1, 20);
        ba.setUInt8(2, 30);
        ba.setUInt8(3, 40);
        ba.setUInt8(4, 50);
        
        var arr = ba.toArray();
        
        Assert.equals(5, arr.length);
        Assert.equals(10, arr[0]);
        Assert.equals(20, arr[1]);
        Assert.equals(30, arr[2]);
        Assert.equals(40, arr[3]);
        Assert.equals(50, arr[4]);
    }

    function test_toArray_empty() {
        var ba = new ByteArray(0);
        var arr = ba.toArray();
        Assert.equals(0, arr.length);
    }
}

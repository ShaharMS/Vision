package tests;

import tests.support.CollectionAssertions;
import utest.Assert;
import vision.ds.ByteArray;

@:access(vision.ds.ByteArray)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ByteArrayTest extends utest.Test {
	@:visionTestId("vision.ds.ByteArray.new#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__default() {
		var instance = new ByteArray(4, 9);
		CollectionAssertions.equalsByteArray([9, 9, 9, 9], instance);
	}

	@:visionTestId("vision.ds.ByteArray.from#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_from__default() {
		var result = ByteArray.from(0x12345678);
		Assert.equals(4, result.length);
		Assert.equals(0x12345678, result.getInt32(0));
	}

	@:visionTestId("vision.ds.ByteArray.from#bool")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_from__bool() {
		CollectionAssertions.equalsByteArray([1], ByteArray.from(true));
	}

	@:visionTestId("vision.ds.ByteArray.from#string")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_from__string() {
		var value:String = "AB";
		CollectionAssertions.equalsByteArray([65, 66], ByteArray.from(value, null));
	}

	@:visionTestId("vision.ds.ByteArray.setUInt8#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setUInt8__default() {
		var instance = new ByteArray(2);
		instance.setUInt8(1, 255);
		Assert.equals(255, instance[1]);
	}

	@:visionTestId("vision.ds.ByteArray.getUInt8#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getUInt8__default() {
		Assert.equals(7, new ByteArray(2, 7).getUInt8(1));
	}

	@:visionTestId("vision.ds.ByteArray.setUInt32#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setUInt32__default() {
		var instance = new ByteArray(4);
		instance.setUInt32(0, 0x12345678);
		Assert.equals(0x12345678, instance.getUInt32(0));
	}

	@:visionTestId("vision.ds.ByteArray.getUInt32#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getUInt32__default() {
		Assert.equals(0x12345678, ByteArray.from(0x12345678).getUInt32(0));
	}

	@:visionTestId("vision.ds.ByteArray.setInt8#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setInt8__default() {
		var instance = new ByteArray(1);
		instance.setInt8(0, 128);
		Assert.equals(128, instance[0]);
	}

	@:visionTestId("vision.ds.ByteArray.getInt8#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getInt8__default() {
		var instance = new ByteArray(1);
		instance[0] = 128;
		Assert.equals(-128, instance.getInt8(0));
	}

	@:visionTestId("vision.ds.ByteArray.getInt8#negativeOne")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getInt8__negativeOne() {
		var instance = new ByteArray(1);
		instance[0] = 0xFF;
		Assert.equals(-1, instance.getInt8(0));
	}

	@:visionTestId("vision.ds.ByteArray.getInt8#highBitValue")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getInt8__highBitValue() {
		var instance = new ByteArray(1);
		instance[0] = 0xFE;
		Assert.equals(-2, instance.getInt8(0));
	}

	@:visionTestId("vision.ds.ByteArray.setBytes#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setBytes__default() {
		var value:String = "ABC";
		var instance = new ByteArray(5);
		instance.setBytes(1, ByteArray.from(value, null));
		CollectionAssertions.bytes([0, 65, 66, 67, 0], instance);
	}

	@:visionTestId("vision.ds.ByteArray.getBytes#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getBytes__default() {
		var value:String = "ABCDE";
		var result = ByteArray.from(value, null).getBytes(1, 3);
		CollectionAssertions.bytes([66, 67, 68], result);
	}

	@:visionTestId("vision.ds.ByteArray.resize#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_resize__default() {
		var value:String = "ABCD";
		var instance = ByteArray.from(value, null);
		instance.resize(2);
		CollectionAssertions.bytes([65, 66], instance);
	}

	@:visionTestId("vision.ds.ByteArray.concat#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_concat__default() {
		var left:String = "AB";
		var right:String = "CD";
		var instance = ByteArray.from(left, null);
		var result = instance.concat(ByteArray.from(right, null));
		CollectionAssertions.bytes([65, 66, 67, 68], result);
		CollectionAssertions.bytes([65, 66], instance);
	}

	@:visionTestId("vision.ds.ByteArray.isEmpty#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_isEmpty__default() {
		Assert.isTrue(new ByteArray(3).isEmpty());
	}

	@:visionTestId("vision.ds.ByteArray.isEmpty#nonZero")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_isEmpty__nonZero() {
		Assert.isFalse(ByteArray.from("A").isEmpty());
	}

	@:visionTestId("vision.ds.ByteArray.toArray#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toArray__default() {
		var value:String = "AB";
		CollectionAssertions.values([65, 66], ByteArray.from(value, null).toArray());
	}
}

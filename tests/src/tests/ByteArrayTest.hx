package tests;

import utest.Assert;
import vision.ds.ByteArray;

@:access(vision.ds.ByteArray)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class ByteArrayTest extends utest.Test {

	@:visionTestId("vision.ds.ByteArray.from#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_from__default() {
		var value = 1;
		var result = vision.ds.ByteArray.from(value);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.ds.ByteArray.setUInt8#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setUInt8__default() {
		var pos = 1;
		var v = 1;
		var instance = new vision.ds.ByteArray(100);
		instance.setUInt8(pos, v);
		Assert.pass();
	}

	@:visionTestId("vision.ds.ByteArray.getUInt8#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getUInt8__default() {
		var pos = 1;
		var instance = new vision.ds.ByteArray(100);
		var result = instance.getUInt8(pos);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ByteArray.setUInt32#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setUInt32__default() {
		var pos = 1;
		var value = 1;
		var instance = new vision.ds.ByteArray(100);
		instance.setUInt32(pos, value);
		Assert.pass();
	}

	@:visionTestId("vision.ds.ByteArray.getUInt32#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getUInt32__default() {
		var pos = 1;
		var instance = new vision.ds.ByteArray(100);
		var result = instance.getUInt32(pos);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ByteArray.setInt8#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setInt8__default() {
		var pos = 1;
		var v = 1;
		var instance = new vision.ds.ByteArray(100);
		instance.setInt8(pos, v);
		Assert.pass();
	}

	@:visionTestId("vision.ds.ByteArray.getInt8#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getInt8__default() {
		var pos = 1;
		var instance = new vision.ds.ByteArray(100);
		var result = instance.getInt8(pos);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ByteArray.setBytes#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setBytes__default() {
		var pos = 1;
		var array = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var instance = new vision.ds.ByteArray(100);
		instance.setBytes(pos, array);
		Assert.pass();
	}

	@:visionTestId("vision.ds.ByteArray.getBytes#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_getBytes__default() {
		var pos = 1;
		var length = 1;
		var instance = new vision.ds.ByteArray(100);
		var result = instance.getBytes(pos, length);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.ds.ByteArray.resize#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_resize__default() {
		var length = 1;
		var instance = new vision.ds.ByteArray(100);
		instance.resize(length);
		Assert.pass();
	}

	@:visionTestId("vision.ds.ByteArray.concat#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_concat__default() {
		var array = vision.ds.ByteArray.from([1, 2, 3, 4]);
		var instance = new vision.ds.ByteArray(100);
		var result = instance.concat(array);
		Assert.notNull(result);
		Assert.isTrue(result.length > 0);
	}

	@:visionTestId("vision.ds.ByteArray.isEmpty#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_isEmpty__default() {
		var instance = new vision.ds.ByteArray(100);
		var result = instance.isEmpty();
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.ds.ByteArray.toArray#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_toArray__default() {
		var instance = new vision.ds.ByteArray(100);
		var result = instance.toArray();
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}

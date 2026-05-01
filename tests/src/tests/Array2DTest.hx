package tests;

import utest.Assert;
import vision.ds.Array2D;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;

@:access(vision.ds.Array2D)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class Array2DTest extends utest.Test {

	@:visionTestId("vision.ds.Array2D.inner#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_inner__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.inner;
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.ds.Array2D.width#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_width__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.width;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Array2D.height#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_height__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.height;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Array2D.length#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_length__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.length;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Array2D.get#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_get__default() {
		var x = 1;
		var y = 1;
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.get(x, y);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Array2D.set#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_set__default() {
		var x = 1;
		var y = 1;
		var val = cast 0;
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.set(x, y, val);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Array2D.setMultiple#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setMultiple__default() {
		var points = [new vision.ds.IntPoint2D(0, 0), new vision.ds.IntPoint2D(1, 1)];
		var val = cast 0;
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		instance.setMultiple(points, val);
		Assert.pass();
	}

	@:visionTestId("vision.ds.Array2D.setMultiple#duplicates")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_setMultiple__duplicates() {
		var points = [new vision.ds.IntPoint2D(1, 1), new vision.ds.IntPoint2D(1, 1)];
		var val = cast 0;
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		instance.setMultiple(points, val);
		Assert.pass();
	}

	@:visionTestId("vision.ds.Array2D.row#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_row__default() {
		var y = 1;
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.row(y);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.ds.Array2D.column#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_column__default() {
		var x = 1;
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.column(x);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.ds.Array2D.iterator#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_iterator__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.iterator();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Array2D.fill#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_fill__default() {
		var value = cast 0;
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.fill(value);
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.ds.Array2D.clone#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_clone__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.clone();
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

	@:visionTestId("vision.ds.Array2D.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.toString();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Array2D.to2DArray#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_to2DArray__default() {
		var ctor_width = 3;
		var ctor_height = 3;
		var ctor_fillWith = cast 0;
		var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
		var result = instance.to2DArray();
		Assert.notNull(result);
		Assert.isTrue(result.length >= 0);
	}

}

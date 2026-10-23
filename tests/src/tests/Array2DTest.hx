package tests;

import tests.support.CollectionAssertions;
import utest.Assert;
import vision.ds.Array2D;
import vision.ds.IntPoint2D;

@:access(vision.ds.Array2D)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class Array2DTest extends utest.Test {
	function createSequentialArray():Array2D<Int> {
		var instance = new Array2D<Int>(2, 2, 0);
		instance.set(0, 0, 1);
		instance.set(1, 0, 2);
		instance.set(0, 1, 3);
		instance.set(1, 1, 4);
		return instance;
	}

	@:visionTestId("vision.ds.Array2D.inner#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_inner__default() {
		var instance = new Array2D<Int>(2, 3, 7);
		CollectionAssertions.values([7, 7, 7, 7, 7, 7], instance.inner);
	}

	@:visionTestId("vision.ds.Array2D.width#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_width__default() {
		Assert.equals(2, createSequentialArray().width);
	}

	@:visionTestId("vision.ds.Array2D.height#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_height__default() {
		Assert.equals(2, createSequentialArray().height);
	}

	@:visionTestId("vision.ds.Array2D.length#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_length__default() {
		Assert.equals(4, createSequentialArray().length);
	}

	@:visionTestId("vision.ds.Array2D.get#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_get__default() {
		Assert.equals(4, createSequentialArray().get(1, 1));
	}

	@:visionTestId("vision.ds.Array2D.set#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_set__default() {
		var instance = new Array2D<Int>(2, 2, 0);
		Assert.equals(9, instance.set(1, 1, 9));
		Assert.equals(9, instance.get(1, 1));
	}

	@:visionTestId("vision.ds.Array2D.setMultiple#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setMultiple__default() {
		var instance = new Array2D<Int>(2, 2, 0);
		instance.setMultiple([new IntPoint2D(0, 0), new IntPoint2D(1, 1)], 5);
		CollectionAssertions.nestedValues([[5, 0], [0, 5]], instance.to2DArray());
	}

	@:visionTestId("vision.ds.Array2D.setMultiple#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_setMultiple__duplicates() {
		var instance = new Array2D<Int>(2, 2, 0);
		instance.setMultiple([new IntPoint2D(1, 1), new IntPoint2D(1, 1)], 8);
		CollectionAssertions.nestedValues([[0, 0], [0, 8]], instance.to2DArray());
	}

	@:visionTestId("vision.ds.Array2D.row#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_row__default() {
		CollectionAssertions.values([3, 4], createSequentialArray().row(1));
	}

	@:visionTestId("vision.ds.Array2D.column#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_column__default() {
		CollectionAssertions.values([2, 4], createSequentialArray().column(1));
	}

	@:visionTestId("vision.ds.Array2D.iterator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_iterator__default() {
		var result = [for (value in createSequentialArray().iterator()) value];
		CollectionAssertions.values([1, 2, 3, 4], result);
	}

	@:visionTestId("vision.ds.Array2D.fill#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_fill__default() {
		var instance = new Array2D<Int>(2, 2, 0);
		var result = instance.fill(6);
		CollectionAssertions.values([6, 6, 6, 6], result.inner);
	}

	@:visionTestId("vision.ds.Array2D.clone#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_clone__default() {
		var instance = createSequentialArray();
		var result = instance.clone();
		instance.set(0, 0, 9);
		CollectionAssertions.values([1, 2, 3, 4], result.inner);
		Assert.isFalse(instance.inner == result.inner);
	}

	@:visionTestId("vision.ds.Array2D.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals("\n[[1, 2],\n [3, 4]]", createSequentialArray().toString());
	}

	@:visionTestId("vision.ds.Array2D.to2DArray#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_to2DArray__default() {
		CollectionAssertions.nestedValues([[1, 2], [3, 4]], createSequentialArray().to2DArray());
	}
	@:visionTestId("vision.ds.Array2D.get#fractional-grid")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_get__fractionalGridPreservesPrecision() {
		var grid = new Array2D<Float>(3, 2, 0.0);
		for (y in 0...2) for (x in 0...3) grid.set(x, y, (1 + x + y * 3) / 8);
		var sum = 0.0;
		for (y in 0...2) for (x in 0...3) sum += grid.get(x, y);
		Assert.floatEquals(2.625, sum);
	}

	@:visionTestId("vision.ds.Array2D.length#dynamic-resize")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_length__dynamicBufferGrowsAndShrinks() {
		var grid = new Array2D<Dynamic>(2, 2);
		Assert.equals(4, grid.length);
		grid.inner[0] = "kept";
		grid.length = 6;
		Assert.equals(6, grid.length);
		Assert.equals("kept", grid.inner[0]);
		Assert.equals(null, grid.inner[5]);
		grid.length = 2;
		Assert.equals(2, grid.length);
		Assert.equals("kept", grid.inner[0]);
		grid.length = 0;
		Assert.equals(0, grid.length);
	}

	@:visionTestId("vision.ds.Array2D.to2DArray#fractional-row-mutation")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_to2DArray__fractionalRowsKeepLengthAndValues() {
		var grid = new Array2D<Float>(3, 2, 0.0);
		for (y in 0...2) for (x in 0...3) grid.set(x, y, (1 + x + y * 3) / 8);
		var rows = grid.to2DArray();
		CollectionAssertions.nestedValues([[0.125, 0.25, 0.375], [0.5, 0.625, 0.75]], rows);
		Assert.floatEquals(0.375, rows[0].pop());
		Assert.equals(2, rows[0].length);
		Assert.floatEquals(0.125, rows[0].shift());
		Assert.equals(1, rows[0].length);
		Assert.floatEquals(0.375, grid.get(2, 0));
	}

}

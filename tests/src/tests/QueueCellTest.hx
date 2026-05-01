package tests;

import utest.Assert;
import vision.ds.QueueCell;

@:access(vision.ds.QueueCell)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class QueueCellTest extends utest.Test {

	@:visionTestId("vision.ds.QueueCell.previous#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_previous__default() {
		var instance = new vision.ds.QueueCell(cast 1, new vision.ds.QueueCell(cast 2, null, null), new vision.ds.QueueCell(cast 0, null, null));
		var result = instance.previous;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.QueueCell.value#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_value__default() {
		var instance = new vision.ds.QueueCell(cast 1, new vision.ds.QueueCell(cast 2, null, null), new vision.ds.QueueCell(cast 0, null, null));
		var result = instance.value;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.QueueCell.next#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_next__default() {
		var instance = new vision.ds.QueueCell(cast 1, new vision.ds.QueueCell(cast 2, null, null), new vision.ds.QueueCell(cast 0, null, null));
		var result = instance.next;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.QueueCell.getValue#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_getValue__default() {
		var instance = new vision.ds.QueueCell(cast 1, new vision.ds.QueueCell(cast 2, null, null), new vision.ds.QueueCell(cast 0, null, null));
		var result = instance.getValue();
		Assert.notNull(result);
	}

}

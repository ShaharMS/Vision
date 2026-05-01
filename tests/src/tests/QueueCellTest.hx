package tests;

import utest.Assert;
import vision.ds.QueueCell;

@:access(vision.ds.QueueCell)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class QueueCellTest extends utest.Test {
	function createCell():QueueCell<Int> {
		return new QueueCell(1, new QueueCell(2, null, null), new QueueCell(0, null, null));
	}

	@:visionTestId("vision.ds.QueueCell.previous#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_previous__default() {
		Assert.equals(0, createCell().previous.value);
	}

	@:visionTestId("vision.ds.QueueCell.value#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_value__default() {
		Assert.equals(1, createCell().value);
	}

	@:visionTestId("vision.ds.QueueCell.next#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_next__default() {
		Assert.equals(2, createCell().next.value);
	}

	@:visionTestId("vision.ds.QueueCell.getValue#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_getValue__default() {
		Assert.equals(1, createCell().getValue());
	}
}

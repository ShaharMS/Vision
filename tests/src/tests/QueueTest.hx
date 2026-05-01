package tests;

import tests.support.CollectionAssertions;
import utest.Assert;
import vision.ds.Queue;

@:access(vision.ds.Queue)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class QueueTest extends utest.Test {
	function createQueue():Queue<Int> {
		var queue = new Queue<Int>();
		queue.enqueue(1);
		queue.enqueue(2);
		queue.enqueue(3);
		return queue;
	}

	@:visionTestId("vision.ds.Queue.length#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_length__default() {
		Assert.equals(3, createQueue().length);
	}

	@:visionTestId("vision.ds.Queue.first#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_first__default() {
		Assert.equals(3, createQueue().first.value);
	}

	@:visionTestId("vision.ds.Queue.last#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_last__default() {
		Assert.equals(1, createQueue().last.value);
	}

	@:visionTestId("vision.ds.Queue.iterator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_iterator__default() {
		CollectionAssertions.values([3, 2, 1], [for (value in createQueue().iterator()) value]);
	}

	@:visionTestId("vision.ds.Queue.dequeue#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_dequeue__default() {
		var instance = createQueue();
		Assert.equals(1, instance.dequeue());
		Assert.equals(2, instance.length);
		Assert.equals(2, instance.last.value);
	}

	@:visionTestId("vision.ds.Queue.enqueue#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_enqueue__default() {
		var instance = createQueue();
		Assert.equals(0, instance.enqueue(0));
		Assert.equals(4, instance.length);
		Assert.equals(0, instance.first.value);
	}

	@:visionTestId("vision.ds.Queue.has#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_has__default() {
		Assert.isTrue(createQueue().has(3));
	}

	@:visionTestId("vision.ds.Queue.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		Assert.equals("[3 -> 2 -> 1]", createQueue().toString());
	}
}

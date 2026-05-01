package tests;

import utest.Assert;
import vision.ds.Queue;

@:access(vision.ds.Queue)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class QueueTest extends utest.Test {

	@:visionTestId("vision.ds.Queue.length#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_length__default() {
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.length;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Queue.first#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_first__default() {
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.first;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Queue.last#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_last__default() {
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.last;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Queue.iterator#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_iterator__default() {
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.iterator();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Queue.dequeue#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_dequeue__default() {
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.dequeue();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Queue.enqueue#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_enqueue__default() {
		var value = cast 0;
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.enqueue(value);
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Queue.has#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_has__default() {
		var value = cast 0;
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.has(value);
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.ds.Queue.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var instance = (function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })();
		var result = instance.toString();
		Assert.notNull(result);
	}

}

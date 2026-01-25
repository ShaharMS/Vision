package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Queue;

@:access(vision.ds.Queue)
class QueueTest extends utest.Test {

    // ============================================================
    // Constructor Tests
    // ============================================================

    function test_constructor_empty() {
        var queue = new Queue<Int>();
        Assert.equals(0, queue.length);
        Assert.isNull(queue.first);
    }

    // ============================================================
    // Enqueue Tests
    // ============================================================

    function test_enqueue_single() {
        var queue = new Queue<Int>();
        var result = queue.enqueue(42);
        Assert.equals(42, result);
        Assert.equals(1, queue.length);
        Assert.notNull(queue.first);
        Assert.equals(42, queue.first.value);
    }

    function test_enqueue_multiple() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        queue.enqueue(2);
        queue.enqueue(3);
        Assert.equals(3, queue.length);
    }

    function test_enqueue_returnsValue() {
        var queue = new Queue<Int>();
        Assert.equals(10, queue.enqueue(10));
        Assert.equals(20, queue.enqueue(20));
    }

    function test_enqueue_string() {
        var queue = new Queue<String>();
        queue.enqueue("hello");
        queue.enqueue("world");
        Assert.equals(2, queue.length);
    }

    // ============================================================
    // Dequeue Tests
    // ============================================================

    function test_dequeue_fifoOrder() {
        var queue = new Queue<Int>();
        queue.enqueue(10);
        queue.enqueue(20);
        queue.enqueue(30);
        // Dequeue returns oldest (first enqueued)
        Assert.equals(10, queue.dequeue());
        Assert.equals(2, queue.length);
    }

    function test_dequeue_multipleItems() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        queue.enqueue(2);
        queue.enqueue(3);
        Assert.equals(1, queue.dequeue());
        Assert.equals(2, queue.dequeue());
        Assert.equals(3, queue.dequeue());
    }

    function test_dequeue_lengthDecreases() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        queue.enqueue(2);
        Assert.equals(2, queue.length);
        queue.dequeue();
        Assert.equals(1, queue.length);
    }

    // ============================================================
    // Length Tests
    // ============================================================

    function test_length_startsAtZero() {
        var queue = new Queue<Int>();
        Assert.equals(0, queue.length);
    }

    function test_length_incrementsOnEnqueue() {
        var queue = new Queue<Int>();
        Assert.equals(0, queue.length);
        queue.enqueue(1);
        Assert.equals(1, queue.length);
        queue.enqueue(2);
        Assert.equals(2, queue.length);
    }

    // ============================================================
    // Last Property Tests
    // ============================================================

    function test_last_singleItem() {
        var queue = new Queue<Int>();
        queue.enqueue(42);
        Assert.notNull(queue.last);
        Assert.equals(42, queue.last.value);
    }

    function test_last_multipleItems() {
        var queue = new Queue<Int>();
        queue.enqueue(5);
        queue.enqueue(10);
        queue.enqueue(15);
        // First enqueued ends up at the tail (last)
        Assert.equals(5, queue.last.value);
    }

    function test_last_isFirstEnqueued() {
        var queue = new Queue<Int>();
        queue.enqueue(100);
        queue.enqueue(200);
        queue.enqueue(300);
        // Queue: first=300 -> 200 -> 100=last
        Assert.equals(100, queue.last.value);
    }

    // ============================================================
    // Has Tests
    // ============================================================

    function test_has_existingItem() {
        var queue = new Queue<Int>();
        queue.enqueue(100);
        queue.enqueue(200);
        queue.enqueue(300);
        Assert.isTrue(queue.has(200));
    }

    function test_has_firstItem() {
        var queue = new Queue<Int>();
        queue.enqueue(100);
        queue.enqueue(200);
        queue.enqueue(300);
        Assert.isTrue(queue.has(300)); // Most recently enqueued
    }

    function test_has_nonExistingItem() {
        var queue = new Queue<Int>();
        queue.enqueue(100);
        queue.enqueue(200);
        queue.enqueue(300);
        Assert.isFalse(queue.has(999));
    }

    // ============================================================
    // Iterator Tests
    // ============================================================

    function test_iterator_notNull() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        queue.enqueue(2);
        var iter = queue.iterator();
        Assert.notNull(iter);
    }

    function test_iterator_count() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        queue.enqueue(2);
        queue.enqueue(3);
        var count = 0;
        for (_ in queue.iterator()) count++;
        Assert.equals(3, count);
    }

    function test_iterator_values() {
        var queue = new Queue<Int>();
        queue.enqueue(10);
        queue.enqueue(20);
        queue.enqueue(30);
        var values = new Array<Int>();
        for (v in queue.iterator()) values.push(v);
        Assert.equals(3, values.length);
        // Iterator goes from first (most recent) to last
        Assert.equals(30, values[0]);
        Assert.equals(20, values[1]);
        Assert.equals(10, values[2]);
    }

    function test_iterator_hasNext() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        var iter = queue.iterator();
        Assert.isTrue(iter.hasNext());
        iter.next();
        Assert.isFalse(iter.hasNext());
    }

    // ============================================================
    // ToString Tests
    // ============================================================

    function test_toString_format() {
        var queue = new Queue<Int>();
        queue.enqueue(5);
        queue.enqueue(7);
        queue.enqueue(4);
        var result = queue.toString();
        Assert.equals("[4 -> 7 -> 5]", result);
    }

    function test_toString_singleItem() {
        var queue = new Queue<Int>();
        queue.enqueue(42);
        var result = queue.toString();
        Assert.equals("[42]", result);
    }

    function test_toString_notNull() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        queue.enqueue(2);
        Assert.notNull(queue.toString());
    }

    // ============================================================
    // First Property Tests
    // ============================================================

    function test_first_mostRecentEnqueue() {
        var queue = new Queue<Int>();
        queue.enqueue(1);
        queue.enqueue(2);
        queue.enqueue(3);
        // Most recently enqueued becomes first
        Assert.equals(3, queue.first.value);
    }

    function test_first_singleItem() {
        var queue = new Queue<Int>();
        queue.enqueue(42);
        Assert.equals(42, queue.first.value);
    }

}

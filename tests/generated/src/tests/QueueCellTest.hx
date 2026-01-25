package tests;

import utest.Assert;
import utest.Async;
import vision.ds.QueueCell;

@:access(vision.ds.QueueCell)
class QueueCellTest extends utest.Test {

    // ============================================================
    // Constructor Tests
    // ============================================================

    function test_constructor_valueOnly() {
        var cell = new QueueCell<Int>(42, null, null);
        Assert.equals(42, cell.value);
        Assert.isNull(cell.next);
        Assert.isNull(cell.previous);
    }

    function test_constructor_withNext() {
        var nextCell = new QueueCell<Int>(100, null, null);
        var cell = new QueueCell<Int>(42, nextCell, null);
        Assert.equals(42, cell.value);
        Assert.notNull(cell.next);
        Assert.equals(100, cell.next.value);
        Assert.isNull(cell.previous);
    }

    function test_constructor_withPrevious() {
        var prevCell = new QueueCell<Int>(50, null, null);
        var cell = new QueueCell<Int>(42, null, prevCell);
        Assert.equals(42, cell.value);
        Assert.isNull(cell.next);
        Assert.notNull(cell.previous);
        Assert.equals(50, cell.previous.value);
    }

    function test_constructor_withBothLinks() {
        var prevCell = new QueueCell<Int>(50, null, null);
        var nextCell = new QueueCell<Int>(100, null, null);
        var cell = new QueueCell<Int>(42, nextCell, prevCell);
        Assert.equals(42, cell.value);
        Assert.equals(100, cell.next.value);
        Assert.equals(50, cell.previous.value);
    }

    // ============================================================
    // getValue Tests
    // ============================================================

    function test_getValue_int() {
        var cell = new QueueCell<Int>(42, null, null);
        Assert.equals(42, cell.getValue());
    }

    function test_getValue_string() {
        var cell = new QueueCell<String>("hello", null, null);
        Assert.equals("hello", cell.getValue());
    }

    function test_getValue_float() {
        var cell = new QueueCell<Float>(3.14, null, null);
        Assert.floatEquals(3.14, cell.getValue());
    }

    function test_getValue_null() {
        var cell = new QueueCell<Dynamic>(null, null, null);
        Assert.isNull(cell.getValue());
    }

    // ============================================================
    // Value Field Tests
    // ============================================================

    function test_value_direct_access() {
        var cell = new QueueCell<Int>(42, null, null);
        Assert.equals(42, cell.value);
    }

    function test_value_mutability() {
        var cell = new QueueCell<Int>(42, null, null);
        cell.value = 100;
        Assert.equals(100, cell.value);
        Assert.equals(100, cell.getValue());
    }

    // ============================================================
    // Link Mutability Tests
    // ============================================================

    function test_next_mutability() {
        var cell = new QueueCell<Int>(42, null, null);
        var nextCell = new QueueCell<Int>(100, null, null);
        cell.next = nextCell;
        Assert.notNull(cell.next);
        Assert.equals(100, cell.next.value);
    }

    function test_previous_mutability() {
        var cell = new QueueCell<Int>(42, null, null);
        var prevCell = new QueueCell<Int>(50, null, null);
        cell.previous = prevCell;
        Assert.notNull(cell.previous);
        Assert.equals(50, cell.previous.value);
    }

    // ============================================================
    // Chain Tests
    // ============================================================

    function test_chain_threeNodes() {
        var first = new QueueCell<Int>(1, null, null);
        var second = new QueueCell<Int>(2, null, first);
        var third = new QueueCell<Int>(3, null, second);
        
        first.next = second;
        second.next = third;
        
        // Traverse forward
        Assert.equals(1, first.value);
        Assert.equals(2, first.next.value);
        Assert.equals(3, first.next.next.value);
        
        // Traverse backward
        Assert.equals(3, third.value);
        Assert.equals(2, third.previous.value);
        Assert.equals(1, third.previous.previous.value);
    }

    function test_chain_bidirectional() {
        var cell1 = new QueueCell<Int>(1, null, null);
        var cell2 = new QueueCell<Int>(2, null, cell1);
        cell1.next = cell2;
        
        // Forward and back should return to same cell
        Assert.equals(cell1, cell1.next.previous);
        Assert.equals(cell2, cell2.previous.next);
    }

    // ============================================================
    // Generic Type Tests
    // ============================================================

    function test_generic_array() {
        var arr = [1, 2, 3];
        var cell = new QueueCell<Array<Int>>(arr, null, null);
        Assert.equals(3, cell.value.length);
        Assert.equals(2, cell.value[1]);
    }

}

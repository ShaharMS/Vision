package vision.ds;


#if (flash || cpp) @:generic #end 
class QueueCell<T> {

    public var previous:QueueCell<T>;
    
    public var value:T;

    public var next:QueueCell<T>;

    public function new(value:T, next:QueueCell<T>, previous:QueueCell<T>) {
        this.previous = previous;
        this.value = value;
        this.next = next;
    }

    @:to @:noCompletion public function getValue():T {
        return value;
    }
}

#if (flash || cpp) @:generic #end 
class Queue<T> {
    
    public var length(default, null):Int = 0;
    public var first:QueueCell<T>;
    public var last(get, set):QueueCell<T>;

    public function new() {}

    /**
		Returns an iterator over the elements of `this` Queue.
	**/
	public function iterator():Iterator<T> {
		var l = first;
		return {
			hasNext: function() {
				return l != null;
			},
			next: function() {
				var k = l;
				l = k.next;
				return k.value;
			}
		};
	}

    /**
        Gets the last cell's value in the queue, and removes it from the queue
    **/
    public function dequeue():T {
        var v = last.value;
        //funny maneuver
        last.previous.next = null;
        length--;
        return v;
    }

    public function enqueue(value:T):T {
        if (first == null) {
            first = new QueueCell(value, null, null);
            length++;
            return value;
        }
        first.previous = new QueueCell(value, first, null);
        first = first.previous;
        length++;
        return value;
    }

    public function has(value:T):Bool {
        var processed:QueueCell<T> = first;

        while (processed.next != null) {
            if (processed.value == value) return true;
            processed = processed.next;
        }
        return false;
    }

    public function toString():String {
        var s = "[";
        var processed:QueueCell<T> = first;

        while (processed.next != null) {
            s += '${processed.value} -> ';
            processed = processed.next;
        }
        s += '${processed.value}]';
        return s;
    }

    function get_last():QueueCell<T> {
        var processed:QueueCell<T> = first;

        while (processed.next != null) {
            processed = processed.next;
        }
        return processed;
    }

    function set_last(value:QueueCell<T>):QueueCell<T> {
        var processed:QueueCell<T> = first;

        while (processed.next != null) {
            processed = processed.next;
        }
        processed = value;
        return value;
    }

}
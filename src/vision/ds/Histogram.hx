package vision.ds;

/**
 * A 2D graph, usually representing a distribution of numerical values.
 */
@:forward(has, indexOf, iterator, copy, toString)
abstract Histogram(Map<Int, Int>) {
	public function new() {
        this = [];
    }

	public function increment(cell:Int):Histogram {
		this[cell] != null ?this[cell]
		++:this[cell] = 0;
		return cast this;
	}

	public function decrement(cell:Int, forcePositive:Bool = true):Histogram {
		this[cell] != null ?this[cell]
		--:this[cell] = 0;
		if (forcePositive && this[cell] < 0)
			this[cell] = 0;
		return cast this;
	}

	public function set(cell:Int, value:Int):Histogram {
		this[cell] = value;
		return cast this;
	}

	public function get(cell:Int):Int {
		return this[cell];
	}

	public var length(get, never):Int;

	public function getMedian() {
        var offset:Int = length % 2;

        return this[Std.int((length - offset) / 2)];
	}

	function get_length():Int {
		return Lambda.count(this);
	}
}

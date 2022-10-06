package vision.ds;

import haxe.ds.IntMap;

/**
 * A 2D graph, usually represens a sorted distribution of numerical values.
 */
class Histogram {
	var underlying:Array<Int>;

	public var length(get, null):Int = 0;

	public var median(get, null):Int;

	public function new() {
		underlying = [];
	}

	public function increment(cell:Int):Histogram {
		underlying.insert(cell, cell);
		return cast this;
	}

	public function decrement(cell:Int):Histogram {
		underlying.remove(cell);
		return cast this;
	}

	function get_median():Int {
		final offset = length % 2;
		return underlying[Std.int((length - offset) / 2)];
	}

	function get_length():Int {
		return underlying.length;
	}
}

package vision.ds;

import haxe.ds.IntMap;

/**
 * A 2D graph, usually represents a sorted distribution of numerical values.
 */
class Histogram {
	var underlying:Array<Null<Int>>;

	/**
		The amount of items in this `Histogram`
	**/
	public var length(get, null):Int = 0;

	/**
		The value at the middle of this `Histogram`.
	**/
	public var median(get, null):Int;

	/**
		Creates a new, empty `Histogram`
	**/
	public function new() {
		underlying = [];
	}

	/**
		Increments the value at `cell`.
	**/
	public function increment(cell:Int):Histogram {
		underlying[cell] != null ? underlying[cell]++ : underlying[cell] = 1;
		return cast this;
	}

	/**
		Decrements the value at `cell`.
	**/
	public function decrement(cell:Int):Histogram {
		underlying[cell] != null ? underlying[cell]-- : underlying[cell] = -1;
		return cast this;
	}

	function get_median():Int {
		var temp = [];
		for (i in 0...underlying.length) {
			if (underlying[i] == null) continue
			else {
				for (_ in 0...underlying[i]) temp.push(i);
			}
		}
		final offset = temp.length % 2;
		return temp[Std.int((temp.length - offset) / 2)];
	}

	function get_length():Int {
		return underlying.length;
	}
}

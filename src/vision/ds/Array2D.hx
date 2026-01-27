package vision.ds;

import haxe.iterators.ArrayIterator;
#if !vision_fancy_array_access
/**
	A 2D array, faster than an `Array<Array<T>>`.
**/
#else
/**
	A 2D array, faster than an `Array<Array<T>>`.

	You have fancy array access turned on, so you can get/set elements using the following syntax:
	```haxe
	var arr = new Array2D(10, 10);
	arr[[1, 5]] = 3;
	trace(arr[[1, 5]]); // 3
	```
**/
#end
class Array2D<T> {
	/**
		The underlying `Array<T>` instance that holds the data.
	**/
	public var inner:Array<T>;

	/**
		The 2D array's width.
	**/
	public var width(default, set):Int;

	/**
		The 2D array's height.
	**/
	public var height(default, set):Int;

	/**
		The amount of elements in this `Array2D`.
	**/
	public var length(get, set):Int;

	/**
		Creates a new `Array2D` instance. The created array can be filled in with non-null values. 
		if null is given, or no value is provided, the behavior is target-dependent:    

		 - on dynamic targets, values are always `null`
		 - on static targets, `0`, `0.0` or `false` are filled in for `Int`, `Float` and `Bool` respectively. Other types are filled in with `null`

		@param width The array's width
		@param height The array's height
		@param fillWith Optional, A custom value of type `T` to fill the created array with. If `fillWith` is not provided, the created array will contain the default values specified above.
	**/
	public inline function new(width:Int, height:Int, ?fillWith:T) {
		@:bypassAccessor this.width = width;
		@:bypassAccessor this.height = height;

		this.inner = new Array();
		inner.resize(width * height);
		if (fillWith != null) {
			for (i in 0...inner.length)
				inner[i] = fillWith;
		}
	}

	/**
		Gets the element at column `x`, row `y`
	**/
	public inline function get(x:Int, y:Int):T {
		return inner[(y * width) + x];
	}

	/**
		Sets the element at column `x`, row `y`
	**/
	public inline function set(x:Int, y:Int, val:T) {
		return inner[x + (y * width)] = val;
	}

	/**
		Sets multiple elements at multiple positions, at the same time
		@param points the indices at which to set
		@param val the value to set
	**/
	public inline function setMultiple(points:Array<IntPoint2D>, val:T) {
		for (p in points) {
			set(p.x, p.y, val);
		}
	}

	/**
		returns the entire row at position `y`
	**/
	public inline function row(y:Int):Array<T> {
		return [for (i in y * width...y * width + width) inner[i]];
	}

	/**
		returns the entire coluumn at position `x`
	**/
	public inline function column(x:Int):Array<T> {
		return [for (i in 0...height) inner[i * width + x]];
	}

	/**
		Returns an array iterator for this `Array2D`.

		Values are iterated on from left to right, top to bottom, for example (array of width 5, height 5):

		`(x, y)...(x + 5, y) -> (x, y + 1)...(x + 5, y + 1) -> (x, y + 2)...`
	**/
	public inline function iterator():ArrayIterator<T> {
		return inner.iterator();
	}

	/**
		Fills the entire array with the provided value
		@param value the value to fill the array with
		@return this, filled `Array2D`
	**/
	public inline function fill(value:T):Array2D<T> {
		for (i in 0...inner.length)
			inner[i] = value;
		return this;
	}

	/**
		Clones this `Array2D`
		@return A new `Array2D`, similar to this one.
	**/
	public inline function clone():Array2D<T> {
		var arr = new Array2D(width, height);
		arr.inner = inner.copy();
		return arr;
	}

	/**
		Gets a string representation of this `Array2D`@:noCompletion 
	**/
	public inline function toString():String {
		var str = "\n[[";
		var counter = 0;
		for (item in inner) {
			if (counter < width) {
				var add = ', $item';
				if (counter == 0) add = add.substr(2);
				str += add;
				counter++;
			} else {
				counter = 0;
				str += "],\n [";
				var add = '$item';
				str += add;
				counter++;
			}
		}

		return str.substring(0, str.length) + "]]";
	}

	@:noCompletion inline function get_length():Int {
		return inner.length;
	}

	@:noCompletion inline function set_length(value:Int):Int {
		inner.resize(value);
		return value;
	}

	@:noCompletion inline function set_width(value:Int):Int {
		inner.resize(value * height);
		return width = value;
	}

	@:noCompletion inline function set_height(value:Int):Int {
		inner.resize(width * value);
		return height = value;
	}

	@:noCompletion @:op([]) inline function get_item(index:Array<Int>) {
		return inner[index[0] + (index[1] * height)];
	}

	@:noCompletion @:op([]) inline function set_item(index:Array<Int>, value:T) {
		return inner[index[0] + (index[1] * height)] = value;
	}

	@:to public function to2DArray():Array<Array<T>> {
		var arr = [];
		for (y in 0...height) {
			arr.push(this.row(y));
		}

		return arr;
	}
}
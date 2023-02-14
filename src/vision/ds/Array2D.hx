package vision.ds;

/**
    A 2D array, faster than an `Array<Array<T>>`.
**/
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
	    Creates a new `Array2D` instance. The created array can be filled in with non-null values, and thats target-dependent:

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
			for (i in 0...inner.length) inner[i] = fillWith;
		}
	}

	/**
	    Gets the element at row `x`, column `y`
	**/
	public inline function get(x:Int, y:Int):T {
		return inner[(y * height) + x];
	}

	/**
	    Sets the element at row `x`, column `y`
	**/
	public inline function set(x:Int, y:Int, val:T) {
		return inner[x + (y * height)] = val;
	}

	/**
	    Returns an array iterator for this `Array2D`.
	    
		Values are iterated on from left to right, top to bottom:
		
		`(x, y)...(x + 5, y) -> (x, y + 1)...(x + 5, y + 1) -> (x, y + 2)...`
	**/
	public inline function iterator() {
		return inner.iterator();
	}

	public inline function fill(value:T):Array2D<T> {
		for (i in 0...inner.length) inner[i] = value;
		return this;
	}

	inline function get_length():Int {
		return inner.length;
	}

	inline function set_length(value:Int):Int {
		inner.resize(value);
		return value;
	}

	inline function set_width(value:Int):Int {
		inner.resize(value * height);
		return width = value;
	}

	inline function set_height(value:Int):Int {
		inner.resize(width * value);
		return height = value;
	}
}

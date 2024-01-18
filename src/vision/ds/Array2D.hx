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
			for (i in 0...inner.length) inner[i] = fillWith;
		}
	}

	/**
	    Gets the element at column `x`, row `y`
	**/
	public inline function get(x:Int, y:Int):T {
		return inner[(y * height) + x];
	}

	/**
	    Sets the element at column `x`, row `y`
	**/
	public inline function set(x:Int, y:Int, val:T) {
		return inner[x + (y * height)] = val;
	}

	public inline function setMultiple(points:Array<IntPoint2D>, val:T) {
		for (p in points) {
			set(p.x, p.y, val);
		}
	}

	/**
		returns the entire row at position `y`
	**/
	public inline function row(y:Int):Array<T> {
		return [for (i in y * width... y * width + width) inner[i]];
	}

	/**
		returns the entire coluumn at position `x`
	**/
	public inline function column(x:Int):Array<T> {
		return [for (i in 0...height) inner[i * width + x]];
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

	public inline function clone():Array2D<T> {
		var arr = new Array2D(width, height);
		arr.inner = inner.copy();
		return arr;
	}

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


	@:to public function to2DArray():Array<Array<T>> {
		var arr = [];
		for (y in 0...height) {
			arr.push(this.row(y));
		}

		return arr;
	}
}

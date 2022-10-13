package vision.ds;

class Array2D<T> {
	public var inner:Array<T>;
	public var width:Int;
	public var height:Int;

	public inline function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;

		this.inner = new Array();
		inner.resize(width * height);
	}

	public inline function get(x:Int, y:Int):T {
		return inner[(y * height) + x];
	}

	public inline function set(x:Int, y:Int, val:T) {
		return inner[x + (y * height)] = val;
	}
}
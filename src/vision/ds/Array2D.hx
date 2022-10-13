package vision.ds;

class Array2D<T> {
	public var inner:Array<T>;
	public var width:Int;
	public var height:Int;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;

		this.inner = new Array();
		inner.resize(width * height);
	}

	public function get(x:Int, y:Int):T {
		return inner[(y * height) + x];
	}

	public function set(x:Int, y:Int, val:T) {
		return inner[x + (y * height)] = val;
	}
}
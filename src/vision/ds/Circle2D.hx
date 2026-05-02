package vision.ds;

class Circle2D {
	public var center(default, null):Point2D;
	public var radius(default, null):Float;
	public var votes(default, null):Float;

	public inline function new(center:Point2D, radius:Float, votes:Float = 0) {
		this.center = center;
		this.radius = radius;
		this.votes = votes;
	}

	public inline function copy():Circle2D {
		return new Circle2D(center.copy(), radius, votes);
	}

	@:keep
	public inline function toString():String {
		return 'Circle2D(center=${center.toString()}, radius=$radius, votes=$votes)';
	}
}
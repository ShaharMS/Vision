package vision.ds;

class Circle2D {
	public var center(default, null):Point2D;
	public var radius(default, null):Float;

	public inline function new(center:Point2D, radius:Float) {
		this.center = center;
		this.radius = radius;
	}

	public inline function copy():Circle2D {
		return new Circle2D(center.copy(), radius);
	}

	@:keep
	public inline function toString():String {
		return 'Circle2D(center=${center.toString()}, radius=$radius)';
	}
}
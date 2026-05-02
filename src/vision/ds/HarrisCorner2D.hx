package vision.ds;

class HarrisCorner2D {
	public var point(default, null):Point2D;
	public var score(default, null):Float;

	public inline function new(point:Point2D, score:Float) {
		this.point = point;
		this.score = score;
	}

	public inline function copy():HarrisCorner2D {
		return new HarrisCorner2D(point.copy(), score);
	}

	public inline function toPoint2D():Point2D {
		return point.copy();
	}

	@:keep
	public inline function toString():String {
		return 'HarrisCorner2D(point=${point.toString()}, score=$score)';
	}
}
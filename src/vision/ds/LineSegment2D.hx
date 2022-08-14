package vision.ds;

import vision.tools.MathTools;

class LineSegment2D {
	public var length(get, null):Float;

	public var slope(default, set):Float;

    public var degrees(default, set):Float;

    public var radians(default, set):Float;

	public var start(default, null):Point2D = {x: 0, y: 0};

	public var end(default, null):Point2D = {x: 0, y: 0};

	public function new(start:Point2D, end:Point2D) {
		this.start.x = start.x;
		this.start.y = start.y;
		this.end.x = end.x;
		this.end.y = end.y;
	}

	function get_length():Float {
		return Math.sqrt(Math.pow(this.end.x - this.start.x, 2) + Math.pow(this.end.y - this.start.y, 2));
	}

	public function toString() {
		return '\n ($start.x, $start.y) --> ($end.x, $end.y)';
	}

	function set_slope(value:Float):Float {
		@:bypassAccessor degrees = MathTools.slopeToDegrees(value);
        @:bypassAccessor radians = MathTools.slopeToRadians(value);
        return slope = value;
	}

	function set_degrees(value:Float):Float {
		@:bypassAccessor slope = MathTools.degreesToSlope(value);
        @:bypassAccessor radians = MathTools.degreesToRadians(value);
        return degrees = value;
	}

    function set_radians(value:Float):Float {
        @:bypassAccessor slope = MathTools.radiansToSlope(value);
        @:bypassAccessor degrees = MathTools.radiansToDegrees(value);
        return radians = value;
    }

	public static function fromRay2D(ray:Ray2D):LineSegment2D {
		var x:Float = ray.point.x;
		var y:Float = ray.point.y;
		var length:Float = 1;
		var end:Point2D = new Point2D(Std.int(x + length * Math.cos(ray.radians)), Std.int(y + length * Math.sin(ray.radians)));
		return new LineSegment2D(ray.point, end);
	}

	public function toRay2D():Ray2D {
		return new Ray2D(this.start, this.slope);
	}
}
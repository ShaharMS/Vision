package vision.ds;

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
		Reflect.setField(this, "degrees", MathUtils.degreesFromSlope(value));
        Reflect.setField(this, "radians", MathUtils.radiansFromSlope(value));
        return slope = value;
	}

	function set_degrees(value:Float):Float {
		Reflect.setField(this, "slope", MathUtils.slopeFromDegrees(value));
        Reflect.setField(this, "radians", MathUtils.radiansFromDegrees(value));
        return degrees = value;
	}

    function set_radians(value:Float):Float {
        Reflect.setField(this, "slope", MathUtils.slopeFromRadians(value));
        Reflect.setField(this, "degrees", MathUtils.degreesFromRadians(value));
        return radians = value;
    }

	public static function fromPointAndAngle(point:Point2D, angle:Float) {
		var x:Float = point.x;
		var y:Float = point.y;
		var length:Float = 1;
		var end:Point2D = new Point2D(Std.int(x + length * Math.cos(angle * (Math.PI / 180))), Std.int(y + length * Math.sin(angle * (Math.PI / 180))));
		return new LineSegment2D(point, end);
	}
}
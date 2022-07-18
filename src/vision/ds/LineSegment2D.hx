package vision.ds;

class LineSegment2D {
	public var length(get, null):Float;

	public var angle(get, null):Float;

	public var start(default, null):Point2D = {x: 0, y: 0};

	public var end(default, null):Point2D = {x: 0, y: 0};

	public function new(start:Point2D, end:Point2D) {
		this.start.x = start.x;
		this.start.y = start.y;
		this.end.x = end.x;
		this.end.y = end.y;
	}

	public function toString() {
		return '\n ($start.x, $start.y) --> ($end.x, $end.y)';
	}

    public function get_length() {
        return Math.sqrt((start.x - end.x) * (start.x - end.x) + (start.y - end.y) * (start.y - end.y));
    }

	public function get_angle() {
		var dx:Float = start.x - end.x;
		var dy:Float = start.y - end.y;
		var angle:Float = Math.atan2(dy, dx) * (180 / Math.PI) - 180;
		return angle;
	}

	public static function fromPointAndAngle(point:Point2D, angle:Float) {
		var x:Float = point.x;
		var y:Float = point.y;
		var length:Float = 1;
		var end:Point2D = new Point2D(Std.int(x + length * Math.cos(angle * (Math.PI / 180))), Std.int(y + length * Math.sin(angle * (Math.PI / 180))));
		return new LineSegment2D(point, end);
	}
}
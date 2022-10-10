package vision.ds;

import vision.tools.MathTools;

class Line2D {
	public var length(get, null):Float;

	public var slope(default, null):Float;

	public var degrees(default, null):Float;

	public var radians(default, null):Float;

	public var start(default, set):Point2D = {x: 0, y: 0};

	public var end(default, set):Point2D = {x: 0, y: 0};

	public var middle(get, set):Point2D;

	/**
		 When editing the slope/degrees/radians of `this` line,
		 the `start`,`end` or `middle` points will change according to this setting:
		 
		 
		 | Name | Explanation | Modifies Start | Modifies End | Modifies Middle |
		 | --- | --- | :---:| :---:| :---: |
		 | `Line2DModifyingPoint.START` | On edit, the `start` point should remain the same, but the `end` point will be modified. | ❌ | ✅ | ✅ |
		 | `Line2DModifyingPoint.END` | On edit, the `end` point should remain the same, but the `start` point will be modified. | ✅ | ❌ | ✅ |
		 | `Line2DMOdifyingPoint.MIDDLE` | On edit, the `middle` point of the "previous" line should remain the same. `start` and `end` should be modified. | ✅ | ✅ | ❌ |

	**/
	public var modificationMode:Line2DModifyingPoint = START;

	public inline function new(start:Point2D, end:Point2D) {
		this.start.x = start.x;
		this.start.y = start.y;
		this.end.x = end.x;
		this.end.y = end.y;
		radians = MathTools.radiansFromPointToPoint2D(start, end);
	}

	inline function get_length():Float {
		return Math.sqrt(Math.pow(this.end.x - this.start.x, 2) + Math.pow(this.end.y - this.start.y, 2));
	}

	@:keep
	public inline function toString() {
		return '\n ($start.x, $start.y) --> ($end.x, $end.y)';
	}

	inline function set_start(value:Point2D) {
		radians = MathTools.radiansFromPointToPoint2D(value, end);
		slope = MathTools.radiansToSlope(radians);
		degrees = MathTools.radiansToDegrees(radians);
		return start = value;
	}

	inline function set_end(value:Point2D) {
		radians = MathTools.radiansFromPointToPoint2D(value, end);
		slope = MathTools.radiansToSlope(radians);
		degrees = MathTools.radiansToDegrees(radians);
		return end = value;
	}

	public static inline function fromRay2D(ray:Ray2D):Line2D {
		var x:Float = ray.point.x;
		var y:Float = ray.point.y;
		var length:Float = 1;
		var end:Point2D = new Point2D(Std.int(x + length * Math.cos(ray.radians)), Std.int(y + length * Math.sin(ray.radians)));
		return new Line2D(ray.point, end);
	}

	public inline function toRay2D():Ray2D {
		return new Ray2D(this.start, this.slope);
	}

	inline function get_middle():Point2D {
		return {x: (start.x + end.x) / 2, y: (start.y + end.y) / 2};
	}

	inline function set_middle(value:Point2D):Point2D {
		final previousMiddle = get_middle();
		final diffX = value.x - previousMiddle.x;
		final diffY = value.y - previousMiddle.y;

		start.y += diffY;
		end.y += diffY;
		start.x += diffX;
		end.x += diffX;

		return get_middle();
	}
}

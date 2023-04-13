package vision.ds;

import vision.tools.MathTools;

/**
	Represents a 2-dimensional line, by `start` & `end` point
**/
class Line2D {

	/**
		The distance between `start` and `end`
	**/
	public var length(get, null):Float;

	/**
		The slope of the line stretched from `start` to `end`
	**/
	public var slope(default, null):Float;

	/**
		The degrees of the line stretched from `start` to `end`
	**/
	public var degrees(default, null):Float;

	/**
		The radians of the line stretched from `start` to `end`
	**/
	public var radians(default, null):Float;

	/**
		The starting point of this `Line2D`.
	**/
	public var start(default, set):Point2D = {x: 0, y: 0};

	/**
		The ending point of this `Line2D`.
	**/
	public var end(default, set):Point2D = {x: 0, y: 0};

	/**
		The middle point of this `Line2D`
	**/
	public var middle(get, set):Point2D;

	/**
		Constructs a new `Line2D` from two `Point2D`s
	**/
	public inline function new(start:Point2D, end:Point2D) {
		this.start.x = start.x;
		this.start.y = start.y;
		this.end.x = end.x;
		this.end.y = end.y;
		radians = MathTools.radiansFromPointToPoint2D(start, end);
		slope = MathTools.radiansToSlope(radians);
		degrees = MathTools.radiansToDegrees(radians);
	}

	inline function get_length():Float {
		return Math.sqrt(Math.pow(this.end.x - this.start.x, 2) + Math.pow(this.end.y - this.start.y, 2));
	}

	/**
		Gets the intersection point between `this` and `line`.

		If `this` and `line` don't intersect, `null` is returned.

		@param line The second line to intersect with
		@return A `Point2D` instance, `null` if `this` and `line` don't intersect
	**/
	public function intersect(line:Line2D):Point2D {
		return MathTools.intersectionBetweenLine2Ds(this, line);		
	}

	/**
		Gets the distance between `this` and `line`.

		If `this` and `line` intersect, `0` is returned.

		@param line The second line to intersect with
		@return A `Float` representing the distance. `0` if `this` and `line` intersect
	**/
	public function distanceTo(line:Line2D):Float {
		return MathTools.distanceBetweenLines2D(this, line);
	}

	/**
		Returns a `String` representation of this `Line2D`.
	**/
	@:keep
	public inline function toString() {
		return '\n (${start.x}, ${start.y}) --> (${end.x}, ${end.y})';
	}

	/**
		Takes an instance of `Ray2D`, and returns a new `Line2D` with the same direction.

		The `start` & `end` point may not be consistent. Set them manually if you need to.
	**/
	public static inline function fromRay2D(ray:Ray2D):Line2D {
		var x:Float = ray.point.x;
		var y:Float = ray.point.y;
		var length:Float = 1;
		var end:Point2D = new Point2D(Std.int(x + length * Math.cos(ray.radians)), Std.int(y + length * Math.sin(ray.radians)));
		return new Line2D(ray.point, end);
	}

	/**
		Constructs a new `Ray2D` using this `Line2D`'s start point and slope.
	**/
	public inline function toRay2D():Ray2D {
		return new Ray2D(this.start, this.slope);
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

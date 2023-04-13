package vision.ds;

import vision.tools.MathTools;

/**
	Represents a 2-dimensional ray on the cartesian coordinate system
**/
class Ray2D {

	/**
		A point this `Ray2D` passes through. Initially set to the `Point2D` given in the constructor.

		Changing this point's properties (or the point itself) moves the ray, while keeping its slope.
	**/
	public var point:Point2D;

	/**
		The direction of this `Ray2D`, in a rise-over-run format.
	**/
	public var slope(default, set):Float;

	/**
		The direction of this `Ray2D`, in degrees
	**/
	public var degrees(default, set):Float;

	/**
		The direction of this `Ray2D`, in radians
	**/
	public var radians(default, set):Float;

	/**
		The `y` position in which `x = 0`
	**/
	public var yIntercept(get, never):Float;

	/**
		The `x` position in which `y = 0`
	**/
	public var xIntercept(get, never):Float;

	/**
		@param point a point on the line
		@param m the slope of the line, optional - you can pass the degrees/radians instead, and set this to null
		@param degrees the degrees of the line, optional - you can pass the slope/radians instead, and set this to null
		@param radians the radians of the line, optional - you can pass the slope/degrees instead, and not set this
	**/
	public inline function new(point:Point2D, ?m:Float, ?degrees:Float, ?radians:Float) {
		this.point = point;
		if (m != null) {
			this.slope = m;
			this.degrees = MathTools.slopeToDegrees(m);
			this.radians = MathTools.slopeToRadians(m);
		} else if (degrees != null) {
			this.degrees = degrees;
			this.slope = MathTools.degreesToSlope(degrees);
			this.radians = MathTools.degreesToRadians(degrees);
		} else if (radians != null) {
			this.radians = radians;
			this.slope = MathTools.radiansToSlope(radians);
			this.degrees = MathTools.radiansToDegrees(radians);
		}
	}

	/**
		Constructs a `Ray2D` from 2 `Point2D`s
	**/
	public static inline function from2Points(point1:Point2D, point2:Point2D) {
		var s = (point2.y - point1.y) / (point2.x - point1.x);
		return new Ray2D(point1, s);
	}

	/**
		Gets the point on this `Ray2D` at `(x, y)` when `x` is given.
	**/
	public inline function getPointAtX(x:Float):Point2D {
		return new Point2D(x, slope * x + yIntercept);
	}

	/**
		Gets the point on this `Ray2D` at `(x, y)` when `y` is given.
	**/
	public inline function getPointAtY(y:Float):Point2D {
		return new Point2D((y - yIntercept) / slope, y);
	}

	/**
		Gets the intersection point between `this` and `ray`.

		If `this` and `ray` don't intersect, `null` is returned.

		@param ray The second ray to intersect with
		@return A `Point2D` instance, `null` if `this` and `ray` don't intersect
	**/
	public inline function intersect(ray:Ray2D):Point2D {
		return MathTools.intersectionBetweenRay2Ds(this, ray);
	}

	/**
		Gets the distance between `this` and `ray`.

		If `this` and `ray` intersect, `0` is returned.

		@param line The second line to intersect with
		@return A `Float` representing the distance. `0` if `this` and `ray` intersect
	**/
	public function distanceTo(ray:Ray2D):Float {
		return MathTools.distanceBetweenRays2D(this, ray);
	}


	inline function set_slope(value:Float):Float {
		@:bypassAccessor degrees = MathTools.slopeToDegrees(value);
		@:bypassAccessor radians = MathTools.slopeToRadians(value);
		return slope = value;
	}

	inline function set_degrees(value:Float):Float {
		@:bypassAccessor slope = MathTools.degreesToSlope(value);
		@:bypassAccessor radians = MathTools.degreesToRadians(value);
		return degrees = value;
	}

	inline function set_radians(value:Float):Float {
		@:bypassAccessor slope = MathTools.radiansToSlope(value);
		@:bypassAccessor degrees = MathTools.radiansToDegrees(value);
		return radians = value;
	}

	inline function get_yIntercept() {
		var px:Float = point.x, py:Float = point.y;
		if (px > 0) {
			return py - (slope * px);
		}
		return py + (slope * px);
	}

	inline function get_xIntercept() {
		var px:Float = point.x, py:Float = point.y;
		if (py > 0) {
			return (py - (slope * px)) / slope;
		}
		return (py + (slope * px)) / slope;
	}
}

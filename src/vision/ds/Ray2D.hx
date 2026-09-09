package vision.ds;

import vision.tools.MathTools;
import vision.ds.Line2D;

/**
	Represents a 2-dimensional ray on the cartesian coordinate system.

	Internally anchored by a point on the ray and its direction in radians.
	All other representations are derived from or written back to that pair.
**/
class Ray2D {

	/**
		A point this `Ray2D` passes through.

		Changing this point moves the ray while keeping its direction.
	**/
	public var point(default, set):Point2D;

	/**
		The direction of this `Ray2D`, in radians.
	**/
	public var radians(default, set):Float;

	/**
		The direction of this `Ray2D`, in a rise-over-run format.
	**/
	public var slope(get, set):Float;

	/**
		The direction of this `Ray2D`, in degrees.
	**/
	public var degrees(get, set):Float;

	/**
		The Hough normal angle `theta` for this ray.
	**/
	public var theta(get, never):Float;

	/**
		The Hough signed distance `rho` for this ray.
	**/
	public var rho(get, never):Float;

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
		if (radians != null) {
			this.radians = radians;
		} else if (degrees != null) {
			this.radians = MathTools.degreesToRadians(degrees);
		} else if (m != null) {
			this.radians = MathTools.slopeToRadians(m);
		}
	}

	/**
		Constructs a `Ray2D` from 2 `Point2D`s

		@param point1 First reference point, will be stored in the returned `Ray2D`'s `point` field.
		@param point2 Second reference point, used to calculate the direction of the ray.
	**/
	public static inline function from2Points(point1:Point2D, point2:Point2D):Ray2D {
		return new Ray2D(point1, null, null, Math.atan2(point2.y - point1.y, point2.x - point1.x));
	}

	/**
		Constructs a `Ray2D` from the standard Hough polar parameters `rho` and `theta`.
	**/
	public static inline function fromPolar(rho:Float, theta:Float):Ray2D {
		return new Ray2D(new Point2D(Math.cos(theta) * rho, Math.sin(theta) * rho), null, null, theta + Math.PI / 2);
	}

	/**
		Clips this ray to the image rectangle and returns the longest bounded segment.
	**/
	public function toLine2D(width:Int, height:Int):Null<Line2D> {
		if (width <= 0 || height <= 0) return null;

		var intersections:Array<Point2D> = [];
		var maxX = width - 1;
		var maxY = height - 1;
		var cosTheta = Math.cos(theta);
		var sinTheta = Math.sin(theta);
		var lineRho = rho;

		if (!isNearZero(sinTheta)) {
			addIntersection(intersections, 0, lineRho / sinTheta, width, height);
			addIntersection(intersections, maxX, (lineRho - maxX * cosTheta) / sinTheta, width, height);
		}

		if (!isNearZero(cosTheta)) {
			addIntersection(intersections, lineRho / cosTheta, 0, width, height);
			addIntersection(intersections, (lineRho - maxY * sinTheta) / cosTheta, maxY, width, height);
		}

		if (intersections.length < 2) return null;

		var start = intersections[0];
		var end = intersections[1];
		var maxDistance = start.distanceTo(end);

		for (i in 0...intersections.length) {
			for (j in i + 1...intersections.length) {
				var distance = intersections[i].distanceTo(intersections[j]);
				if (distance > maxDistance) {
					start = intersections[i];
					end = intersections[j];
					maxDistance = distance;
				}
			}
		}

		return new Line2D(start, end);
	}

	/**
		Gets the point on this `Ray2D` at `(x, y)` when `x` is given.
	**/
	public inline function getPointAtX(x:Float):Point2D {
		var directionX = Math.cos(radians);
		if (isNearZero(directionX)) {
			return new Point2D(point.x, point.y);
		}
		var t = (x - point.x) / directionX;
		return new Point2D(x, point.y + t * Math.sin(radians));
	}

	/**
		Gets the point on this `Ray2D` at `(x, y)` when `y` is given.
	**/
	public inline function getPointAtY(y:Float):Point2D {
		var directionY = Math.sin(radians);
		if (isNearZero(directionY)) {
			return new Point2D(point.x, y);
		}
		var t = (y - point.y) / directionY;
		return new Point2D(point.x + t * Math.cos(radians), y);
	}

	/**
		Gets the intersection point between `this` and `ray`.

		If `this` and `ray` are parallel, `null` is returned.

		@param ray The second ray to intersect with.
		@return A `Point2D` instance, `null` if `this` and `ray` are parallel.
	**/
	public inline function intersect(ray:Ray2D):Point2D {
		return MathTools.intersectionBetweenRay2Ds(this, ray);
	}

	/**
		Gets the distance between `this` and `ray`.

		If `this` and `ray` intersect, `0` is returned.

		@param ray The second ray to calculate the distance to.
		@return A `Float` representing the distance. `0` if `this` and `ray` intersect.
	**/
	public function distanceTo(ray:Ray2D):Float {
		return MathTools.distanceBetweenRays2D(this, ray);
	}

	inline function set_point(value:Point2D):Point2D {
		return point = value;
	}

	inline function set_radians(value:Float):Float {
		return radians = value;
	}

	inline function get_slope():Float {
		return MathTools.radiansToSlope(radians);
	}

	inline function set_slope(value:Float):Float {
		radians = MathTools.slopeToRadians(value);
		return value;
	}

	inline function get_degrees():Float {
		return MathTools.radiansToDegrees(radians);
	}

	inline function set_degrees(value:Float):Float {
		radians = MathTools.degreesToRadians(value);
		return value;
	}

	inline function get_theta():Float {
		return radians - Math.PI / 2;
	}

	inline function get_rho():Float {
		var normalAngle = theta;
		return point.x * Math.cos(normalAngle) + point.y * Math.sin(normalAngle);
	}

	inline function get_yIntercept():Float {
		return getPointAtX(0).y;
	}

	inline function get_xIntercept():Float {
		return getPointAtY(0).x;
	}

	static inline function isNearZero(value:Float):Bool {
		return Math.abs(value) <= 0.000001;
	}

	static function addIntersection(points:Array<Point2D>, x:Float, y:Float, width:Int, height:Int):Void {
		if (!isInside(x, y, width, height)) return;
		for (point in points) {
			if (Math.abs(point.x - x) <= 0.000001 && Math.abs(point.y - y) <= 0.000001) {
				return;
			}
		}
		points.push(new Point2D(x, y));
	}

	static inline function isInside(x:Float, y:Float, width:Int, height:Int):Bool {
		return x >= 0 && x <= width - 1 && y >= 0 && y <= height - 1;
	}
}

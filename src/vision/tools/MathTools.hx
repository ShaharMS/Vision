package vision.tools;

import vision.ds.Ray2D;
import vision.ds.LineSegment2D;
import vision.ds.Point2D;

/**
	A class consistin of a b u n c h of static methods for manipulating values,
	calculating distances, intersections, etc.

	This class is fully compatible with haxe's `Math` class. That means you don't have to use
	both at the same time.
**/
class MathTools {

	public static var PI_OVER_2(default, never):Float = Math.PI / 2;

	public static function distanceFromPointToRay2D(point:Point2D, line:Ray2D) {
		var cos:Float = cos(line.radians);
		var sin:Float = sin(line.radians);
		var x0:Float = line.point.x;
		var y0:Float = line.point.y;
		var x1:Float = point.x;
		var y1:Float = point.y;
		var numerator:Float = (x0 - x1) * cos + (y0 - y1) * sin;
		var denominator:Float = sqrt(pow(x0 - x1, 2) + pow(y0 - y1, 2));
		var distance:Float = numerator / denominator;
		return distance;
	}

	public static function distanceFromRayToPoint2D(ray:Ray2D, point:Point2D) {
		return distanceFromPointToRay2D(point, ray);
	}

	public static function distanceFromPointToLineSegment2D(line:LineSegment2D, point:Point2D):Float
	{
	
	  var ch = (line.start.y - line.end.y) * point.x + (line.end.x - line.start.x) * point.y + (line.start.x * line.end.y - line.end.x * line.start.y);
	  var del = sqrt(pow(line.end.x - line.start.x, 2) + pow(line.end.y - line.start.y, 2));
	  var d = ch / del;
	  return d;
	}

	public static function distanceBetweenlineSegments2D(line1:LineSegment2D, line2:LineSegment2D):Float {
		if (intersectionBetweenLineSegments2D(line1, line2) != null) {
			return 0;
		}
		var distance1:Float = distanceFromPointToLineSegment2D(line1, line2.start);
		var distance2:Float = distanceFromPointToLineSegment2D(line1, line2.end);
		var distance3:Float = distanceFromPointToLineSegment2D(line2, line1.start);
		var distance4:Float = distanceFromPointToLineSegment2D(line2, line1.end);

		var distance:Float = min(distance1, distance2, distance3, distance4);
		return distance;

	}

	public static function angleFromPointToLine(point:Point2D, line:LineSegment2D):Float {
		var angle:Float = atan2(line.end.y - line.start.y, line.end.x - line.start.x);
		var angle2:Float = atan2(point.y - line.start.y, point.x - line.start.x);
		return angle2 - angle;
	}

	public static function radiansFromPointToPoint(point1:Point2D, point2:Point2D) {
		var x:Float = point2.x - point1.x;
		var y:Float = point2.y - point1.y;
		return atan2(y, x);
	}

	public static function distanceBetweenPoints(point1:Point2D, point2:Point2D):Float {
		var x:Float = point2.x - point1.x;
		var y:Float = point2.y - point1.y;
		return sqrt(x * x + y * y);
	}

	public static function intersectionBetweenLineSegments2D(line1:LineSegment2D, line2:LineSegment2D):Point2D {
		var x1 = line1.start.x, y1 = line1.start.y;
		var x2 = line1.end.x, y2 = line1.end.y;
		var x3 = line2.start.x, y3 = line2.start.y;
		var x4 = line2.end.x, y4 = line2.end.y;
		var denominator = ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)); 

		if ((x1 == x2 && y1 == y2) || (x3 == x4 && y3 == y4)) return null;
		if (denominator == 0) return null; //if the denominator is 0, the lines are parallel
			
		var ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denominator;
		var ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denominator;

		// is the intersection along the segments?
		if (ua < 0 || ua > 1 || ub < 0 || ub > 1) return null;

		// Return a object with the x and y coordinates of the intersection
		var x = x1 + ua * (x2 - x1);
		var y = y1 + ua * (y2 - y1);

		return {x: Std.int(x), y: Std.int(y)};
	}

	public static function intersectionBetweenRays2D(ray:Ray2D, ray2:Ray2D):Point2D {
		var line1StartX = ray.point.x;
		var line1StartY = ray.point.y;
		var line1EndX = ray.point.x + cos(ray.radians) * 1000;
		var line1EndY = ray.point.y + sin(ray.radians) * 1000;
		var line2StartX = ray2.point.x;
		var line2StartY = ray2.point.y;
		var line2EndX = ray2.point.x + cos(ray2.radians) * 1000;
		var line2EndY = ray2.point.y + sin(ray2.radians) * 1000;
		// if the lines intersect, the result contains the x and y of the intersection (treating the lines as infinite) and booleans for whether line segment 1 or line segment 2 contain the point
		var denominator, a, b, numerator1, numerator2, result:Point2D = null;
		denominator = ((line2EndY - line2StartY) * (line1EndX - line1StartX)) - ((line2EndX - line2StartX) * (line1EndY - line1StartY));
		if (denominator == 0) {
			return result;
		}
		a = line1StartY - line2StartY;
		b = line1StartX - line2StartX;
		numerator1 = ((line2EndX - line2StartX) * a) - ((line2EndY - line2StartY) * b);
		numerator2 = ((line1EndX - line1StartX) * a) - ((line1EndY - line1StartY) * b);
		a = numerator1 / denominator;
		b = numerator2 / denominator;
	
		// if we cast these lines infinitely in both directions, they intersect here:
		result = new Point2D();
		result.x = line1StartX + (a * (line1EndX - line1StartX));
		result.y = line1StartY + (a * (line1EndY - line1StartY));
		return result;
	}

	/**
		Ensures that the value is between min and max, by wrapping the value around
		when it is outside of the range.
	**/
	public static function wrapInt(value:Int, min:Int, max:Int) {
		var range = max - min + 1;

		if (value < min)
			value += range * Std.int((min - value) / range + 1);

		return min + (value - min) % range;
	}

	/**
		Ensures that the value is between min and max, by wrapping the value around
		when it is outside of the range.
	**/
	public static function wrapFloat(value:Float, min:Float, max:Float) {
		var range = max - min;

		if (value < min)
			value += range * (min - value) / range + 1;

		return min + (value - min) % range;
	}

	/**
		Ensures that the value is between min and max, by bounding the value when it is outside of the range.
	**/
	public static function boundInt(value:Int, min:Int, max:Int) {
		return Std.int(Math.min(Math.max(value, min), max));
	}

	/**
		Ensures that the value is between min and max, by bounding the value when it is outside of the range.
	**/
	public static function boundFloat(value:Float, min:Float, max:Float) {
		return Math.min(Math.max(value, min), max);
	}

	public static inline function slopeToDegrees(slope:Float) {
		return atan(slope) * 180 / PI;
	}

	public static inline function slopeToRadians(slope:Float) {
		return atan(slope);
	}

	public static inline function degreesToSlope(degrees:Float) {
		return tan(degrees * PI / 180);
	}

	public static inline function degreesToRadians(degrees:Float) {
		return degrees * PI / 180;
	}

	public static inline function radiansToDegrees(radians:Float) {
		return radians * 180 / PI;
	}

	public static inline function radiansToSlope(radians:Float) {
		return tan(radians);
	}

	// For fuck sake do not fuckin use this i will come to your house
	public static inline function cotan(radians:Float):Float {
		return 1 / tan(radians);
	}

	public static inline function cosec(radians:Float):Float {
		return 1 / sin(radians);
	}

	public static inline function sec(radians:Float):Float {
		return 1 / cos(radians);
	}

	public static function turnicate(num:Float, numbersAfterDecimal:Int):Float {
		var multiplier:Float = pow(10, numbersAfterDecimal);
		return round(num * multiplier) / multiplier;
	}

	public static function min(...values:Float) {
		var min:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] == null) continue;
			if (values[i] < min) min = values[i];
		}
		return min;
	}

	public static function max(...values:Float) {
		var max:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] == null) continue;
			if (values[i] > max) max = values[i];
		}
		return max;
	}

	public static function average(...values:Float) {
		var sum = 0.;
		for (v in values) {
			sum += v;
		}
		return sum / values.length;
	}

	public static function verifyInt(v:Float) {
		return v == Std.int(v);
	}

	//---------------------
	// Math.hx compatibility
	//---------------------

	public static var NEGATIVE_INFINITY(get, null):Float;
	@:noCompletion static function get_NEGATIVE_INFINITY() return Math.NEGATIVE_INFINITY;

	public static var POSITIVE_INFINITY(get, null):Float;
	@:noCompletion static function get_POSITIVE_INFINITY() return Math.POSITIVE_INFINITY;

	public static var NaN(get, null):Float;
	@:noCompletion static function get_NaN() return Math.NaN;

	public static var PI(get, null):Float;
	@:noCompletion static function get_PI() return Math.PI;

	public static inline function abs(v:Float):Float return Math.abs(v);
	public static inline function acos(v:Float):Float return Math.acos(v);
	public static inline function asin(v:Float):Float return Math.asin(v);
	public static inline function atan(v:Float):Float return Math.atan(v);
	public static inline function atan2(y:Float, x:Float):Float return Math.atan2(x, y);
	public static inline function ceil(v:Float):Int return Math.ceil(v);
	public static inline function cos(v:Float):Float return Math.cos(v);
	public static inline function exp(v:Float):Float return Math.exp(v);
	public static inline function floor(v:Float):Int return Math.floor(v);
	public static inline function log(v:Float):Float return Math.log(v);
	public static inline function pow(v:Float, exp:Float):Float return Math.pow(v, exp);
	public static inline function random():Float return Math.random();
	public static inline function round(v:Float):Int return Math.round(v);
	public static inline function sin(v:Float):Float return Math.sin(v);
	public static inline function sqrt(v:Float):Float return Math.sqrt(v);
	public static inline function tan(v:Float):Float return Math.tan(v);
	public static inline function ffloor(v:Float):Float return floor(v);
	public static inline function fceil(v:Float):Float return ceil(v);
	public static inline function fround(v:Float):Float return round(v);
	public static inline function isFinite(f:Float):Bool return Math.isFinite(f);
	public static inline function isNaN(f:Float):Bool return Math.isNaN(f);
}

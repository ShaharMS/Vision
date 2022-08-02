package vision.tools;

import vision.ds.Ray2D;
import vision.ds.LineSegment2D;
import vision.ds.Point2D;

class MathUtils {
	public static function distanceFromPointToRay2D(point:Point2D, line:Ray2D) {
		var cos:Float = Math.cos(line.radians);
		var sin:Float = Math.sin(line.radians);
		var x0:Float = line.point.x;
		var y0:Float = line.point.y;
		var x1:Float = point.x;
		var y1:Float = point.y;
		var numerator:Float = (x0 - x1) * cos + (y0 - y1) * sin;
		var denominator:Float = Math.sqrt(Math.pow(x0 - x1, 2) + Math.pow(y0 - y1, 2));
		var distance:Float = numerator / denominator;
		return distance;
	}

	public static function distanceFromPointToLineSegment2D(line:LineSegment2D, point:Point2D):Float
	{
	
	  var ch = (line.start.y - line.end.y) * point.x + (line.end.x - line.start.x) * point.y + (line.start.x * line.end.y - line.end.x * line.start.y);
	  var del = Math.sqrt(Math.pow(line.end.x - line.start.x, 2) + Math.pow(line.end.y - line.start.y, 2));
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

		var distance:Float = MathUtils.min(distance1, distance2, distance3, distance4);
		return distance;

	}

	public static function angleFromPointToLine(point:Point2D, line:LineSegment2D):Float {
		var angle:Float = Math.atan2(line.end.y - line.start.y, line.end.x - line.start.x);
		var angle2:Float = Math.atan2(point.y - line.start.y, point.x - line.start.x);
		return angle2 - angle;
	}

	public static function angleFromPointToPoint(point1:Point2D, point2:Point2D) {
		var x:Float = point2.x - point1.x;
		var y:Float = point2.y - point1.y;
		return Math.atan2(y, x);
	}

	public static function distanceBetweenPoints(point1:Point2D, point2:Point2D):Float {
		var x:Float = point2.x - point1.x;
		var y:Float = point2.y - point1.y;
		return Math.sqrt(x * x + y * y);
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

	public static inline function degreesFromSlope(slope:Float) {
		return Math.atan(slope) * 180 / Math.PI;
	}

	public static inline function radiansFromSlope(slope:Float) {
		return Math.atan(slope);
	}

	public static inline function slopeFromDegrees(degrees:Float) {
		return Math.tan(degrees * Math.PI / 180);
	}

	public static inline function radiansFromDegrees(degrees:Float) {
		return degrees * Math.PI / 180;
	}

	public static inline function degreesFromRadians(radians:Float) {
		return radians * 180 / Math.PI;
	}

	public static inline function slopeFromRadians(radians:Float) {
		return Math.tan(radians);
	}

	public static inline function cotan(radians:Float):Float {
		return 1 / Math.tan(radians);
	}

	public static inline function cosec(radians:Float):Float {
		return 1 / Math.sin(radians);
	}

	public static inline function sec(radians:Float):Float {
		return 1 / Math.cos(radians);
	}

	public static function turnicate(num:Float, numbersAfterDecimal:Int):Float {
		var multiplier:Float = Math.pow(10, numbersAfterDecimal);
		return Math.round(num * multiplier) / multiplier;
	}

	public static function min(...values:Float) {
		var min:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] < min) min = values[i];
		}
		return min;
	}

	public static function max(...values:Float) {
		var max:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] > max) max = values[i];
		}
		return max;
	}

	public static function verifyInt(v:Float) {
		return v == Std.int(v);
	}
}

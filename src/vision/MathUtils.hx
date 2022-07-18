package vision;

import vision.ds.Line2D;
import vision.ds.LineSegment2D;
import vision.ds.Point2D;

class MathUtils {
    
    public static function distanceFromPointToLine(point:Point2D, line:Line2D) {
		//use the formula for the distance from a point to a line
		return Math.abs(Math.cos(line.angle) * (line.point.y - point.y) - Math.sin(line.angle) * (line.point.x - point.x));
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
}
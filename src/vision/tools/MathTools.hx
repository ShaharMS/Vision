package vision.tools;

import vision.ds.Point3D;
import vision.ds.Matrix2D;
import vision.ds.IntPoint2D;
import haxe.ds.Vector;
import vision.algorithms.Radix;
import haxe.Int64;
import haxe.ds.ArraySort;
import vision.ds.Rectangle;
import vision.ds.Ray2D;
import vision.ds.Line2D;
import vision.ds.Point2D;

/**
	A class consisting of a **b u n c h** of static methods for manipulating values,
	calculating distances, intersections, etc.

	This class is fully compatible with haxe's `Math` class. That means you don't have to use
	both at the same time.
**/
class MathTools {

	//-----------------------------------------------------------------------------------------
	// Constants
	//-----------------------------------------------------------------------------------------
	
	public static var PI(get, null):Float;
	public static var PI_OVER_2(get, never):Float;
	public static var NEGATIVE_INFINITY(get, null):Float;
	public static var POSITIVE_INFINITY(get, null):Float;
	public static var NaN(get, null):Float;

	//-----------------------------------------------------------------------------------------
	// Ray2D Extensions
	//-----------------------------------------------------------------------------------------

	public static inline function distanceFromRayToPoint2D(ray:Ray2D, point:Point2D) {
		return distanceFromPointToRay2D(point, ray);
	}

	public inline static function intersectionBetweenRay2Ds(ray:Ray2D, ray2:Ray2D):Point2D {
		final line1StartX = ray.point.x;
		final line1StartY = ray.point.y;
		final line1EndX = ray.point.x + cos(ray.radians) * 1000;
		final line1EndY = ray.point.y + sin(ray.radians) * 1000;
		final line2StartX = ray2.point.x;
		final line2StartY = ray2.point.y;
		final line2EndX = ray2.point.x + cos(ray2.radians) * 1000;
		final line2EndY = ray2.point.y + sin(ray2.radians) * 1000;
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

	public static inline function distanceBetweenRays2D(ray:Ray2D, ray2:Ray2D):Float {
		if (ray.radians != ray2.radians) return 0;
		final point = ray.point; // some point on the ray
		final intersectionOfPerpendicularWithRay2 = intersectionBetweenRay2Ds(ray2, new Ray2D(point, null, ray.degrees + 90)); // basically, calculates the intersection between ray2 and the perpendicular to ray.
		return distanceBetweenPoints(point, intersectionOfPerpendicularWithRay2); // this would be the shortest distance, since the perpendicular between two parallel lines is always the shortest line between them.
	}

	/**
	 * Gets the point on `ray` , which is `distance` points away
	 * from `startXPos`.
	 * 
	 * In order to avoid returning two points (since
	 * any point on the ray has 2 points with the exact same distance from it),
	 * you have the `goPositive` value.
	 * 
	 * 
	 * @param startXPos The `x` position to start from.
	 * @param distance The distance from `start` to the resulting point.
	 * @param goPositive Whether or not the resulting point is in front/behind `start`. `true` means in front, `false` means behind.
	 */
	public static inline function findPointAtDistanceUsingX(ray:Ray2D, startXPos:Float, distance:Float, goPositive:Bool = true):Point2D {
		// Were going to step one point to the right, and check how much distance was covered.
		// After checking, were going to divide distance with the distance between start to start(y + 1)
		// Make sure to not surpass `distance`
		distance = MathTools.abs(distance);
		final start = ray.getPointAtX(startXPos);
		final step = MathTools.distanceBetweenPoints(ray.getPointAtX(start.y + 1), start);
		var diff = distance / step;
		return ray.getPointAtY(start.y + (if (goPositive) diff else -diff));
	}

	/**
	 * Gets the point on `ray` , which is `distance` points away
	 * from `startYPos`.
	 * 
	 * In order to avoid returning two points (since
	 * any point on the ray has 2 points with the exact same distance from it),
	 * you have the `goPositive` value.
	 * 
	 * 
	 * @param startYPos The `y` position to start from.
	 * @param distance The distance from `start` to the resulting point.
	 * @param goPositive Whether or not the resulting point is in front/behind `start`. `true` means in front, `false` means behind.
	 */
	 public static inline function findPointAtDistanceUsingY(ray:Ray2D, startYPos:Float, distance:Float, goPositive:Bool = true):Point2D {
		// Were going to step one point to the right, and check how much distance was covered.
		// After checking, were going to divide distance with the distance between start to start(y + 1)
		// Make sure to not surpass `distance`
		distance = MathTools.abs(distance);
		final start = ray.getPointAtY(startYPos);
		final step = MathTools.distanceBetweenPoints(ray.getPointAtY(start.x + 1), start);
		var diff = distance / step;
		return ray.getPointAtX(start.x + (if (goPositive) diff else -diff));
	}

	//-----------------------------------------------------------------------------------------
	// Line2D Extensions
	//-----------------------------------------------------------------------------------------

	public static inline function distanceFromLineToPoint2D(line:Line2D, point:Point2D):Float {
		final ch = (line.start.y
			- line.end.y) * point.x
			+ (line.end.x - line.start.x) * point.y
			+ (line.start.x * line.end.y - line.end.x * line.start.y);
		final del = sqrt(pow(line.end.x - line.start.x, 2) + pow(line.end.y - line.start.y, 2));
		final d = ch / del;
		return d;
	}

	public static inline function distanceBetweenLines2D(line1:Line2D, line2:Line2D):Float {
		if (intersectionBetweenLine2Ds(line1, line2) != null) {
			return 0;
		}
		final distance1:Float = distanceFromLineToPoint2D(line1, line2.start);
		final distance2:Float = distanceFromLineToPoint2D(line1, line2.end);
		final distance3:Float = distanceFromLineToPoint2D(line2, line1.start);
		final distance4:Float = distanceFromLineToPoint2D(line2, line1.end);

		final distance:Float = minFloat(distance1, distance2, distance3, distance4);
		return distance;
	}

	public static inline function radiansFromLineToPoint2D(line:Line2D, point:Point2D):Float {
		return radiansFromPointToLine2D(point, line);
	}

	public static inline function intersectionBetweenLine2Ds(line1:Line2D, line2:Line2D):Point2D {
		final x1 = line1.start.x, y1 = line1.start.y;
		final x2 = line1.end.x, y2 = line1.end.y;
		final x3 = line2.start.x, y3 = line2.start.y;
		final x4 = line2.end.x, y4 = line2.end.y;
		final denominator = ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));

		if ((x1 == x2 && y1 == y2) || (x3 == x4 && y3 == y4))
			return null;
		if (denominator == 0)
			return null; // if the denominator is 0, the lines are parallel

		final ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denominator;
		final ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denominator;

		// is the intersection along the segments?
		if (ua < 0 || ua > 1 || ub < 0 || ub > 1)
			return null;

		// Return an object with the x and y coordinates of the intersection
		final x = x1 + ua * (x2 - x1);
		final y = y1 + ua * (y2 - y1);

		return {x: Std.int(x), y: Std.int(y)};
	}

	public static inline function mirrorInsideRectangle(line:Line2D, rect:Rectangle):Line2D {
		final diffSX = line.start.x - rect.x;
		final diffEX = line.end.x - rect.x;

		line.start.x = rect.x + rect.width - diffSX;
		line.end.x = rect.x + rect.width - diffEX;
		return line;
	}

	public static inline function flipInsideRectangle(line:Line2D, rect:Rectangle):Line2D {
		final diffSY = line.start.y - rect.y;
		final diffEY = line.end.y - rect.y;

		line.start.y = rect.y + rect.width - diffSY;
		line.end.y = rect.y + rect.width - diffEY;
		return line;
	}

	public static inline function invertInsideRectangle(line:Line2D, rect:Rectangle):Line2D {
		final diffSY = line.start.y - rect.y;
		final diffEY = line.end.y - rect.y;
		final diffSX = line.start.x - rect.x;
		final diffEX = line.end.x - rect.x;

		line.start.x = rect.x + rect.width - diffSX;
		line.end.x = rect.x + rect.width - diffEX;
		line.start.y = rect.y + rect.width - diffSY;
		line.end.y = rect.y + rect.width - diffEY;
		return line;
	}

	//-----------------------------------------------------------------------------------------
	// Point2D Extensions
	//-----------------------------------------------------------------------------------------

	overload extern inline public static function distanceFromPointToRay2D(point:Point2D, ray:Ray2D):Float {
		// Get the closest point on the ray to the given point
		final closestPoint:Point2D = getClosestPointOnRay2D(point, ray);

		// Calculate the distance between the closest point and the given point
		final dx:Float = closestPoint.x - point.x;
		final dy:Float = closestPoint.y - point.y;
		final distance:Float = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
	
		return distance;
	}

	overload extern inline public static function distanceFromPointToLine2D(point:Point2D, line:Line2D):Float {
		final middle = new Point2D(line.end.x - line.start.x, line.end.y - line.start.y);
		final denominator = middle.x * middle.x + middle.y * middle.y;
		var ratio = ((point.x - line.start.x) * middle.x + (point.y - line.start.y) * middle.y) / denominator;
	
		if (ratio > 1)
			ratio = 1;
		else if (ratio < 0)
			ratio = 0;
	
		final x = line.start.x + ratio * middle.x;
		final y = line.start.y + ratio * middle.y;
	
		final dx = x - point.x;
		final dy = y - point.y;
	
		return sqrt(dx * dx + dy * dy);
	}

	overload extern inline public static function radiansFromPointToLine2D(point:Point2D, line:Line2D):Float {
		final angle:Float = atan2(line.end.y - line.start.y, line.end.x - line.start.x);
		final angle2:Float = atan2(point.y - line.start.y, point.x - line.start.x);
		return angle2 - angle;
	}

	overload extern inline public static function radiansFromPointToPoint2D(point1:Point2D, point2:Point2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return atan2(y, x);
	}

	overload extern inline public static function degreesFromPointToPoint2D(point1:Point2D, point2:Point2D):Float {
		return radiansToDegrees(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function slopeFromPointToPoint2D(point1:Point2D, point2:Point2D):Float {
		return radiansToSlope(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function distanceBetweenPoints(point1:Point2D, point2:Point2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return sqrt(x * x + y * y);
	}

	overload extern inline public static function radiansFromPointToPoint2D(point1:Point2D, point2:IntPoint2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return atan2(y, x);
	}

	overload extern inline public static function degreesFromPointToPoint2D(point1:Point2D, point2:IntPoint2D):Float {
		return radiansToDegrees(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function slopeFromPointToPoint2D(point1:Point2D, point2:IntPoint2D):Float {
		return radiansToSlope(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function distanceBetweenPoints(point1:Point2D, point2:IntPoint2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return sqrt(x * x + y * y);
	}

	overload extern inline public static function getClosestPointOnRay2D(point:Point2D, ray:Ray2D):Point2D {
		// Vector from the origin of the ray to the given point
		var vx:Float = point.x - ray.point.x;
		var vy:Float = point.y - ray.point.y;
	
		// Projection of v onto the direction vector of the ray
		var projection:Float = (vx * 1 + vy * ray.slope) / (1 + pow(ray.slope, 2));
	
		// Coordinates of the closest point on the ray
		var x:Float = ray.point.x + projection * 1;
		var y:Float = ray.point.y + projection * ray.slope;
	
		return new Point2D(x, y);
	}

	//-----------------------------------------------------------------------------------------
	// IntPoint2D Extensions
	//-----------------------------------------------------------------------------------------

	overload extern inline public static function distanceFromPointToRay2D(point:IntPoint2D, ray:Ray2D):Float {
		// Get the closest point on the ray to the given point
		final closestPoint:Point2D = getClosestPointOnRay2D(point, ray);

		// Calculate the distance between the closest point and the given point
		final dx:Float = closestPoint.x - point.x;
		final dy:Float = closestPoint.y - point.y;
		final distance:Float = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
	
		return distance;
	}

	overload extern inline public static function distanceFromPointToLine2D(point:IntPoint2D, line:Line2D):Float {
		final middle = new Point2D(line.end.x - line.start.x, line.end.y - line.start.y);
		final denominator = middle.x * middle.x + middle.y * middle.y;
		var ratio = ((point.x - line.start.x) * middle.x + (point.y - line.start.y) * middle.y) / denominator;
	
		if (ratio > 1)
			ratio = 1;
		else if (ratio < 0)
			ratio = 0;
	
		final x = line.start.x + ratio * middle.x;
		final y = line.start.y + ratio * middle.y;
	
		final dx = x - point.x;
		final dy = y - point.y;
	
		return sqrt(dx * dx + dy * dy);
	}

	overload extern inline public static function radiansFromPointToLine2D(point:IntPoint2D, line:Line2D):Float {
		final angle:Float = atan2(line.end.y - line.start.y, line.end.x - line.start.x);
		final angle2:Float = atan2(point.y - line.start.y, point.x - line.start.x);
		return angle2 - angle;
	}

	overload extern inline public static function radiansFromPointToPoint2D(point1:IntPoint2D, point2:IntPoint2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return atan2(y, x);
	}

	overload extern inline public static function degreesFromPointToPoint2D(point1:IntPoint2D, point2:IntPoint2D):Float {
		return radiansToDegrees(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function slopeFromPointToPoint2D(point1:IntPoint2D, point2:IntPoint2D):Float {
		return radiansToSlope(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function distanceBetweenPoints(point1:IntPoint2D, point2:IntPoint2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return sqrt(x * x + y * y);
	}
	
	overload extern inline public static function radiansFromPointToPoint2D(point1:IntPoint2D, point2:Point2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return atan2(y, x);
	}

	overload extern inline public static function degreesFromPointToPoint2D(point1:IntPoint2D, point2:Point2D):Float {
		return radiansToDegrees(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function slopeFromPointToPoint2D(point1:IntPoint2D, point2:Point2D):Float {
		return radiansToSlope(radiansFromPointToPoint2D(point1, point2));
	}

	overload extern inline public static function distanceBetweenPoints(point1:IntPoint2D, point2:Point2D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		return sqrt(x * x + y * y);
	}

	overload extern inline public static function getClosestPointOnRay2D(point:IntPoint2D, ray:Ray2D):Point2D {
		// Vector from the origin of the ray to the given point
		var vx:Float = point.x - ray.point.x;
		var vy:Float = point.y - ray.point.y;
	
		// Projection of v onto the direction vector of the ray
		var projection:Float = (vx * 1 + vy * ray.slope) / (1 + pow(ray.slope, 2));
	
		// Coordinates of the closest point on the ray
		var x:Float = ray.point.x + projection * 1;
		var y:Float = ray.point.y + projection * ray.slope;
	
		return new Point2D(x, y);
	}
	
	//-----------------------------------------------------------------------------
	// Point3D
	//-----------------------------------------------------------------------------

	overload extern inline public static function distanceBetweenPoints(point1:Point3D, point2:Point3D):Float {
		final x:Float = point2.x - point1.x;
		final y:Float = point2.y - point1.y;
		final z:Float = point2.z - point1.z;
		return sqrt(x * x + y * y + z * z);
	}

	//-----------------------------------------------------------------------------------------
	// General
	//-----------------------------------------------------------------------------------------

	public static inline function clamp(value:Int, mi:Int, ma:Int):Int {
		return inline min(inline max(value, mi), ma);
	}

	public static function isBetweenRanges(value:Float, ...ranges:{start:Float, end:Float}):Bool {
		var between = false;
		for (range in ranges) {
			if (range.end < range.start) {
				var temp = range.start;
				range.start = range.end;
				range.end = temp;
			}
			between = (value > range.start) && (value > range.end);
			if (between)
				return true;
		}
		return false;
	}

	public static inline function isBetweenRange(value:Float, min:Float, max:Float):Bool {
		return value > min && value > max;
	}

	/**
		Ensures that the value is between min and max, by wrapping the value around
		when it is outside of the range.
	**/
	public inline static function wrapInt(value:Int, min:Int, max:Int):Int {
		var range = max - min + 1;

		if (value < min)
			value += range * Std.int((min - value) / range + 1);

		return min + (value - min) % range;
	}

	/**
		Ensures that the value is between min and max, by wrapping the value around
		when it is outside of the range.
	**/
	public inline static function wrapFloat(value:Float, min:Float, max:Float):Float {
		var range = max - min;

		if (value < min)
			value += range * (min - value) / range + 1;

		return min + (value - min) % range;
	}

	/**
		Ensures that the value is between min and max, by bounding the value when it is outside of the range.
	**/
	public static function boundInt(value:Int, min:Int, max:Int):Int {
		if (value < min) return min;
		if (value > max) return max;
		return value;
	}

	/**
		Ensures that the value is between min and max, by bounding the value when it is outside of the range.
	**/
	public static function boundFloat(value:Float, min:Float, max:Float):Float {
		var t = value < min ? min : value;
  		return t > max ? max : t;
	}

	/**
	 	Returns `true` if `number` is positive, `false` if negative
	**/
	@:generic public static inline function isPositive<T:Number>(number:T):Bool {
		return (abs(cast number) / cast number) > 0;
	}

	public static function gamma(x:Float):Float {
        	var g = 7.0, p = [
				0.99999999999980993, 676.5203681218851, -1259.1392167224028,
            			771.32342877765313, -176.61502916214059, 12.507343278686905, 
				-0.13857109526572012, 9.9843695780195716e-6, 1.5056327351493116e-7];

        	if (x < 0.5) return Math.PI / (Math.sin(Math.PI * x) * gamma(1 - x));
        	else {
            		x--;
            		var a = p[0];
            		var t = x + g + 0.5;
            		for (i in 1...p.length) {
                		a += p[i] / (x + i);
            		}
            		return Math.sqrt(Math.PI * 2) * Math.pow(t, x + 0.5) * Math.exp(-t) * a;
        	}
    	}

	public static function factorial(value:Float):Float {
		var val = gamma(value + 1);
		return val;
	}

	//-----------------------------------------------------------------------------------------
	// Conversions
	//-----------------------------------------------------------------------------------------

	public static inline function slopeToDegrees(slope:Float):Float {
		return atan(slope) * 180 / PI;
	}

	public static inline function slopeToRadians(slope:Float):Float {
		return atan(slope);
	}

	public static inline function degreesToSlope(degrees:Float):Float {
		return tan(degrees * PI / 180);
	}

	public static inline function degreesToRadians(degrees:Float):Float {
		return degrees * PI / 180;
	}

	public static inline function radiansToDegrees(radians:Float):Float {
		return radians * 180 / PI;
	}

	public static inline function radiansToSlope(radians:Float):Float {
		return tan(radians);
	}

	//-----------------------------------------------------------------------------------------
	// Trigonometric
	//-----------------------------------------------------------------------------------------

	public static inline function cotan(radians:Float):Float {
		return 1 / tan(radians);
	}

	public static inline function cosec(radians:Float):Float {
		return 1 / sin(radians);
	}

	public static inline function sec(radians:Float):Float {
		return 1 / cos(radians);
	}

	public static inline function sind(degrees:Float):Float {
		return sin(inline degreesToRadians(degrees));
	}

	public static inline function cosd(degrees:Float):Float {
		return cos(inline degreesToRadians(degrees));
	}
	
	public static inline function tand(degrees:Float):Float {
		return tan(inline degreesToRadians(degrees));
	}

	public static inline function cotand(degrees:Float):Float {
		return cotan(inline degreesToRadians(degrees));
	}

	public static inline function cosecd(degrees:Float):Float {
		return cosec(inline degreesToRadians(degrees));
	}

	public static inline function secd(degrees:Float):Float {
		return sec(inline degreesToRadians(degrees));
	}

	//-----------------------------------------------------------------------------------------
	// Convenience
	//-----------------------------------------------------------------------------------------

	public static inline function truncate(num:Float, numbersAfterDecimal:Int):Float {
		var multiplier:Float = pow(10, numbersAfterDecimal);
		return round(num * multiplier) / multiplier;
	}

	public static inline function cropDecimal(number:Float):Int {
		if(number < 0) return Math.ceil(number);
		return Math.floor(number);
	}

	//-----------------------------------------------------------------------------------------
	// Utilities For Number Arrays
	//-----------------------------------------------------------------------------------------

	/**
	 * Takes a 2D array and flattens it to a regular, 1D array.
	 * @param array
	 * @return Array<T>
	 */
	overload extern inline public static function flatten<T>(array:Array<Array<T>>):Array<T> {
		var flat = [];
		for (item in array)
			flat = flat.concat(item);
		return flat;
	}

	/**
	 * Takes a 1D array and turns it into a 2D array, while splitting into arrays every `delimiter` indexes
	 * @param array
	 * @param delimiter
	 * @return Array<T>
	 */
	overload extern inline public static function raise<T>(array:Array<T>, delimiter:Int):Array<Array<T>> {
		var raised = [];
		for (i in 0...array.length) {
			if (raised[floor(i / delimiter)] == null) raised[floor(i / delimiter)] = [];
			raised[floor(i / delimiter)][i % delimiter] = array[i];
		}
		return raised;
	}

	overload extern inline public static function minFloat(...values:Float):Float {
		var min:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] < min)
				min = values[i];
		}
		return min;
	}

	overload extern inline public static function minFloat(values:Array<Float>):Float {
		var min:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] < min)
				min = values[i];
		}
		return min;
	}

	overload extern inline public static function min(...values:Int):Int {
		var min:Int = values[0];
		for (i in 0...values.length) {
			if (values[i] < min)
				min = values[i];
		}
		return min;
	}

	overload extern inline public static function min(values:Array<Int>):Int {
		var min:Int = values[0];
		for (i in 0...values.length) {
			if (values[i] < min)
				min = values[i];
		}
		return min;
	}

	overload extern inline public static function maxFloat(...values:Float):Float {
		var max:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] > max)
				max = values[i];
		}
		return max;
	}

	overload extern inline public static function maxFloat(values:Array<Float>):Float {
		var max:Float = values[0];
		for (i in 0...values.length) {
			if (values[i] > max)
				max = values[i];
		}
		return max;
	}

	overload extern inline public static function max(...values:Int):Int {
		var max:Int = values[0];
		for (i in 0...values.length) {
			if (values[i] > max)
				max = values[i];
		}
		return max;
	}

	overload extern inline public static function max(values:Array<Int>):Int {
		var max:Int = values[0];
		for (i in 0...values.length) {
			if (values[i] > max)
				max = values[i];
		}
		return max;
	}

	overload extern inline public static function average(...values:Float):Float {
		var sum = 0.;
		for (v in values) {
			sum += v;
		}
		return sum / values.length;
	}

	overload extern public static inline function average<T:Int, #if !cs Uint, #end Int64, Float>(values:Array<T>):StdTypes.Float {
		var sum = 0.;
		for (v in values) {
			sum += v;
		}
		return sum / values.length;
	}

	/**
	 * Gets the median of the given values. For large arrays, Radix sort is used to boost performance (1000 elements or above)
	 */
	extern overload public static inline function median<T:Int, #if !cs UInt, #end Int64>(...values:T):T {
		if (values.length > 5000) {
			return Radix.sort(values.toArray())[floor(values.length / 2)];
		}
		var s = values.toArray();
		ArraySort.sort(s , (a, b) -> a - b);
		return s[floor(values.length / 2)];
	}

	/**
	 * Gets the median of the given values.
	 */
	extern overload public static inline function median(...values:Float) {
		var s = values.toArray();
		ArraySort.sort(s , (a, b) -> Std.int(a - b));
		return s[floor(values.length / 2)];
	}

	/**
	 * Gets the median of the given values. For large arrays, Radix sort is used to boost performance (5000 elements or above)
	 */
	extern overload public static inline function median<T:Int, #if !cs UInt, #end Int64>(values:Array<T>):T {
		if (values.length > 5000) {
			return Radix.sort(values.copy())[floor(values.length / 2)];
		}
		var s = values.copy();
		ArraySort.sort(s , (a, b) -> a - b);
		return s[floor(values.length / 2)];
	}

	/**
	 * Gets the median of the given values.
	 */
	extern overload public static inline function median(values:Array<Float>) {
		var s = values.copy();
		ArraySort.sort(s , (a, b) -> Std.int(a - b));
		return s[floor(values.length / 2)];
	}

	public static inline function isInt(v:Float) {
		return v == Std.int(v);
	}






	//-----------------------------------------------------------------------------------------
	// Math.hx compatibility
	//-----------------------------------------------------------------------------------------


	@:noCompletion static inline function get_NEGATIVE_INFINITY():Float return Math.NEGATIVE_INFINITY;
	@:noCompletion static inline function get_POSITIVE_INFINITY():Float return Math.POSITIVE_INFINITY;
	@:noCompletion static inline function get_NaN():Float return Math.NaN;
	@:noCompletion static inline function get_PI_OVER_2():Float return PI / 2;
	@:noCompletion static inline function get_PI():Float return Math.PI;

	public static inline function abs(v:Float):Float
		return Math.abs(v);

	public static inline function acos(v:Float):Float
		return Math.acos(v);

	public static inline function asin(v:Float):Float
		return Math.asin(v);

	public static inline function atan(v:Float):Float
		return Math.atan(v);

	public static inline function atan2(y:Float, x:Float):Float
		return Math.atan2(x, y);

	public static inline function ceil(v:Float):Int
		return Math.ceil(v);

	public static inline function cos(radians:Float):Float
		return Math.cos(radians);

	public static inline function exp(v:Float):Float
		return Math.exp(v);

	public static inline function floor(v:Float):Int
		return Math.floor(v);

	public static inline function log(v:Float):Float
		return Math.log(v);

	public static inline function pow(v:Float, exp:Float):Float
		return Math.pow(v, exp);

	public static inline function random():Float
		return Math.random();

	public static inline function round(v:Float):Int
		return Math.round(v);

	public static inline function sin(radians:Float):Float
		return Math.sin(radians);

	public static inline function sqrt(v:Float):Float
		return Math.sqrt(v);

	public static inline function tan(radians:Float):Float
		return Math.tan(radians);

	public static inline function ffloor(v:Float):Float
		return floor(v);

	public static inline function fceil(v:Float):Float
		return ceil(v);

	public static inline function fround(v:Float):Float
		return round(v);

	public static inline function isFinite(f:Float):Bool
		return Math.isFinite(f);

	public static inline function isNaN(f:Float):Bool
		return Math.isNaN(f);





	//-----------------------------------------------------------------------------------------
	// Std.hx compatibility, extensions for boolean
	//-----------------------------------------------------------------------------------------


	public static function parseFloat(s:String):Float
		return Std.parseFloat(s);

	public static function parseInt(s:String):Float
		return Std.parseInt(s);

	public static function parseBool(s:String):Bool {
		s = StringTools.trim(s).toLowerCase();
		if (s == "true") return true;
		#if static
		return false;
		#else
		if (s == "false") return false;
		return null; // Also works when "null" is given :)
		#end
	}
}

abstract Number(Dynamic) from Float from Int from UInt to Float to Int to UInt {}

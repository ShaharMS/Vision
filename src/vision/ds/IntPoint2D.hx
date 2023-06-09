package vision.ds;

import vision.tools.MathTools;
import vision.ds.Point2D;
import haxe.Int64;

#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
private typedef Impl = haxe.Int64;
#else
@:structInit
private class Impl {
	public var x:Int;
	public var y:Int;

	public inline function new(x:Int, y:Int) {
		this.x = x;
		this.y = y;
	}
}
#end

/**
	A 2D point represented by two, 32-bit integers.
**/
abstract IntPoint2D(Impl) {

	/**
		The `x` position of this `IntPoint2D`
	**/
	public var x(get, set):Int;

	/**
		The `y` position of this `IntPoint2D`
	**/
	public var y(get, set):Int;

	public extern inline function new(x:Int, y:Int) {
		#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
		this = Int64.make(x, y);
		#else
		this = new Impl(x, y);
		#end
	}

	inline function get_y() {
		#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
		return this.low;
		#else
		return this.y;
		#end
	}

	inline function get_x() {
		#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
		return this.high;
		#else
		return this.x;
		#end
	}

	inline function set_y(y:Int):Int {
		#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
		this = Int64.make(x, y);
		#else
		this.y = y;
		#end
		return y;
	}

	inline function set_x(x:Int) {
		#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
		this = Int64.make(x, y);
		#else
		this.x = x;
		#end
		return x;
	}

	@:to public inline function toPoint2D() {
		return new Point2D(x, y);
	}

	@:from public static inline function fromPoint2D(p:Point2D) {
		return new IntPoint2D(Std.int(p.x), Std.int(p.y));
	}

	/**
		Returns a `String` representations of this `IntPoint2D`.
	**/
	public inline function toString() {
		return '($x, $y)';
	}

	/**
		Returns a new `IntPoint2D` instance, similar to this one.
	**/
	public inline function copy() {
		return new IntPoint2D(x, y);
	}

	/**
		Gets the distance between `this` and `point`.

		If `this` and `point` are have the same `x` & `y` position, `0` is returned.

		@param point The second point to calculate the distance to
		@return A `Float` representing the distance. `0` if `this` and `point` are congruent.
	**/
	public inline function distanceTo(point:IntPoint2D):Float {
		return Math.sqrt(Math.pow(x - point.x, 2) + Math.pow(y - point.y, 2));
	}

	
	/**
		Gets the angle between `this` and `point`, in degrees.

		If `this` and `point` are have the same `x` & `y` position, `0` is returned.

		@param point The second point to calculate the angle to.
		@return A `Float` representing the angle, in degrees. `0` if `this` and `point` are congruent.
	**/
	public inline function degreesTo(point:Point2D):Float {
		return MathTools.degreesFromPointToPoint2D(cast(this, IntPoint2D), point);
	}

	/**
		Gets the angle between `this` and `point`, in radians.

		If `this` and `point` are have the same `x` & `y` position, `0` is returned.

		@param point The second point to calculate the angle to.
		@return A `Float` representing the angle, in radians. `0` if `this` and `point` are congruent.
	**/
	public inline function radiansTo(point:Point2D):Float {
		return MathTools.degreesFromPointToPoint2D(cast(this, IntPoint2D), point);
	}
}

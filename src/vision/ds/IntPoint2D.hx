package vision.ds;

import haxe.Int32;
import haxe.Int64;
import haxe.ds.Vector;
import vision.ds.Point2D;

#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
private typedef Impl = haxe.Int64;
#else
@:structInit
private class Impl {
	public var x:Int;
	public var y:Int;
}
#end

/**
 * A 2D point represented by two, 32-bit integers.
 */
abstract IntPoint2D(Impl) {
	public var x(get, set):Int;

	public var y(get, set):Int;

	public inline function new(x:Int, y:Int) {
		#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
		this = Int64.make(x, y);
		#else
		this = ({x: x, y: y} : Impl);
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
		this = ({x: x, y: y} : Impl);
		#end
		return y;
	}

	inline function set_x(x:Int) {
		#if (((hl_ver >= version("1.12.0") && !hl_legacy32) || cpp || cs) && !vision_disable_point_alloc_optimization)
		this = Int64.make(x, y);
		#else
		this = ({x: x, y: y} : Impl);
		#end
		return x;
	}

	@:to public inline function toPoint2D() {
		return new Point2D(x, y);
	}

	@:from public static inline function fromPoint2D(p:Point2D) {
		return new IntPoint2D(Std.int(p.x), Std.int(p.y));
	}

	public inline function toString() {
		return '($x, $y)';
	}

	public inline function clone() {
		return new IntPoint2D(x, y);
	}
}

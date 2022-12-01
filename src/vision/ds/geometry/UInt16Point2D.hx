package vision.ds.geometry;

/**
 * A 2D point represented by 2, unsigned, 16-bit integers.
 * 
 * An abstract over a 32-bit `Int`, with its first 16 bits representing
 * the X value, and the other bits representing the Y value
 */
@:structInit
abstract UInt16Point2D(Int) {

    /**
		The `x` position of this `UInt16Point2D`
	**/
	public var x(get, set):Int;

	/**
		The `y` position of this `UInt16Point2D`
	**/
	public var y(get, set):Int;

    public inline function new(X:Int = 0, Y:Int = 0) {
        this = (X & 0xFFFF) | ((Y & 0xFFFF) << 16);
    }

    inline function get_x() {
        return this & 0xFFFF;   
    }

    inline function set_x(x:Int):Int {
        x &= 0xFFFF;
        this = (this & 0xFFFF0000) | x;
        return x;
    }

    inline function get_y() {
        return this >> 16 & 0xFFFF;   
    }

    inline function set_y(y:Int):Int {
        y &= 0xFFFF;
        this = (this & 0xFFFF) | (y << 16);
        return y;
    }

    public inline function toString():String {
        return '($x, $y)';
    }

    @:to public inline function toPoint2D():Point2D {
        return new Point2D(x, y);
    }

    @:to public inline function toIntPoint2D():Point2D {
        return new IntPoint2D(x, y);
    }

    @:to public inline function toInt():Int {
        return this;
    }
}
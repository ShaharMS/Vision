package vision.ds;

import haxe.Int64;
import haxe.ds.Vector;
import vision.ds.Point2D;

/**
 * A 2D point represented by two, 32-bit integers.
 */
abstract IntPoint2D(Int64) {
    public var x(get, set):Int;

    public var y(get, set):Int;

    public function new(X:Int, Y:Int) {
        this = Int64.make(X, Y);
    }

    function get_y() {
        return this.low;
    }

    function get_x() {
        return this.high;
    }

    inline function set_y(y:Int):Int {
        this = Int64.make(x, y);
        return y;
    }

    inline function set_x(x:Int) {
        this = Int64.make(x, y);
        return x;
    }

    @:to public function toPoint2D() {
        return new Point2D(x, y);
    }

    @:from public static function fromPoint2D(p:Point2D) {
        return new IntPoint2D(Std.int(p.x), Std.int(p.y));
    }
}
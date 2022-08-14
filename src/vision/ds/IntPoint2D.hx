package vision.ds;

import haxe.ds.Vector;
import vision.ds.Point2D;

abstract IntPoint2D(Vector<Int>) {
    public var x(get, set):Int;

    public var y(get, set):Int;

    public function new(X:Int, Y:Int) {
        this = Vector.fromArrayCopy([X, Y]);
    }

    function get_y() {
        return this[1];
    }

    function get_x() {
        return this[0];
    }

    function set_y(y:Int) {
        return this[1] = y;
    }

    function set_x(x:Int) {
        return this[0] = x;
    }

    @:to public function toPoint2D() {
        return new Point2D(x, y);
    }

    @:from public static function fromPoint2D(p:Point2D) {
        return new IntPoint2D(Std.int(p.x), Std.int(p.y));
    }
}
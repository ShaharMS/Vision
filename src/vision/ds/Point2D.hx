package vision.ds;

@:structInit
class Point2D {
    
    public var x:Int;

    public var y:Int;

    public function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;
    }

    public function toString() {
        return '($x, $y)';
    }
}
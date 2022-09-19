package vision.ds;

@:structInit
class Pixel {
    public var x:Int;
    public var y:Int;
    public var color:Color;

    public function new(x:Int, y:Int, color:Color) {
        this.x = x;
        this.y = y;
        this.color = color;
    }
}
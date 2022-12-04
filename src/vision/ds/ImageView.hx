package vision.ds;

@:structInit
class ImageView {
    @:optional public var x:Int = 0;
    @:optional public var y:Int = 0;
    @:optional public var width:Int = 0;
    @:optional public var height:Int = 0; 
    @:optional public var shape:ImageViewShape = RECTANGLE;

    public function toString() {
        return '{shape: $shape, x: $x, y: $y, width: $width, height: $height}';
    }
}
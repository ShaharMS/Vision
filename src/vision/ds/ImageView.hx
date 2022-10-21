package vision.ds;

@:structInit
class ImageView {
    @:optional public var x:Int = 0;
    @:optional public var y:Int = 0;
    public var width:Int;
    public var height:Int;
    @:optional public var shape:ImageViewShape = RECTANGLE;
}
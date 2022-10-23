package vision.ds;

@:structInit
class ImageView {
    @:optional public var x:Int = 0;
    @:optional public var y:Int = 0;
    @:optional public var width:Int = 0;
    @:optional public var height:Int = 0; 
    @:optional public var shape:ImageViewShape = RECTANGLE;
}
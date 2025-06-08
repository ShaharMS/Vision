package vision.ds;

@:structInit
class ImageView {
    /**
    	The `x` position of the `ImageView`'s "bounding box"'s top-left corner.
    **/
    @:optional public var x:Int = 0;
    /**
    	The `y` position of the `ImageView`'s "bounding box"'s top-left corner.
    **/
    @:optional public var y:Int = 0;
    /**
    	The `ImageView`'s "bounding box"'s width.
    **/
    @:optional public var width:Int = 0;
    /**
    	The `ImageView`'s "bounding box"'s height.
    **/
    @:optional public var height:Int = 0; 
    /**
    	The view's shape. 
        
        This determiens which pixels **inside** the bounding box are contained within the view, and which aren't.
    **/
    @:optional public var shape:ImageViewShape = RECTANGLE;

    public function toString():String {
        return '{shape: $shape, x: $x, y: $y, width: $width, height: $height}';
    }
}
package vision.ds;

import haxe.io.BytesBuffer;
import vision.ds.Image;

@:access(vision.ds.Image)
@:forward
abstract ImageView(Image) {

    public static function of(image:Image, shape:ImageViewShape, x:Int, y:Int, width:Int, height:Int) {
        
    }
}
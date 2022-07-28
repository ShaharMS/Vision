package vision.exceptions;

import vision.ds.Point2D;
import vision.ds.Image;
import haxe.Exception;

class OutOfBounds extends VisionException {

    public function new(image:Image, position:Point2D) {
        super('pixel $position is outside the bounds of the image (size: ${image.width}x${image.height}, position: $position)', "Pixel Coordinates Out Of Bounds");
    }
}
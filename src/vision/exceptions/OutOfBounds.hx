package vision.exceptions;

import vision.ds.Point2D;
import vision.ds.Image;
import haxe.Exception;

class OutOfBounds extends Exception {

    public function new(image:Image, position:Point2D) {
        super('Coordinate Out Of Bounds: pixel $position is outside the bounds of the image (size: ${image.width}x${image.height})');
    }
}
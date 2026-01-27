package vision.exceptions;

import vision.ds.Point2D;
import vision.ds.Image;
class OutOfBounds extends VisionException {
	public function new(image:Image, position:Point2D) {
		super(buildMessage(image, position), "Pixel Coordinates Out Of Bounds");
	}

	static function buildMessage(image:Image, position:Point2D):String {
		return 'pixel ' + position + ' is outside the bounds of the image (size: ' + image.width + 'x' + image.height + ')';
	}
}

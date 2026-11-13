package vision.exceptions;

import vision.ds.Image;

/**
	Thrown when probabilistic Hough segment detection receives an `edgeImage`
	whose width or height does not match the source `image` bounds.
**/
class HoughEdgeImageSizeMismatch extends VisionException {
	public function new(source:Image, edgeImage:Image) {
		super(buildMessage(source, edgeImage), 'Hough Feature Extraction Error');
	}

	static function buildMessage(source:Image, edgeImage:Image):String {
		return 'Custom edgeImage must match the source image dimensions. Expected ${source.width}x${source.height} but got ${edgeImage.width}x${edgeImage.height}.';
	}
}

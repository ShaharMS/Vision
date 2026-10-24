package vision.exceptions;

import vision.ds.Image;

/**
	Thrown when probabilistic Hough segment detection receives an `edgeImage`
	whose width or height does not match the source `image` bounds.
**/
class HoughEdgeImageSizeMismatch extends VisionException {
	public function new(source:Image, edgeImage:Image) {
		super(
			'Custom edgeImage must match the source image dimensions. Expected ${source.width}x${source.height} but got ${edgeImage.width}x${edgeImage.height}.',
			'Hough Feature Extraction Error'
		);
	}
}
package vision.exceptions;

class PanoramaError extends VisionException {
	public function new(message:String) {
		super(message, "Panorama Error");
	}
}

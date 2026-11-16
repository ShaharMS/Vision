package vision.exceptions;

class UnknownPixelFormat extends VisionException {
	public function new() {
		super("Unknown Pixel Format", "Pixel Conversion");
	}
}

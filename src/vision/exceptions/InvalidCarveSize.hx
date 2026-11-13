package vision.exceptions;

class InvalidCarveSize extends VisionException {
	public function new() {
		super("Carve dimensions must be positive and no larger than the source.", "Invalid Carve Size");
	}
}

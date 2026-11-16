package vision.exceptions;

class InvalidWarpPoints extends VisionException {
	public function new() {
		super("Expected 4 source points and 4 destination points.", "Perspective Warp Error");
	}
}

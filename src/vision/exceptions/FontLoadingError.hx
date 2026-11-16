package vision.exceptions;

class FontLoadingError extends VisionException {
	public function new(family:String, reason:String) {
		super('Could not load font "$family": $reason', "Font Loading Error");
	}
}

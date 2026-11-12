package vision.exceptions;

class ScreenError extends VisionException {
	public function new(message:String) {
		super(message, "Screen");
	}
}

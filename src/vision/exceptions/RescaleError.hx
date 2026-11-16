package vision.exceptions;

class RescaleError extends VisionException {
	public function new(message:String) {
		super(message, "Scale2x Error");
	}
}

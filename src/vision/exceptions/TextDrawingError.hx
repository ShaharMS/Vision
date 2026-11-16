package vision.exceptions;

class TextDrawingError extends VisionException {
	public function new(message:String) {
		super(message, "Text Drawing Error");
	}
}

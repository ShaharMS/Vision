package vision.exceptions;

class CanvasRenderingError extends VisionException {
	public function new(message:String) {
		super(message, "CanvasRenderer");
	}
}

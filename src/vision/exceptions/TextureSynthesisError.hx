package vision.exceptions;

class TextureSynthesisError extends VisionException {
	public function new(message:String) {
		super(message, "Texture Synthesis Error");
	}
}

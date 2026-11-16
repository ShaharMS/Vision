package vision.exceptions;

class PatternSynthesisError extends VisionException {
	public function new(message:String) {
		super(message, "Pattern Synthesis Error");
	}
}

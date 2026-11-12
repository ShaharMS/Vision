package vision.exceptions;

class ConvChainError extends VisionException {
	public function new(message:String) {
		super(message, "ConvChain Error");
	}
}

package vision.exceptions;

/** A malformed or unsupported AV1 bitstream. **/
class Av1BitstreamError extends VisionException {
	public function new(message:String) {
		super(message, "AV1 bitstream");
	}
}

package vision.exceptions;

/** A malformed HEVC bitstream. **/
class HevcBitstreamError extends VisionException {
	public function new(message:String) {
		super(message, "HEVC bitstream");
	}
}

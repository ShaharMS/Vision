package vision.exceptions;

/** Invalid or unsupported HEIF container data. **/
class HeifContainerError extends VisionException {
	public function new(message:String) {
		super(message, "HEIF container");
	}
}

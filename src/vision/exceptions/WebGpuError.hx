package vision.exceptions;

class WebGpuError extends VisionException {
	public function new(message:String) {
		super(message, "WebGPU invert");
	}
}

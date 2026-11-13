package vision.exceptions;

class ClusteringError extends VisionException {
	public function new(message:String, type:String) {
		super(message, type);
	}
}

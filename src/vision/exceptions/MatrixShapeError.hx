package vision.exceptions;

class MatrixShapeError extends VisionException {
	public function new(message:String, type:String) {
		super(message, type);
	}
}

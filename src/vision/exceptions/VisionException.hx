package vision.exceptions;

/** Base exception used by Vision's existing exception classes. **/
class VisionException extends VisionError {
	public function new(message:String, type:String) {
		super(message, type);
	}
}

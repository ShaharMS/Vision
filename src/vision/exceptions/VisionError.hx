package vision.exceptions;

import haxe.Exception;

/** Base type for errors raised by Vision. **/
class VisionError extends Exception {
	public function new(message:String, type:String) {
		super('$type: $message');
	}
}

package vision.exceptions;

class MultithreadFailure extends VisionException {
	public function new(count:Int, reason:Dynamic) {
		super('Thread number #$count failed: $reason', 'Multithreading Failure');
	}
}

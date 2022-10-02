package vision.exceptions;

class MultithreadFaliure extends VisionException {
	public function new(count:Int, reason:Dynamic) {
		super('Thread number #$count failed: $reason', 'Multithreading Faliure');
	}
}

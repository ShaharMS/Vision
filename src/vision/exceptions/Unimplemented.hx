package vision.exceptions;

class Unimplemented extends VisionException {
	public function new(name:String) {
		super('$name is not yet implemented', "Unimplemented Method");
	}
}

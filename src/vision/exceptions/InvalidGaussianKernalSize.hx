package vision.exceptions;

class InvalidGaussianKernalSize extends VisionException {
	public function new(size:Int) {
		super('Creating a gaussian kernal of size $size is not allowed. ${getReason(size)}', "Invalid Gaussian Kernal Size");
	}

	inline function getReason(size:Int) {
		if (size < 0) return "Is the kernal size a negative value?";
		if (size % 2 == 0) return "Is the kernal size even?";
		if (size == 0) return "Is the kernal size 0?";
		return "";
	}
}

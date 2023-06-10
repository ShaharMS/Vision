package vision.exceptions;

import haxe.Exception;

class InvalidGaussianKernelSize extends VisionException {
	public function new(size:Int) {
		super('Creating a gaussian kernel of size $size is not allowed. ${getReason(size)}', "Invalid Gaussian Kernel Size");
	}

	inline function getReason(size:Int) {
		if (size < 0) return "Is the kernel size a negative value?";
		if (size % 2 == 0) return "Is the kernel size even?";
		if (size == 0) return "Is the kernel size 0?";
		return "";
	}
}

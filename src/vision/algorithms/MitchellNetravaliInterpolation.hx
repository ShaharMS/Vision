package vision.algorithms;

import vision.ds.Image;

class MitchellNetravaliInterpolation {
	static inline var B:Float = 1 / 3;
	static inline var C:Float = 1 / 3;

	public static function interpolate(image:Image, width:Int, height:Int):Image {
		return KernelResampler.resize(image, width, height, 2, mitchellKernel);
	}

	static inline function mitchellKernel(x:Float):Float {
		return KernelResampler.cubicKernel(x, B, C);
	}
}

package vision.algorithms;

import vision.ds.Image;

class CatmullRomInterpolation {
	static inline var B:Float = 0;
	static inline var C:Float = 0.5;

	public static function interpolate(image:Image, width:Int, height:Int):Image {
		return KernelResampler.resize(image, width, height, 2, catmullRomKernel);
	}

	static inline function catmullRomKernel(x:Float):Float {
		return KernelResampler.cubicKernel(x, B, C);
	}
}

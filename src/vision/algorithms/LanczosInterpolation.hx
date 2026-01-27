package vision.algorithms;

import vision.ds.Image;

class LanczosInterpolation {
	public static inline var RADIUS:Int = 3;

	public static function interpolate(image:Image, width:Int, height:Int):Image {
		return KernelResampler.resize(image, width, height, RADIUS, lanczosKernel);
	}

	static inline function sinc(x:Float):Float {
		if (Math.abs(x) < 1e-7) return 1;
		return Math.sin(Math.PI * x) / (Math.PI * x);
	}

	static inline function lanczosKernel(x:Float):Float {
		final t = Math.abs(x);
		if (t >= RADIUS) return 0;
		if (t < 1e-7) return 1;
		return sinc(t) * sinc(t / RADIUS);
	}
}

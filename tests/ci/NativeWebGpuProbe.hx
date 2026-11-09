import vision.ds.Image;

class NativeWebGpuProbe {
	#if (vision_native_probe && hl)
	@:hlNative("vision_gpu", "probe")
	static function probe():Int return 1;
	#elseif (vision_native_probe && cpp)
	static function probe():Int {
		final call:Void->Int = cpp.Lib.load("vision_gpu", "probe", 0);
		return call();
	}
	#end

	static function main() {
		final image = new Image(2, 2);
		image.setPixel(0, 0, 0xFF010203);
		if (image.getPixel(0, 0) != 0xFF010203)
			throw "CPU image fallback failed";
		#if vision_native_probe
		final result = probe();
		if (result != 0)
			throw 'Native WebGPU surface probe failed at stage $result';
		Sys.println("Native WebGPU surface clear and present passed");
		#else
		Sys.println("CPU fallback passed");
		#end
	}
}

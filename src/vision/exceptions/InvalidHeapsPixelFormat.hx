package vision.exceptions;

class InvalidHeapsPixelFormat extends VisionException {
	public function new(actualFormat:Dynamic) {
		super('FrameworkImageIO.fromHeapsPixels expects pixels in ARGB format, but received ${Std.string(actualFormat)}. Convert the source pixels to ARGB before calling this method.', 'Invalid Heaps Pixel Format');
	}
}
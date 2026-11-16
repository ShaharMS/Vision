package vision.formats._internal.images.webp;

import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.ImageSavingFailed;
#if (cpp && !cppia && vision_webp)
import haxe.io.Bytes;
import vision.ds.PixelFormat;
import vision.native.webp.LibWebp;
#end

/** Lossy WebP through the optional libwebp backend. **/
@:noCompletion
class WebpLossy {
	public static function read(bytes:ByteArray):Image {
		#if (cpp && !cppia && vision_webp)
		final dimensions = LibWebp.dimensions(bytes.getData());
		if (dimensions == 0) throw WebpContainer.invalid("Invalid or oversized lossy WebP.");
		final width = dimensions & 0xffff;
		final height = dimensions >>> 16;
		final pixels = Bytes.alloc(width * height * 4);
		if (!LibWebp.decode(bytes.getData(), pixels.getData(), width * 4))
			throw WebpContainer.invalid("Invalid lossy WebP bitstream.");
		return Image.loadFromBytes(pixels, width, height);
		#else
		throw WebpContainer.invalid("Lossy WebP requires an hxcpp build with -D vision_webp and libwebp.");
		#end
	}

	public static function write(image:Image, quality:Float):ByteArray {
		if (!Math.isFinite(quality) || quality < 0 || quality > 100)
			throw new ImageSavingFailed(WEBP, "WebP quality must be between 0 and 100.");
		#if (cpp && !cppia && vision_webp)
		final width = image.width;
		final height = image.height;
		if (width < 1 || height < 1 || width > 16383 || height > 16383 || width * 1.0 * height > 32000000)
			throw new ImageSavingFailed(WEBP, "Invalid lossy WebP dimensions.");
		final pixels = image.exportToBytes(PixelFormat.RGBA);
		final data = LibWebp.encode(pixels.getData(), width, height, quality);
		if (data == null) throw new ImageSavingFailed(WEBP, "libwebp could not encode the image.");
		return Bytes.ofData(data);
		#else
		throw new ImageSavingFailed(WEBP, "Lossy WebP requires an hxcpp build with -D vision_webp and libwebp.");
		#end
	}
}

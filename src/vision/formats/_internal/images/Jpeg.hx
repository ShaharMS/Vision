package vision.formats._internal.images;

import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.exceptions.ImageSavingFailed;
import vision.formats._internal.images.jpeg.JpegReader;
import vision.formats._internal.images.jpeg.JpegWriter;

/** Portable JPEG byte conversion. **/
@:noCompletion
class Jpeg {
	public static function read(bytes:ByteArray):Image {
		try {
			return new JpegReader(bytes).read();
		} catch (error:ImageLoadingFailed) {
			throw error;
		} catch (error:Dynamic) {
			throw new ImageLoadingFailed(JPEG, Std.string(error));
		}
	}

	public static function write(image:Image, quality:Int):ByteArray {
		return encode(image.exportToBytes(), image.width, image.height, quality, false);
	}

	public static function writeCmyk(inks:ByteArray, width:Int, height:Int, quality:Int):ByteArray {
		return encode(inks, width, height, quality, true);
	}

	static function encode(pixels:ByteArray, width:Int, height:Int, quality:Int, cmyk:Bool):ByteArray {
		if (quality < 1 || quality > 100 || width < 1 || height < 1 || width > 65535 || height > 65535
			|| width * 1.0 * height * 4 != pixels.length)
			throw new ImageSavingFailed(JPEG, "Invalid image dimensions, pixel data, or quality.");
		try {
			final output = new BytesOutput();
			new JpegWriter(output).write({width: width, height: height, quality: quality, pixels: pixels}, cmyk);
			return output.getBytes();
		} catch (error:Dynamic) {
			throw new ImageSavingFailed(JPEG, Std.string(error));
		}
	}
}

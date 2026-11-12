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
		if (quality < 1 || quality > 100 || image.width < 1 || image.height < 1 || image.width > 65535 || image.height > 65535)
			throw new ImageSavingFailed(JPEG, "Invalid image dimensions or quality.");
		try {
			final output = new BytesOutput();
			new JpegWriter(output).write({
				width: image.width, height: image.height, quality: quality, pixels: image.exportToBytes()
			});
			return output.getBytes();
		} catch (error:Dynamic) {
			throw new ImageSavingFailed(JPEG, Std.string(error));
		}
	}
}

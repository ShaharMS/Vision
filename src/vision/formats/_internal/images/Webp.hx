package vision.formats._internal.images;

import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.exceptions.ImageSavingFailed;
import vision.formats._internal.images.webp.WebpBits;
import vision.formats._internal.images.webp.WebpContainer;
import vision.formats._internal.images.webp.WebpLossless;
import vision.formats._internal.images.webp.WebpLosslessWriter;

/** RIFF container for still lossless WebP images. **/
@:noCompletion
class Webp {
	public static function read(bytes:ByteArray):Image {
		try {
			var payload:WebpBits = null;
			WebpContainer.read(bytes, (tag, offset, length) -> {
				switch tag {
					case "VP8L":
						if (payload != null) throw WebpContainer.invalid("Multiple VP8L chunks.");
						payload = new WebpBits(bytes, offset, offset + length);
					case "VP8 ": throw WebpContainer.invalid("Lossy WebP is unsupported.");
					case "ANIM", "ANMF": throw WebpContainer.invalid("Use webpAnimation() for animated WebP.");
					default:
				}
			});
			if (payload == null) throw new ImageLoadingFailed(WEBP, "Missing VP8L image chunk.");
			return new WebpLossless(payload).read();
		} catch (error:ImageLoadingFailed) {
			throw error;
		} catch (error:Dynamic) {
			throw new ImageLoadingFailed(WEBP, Std.string(error));
		}
	}

	public static function write(image:Image):ByteArray {
		if (image.width < 1 || image.height < 1 || image.width > 16384 || image.height > 16384 || image.width * image.height > 32000000)
			throw new ImageSavingFailed(WEBP, "Invalid lossless WebP dimensions.");
		try {
			final payload = WebpLosslessWriter.write(image);
			final output = new BytesOutput();
			WebpContainer.chunk(output, "VP8L", payload);
			return WebpContainer.write(output.getBytes());
		} catch (error:Dynamic) {
			throw new ImageSavingFailed(WEBP, Std.string(error));
		}
	}
}

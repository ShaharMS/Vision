package vision.formats._internal;

import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.exceptions.ImageSavingFailed;
import vision.formats._internal.images.webp.WebpBits;
import vision.formats._internal.images.webp.WebpContainer;
import vision.formats._internal.images.webp.WebpLossless;
import vision.formats._internal.images.webp.WebpLosslessWriter;
import vision.formats._internal.images.webp.WebpLossy;

/** RIFF container for still WebP images. **/
@:noCompletion
class Webp {
	public static function read(bytes:ByteArray):Image {
		try {
			var lossless:WebpBits = null;
			var lossy:ByteArray = null;
			var alpha:ByteArray = null;
			WebpContainer.read(bytes, (tag, offset, length) -> {
				switch tag {
					case "VP8L":
						if (lossless != null || lossy != null || alpha != null) throw WebpContainer.invalid("Multiple WebP image chunks.");
						lossless = new WebpBits(bytes, offset, offset + length);
					case "VP8 ":
						if (lossless != null || lossy != null) throw WebpContainer.invalid("Multiple WebP image chunks.");
						lossy = bytes.sub(offset, length);
					case "ALPH":
						if (alpha != null || lossless != null || lossy != null) throw WebpContainer.invalid("Invalid WebP alpha chunk.");
						alpha = bytes.sub(offset, length);
					case "ANIM", "ANMF": throw WebpContainer.invalid("Use webpAnimation() for animated WebP.");
					default:
				}
			});
			if (lossy != null) return WebpLossy.read(lossy, alpha);
			if (lossless == null) throw WebpContainer.invalid("Missing WebP image chunk.");
			return new WebpLossless(lossless).read();
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

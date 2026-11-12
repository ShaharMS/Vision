package vision.formats._internal.images;

import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.exceptions.ImageSavingFailed;
import vision.formats._internal.images.webp.WebpBits;
import vision.formats._internal.images.webp.WebpLossless;
import vision.formats._internal.images.webp.WebpLosslessWriter;

/** RIFF container for still lossless WebP images. **/
@:noCompletion
class Webp {
	public static function read(bytes:ByteArray):Image {
		try {
			if (bytes.length < 12 || bytes.getString(0, 4) != "RIFF" || bytes.getString(8, 4) != "WEBP")
				throw new ImageLoadingFailed(WEBP, "Invalid WebP container.");
			final size = bytes.getInt32(4);
			if (size < 4 || size > bytes.length - 8) throw new ImageLoadingFailed(WEBP, "Invalid WebP container size.");
			final end = size + 8;
			var offset = 12;
			var payload:WebpBits = null;
			while (offset < end) {
				if (end - offset < 8) throw new ImageLoadingFailed(WEBP, "Truncated WebP chunk.");
				final tag = bytes.getString(offset, 4);
				final length = bytes.getInt32(offset + 4);
				offset += 8;
				if (length < 0 || length > end - offset || (length & 1) > end - offset - length)
					throw new ImageLoadingFailed(WEBP, "Invalid WebP chunk size.");
				switch tag {
					case "VP8L":
						if (payload != null) throw new ImageLoadingFailed(WEBP, "Multiple VP8L chunks.");
						payload = new WebpBits(bytes, offset, offset + length);
					case "VP8 ": throw new ImageLoadingFailed(WEBP, "Lossy WebP is unsupported.");
					case "ANIM", "ANMF": throw new ImageLoadingFailed(WEBP, "Animated WebP is unsupported.");
					default:
				}
				offset += length + (length & 1);
			}
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
			final padding = payload.length & 1;
			final output = new BytesOutput();
			output.writeString("RIFF");
			output.writeInt32(12 + payload.length + padding);
			output.writeString("WEBPVP8L");
			output.writeInt32(payload.length);
			output.write(payload);
			if (padding != 0) output.writeByte(0);
			return output.getBytes();
		} catch (error:Dynamic) {
			throw new ImageSavingFailed(WEBP, Std.string(error));
		}
	}
}

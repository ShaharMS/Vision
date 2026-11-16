package vision.formats._internal.images.webp;

import haxe.io.Bytes;
import vision.ds.ByteArray;
import vision.ds.Image;

/** Decodes a WebP VP8 payload and its optional ALPH chunk. **/
@:noCompletion
class WebpLossy {
	public static function read(bytes:ByteArray, ?alpha:ByteArray):Image {
		final decoder = new Vp8Decoder(bytes);
		return decoder.read(alpha == null ? null : readAlpha(alpha, decoder.width, decoder.height));
	}

	static function readAlpha(alpha:ByteArray, width:Int, height:Int):ByteArray {
		if (alpha.length < 1) throw WebpContainer.invalid("Empty WebP alpha chunk.");
		final flags = alpha[0];
		final compression = flags & 3;
		final filter = (flags >> 2) & 3;
		if (compression > 1 || (flags >>> 4) > 1) throw WebpContainer.invalid("Invalid WebP alpha flags.");
		final length = width * height;
		final result:ByteArray = Bytes.alloc(length);
		if (compression == 0) {
			if (alpha.length != length + 1) throw WebpContainer.invalid("Invalid raw WebP alpha length.");
			result.blit(0, alpha, 1, length);
		} else {
			final pixels = new WebpLossless(new WebpBits(alpha, 1, alpha.length)).readBody(width, height);
			for (i in 0...length) result[i] = (pixels[i] >>> 8) & 255;
		}
		if (filter != 0) {
			for (y in 0...height)
				for (x in 0...width) {
					final index = y * width + x;
					final left = x == 0 ? 0 : result[index - 1];
					final top = y == 0 ? 0 : result[index - width];
					final prediction = if (y == 0) left else if (x == 0) top else switch filter {
						case 1: left;
						case 2: top;
						default:
							final gradient = left + top - result[index - width - 1];
							gradient < 0 ? 0 : gradient > 255 ? 255 : gradient;
					};
					result[index] = (result[index] + prediction) & 255;
				}
		}
		return result;
	}
}

package vision.formats._internal.images.webp;

import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageAnimation;
import vision.ds.ImageAnimation.AnimationFrame;
import vision.exceptions.ImageLoadingFailed;
import vision.exceptions.ImageSavingFailed;

/** Decodes and encodes animated WebP containers with lossless VP8L frames. **/
@:noCompletion
class WebpAnimation {
	static inline var MAX_PIXELS = 32000000;

	public static function read(bytes:ByteArray):ImageAnimation {
		try {
			return decode(bytes);
		} catch (error:ImageLoadingFailed) {
			throw error;
		} catch (error:Dynamic) {
			throw WebpContainer.invalid(Std.string(error));
		}
	}

	static function decode(bytes:ByteArray):ImageAnimation {
		var width = 0, height = 0, loop = 0;
		var background:Color = 0;
		var canvas:Image = null;
		final frames:Array<AnimationFrame> = [];
		WebpContainer.read(bytes, (tag, offset, length) -> {
			switch tag {
				case "VP8X":
					if (width != 0 || length != 10 || (bytes.get(offset) & 2) == 0)
						throw WebpContainer.invalid("Missing or invalid animated WebP header.");
					width = uint24(bytes, offset + 4) + 1;
					height = uint24(bytes, offset + 7) + 1;
					if (width > 65535 || width * 1.0 * height > MAX_PIXELS)
						throw WebpContainer.invalid("WebP animation canvas is too large.");
				case "ANIM":
					if (width == 0 || canvas != null || length != 6) throw WebpContainer.invalid("Invalid WebP animation parameters.");
					background = new Color(bytes.getInt32(offset));
					loop = bytes.get(offset + 4) | (bytes.get(offset + 5) << 8);
					canvas = new Image(width, height);
				case "ANMF":
					if (canvas == null || length < 16 || (frames.length + 1) * width * 1.0 * height > MAX_PIXELS)
						throw WebpContainer.invalid("Invalid or oversized WebP animation.");
					final x = uint24(bytes, offset) * 2;
					final y = uint24(bytes, offset + 3) * 2;
					final columns = uint24(bytes, offset + 6) + 1;
					final rows = uint24(bytes, offset + 9) + 1;
					final duration = uint24(bytes, offset + 12);
					final flags = bytes.get(offset + 15);
					if (columns > width - x || rows > height - y) throw WebpContainer.invalid("WebP frame lies outside its canvas.");
					final frame = decodeFrame(bytes, offset + 16, offset + length, columns, rows);
					final overwrite = (flags & 2) != 0;
					for (row in 0...rows)
						for (column in 0...columns) {
							final color = frame.getUnsafePixel(column, row);
							canvas.setUnsafePixel(x + column, y + row, overwrite ? color :
								over(color, canvas.getUnsafePixel(x + column, y + row)));
						}
					frames.push({image: canvas.clone(), duration: duration});
					if ((flags & 1) != 0) canvas.fillRect(x, y, columns, rows, 0);
				default:
			}
		});
		if (frames.length == 0) throw WebpContainer.invalid("Missing WebP animation frames.");
		return new ImageAnimation(frames, loop, background);
	}

	static function decodeFrame(bytes:ByteArray, start:Int, end:Int, width:Int, height:Int):Image {
		var image:Image = null;
		WebpContainer.chunks(bytes, start, end, (tag, offset, length) -> {
			switch tag {
				case "VP8L":
					if (image != null) throw WebpContainer.invalid("Multiple bitstreams in one WebP frame.");
					image = new WebpLossless(new WebpBits(bytes, offset, offset + length)).read();
				case "VP8 ", "ALPH": throw WebpContainer.invalid("Lossy WebP animation frames are unsupported.");
				default:
			}
		});
		if (image == null || image.width != width || image.height != height) throw WebpContainer.invalid("Invalid WebP animation frame size.");
		return image;
	}

	public static function write(animation:ImageAnimation):ByteArray {
		try {
			return encode(animation);
		} catch (error:ImageSavingFailed) {
			throw error;
		} catch (error:Dynamic) {
			throw new ImageSavingFailed(WEBP, Std.string(error));
		}
	}

	static function encode(animation:ImageAnimation):ByteArray {
		if (animation.frames.length == 0 || animation.loopCount < 0 || animation.loopCount > 65535)
			throw new ImageSavingFailed(WEBP, "Invalid animation frame count or loop count.");
		final first = animation.frames[0].image;
		final width = first.width, height = first.height;
		if (width < 1 || height < 1 || width > 16384 || height > 16384 || width * 1.0 * height * animation.frames.length > MAX_PIXELS)
			throw new ImageSavingFailed(WEBP, "Invalid WebP animation dimensions.");
		final payload = new BytesOutput();
		final header = new BytesOutput();
		header.writeInt32(0x12); // animation and alpha
		write24(header, width - 1);
		write24(header, height - 1);
		WebpContainer.chunk(payload, "VP8X", header.getBytes());
		final metadata = new BytesOutput();
		metadata.writeInt32(animation.background.toInt());
		metadata.writeUInt16(animation.loopCount);
		WebpContainer.chunk(payload, "ANIM", metadata.getBytes());
		for (frame in animation.frames) {
			if (frame.image.width != width || frame.image.height != height || frame.duration < 0 || frame.duration > 0xffffff)
				throw new ImageSavingFailed(WEBP, "Invalid WebP animation frame dimensions or duration.");
			final data = new BytesOutput();
			write24(data, 0);
			write24(data, 0);
			write24(data, width - 1);
			write24(data, height - 1);
			write24(data, frame.duration);
			data.writeByte(2); // full-canvas replacement
			WebpContainer.chunk(data, "VP8L", WebpLosslessWriter.write(frame.image));
			WebpContainer.chunk(payload, "ANMF", data.getBytes());
		}
		return WebpContainer.write(payload.getBytes());
	}

	static function over(source:Color, destination:Color):Color {
		if (source.alpha == 255) return source;
		if (source.alpha == 0) return destination;
		final oldAlpha = destination.alpha * (1 - source.alphaFloat);
		final alpha = source.alpha + oldAlpha;
		return Color.fromRGBA(Math.round((source.red * source.alpha + destination.red * oldAlpha) / alpha),
			Math.round((source.green * source.alpha + destination.green * oldAlpha) / alpha),
			Math.round((source.blue * source.alpha + destination.blue * oldAlpha) / alpha), Math.round(alpha));
	}

	static inline function uint24(bytes:ByteArray, offset:Int):Int {
		return bytes.get(offset) | (bytes.get(offset + 1) << 8) | (bytes.get(offset + 2) << 16);
	}

	static inline function write24(output:BytesOutput, value:Int):Void {
		output.writeByte(value & 255);
		output.writeByte((value >>> 8) & 255);
		output.writeByte(value >>> 16);
	}
}

package vision.formats._internal.images.webp;

import haxe.ds.Vector;
import vision.ds.Image;
import vision.ds.Color;
import vision.exceptions.ImageLoadingFailed;

private typedef Transform = {
	final kind:Int;
	final width:Int;
	final bits:Int;
	final pixels:Null<Vector<Int>>;
}

/** Decodes the VP8L bitstream in a still lossless WebP. **/
@:noCompletion
class WebpLossless {
	static final distanceMap = [
		0x18, 0x07, 0x17, 0x19, 0x28, 0x06, 0x27, 0x29, 0x16, 0x1a, 0x26, 0x2a, 0x38, 0x05, 0x37, 0x39,
		0x15, 0x1b, 0x36, 0x3a, 0x25, 0x2b, 0x48, 0x04, 0x47, 0x49, 0x14, 0x1c, 0x35, 0x3b, 0x46, 0x4a,
		0x24, 0x2c, 0x58, 0x45, 0x4b, 0x34, 0x3c, 0x03, 0x57, 0x59, 0x13, 0x1d, 0x56, 0x5a, 0x23, 0x2d,
		0x44, 0x4c, 0x55, 0x5b, 0x33, 0x3d, 0x68, 0x02, 0x67, 0x69, 0x12, 0x1e, 0x66, 0x6a, 0x22, 0x2e,
		0x54, 0x5c, 0x43, 0x4d, 0x65, 0x6b, 0x32, 0x3e, 0x78, 0x01, 0x77, 0x79, 0x53, 0x5d, 0x11, 0x1f,
		0x64, 0x6c, 0x42, 0x4e, 0x76, 0x7a, 0x21, 0x2f, 0x75, 0x7b, 0x31, 0x3f, 0x63, 0x6d, 0x52, 0x5e,
		0x00, 0x74, 0x7c, 0x41, 0x4f, 0x10, 0x20, 0x62, 0x6e, 0x30, 0x73, 0x7d, 0x51, 0x5f, 0x40, 0x72,
		0x7e, 0x61, 0x6f, 0x50, 0x71, 0x7f, 0x60, 0x70
	];
	final bits:WebpBits;
	var remainingPixels = 32000000;

	public function new(bits:WebpBits) {
		this.bits = bits;
	}

	public function read():Image {
		if (bits.read(8) != 0x2f) throw invalid("Invalid VP8L signature.");
		final width = bits.read(14) + 1;
		final height = bits.read(14) + 1;
		bits.read(1);
		if (bits.read(3) != 0 || width * height > remainingPixels) throw invalid("Invalid VP8L version or dimensions.");
		var encodedWidth = width;
		var used = 0;
		final transforms:Array<Transform> = [];
		while (bits.read(1) != 0) {
			final kind = bits.read(2);
			if ((used & (1 << kind)) != 0) throw invalid("Repeated VP8L transform.");
			used |= 1 << kind;
			switch kind {
				case 0, 1:
					final size = bits.read(3) + 2;
					transforms.push({kind: kind, width: encodedWidth, bits: size,
						pixels: readPixels(tiles(encodedWidth, size), tiles(height, size), false)});
				case 2:
					transforms.push({kind: kind, width: encodedWidth, bits: 0, pixels: null});
				case 3:
					final size = bits.read(8) + 1;
					final palette = readPixels(size, 1, false);
					for (i in 1...size) palette[i] = add(palette[i], palette[i - 1]);
					final packing = size <= 2 ? 3 : size <= 4 ? 2 : size <= 16 ? 1 : 0;
					transforms.push({kind: kind, width: encodedWidth, bits: packing, pixels: palette});
					encodedWidth = tiles(encodedWidth, packing);
			}
		}

		var pixels = readPixels(encodedWidth, height, true);
		while (transforms.length != 0) {
			final transform = transforms.pop();
			switch transform.kind {
				case 0: undoPrediction(pixels, transform, height);
				case 1: undoColor(pixels, transform, height);
				case 2:
					for (i in 0...pixels.length) {
						final green = (pixels[i] >>> 8) & 255;
						pixels[i] = add(pixels[i], (green << 16) | green);
					}
				case 3:
					final expanded = new Vector<Int>(transform.width * height);
					final shift = 8 >> transform.bits;
					final mask = (1 << shift) - 1;
					final group = (1 << transform.bits) - 1;
					for (y in 0...height)
						for (x in 0...transform.width) {
							final packed = (pixels[y * encodedWidth + (x >> transform.bits)] >>> 8) & 255;
							final index = (packed >> ((x & group) * shift)) & mask;
							expanded[y * transform.width + x] = index < transform.pixels.length ? transform.pixels[index] : 0;
						}
					pixels = expanded;
					encodedWidth = transform.width;
			}
		}
		final image = new Image(width, height);
		for (y in 0...height)
			for (x in 0...width) image.setUnsafePixel(x, y, new Color(pixels[y * width + x]));
		return image;
	}

	function readPixels(width:Int, height:Int, top:Bool):Vector<Int> {
		final count = width * height;
		if (count > remainingPixels) throw invalid("VP8L image exceeds the decoded pixel budget.");
		remainingPixels -= count;
		final usesCache = bits.read(1) != 0;
		final cacheBits = usesCache ? bits.read(4) : 0;
		if (usesCache && (cacheBits == 0 || cacheBits > 11)) throw invalid("Invalid VP8L color cache.");
		final cacheSize = cacheBits == 0 ? 0 : 1 << cacheBits;
		final cache = new Vector<Int>(cacheSize);
		for (i in 0...cacheSize) cache[i] = 0;
		var groupCount = 1;
		var groupBits = 0;
		var groupsImage:Vector<Int> = null;
		var groupStride = 0;
		if (top && bits.read(1) != 0) {
			groupBits = bits.read(3) + 2;
			groupStride = tiles(width, groupBits);
			groupsImage = readPixels(groupStride, tiles(height, groupBits), false);
			for (i in 0...groupsImage.length) {
				final index = (groupsImage[i] >>> 8) & 65535;
				groupsImage[i] = index;
				if (index >= groupCount) groupCount = index + 1;
			}
			if (groupCount > 2600) throw invalid("Too many VP8L entropy groups.");
		}
		final groups = [for (_ in 0...groupCount) [
			WebpPrefix.read(bits, 280 + cacheSize), WebpPrefix.read(bits, 256), WebpPrefix.read(bits, 256), WebpPrefix.read(bits, 256),
			WebpPrefix.read(bits, 40)
		]];
		final result = new Vector<Int>(count);
		var position = 0;
		while (position < count) {
			final group = groups[groupsImage == null ? 0 :
				groupsImage[(Std.int(position / width) >> groupBits) * groupStride + ((position % width) >> groupBits)]];
			final green = group[0].symbol(bits);
			if (green < 256) {
				final red = group[1].symbol(bits);
				final blue = group[2].symbol(bits);
				final alpha = group[3].symbol(bits);
				final pixel = (alpha << 24) | (red << 16) | (green << 8) | blue;
				result[position++] = pixel;
				if (cacheBits != 0) cache[hash(pixel, cacheBits)] = pixel;
			} else if (green < 280) {
				final length = expand(green - 256);
				final code = expand(group[4].symbol(bits));
				var distance = code - 120;
				if (code <= 120) {
					final offset = distanceMap[code - 1];
					distance = (offset >> 4) * width + 8 - (offset & 15);
					if (distance < 1) distance = 1;
				}
				if (distance > position || length > count - position) throw invalid("Invalid VP8L backward reference.");
				for (_ in 0...length) {
					final pixel = result[position - distance];
					result[position++] = pixel;
					if (cacheBits != 0) cache[hash(pixel, cacheBits)] = pixel;
				}
			} else {
				final pixel = cache[green - 280];
				result[position++] = pixel;
				cache[hash(pixel, cacheBits)] = pixel;
			}
		}
		return result;
	}

	function expand(code:Int):Int {
		if (code < 4) return code + 1;
		final extra = (code - 2) >> 1;
		return ((2 + (code & 1)) << extra) + bits.read(extra) + 1;
	}

	static function undoPrediction(pixels:Vector<Int>, transform:Transform, height:Int):Void {
		final width = transform.width;
		final stride = tiles(width, transform.bits);
		for (y in 0...height)
			for (x in 0...width) {
				final i = y * width + x;
				final predictor = if (i == 0) 0xff000000 else if (y == 0) pixels[i - 1] else if (x == 0) pixels[i - width] else {
					final mode = (transform.pixels[(y >> transform.bits) * stride + (x >> transform.bits)] >>> 8) & 15;
					predict(mode, pixels[i - 1], pixels[i - width], pixels[i - width - 1], pixels[i - width + 1]);
				};
				pixels[i] = add(pixels[i], predictor);
			}
	}

	static function predict(mode:Int, left:Int, top:Int, corner:Int, right:Int):Int {
		return switch mode {
			case 0: 0xff000000;
			case 1: left;
			case 2: top;
			case 3: right;
			case 4: corner;
			case 5: average(average(left, right), top);
			case 6: average(left, corner);
			case 7: average(left, top);
			case 8: average(corner, top);
			case 9: average(top, right);
			case 10: average(average(left, corner), average(top, right));
			case 11:
				var toLeft = 0.0, toTop = 0.0;
				for (channel in 0...4) {
					final shift = channel * 8;
					final c = (corner >>> shift) & 255;
					toLeft += Math.abs(((top >>> shift) & 255) - c);
					toTop += Math.abs(((left >>> shift) & 255) - c);
				}
				toLeft < toTop ? left : top;
			case 12, 13:
				var result = 0;
				for (channel in 0...4) {
					final shift = channel * 8;
					final l = (left >>> shift) & 255;
					final t = (top >>> shift) & 255;
					final c = (corner >>> shift) & 255;
					final mean = (l + t) >> 1;
					final value = mode == 12 ? l + t - c : mean + Std.int((mean - c) / 2);
					result |= (value < 0 ? 0 : value > 255 ? 255 : value) << shift;
				}
				result;
			default: throw invalid("Invalid VP8L predictor.");
		}
	}

	static function undoColor(pixels:Vector<Int>, transform:Transform, height:Int):Void {
		final width = transform.width;
		final stride = tiles(width, transform.bits);
		for (y in 0...height)
			for (x in 0...width) {
				final i = y * width + x;
				final pixel = pixels[i];
				final coefficients = transform.pixels[(y >> transform.bits) * stride + (x >> transform.bits)];
				final green = signedByte(pixel >>> 8);
				final red = ((pixel >>> 16) + ((signedByte(coefficients) * green) >> 5)) & 255;
				final blue = (pixel + ((signedByte(coefficients >>> 8) * green) >> 5)
					+ ((signedByte(coefficients >>> 16) * signedByte(red)) >> 5)) & 255;
				pixels[i] = (pixel & 0xff00ff00) | (red << 16) | blue;
			}
	}

	static inline function hash(pixel:Int, bits:Int):Int {
		final value:haxe.Int32 = pixel;
		return (value * 0x1e35a7bd) >>> (32 - bits);
	}

	static inline function tiles(size:Int, bits:Int):Int return (size + (1 << bits) - 1) >> bits;

	static inline function signedByte(value:Int):Int return ((value & 255) ^ 128) - 128;

	static inline function average(a:Int, b:Int):Int return (a & b) + (((a ^ b) >>> 1) & 0x7f7f7f7f);

	static inline function add(a:Int, b:Int):Int {
		return (((a & 0x00ff00ff) + (b & 0x00ff00ff)) & 0x00ff00ff)
			| (((a & 0xff00ff00) + (b & 0xff00ff00)) & 0xff00ff00);
	}

	static inline function invalid(reason:String):ImageLoadingFailed return new ImageLoadingFailed(WEBP, reason);
}

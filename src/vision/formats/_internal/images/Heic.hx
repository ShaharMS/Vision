package vision.formats._internal.images;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcPcmEncoder;
import vision.formats._internal.images.heif.HeifContainer;
import vision.formats._internal.images.heif.HeifContainer.HeifProperty;

/** Portable HEIC byte conversion. **/
@:noCompletion
class Heic {
	/** Encodes an opaque HEIC still image using HEVC PCM and 4:2:0 color. **/
	public static function write(image:Image):ByteArray {
		final width = image.width;
		final height = image.height;
		if (width <= 0 || height <= 0 || width > 8192 || height > 8192 || width * 1.0 * height > 8912896)
			throw new HevcBitstreamError("HEIC image exceeds the supported HEVC picture dimensions.");
		final sampleWidth = (width + 1) & ~1;
		final sampleHeight = (height + 1) & ~1;
		final chromaWidth = sampleWidth >> 1;
		final chromaHeight = sampleHeight >> 1;
		final y = Bytes.alloc(sampleWidth * sampleHeight);
		final cb = Bytes.alloc(chromaWidth * chromaHeight);
		final cr = Bytes.alloc(cb.length);
		for (row in 0...chromaHeight) {
			for (column in 0...chromaWidth) {
				var blueDifference = 0;
				var redDifference = 0;
				for (dy in 0...2) {
					final py = row * 2 + dy;
					for (dx in 0...2) {
						final px = column * 2 + dx;
						final pixel = image.getPixel(px < width ? px : width - 1, py < height ? py : height - 1);
						final luminance = pixel.red * 2126 + pixel.green * 7152 + pixel.blue * 722;
						y.set(py * sampleWidth + px, Std.int((luminance + 5000) / 10000));
						blueDifference += pixel.blue * 10000 - luminance;
						redDifference += pixel.red * 10000 - luminance;
					}
				}
				final offset = row * chromaWidth + column;
				cb.set(offset, chromaSample(blueDifference, 8 * (10000 - 722)));
				cr.set(offset, chromaSample(redDifference, 8 * (10000 - 2126)));
			}
		}
		final units = HevcPcmEncoder.encode(sampleWidth, sampleHeight, y, cb, cr);
		final data = writer();
		data.writeInt32(units[3].length);
		data.write(units[3]);
		final dimensions = writer();
		dimensions.writeInt32(0);
		dimensions.writeInt32(sampleWidth);
		dimensions.writeInt32(sampleHeight);
		final properties:Array<HeifProperty> = [
			{type: "hvcC", essential: true, payload: configuration(units)},
			{type: "ispe", essential: false, payload: dimensions.getBytes()},
			{type: "pixi", essential: false, payload: Bytes.ofHex("0000000003080808")},
			{type: "colr", essential: false, payload: Bytes.ofHex("6e636c780001000d000180")}
		];
		if (width != sampleWidth || height != sampleHeight)
			properties.push({type: "clap", essential: true, payload: aperture(width, height, sampleWidth, sampleHeight)});
		return HeifContainer.writePrimary({
			type: "hvc1",
			width: sampleWidth,
			height: sampleHeight,
			data: data.getBytes(),
			properties: properties
		});
	}

	static function configuration(units:Array<Bytes>):Bytes {
		final output = writer();
		output.write(Bytes.ofHex("01216000000090000000000099f000fcfdf8f800000f03"));
		for (i in 0...3) {
			output.writeByte(0x80 | (32 + i));
			output.writeUInt16(1);
			output.writeUInt16(units[i].length);
			output.write(units[i]);
		}
		return output.getBytes();
	}

	static function aperture(width:Int, height:Int, sampleWidth:Int, sampleHeight:Int):Bytes {
		final output = writer();
		for (value in [width, 1, height, 1, width - sampleWidth, 2, height - sampleHeight, 2])
			output.writeInt32(value);
		return output.getBytes();
	}

	static inline function chromaSample(difference:Int, divisor:Int):Int {
		final value = Math.round(128 + difference / divisor);
		return value > 255 ? 255 : value;
	}

	static inline function writer():BytesOutput {
		final output = new BytesOutput();
		output.bigEndian = true;
		return output;
	}
}

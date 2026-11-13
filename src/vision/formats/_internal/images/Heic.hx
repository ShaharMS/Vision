package vision.formats._internal.images;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcConfiguration;
import vision.formats._internal.images.heic.hevc.HevcIdrSlice;
import vision.formats._internal.images.heic.hevc.HevcIntraPicture;
import vision.formats._internal.images.heic.hevc.HevcNalReader;
import vision.formats._internal.images.heic.hevc.HevcPictureParameters;
import vision.formats._internal.images.heic.hevc.HevcPcmDecoder;
import vision.formats._internal.images.heic.hevc.HevcPcmEncoder;
import vision.formats._internal.images.heic.hevc.HevcSequenceGeometry;
import vision.formats._internal.images.heif.HeifContainer;
import vision.formats._internal.images.heif.HeifContainer.HeifProperty;

/** Portable HEIC byte conversion. **/
@:noCompletion
class Heic {
	static final colorProperty = Bytes.ofHex("6e636c780001000d000180");

	/** Decodes a directly coded HEVC still image. **/
	public static function read(bytes:ByteArray):Image {
		final item = HeifContainer.readPrimary(bytes);
		if (item.type != "hvc1") throw new HevcBitstreamError("The primary image is not an HEVC item.");
		var configuration:HevcConfiguration = null;
		var crop = {x: 0, y: 0, width: item.width, height: item.height};
		var matrix:Null<Int> = null;
		var range:Null<Bool> = null;
		for (property in item.properties) {
			switch property.type {
				case "hvcC": configuration = new HevcConfiguration(property.payload);
				case "clap": crop = readAperture(property.payload, item.width, item.height);
				case "colr":
					final color = property.payload;
					if (color.length == 11 && color.getString(0, 4) == "nclx") {
						matrix = (color.get(8) << 8) | color.get(9);
						range = (color.get(10) & 128) != 0;
					} else if (property.essential) throw new HevcBitstreamError("Unsupported essential HEIC color profile.");
				case "irot", "imir": throw new HevcBitstreamError("Unsupported HEVC image orientation.");
				case "ispe", "pixi":
				default:
					if (property.essential) throw new HevcBitstreamError('Unsupported essential HEIC property "${property.type}".');
			}
		}
		if (configuration == null) throw new HevcBitstreamError("Missing HEVC decoder configuration.");
		var geometry:HevcSequenceGeometry = null;
		var pps:Bytes = null;
		for (unit in configuration.units) {
			if (unit.type == 33 && unit.layerId == 0) {
				if (geometry != null) throw new HevcBitstreamError("Multiple HEVC sequence parameter sets are unsupported.");
				geometry = new HevcSequenceGeometry(unit.rbsp);
			}
			if (unit.type == 34 && unit.layerId == 0) {
				if (pps != null) throw new HevcBitstreamError("Multiple HEVC picture parameter sets are unsupported.");
				pps = unit.rbsp;
			}
		}
		if (geometry == null || pps == null || geometry.width != item.width || geometry.height != item.height)
			throw new HevcBitstreamError("HEVC parameter sets do not match the primary item.");
		final reader = new HevcNalReader(item.data, 0, item.data.length, configuration.lengthSize);
		var slice = null;
		var unit = reader.next();
		while (unit != null) {
			if (unit.type < 32) {
				if (slice != null || unit.layerId != 0 || (unit.type != 19 && unit.type != 20))
					throw new HevcBitstreamError("Expected one HEVC IDR slice.");
				slice = unit;
			}
			unit = reader.next();
		}
		if (slice == null) throw new HevcBitstreamError("Missing HEVC IDR slice.");
		final planes = if (geometry.pcm != null) HevcPcmDecoder.decode(geometry, pps, slice.rbsp) else {
			final picture = new HevcPictureParameters(pps);
			final header = new HevcIdrSlice(slice.rbsp, geometry, picture, slice.escaped);
			HevcIntraPicture.decode(geometry, picture, header, slice.rbsp);
		};
		final fullRange = range == null ? geometry.fullRange : range;
		final factors = switch (matrix == null ? geometry.matrixCoefficients : matrix) {
			case 1: [0.2126, 0.0722];
			case 4: [0.30, 0.11];
			case 2, 5, 6: [0.299, 0.114];
			case 7: [0.212, 0.087];
			case 9: [0.2627, 0.0593];
			default: throw new HevcBitstreamError("Unsupported HEVC color matrix.");
		};
		final kr = factors[0];
		final kb = factors[1];
		final kg = 1 - kr - kb;
		final lumaScale = fullRange ? 1.0 : 255.0 / 219;
		final chromaScale = fullRange ? 1.0 : 255.0 / 224;
		final image = new Image(crop.width, crop.height);
		for (row in 0...crop.height) {
			final y = row + geometry.cropTop + crop.y;
			for (column in 0...crop.width) {
				final x = column + geometry.cropLeft + crop.x;
				final luma = (planes[0].get(y * geometry.codedWidth + x) - (fullRange ? 0 : 16)) * lumaScale;
				final chroma = (y >> 1) * (geometry.codedWidth >> 1) + (x >> 1);
				final cb = (planes[1].get(chroma) - 128) * chromaScale;
				final cr = (planes[2].get(chroma) - 128) * chromaScale;
				final r = luma + 2 * (1 - kr) * cr;
				final b = luma + 2 * (1 - kb) * cb;
				image.setPixel(column, row, Color.fromRGBA(
					rgbSample(r), rgbSample((luma - kr * r - kb * b) / kg), rgbSample(b)
				));
			}
		}
		return image;
	}

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
			{type: "colr", essential: false, payload: colorProperty}
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

	static function readAperture(bytes:Bytes, width:Int, height:Int):{x:Int, y:Int, width:Int, height:Int} {
		if (bytes.length != 32) throw new HevcBitstreamError("Invalid HEIC clean aperture.");
		final input = new BytesInput(bytes);
		input.bigEndian = true;
		final cropWidth = readFraction(input);
		final cropHeight = readFraction(input);
		final x = (width - cropWidth) / 2 + readFraction(input);
		final y = (height - cropHeight) / 2 + readFraction(input);
		if (cropWidth < 1 || cropHeight < 1 || x < 0 || y < 0 || x + cropWidth > width || y + cropHeight > height
			|| x != Std.int(x) || y != Std.int(y) || cropWidth != Std.int(cropWidth) || cropHeight != Std.int(cropHeight))
			throw new HevcBitstreamError("Invalid HEIC clean aperture bounds.");
		return {x: Std.int(x), y: Std.int(y), width: Std.int(cropWidth), height: Std.int(cropHeight)};
	}

	static function readFraction(input:BytesInput):Float {
		final numerator = input.readInt32();
		final denominator = input.readInt32();
		if (denominator <= 0) throw new HevcBitstreamError("Invalid HEIC clean aperture denominator.");
		return numerator / denominator;
	}

	static inline function rgbSample(value:Float):Int {
		return value < 0 ? 0 : value > 255 ? 255 : Math.round(value);
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

package vision.formats._internal.images;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1IntraPicture;
import vision.formats._internal.images.avif.av1.Av1ObuReader;
import vision.formats._internal.images.avif.av1.Av1PalettePicture;
import vision.formats._internal.images.avif.av1.Av1SequenceHeader;
import vision.formats._internal.images.avif.av1.Av1StillFrameHeader;
import vision.formats._internal.images.avif.av1.Av1TileLayout.Av1Tile;
import vision.formats._internal.images.heif.HeifContainer;

/** Portable AVIF byte conversion. **/
@:noCompletion
class Avif {
	/** Decodes an opaque, directly coded AV1 still picture. **/
	public static function read(bytes:ByteArray):Image {
		final item = HeifContainer.readPrimary(bytes);
		if (item.type != "av01") throw new Av1BitstreamError("The primary image is not an AV1 item.");
		var sequence:Av1SequenceHeader = null;
		var matrix:Null<Int> = null;
		var fullRange:Null<Bool> = null;
		for (property in item.properties) {
			switch property.type {
				case "av1C":
					if (property.payload.length < 4 || property.payload.get(0) != 0x81)
						throw new Av1BitstreamError("Invalid AV1 codec configuration.");
					final config = new Av1ObuReader(property.payload, 4, property.payload.length - 4);
					var unit = config.next();
					while (unit != null) {
						if (unit.type == 1) sequence = new Av1SequenceHeader(property.payload, unit.offset, unit.length);
						unit = config.next();
					}
				case "colr":
					final color = property.payload;
					if (color.length == 11 && color.getString(0, 4) == "nclx") {
						matrix = (color.get(8) << 8) | color.get(9);
						fullRange = (color.get(10) & 128) != 0;
					} else if (property.essential) throw new Av1BitstreamError("Unsupported essential AVIF color profile.");
				case "ispe", "pixi":
				default:
					if (property.essential || property.type == "irot" || property.type == "imir" || property.type == "clap")
						throw new Av1BitstreamError('Unsupported AVIF property "${property.type}".');
			}
		}
		final reader = new Av1ObuReader(item.data, 0, item.data.length);
		final tiles:Array<Av1Tile> = [];
		var frame:Av1StillFrameHeader = null;
		var unit = reader.next();
		while (unit != null) {
			switch unit.type {
				case 1:
					if (frame != null) throw new Av1BitstreamError("Unexpected sequence header after an AV1 frame.");
					sequence = new Av1SequenceHeader(item.data, unit.offset, unit.length);
				case 3, 6:
					if (sequence == null || frame != null) throw new Av1BitstreamError("Unexpected AV1 frame header.");
					final combined = unit.type == 6;
					frame = new Av1StillFrameHeader(sequence, item.data, unit.offset, unit.length, combined);
					if (combined) {
						final end = unit.offset + unit.length;
						for (tile in frame.tiles.readGroup(item.data, frame.tileGroupOffset, end - frame.tileGroupOffset))
							tiles.push(tile);
					}
				case 4:
					if (frame == null) throw new Av1BitstreamError("AV1 tile group precedes its frame header.");
					for (tile in frame.tiles.readGroup(item.data, unit.offset, unit.length)) tiles.push(tile);
				default:
			}
			unit = reader.next();
		}
		if (frame == null || frame.width != item.width || frame.height != item.height)
			throw new Av1BitstreamError("AV1 frame dimensions do not match the primary item.");
		final planes = frame.screenContent ? Av1PalettePicture.decode(item.data, sequence, frame, tiles)
			: Av1IntraPicture.decode(item.data, sequence, frame, tiles);
		return pixels(item.width, item.height, sequence, planes,
			matrix == null ? sequence.matrixCoefficients : matrix, fullRange == null ? sequence.fullRange : fullRange);
	}

	static function pixels(width:Int, height:Int, sequence:Av1SequenceHeader, planes:Array<Bytes>, matrix:Int, fullRange:Bool):Image {
		final subX = sequence.subsamplingX ? 1 : 0;
		final subY = sequence.subsamplingY ? 1 : 0;
		final stride = (width + subX) >> subX;
		final image = new Image(width, height);
		if (matrix == 0 && !sequence.monochrome) {
			if (subX != 0 || subY != 0 || !fullRange) throw new Av1BitstreamError("Invalid AVIF identity color configuration.");
			for (y in 0...height) for (x in 0...width) {
				final offset = y * width + x;
				image.setPixel(x, y, Color.fromRGBA(planes[2].get(offset), planes[0].get(offset), planes[1].get(offset)));
			}
			return image;
		}
		final factors = sequence.monochrome ? [0.299, 0.114] : switch matrix {
			case 1: [0.2126, 0.0722];
			case 4: [0.30, 0.11];
			case 2, 5, 6: [0.299, 0.114];
			case 7: [0.212, 0.087];
			case 9: [0.2627, 0.0593];
			default: throw new Av1BitstreamError("Unsupported AVIF color matrix.");
		};
		final kr = factors[0];
		final kb = factors[1];
		final kg = 1.0 - kr - kb;
		final lumaScale = fullRange ? 1.0 : 255.0 / 219;
		final chromaScale = fullRange ? 1.0 : 255.0 / 224;
		final lumaOffset = fullRange ? 0 : 16;
		for (y in 0...height) for (x in 0...width) {
			final luma = (planes[0].get(y * width + x) - lumaOffset) * lumaScale;
			final offset = (y >> subY) * stride + (x >> subX);
			final cb = sequence.monochrome ? 0.0 : (planes[1].get(offset) - 128) * chromaScale;
			final cr = sequence.monochrome ? 0.0 : (planes[2].get(offset) - 128) * chromaScale;
			final r = luma + 2 * (1 - kr) * cr;
			final b = luma + 2 * (1 - kb) * cb;
			final g = (luma - kr * r - kb * b) / kg;
			image.setPixel(x, y, Color.fromRGBA(sample(r), sample(g), sample(b)));
		}
		return image;
	}

	static inline function sample(value:Float):Int return value < 0 ? 0 : value > 255 ? 255 : Math.round(value);

	/** Encodes an opaque AVIF still image using AV1 RGB palettes. **/
	public static function write(image:Image):ByteArray {
		final width = image.width;
		final height = image.height;
		if (width < 1 || height < 1 || width > 4096 || height > 4096 || width * height > 4096 * 2304)
			throw new Av1BitstreamError("AVIF image exceeds the supported AV1 picture dimensions.");
		final green = Bytes.alloc(width * height);
		final blue = Bytes.alloc(green.length);
		final red = Bytes.alloc(green.length);
		for (y in 0...height) {
			for (x in 0...width) {
				final pixel = image.getPixel(x, y);
				final offset = y * width + x;
				green.set(offset, pixel.green);
				blue.set(offset, pixel.blue);
				red.set(offset, pixel.red);
			}
		}
		final data = Av1PalettePicture.encode(width, height, green, blue, red);
		final dimensions = new BytesOutput();
		dimensions.bigEndian = true;
		dimensions.writeInt32(0);
		dimensions.writeInt32(width);
		dimensions.writeInt32(height);
		final configuration = Bytes.ofHex("81200000");
		configuration.set(1, (1 << 5) | Av1PalettePicture.LEVEL);
		return HeifContainer.writePrimary({
			type: "av01",
			width: width,
			height: height,
			data: data,
			properties: [
				{type: "av1C", essential: true, payload: configuration},
				{type: "ispe", essential: false, payload: dimensions.getBytes()},
				{type: "pixi", essential: false, payload: Bytes.ofHex("0000000003080808")},
				{type: "colr", essential: false, payload: Bytes.ofHex("6e636c780001000d000080")}
			]
		});
	}
}

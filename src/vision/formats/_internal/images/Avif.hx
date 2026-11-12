package vision.formats._internal.images;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1ObuReader;
import vision.formats._internal.images.avif.av1.Av1PalettePicture;
import vision.formats._internal.images.avif.av1.Av1SequenceHeader;
import vision.formats._internal.images.avif.av1.Av1StillFrameHeader;
import vision.formats._internal.images.avif.av1.Av1TileLayout.Av1Tile;
import vision.formats._internal.images.heif.HeifContainer;

/** Portable AVIF byte conversion. **/
@:noCompletion
class Avif {
	/** Decodes an opaque, directly coded AV1 RGB palette picture. **/
	public static function read(bytes:ByteArray):Image {
		final item = HeifContainer.readPrimary(bytes);
		if (item.type != "av01") throw new Av1BitstreamError("The primary image is not an AV1 item.");
		var sequence:Av1SequenceHeader = null;
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
				case "ispe", "pixi", "colr":
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
		final planes = Av1PalettePicture.decode(item.data, sequence, frame, tiles);
		final image = new Image(item.width, item.height);
		for (y in 0...item.height) {
			for (x in 0...item.width) {
				final offset = y * item.width + x;
				image.setPixel(x, y, Color.fromRGBA(planes[2].get(offset), planes[0].get(offset), planes[1].get(offset)));
			}
		}
		return image;
	}

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

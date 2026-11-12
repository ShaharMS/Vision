package vision.formats._internal.images.heif;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesOutput;
import vision.exceptions.HeifContainerError;

/** An item property with its essential flag and original payload. **/
typedef HeifProperty = {
	final type:String;
	final essential:Bool;
	final payload:Bytes;
}

/** A directly coded image item and its associated container properties. **/
typedef HeifCodedImage = {
	final type:String;
	final width:Int;
	final height:Int;
	final data:Bytes;
	final properties:Array<HeifProperty>;
}

private typedef HeifBox = {
	final type:String;
	final start:Int;
	final end:Int;
}

/** Reads and writes single directly coded image items in HEIF containers. **/
@:noCompletion
class HeifContainer {
	/**
		Extracts the primary AV1 or HEVC bitstream and its properties.

		This operation reads the coded item. Derived grids, auxiliary images,
		and sequences require their own assembly paths.
	**/
	public static function readPrimary(bytes:Bytes):HeifCodedImage {
		final root = new BoxReader(bytes, 0, bytes.length).boxes();
		find(root, "ftyp");
		final meta = cursor(bytes, find(root, "meta"));
		if (meta.read(4) != 0) throw invalid("Unsupported meta header.");
		final children = meta.boxes();
		final primary = cursor(bytes, find(children, "pitm"));
		final version = primary.version();
		if (version > 1) throw invalid("Unsupported primary item version.");
		final id = primary.read(version == 0 ? 2 : 4);
		final type = itemType(bytes, find(children, "iinf"), id);
		final config = configType(type);
		final properties = itemProperties(bytes, find(children, "iprp"), id);
		var spatial:Bytes = null;
		var configured = false;
		for (property in properties) {
			if (property.type == "ispe") spatial = property.payload;
			if (property.type == config) configured = true;
		}
		if (!configured || spatial == null) throw invalid("Missing codec or spatial properties.");
		final dimensions = new BoxReader(spatial, 0, spatial.length);
		if (dimensions.read(4) != 0) throw invalid("Unsupported spatial property version.");
		final width = dimensions.read(4);
		final height = dimensions.read(4);
		if (width == 0 || height == 0) throw invalid("Invalid image dimensions.");
		final data = itemData(bytes, find(children, "iloc"), root, children, id);
		return {type: type, width: width, height: height, properties: properties, data: data};
	}

	static function itemType(bytes:Bytes, box:HeifBox, id:Int):String {
		final reader = cursor(bytes, box);
		final version = reader.version();
		if (version > 1) throw invalid("Unsupported item information version.");
		final count = reader.read(version == 0 ? 2 : 4);
		final entries = reader.boxes();
		if (entries.length != count) throw invalid("Item information count does not match its entries.");
		for (entry in entries) {
			if (entry.type != "infe") continue;
			final item = cursor(bytes, entry);
			final version = item.version();
			if (version != 2 && version != 3) continue;
			if (item.read(version == 2 ? 2 : 4) != id) continue;
			if (item.read(2) != 0) throw invalid("Protected image items are unsupported.");
			return item.tag();
		}
		throw invalid("Primary image item information is missing.");
	}

	static function itemProperties(bytes:Bytes, box:HeifBox, id:Int):Array<HeifProperty> {
		final children = cursor(bytes, box).boxes();
		final properties = cursor(bytes, find(children, "ipco")).boxes();
		final result:Array<HeifProperty> = [];
		final seen = new haxe.ds.IntMap<Bool>();
		for (child in children) {
			if (child.type != "ipma") continue;
			final reader = cursor(bytes, child);
			final header = reader.read(4);
			final version = header >>> 24;
			if (version > 1) throw invalid("Unsupported item association version.");
			final large = (header & 1) != 0;
			for (_ in 0...reader.read(4)) {
				final item = reader.read(version == 0 ? 2 : 4);
				for (_ in 0...reader.read(1)) {
					final association = reader.read(large ? 2 : 1);
					if (item != id) continue;
					final essentialBit = large ? 32768 : 128;
					final index = association & (essentialBit - 1);
					if (index == 0) continue;
					if (index > properties.length || seen.exists(index)) throw invalid("Invalid or repeated item property index.");
					seen.set(index, true);
					final property = properties[index - 1];
					result.push({type: property.type, essential: (association & essentialBit) != 0,
						payload: bytes.sub(property.start, property.end - property.start)});
				}
			}
		}
		return result;
	}

	static function itemData(bytes:Bytes, box:HeifBox, root:Array<HeifBox>, children:Array<HeifBox>, id:Int):Bytes {
		final reader = cursor(bytes, box);
		final version = reader.version();
		if (version > 2) throw invalid("Unsupported item location version.");
		final widths = reader.read(2);
		final offsetSize = widths >>> 12;
		final lengthSize = (widths >>> 8) & 15;
		final baseSize = (widths >>> 4) & 15;
		final indexSize = version == 0 ? 0 : widths & 15;
		final itemSize = version == 2 ? 4 : 2;
		final output = new BytesBuffer();
		var total = 0;
		for (_ in 0...reader.read(itemSize)) {
			final item = reader.read(itemSize);
			final method = version == 0 ? 0 : reader.read(2) & 15;
			final reference = reader.read(2);
			final base = reader.read(baseSize);
			for (_ in 0...reader.read(2)) {
				reader.skip(indexSize);
				final offset = reader.read(offsetSize);
				final length = reader.read(lengthSize);
				if (item != id) continue;
				if (reference != 0 || method > 1 || length == 0) throw invalid("Unsupported primary item extent.");
				final data = method == 1 ? find(children, "idat") : null;
				final start = (data == null ? 0 : data.start) + base * 1.0 + offset;
				if (start > bytes.length || length > bytes.length - start || length > bytes.length - total)
					throw invalid("Primary item extent is outside the file.");
				if (data == null) {
					var contained = false;
					for (candidate in root)
						if (candidate.type == "mdat" && start >= candidate.start && length <= candidate.end - start) contained = true;
					if (!contained) throw invalid("Primary item extent is outside media data.");
				} else if (length > data.end - start) {
					throw invalid("Primary item extent is outside inline data.");
				}
				output.addBytes(bytes, Std.int(start), length);
				total += length;
			}
		}
		if (total == 0) throw invalid("Primary item data is missing.");
		return output.getBytes();
	}

	/** Wraps one already encoded AV1 or HEVC image item in a new HEIF container. **/
	public static function writePrimary(image:HeifCodedImage):Bytes {
		final config = configType(image.type);
		if (image.data.length == 0 || image.data.length > 0x3fffffff || image.properties.length > 127)
			throw invalid("Invalid coded image data or property count.");
		var configured = false;
		var spatial = false;
		var propertyBytes = 0;
		for (property in image.properties) {
			if (Bytes.ofString(property.type).length != 4 || property.payload.length > 0x3fffffff - image.data.length - propertyBytes)
				throw invalid("Invalid property type or length.");
			propertyBytes += property.payload.length;
			if (property.type == config) configured = true;
			if (property.type == "ispe") {
				final reader = new BoxReader(property.payload, 0, property.payload.length);
				if (reader.read(4) != 0 || reader.read(4) != image.width || reader.read(4) != image.height)
					throw invalid("Spatial property does not match image dimensions.");
				spatial = true;
			}
		}
		if (!configured || !spatial || image.width <= 0 || image.height <= 0) throw invalid("Missing codec or spatial properties.");

		final output = writer();
		final brand = image.type == "av01" ? "avif" : "heic";
		final fileType = writer();
		fileType.writeString(brand);
		fileType.writeInt32(0);
		fileType.writeString(brand + "mif1");
		if (brand == "avif") fileType.writeString("miaf");
		box(output, "ftyp", fileType.getBytes());

		final placeholder = metadata(image, 0);
		box(output, "meta", metadata(image, output.length + 8 + placeholder.length + 8));
		box(output, "mdat", image.data);
		return output.getBytes();
	}

	static function metadata(image:HeifCodedImage, dataOffset:Int):Bytes {
		final meta = writer();
		meta.writeInt32(0);

		final handler = writer();
		handler.writeInt32(0);
		handler.writeInt32(0);
		handler.writeString("pict");
		for (_ in 0...3) handler.writeInt32(0);
		handler.writeByte(0);
		box(meta, "hdlr", handler.getBytes());

		final primary = writer();
		primary.writeInt32(0);
		primary.writeUInt16(1);
		box(meta, "pitm", primary.getBytes());

		final locations = writer();
		locations.writeInt32(0);
		locations.writeByte(0x44);
		locations.writeByte(0);
		locations.writeUInt16(1);
		locations.writeUInt16(1);
		locations.writeUInt16(0);
		locations.writeUInt16(1);
		locations.writeInt32(dataOffset);
		locations.writeInt32(image.data.length);
		box(meta, "iloc", locations.getBytes());

		final info = writer();
		info.writeInt32(0);
		info.writeUInt16(1);
		final entry = writer();
		entry.writeInt32(2 << 24);
		entry.writeUInt16(1);
		entry.writeUInt16(0);
		entry.writeString(image.type);
		entry.writeByte(0);
		box(info, "infe", entry.getBytes());
		box(meta, "iinf", info.getBytes());

		final properties = writer();
		for (property in image.properties) box(properties, property.type, property.payload);
		final associations = writer();
		associations.writeInt32(0);
		associations.writeInt32(1);
		associations.writeUInt16(1);
		associations.writeByte(image.properties.length);
		for (i in 0...image.properties.length)
			associations.writeByte((i + 1) | (image.properties[i].essential ? 128 : 0));
		final propertyBox = writer();
		box(propertyBox, "ipco", properties.getBytes());
		box(propertyBox, "ipma", associations.getBytes());
		box(meta, "iprp", propertyBox.getBytes());
		return meta.getBytes();
	}

	static function configType(type:String):String {
		return switch type {
			case "av01": "av1C";
			case "hvc1", "hev1": "hvcC";
			default: throw invalid('Unsupported directly coded primary item "$type".');
		}
	}

	static function find(boxes:Array<HeifBox>, type:String):HeifBox {
		for (box in boxes) if (box.type == type) return box;
		throw invalid('Missing "$type" box.');
	}

	static inline function cursor(bytes:Bytes, box:HeifBox):BoxReader return new BoxReader(bytes, box.start, box.end);

	static function writer():BytesOutput {
		final output = new BytesOutput();
		output.bigEndian = true;
		return output;
	}

	static function box(output:BytesOutput, type:String, data:Bytes):Void {
		output.writeInt32(8 + data.length);
		output.writeString(type);
		output.write(data);
	}

	static inline function invalid(message:String):HeifContainerError return new HeifContainerError(message);
}

private class BoxReader {
	final bytes:Bytes;
	var offset:Int;
	final end:Int;

	public function new(bytes:Bytes, offset:Int, end:Int) {
		this.bytes = bytes;
		this.offset = offset;
		this.end = end;
	}

	public function version():Int {
		final value = read(1);
		skip(3);
		return value;
	}

	public function boxes():Array<HeifBox> {
		final result:Array<HeifBox> = [];
		while (offset < end) {
			final start = offset;
			final size = read(4);
			final type = tag();
			final length = size == 1 ? read(8) : size == 0 ? end - start : size;
			if (length < offset - start || length > end - start) throw new HeifContainerError('Invalid "$type" box size.');
			result.push({type: type, start: offset, end: start + length});
			offset = start + length;
		}
		return result;
	}

	public function tag():String {
		final start = offset;
		skip(4);
		return bytes.getString(start, 4);
	}

	public function read(size:Int):Int {
		final start = offset;
		skip(size);
		var value = 0.0;
		for (i in 0...size) value = value * 256 + bytes.get(start + i);
		if (value > 0x7fffffff) throw new HeifContainerError("Container field exceeds the supported integer range.");
		return Std.int(value);
	}

	public function skip(size:Int):Void {
		if (size < 0 || size > 8 || size > end - offset) throw new HeifContainerError("Truncated or invalid HEIF field.");
		offset += size;
	}
}

package vision.formats._internal.images.jpeg;

import haxe.io.Bytes;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;

private class Component {
	public final id:Int;
	public final horizontal:Int;
	public final vertical:Int;
	public final quantization:Int;
	public var width:Int;
	public var height:Int;
	public var samples:Bytes;
	public var predictor:Int = 0;
	public var dc:Int;
	public var ac:Int;
	public var decoded = false;
	public var blocks:Bytes;
	public final successive = [for (_ in 0...64) -1];

	public function new(id:Int, horizontal:Int, vertical:Int, quantization:Int) {
		this.id = id;
		this.horizontal = horizontal;
		this.vertical = vertical;
		this.quantization = quantization;
	}
}

private class HuffmanTable {
	final first:Array<Int> = [];
	final limit:Array<Int> = [];
	final offsets:Array<Int> = [];
	final symbols:Array<Int>;

	public function new(counts:Array<Int>, symbols:Array<Int>) {
		this.symbols = symbols;
		var code = 0;
		var offset = 0;
		for (i in 0...16) {
			first.push(code);
			code += counts[i];
			if (code >= 1 << (i + 1)) throw JpegReader.invalid("Invalid JPEG Huffman code lengths.");
			limit.push(code);
			offsets.push(offset);
			offset += counts[i];
			code <<= 1;
		}
	}

	public function read(reader:JpegReader):Int {
		var code = 0;
		for (i in 0...16) {
			code = (code << 1) | reader.bit();
			if (code >= first[i] && code < limit[i]) return symbols[offsets[i] + code - first[i]];
		}
		throw JpegReader.invalid("Invalid JPEG Huffman code.");
	}
}

/** Decodes 8-bit sequential and progressive Huffman-coded grayscale, RGB, YCbCr, CMYK, and YCCK JPEGs. **/
@:noCompletion
class JpegReader {
	static final zigzag = [
		0, 1, 8, 16, 9, 2, 3, 10, 17, 24, 32, 25, 18, 11, 4, 5,
		12, 19, 26, 33, 40, 48, 41, 34, 27, 20, 13, 6, 7, 14, 21, 28,
		35, 42, 49, 56, 57, 50, 43, 36, 29, 22, 15, 23, 30, 37, 44, 51,
		58, 59, 52, 45, 38, 31, 39, 46, 53, 60, 61, 54, 47, 55, 62, 63
	];
	static final cosine = [for (x in 0...8) [for (u in 0...8) Math.cos((2 * x + 1) * u * Math.PI / 16) * (u == 0 ? Math.sqrt(0.5) : 1)]];

	final bytes:Bytes;
	final components:Array<Component> = [];
	final quantization:Array<Array<Int>> = [];
	final huffman:Array<HuffmanTable> = [];
	final coefficients = [for (_ in 0...64) 0.0];
	final intermediate = [for (_ in 0...64) 0.0];
	var position = 0;
	var end = 0;
	var width = 0;
	var height = 0;
	var maxHorizontal = 0;
	var maxVertical = 0;
	var columns = 0;
	var rows = 0;
	var interval = 0;
	var bits = 0;
	var entropy = 0;
	var adobeTransform = -1;
	var progressive = false;
	var eobRun = 0;

	public function new(bytes:Bytes) {
		this.bytes = bytes;
		end = bytes.length;
	}

	public function read():Image {
		if (word() != 0xffd8) throw invalid("Missing JPEG start marker.");
		while (true) {
			final marker = nextMarker();
			if (marker == 0xd9) break;
			if (marker < 0xc0 || marker == 0xd8 || (marker >= 0xd0 && marker <= 0xd7)) throw invalid("Unexpected JPEG marker.");
			final length = word();
			if (length < 2 || length - 2 > bytes.length - position) throw invalid("Invalid JPEG segment length.");
			final segmentEnd = position + length - 2;
			end = segmentEnd;
			switch marker {
				case 0xc0, 0xc1, 0xc2: readFrame(marker == 0xc2);
				case 0xc4: readHuffman();
				case 0xdb: readQuantization();
				case 0xdd: interval = word();
				case 0xda:
					readScan(segmentEnd);
					continue;
				case 0xee:
					if (length >= 14 && bytes.getString(position, 5) == "Adobe") adobeTransform = bytes.get(position + 11);
				case value if (value >= 0xc0 && value <= 0xcf):
					throw invalid("Unsupported JPEG frame. Expected sequential or progressive Huffman coding.");
				default:
			}
			position = segmentEnd;
			end = bytes.length;
		}
		if (components.length == 0) throw invalid("Missing JPEG frame.");
		for (component in components) {
			if (!component.decoded) throw invalid("Missing JPEG image scan.");
			if (progressive) finishComponent(component);
		}
		return toImage();
	}

	function readFrame(isProgressive:Bool):Void {
		if (components.length != 0 || byte() != 8) throw invalid("Expected one 8-bit JPEG frame.");
		progressive = isProgressive;
		height = word();
		width = word();
		final count = byte();
		if (width == 0 || height == 0 || width * 1.0 * height > 32000000 || (count != 1 && count != 3 && count != 4))
			throw invalid("Unsupported JPEG dimensions or color components.");
		for (_ in 0...count) {
			final id = byte();
			final sampling = byte();
			final horizontal = sampling >> 4;
			final vertical = sampling & 15;
			final table = byte();
			if (horizontal < 1 || horizontal > 4 || vertical < 1 || vertical > 4 || table > 3 || find(id) != null)
				throw invalid("Invalid JPEG frame component.");
			if (horizontal > maxHorizontal) maxHorizontal = horizontal;
			if (vertical > maxVertical) maxVertical = vertical;
			components.push(new Component(id, horizontal, vertical, table));
		}
		columns = Math.ceil(width / (8 * maxHorizontal));
		rows = Math.ceil(height / (8 * maxVertical));
		var blockCount = 0;
		for (component in components) blockCount += component.horizontal * component.vertical;
		if (blockCount > 10 || columns * 1.0 * rows * blockCount * 64 * (progressive ? 5 : 1) > 128000000)
			throw invalid("JPEG sampling requires too much storage.");
		for (component in components) {
			component.width = columns * component.horizontal * 8;
			component.height = rows * component.vertical * 8;
			component.samples = Bytes.alloc(component.width * component.height);
			if (progressive) component.blocks = Bytes.alloc(component.width * component.height * 4);
		}
	}

	function readHuffman():Void {
		while (position < end) {
			final table = byte();
			if ((table & 0xec) != 0) throw invalid("Invalid JPEG Huffman table index.");
			final counts = [for (_ in 0...16) byte()];
			var total = 0;
			for (count in counts) total += count;
			if (total == 0 || total > 256) throw invalid("Invalid JPEG Huffman symbol count.");
			huffman[table] = new HuffmanTable(counts, [for (_ in 0...total) byte()]);
		}
	}

	function readQuantization():Void {
		while (position < end) {
			final table = byte();
			if ((table & 0xec) != 0) throw invalid("Invalid JPEG quantization table index.");
			final values = [for (_ in 0...64) 0];
			for (i in 0...64) {
				final value = table < 16 ? byte() : word();
				if (value == 0) throw invalid("Invalid JPEG quantization value.");
				values[zigzag[i]] = value;
			}
			quantization[table & 3] = values;
		}
	}

	function readScan(segmentEnd:Int):Void {
		final count = byte();
		if (count == 0 || count > components.length) throw invalid("Invalid JPEG scan component count.");
		final scan:Array<Component> = [];
		for (_ in 0...count) {
			final component = find(byte());
			final table = byte();
			if (component == null || (!progressive && component.decoded) || scan.contains(component) || (table & 0xcc) != 0)
				throw invalid("Invalid JPEG scan component.");
			component.dc = table >> 4;
			component.ac = 16 + (table & 15);
			scan.push(component);
		}
		final start = byte();
		final stop = byte();
		final refinement = byte();
		final high = refinement >> 4;
		final low = refinement & 15;
		if (position != segmentEnd || (!progressive && (start != 0 || stop != 63 || refinement != 0))
			|| (progressive && (start > stop || stop > 63 || (start == 0 && stop != 0) || (start != 0 && count != 1)
				|| high > 13 || low > 13 || (high != 0 && high != low + 1))))
			throw invalid("Invalid JPEG scan parameters.");
		for (component in scan) {
			if (quantization[component.quantization] == null || ((!progressive || (start == 0 && high == 0)) && huffman[component.dc] == null)
				|| ((!progressive || start != 0) && huffman[component.ac] == null))
				throw invalid("Missing JPEG coding table.");
			if (progressive) {
				if (start > 0 && component.successive[0] == -1) throw invalid("Missing JPEG DC scan.");
				for (i in start...stop + 1) {
					if (component.successive[i] != (high == 0 ? -1 : high)) throw invalid("Invalid JPEG coefficient progression.");
					component.successive[i] = low;
				}
			}
		}
		eobRun = 0;
		end = bytes.length;
		bits = 0;
		final first = scan[0];
		final scanColumns = count == 1 ? Math.ceil(width * first.horizontal / (8 * maxHorizontal)) : columns;
		final scanRows = count == 1 ? Math.ceil(height * first.vertical / (8 * maxVertical)) : rows;
		var unit = 0;
		var restart = 0;
		for (row in 0...scanRows)
			for (column in 0...scanColumns) {
				if (interval > 0 && unit > 0 && unit % interval == 0) {
					bits = 0;
					if (eobRun != 0) throw invalid("JPEG end-of-band run crosses a restart marker.");
					if (nextMarker() != 0xd0 + restart) throw invalid("Invalid JPEG restart marker.");
					restart = (restart + 1) & 7;
					for (component in scan) component.predictor = 0;
				}
				for (component in scan) {
					final h = count == 1 ? 1 : component.horizontal;
					final v = count == 1 ? 1 : component.vertical;
					for (y in 0...v)
						for (x in 0...h) {
							if (progressive) readProgressive(component, column * h + x, row * v + y, start, stop, high, low);
							else readBlock(component, column * h + x, row * v + y);
						}
				}
				unit++;
			}
		bits = 0;
		if (eobRun != 0) throw invalid("JPEG end-of-band run exceeds its scan.");
		if (start == 0) for (component in scan) component.decoded = true;
	}

	function readBlock(component:Component, x:Int, y:Int):Void {
		for (i in 0...64) coefficients[i] = 0;
		final table = quantization[component.quantization];
		final dcBits = huffman[component.dc].read(this);
		if (dcBits > 11) throw invalid("Invalid JPEG DC coefficient.");
		component.predictor += signed(dcBits);
		coefficients[0] = component.predictor * 1.0 * table[0];
		var index = 1;
		while (index < 64) {
			final symbol = huffman[component.ac].read(this);
			if (symbol == 0) break;
			final count = symbol & 15;
			index += symbol >> 4;
			if (index >= 64 || count > 10 || (count == 0 && symbol != 0xf0)) throw invalid("Invalid JPEG AC coefficient.");
			if (count != 0) {
				final natural = zigzag[index];
				coefficients[natural] = signed(count) * 1.0 * table[natural];
			}
			index++;
		}
		reconstruct(component, x, y);
	}

	function readProgressive(component:Component, x:Int, y:Int, start:Int, stop:Int, high:Int, low:Int):Void {
		final blocks = component.blocks;
		final offset = (y * (component.width >> 3) + x) * 256;
		final bitValue = 1 << low;
		if (start == 0) {
			if (high == 0) {
				final size = huffman[component.dc].read(this);
				if (size > 11) throw invalid("Invalid JPEG DC coefficient.");
				component.predictor += signed(size);
				blocks.setInt32(offset, component.predictor << low);
			} else {
				blocks.setInt32(offset, blocks.getInt32(offset) | (bit() << low));
			}
			return;
		}

		var index = start;
		if (eobRun == 0) {
			while (index <= stop) {
				final symbol = huffman[component.ac].read(this);
				final count = symbol & 15;
				var zeros = symbol >> 4;
				if (count == 0 && zeros < 15) {
					eobRun = (1 << zeros) + unsigned(zeros);
					break;
				}
				if (high == 0) {
					if (count > 10 || index + zeros > stop) throw invalid("Invalid JPEG AC coefficient.");
					index += zeros;
					if (count != 0) blocks.setInt32(offset + zigzag[index] * 4, signed(count) << low);
					index++;
				} else {
					if (count > 1) throw invalid("Invalid JPEG refinement coefficient.");
					final inserted = count == 1 ? signed(1) * bitValue : 0;
					if (count == 0) zeros++;
					var placed = false;
					while (index <= stop) {
						final address = offset + zigzag[index++] * 4;
						final value = blocks.getInt32(address);
						if (value != 0) {
							refine(blocks, address, value, bitValue);
						} else if (zeros == 0) {
							blocks.setInt32(address, inserted);
							placed = true;
							break;
						} else {
							zeros--;
							if (zeros == 0 && count == 0) {
								placed = true;
								break;
							}
						}
					}
					if (!placed) throw invalid("JPEG refinement run exceeds its band.");
				}
			}
		}
		if (eobRun > 0) {
			if (high != 0)
				while (index <= stop) {
					final address = offset + zigzag[index++] * 4;
					final value = blocks.getInt32(address);
					if (value != 0) refine(blocks, address, value, bitValue);
				}
			eobRun--;
		}
	}

	inline function refine(blocks:Bytes, address:Int, value:Int, bitValue:Int):Void {
		if (bit() != 0 && (Std.int(Math.abs(value)) & bitValue) == 0)
			blocks.setInt32(address, value + (value < 0 ? -bitValue : bitValue));
	}

	function finishComponent(component:Component):Void {
		final table = quantization[component.quantization];
		final columns = component.width >> 3;
		for (y in 0...(component.height >> 3))
			for (x in 0...columns) {
				final offset = (y * columns + x) * 256;
				for (i in 0...64) coefficients[i] = component.blocks.getInt32(offset + i * 4) * 1.0 * table[i];
				reconstruct(component, x, y);
			}
		component.blocks = null;
	}

	function reconstruct(component:Component, x:Int, y:Int):Void {
		final stride = component.width;
		final start = y * 8 * stride + x * 8;
		for (row in 0...8)
			for (column in 0...8) {
				var sum = 0.0;
				for (u in 0...8) sum += coefficients[row * 8 + u] * cosine[column][u];
				intermediate[row * 8 + column] = sum;
			}
		for (row in 0...8)
			for (column in 0...8) {
				var sum = 0.0;
				for (v in 0...8) sum += intermediate[v * 8 + column] * cosine[row][v];
				component.samples.set(start + row * stride + column, clamp(128 + sum * 0.25));
			}
	}

	function toImage():Image {
		final image = new Image(width, height);
		final rgb = adobeTransform == 0 || (components.length == 3 && components[0].id == 82 && components[1].id == 71 && components[2].id == 66);
		for (y in 0...height)
			for (x in 0...width) {
				final luma = sample(components[0], x, y);
				if (components.length == 1) {
					image.setUnsafePixel(x, y, Color.fromRGBA(luma, luma, luma));
				} else {
					final second = sample(components[1], x, y);
					final third = sample(components[2], x, y);
					if (components.length == 4) {
						final black = sample(components[3], x, y);
						image.setUnsafePixel(x, y, fourComponentColor(luma, second, third, black));
					} else {
						image.setUnsafePixel(x, y, rgb ? Color.fromRGBA(luma, second, third) : ycbcr(luma, second, third));
					}
				}
			}
		return image;
	}

	function fourComponentColor(first:Int, second:Int, third:Int, black:Int):Color {
		if (adobeTransform == 2) {
			final cmy = ycbcr(first, second, third);
			return multiplyInk(255 - cmy.red, 255 - cmy.green, 255 - cmy.blue, black);
		}
		if (adobeTransform == 0) return multiplyInk(first, second, third, black);
		return multiplyInk(255 - first, 255 - second, 255 - third, 255 - black);
	}

	static inline function multiplyInk(red:Int, green:Int, blue:Int, black:Int):Color {
		return Color.fromRGBA(Math.round(red * black / 255), Math.round(green * black / 255), Math.round(blue * black / 255));
	}

	static inline function ycbcr(y:Int, blue:Int, red:Int):Color {
		final cb = blue - 128;
		final cr = red - 128;
		return Color.fromRGBA(clamp(y + 1.402 * cr), clamp(y - 0.344136 * cb - 0.714136 * cr), clamp(y + 1.772 * cb));
	}

	inline function sample(component:Component, x:Int, y:Int):Int {
		return component.samples.get(Std.int(y * component.vertical / maxVertical) * component.width + Std.int(x * component.horizontal / maxHorizontal));
	}

	function find(id:Int):Null<Component> {
		for (component in components) if (component.id == id) return component;
		return null;
	}

	function nextMarker():Int {
		if (byte() != 255) throw invalid("Expected a JPEG marker.");
		var marker = byte();
		while (marker == 255) marker = byte();
		return marker;
	}

	inline function word():Int return (byte() << 8) | byte();

	function byte():Int {
		if (position >= end) throw invalid("Truncated JPEG data.");
		return bytes.get(position++);
	}

	public function bit():Int {
		if (bits == 0) {
			entropy = byte();
			if (entropy == 255 && byte() != 0) throw invalid("JPEG entropy data ended early.");
			bits = 8;
		}
		return (entropy >> --bits) & 1;
	}

	function signed(size:Int):Int {
		if (size == 0) return 0;
		final value = unsigned(size);
		return value < 1 << (size - 1) ? value - (1 << size) + 1 : value;
	}

	function unsigned(size:Int):Int {
		var value = 0;
		for (_ in 0...size) value = (value << 1) | bit();
		return value;
	}

	static inline function clamp(value:Float):Int return value <= 0 ? 0 : value >= 255 ? 255 : Math.round(value);

	public static function invalid(reason:String):ImageLoadingFailed return new ImageLoadingFailed(JPEG, reason);
}

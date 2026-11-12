package vision.formats._internal.images;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.ds.Image;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1PalettePicture;
import vision.formats._internal.images.heif.HeifContainer;

/** Portable AVIF byte conversion. **/
@:noCompletion
class Avif {
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

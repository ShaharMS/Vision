package vision.formats._internal.images.heif;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import vision.ds.Image;
import vision.exceptions.HeifContainerError;
import vision.formats._internal.images.heif.HeifContainer.HeifProperty;

/** Applies HEIF transformative item properties in association order. **/
@:noCompletion
class HeifTransforms {
	public static function apply(image:Image, properties:Array<HeifProperty>):Image {
		for (property in properties) {
			switch property.type {
				case "clap":
					final crop = readAperture(property.payload, image.width, image.height);
					final output = new Image(crop.width, crop.height);
					for (y in 0...crop.height) for (x in 0...crop.width)
						output.setPixel(x, y, image.getPixel(x + crop.x, y + crop.y));
					image = output;
				case "irot":
					final turns = readFlag(property.payload, 3);
					if (turns == 0) continue;
					final w = image.width;
					final h = image.height;
					final output = (turns & 1) == 0 ? new Image(w, h) : new Image(h, w);
					for (y in 0...h) for (x in 0...w) {
						final pixel = image.getPixel(x, y);
						switch turns {
							case 1: output.setPixel(y, w - 1 - x, pixel);
							case 2: output.setPixel(w - 1 - x, h - 1 - y, pixel);
							case 3: output.setPixel(h - 1 - y, x, pixel);
							default:
						}
					}
					image = output;
				case "imir":
					final axis = readFlag(property.payload, 1);
					final w = image.width;
					final h = image.height;
					final output = new Image(w, h);
					for (y in 0...h) for (x in 0...w)
						output.setPixel(axis == 1 ? w - 1 - x : x, axis == 0 ? h - 1 - y : y, image.getPixel(x, y));
					image = output;
				default:
			}
		}
		return image;
	}

	static function readFlag(bytes:Bytes, mask:Int):Int {
		if (bytes.length != 1 || (bytes.get(0) & ~mask) != 0)
			throw new HeifContainerError("Invalid HEIF orientation property.");
		return bytes.get(0);
	}

	static function readAperture(bytes:Bytes, width:Int, height:Int):{x:Int, y:Int, width:Int, height:Int} {
		if (bytes.length != 32) throw new HeifContainerError("Invalid HEIF clean aperture.");
		final input = new BytesInput(bytes);
		input.bigEndian = true;
		final cropWidth = readFraction(input);
		final cropHeight = readFraction(input);
		final x = (width - cropWidth) / 2 + readFraction(input);
		final y = (height - cropHeight) / 2 + readFraction(input);
		if (cropWidth < 1 || cropHeight < 1 || x < 0 || y < 0 || x + cropWidth > width || y + cropHeight > height
			|| x != Std.int(x) || y != Std.int(y) || cropWidth != Std.int(cropWidth) || cropHeight != Std.int(cropHeight))
			throw new HeifContainerError("Invalid HEIF clean aperture bounds.");
		return {x: Std.int(x), y: Std.int(y), width: Std.int(cropWidth), height: Std.int(cropHeight)};
	}

	static function readFraction(input:BytesInput):Float {
		final numerator = input.readInt32();
		final denominator = input.readInt32();
		if (denominator <= 0) throw new HeifContainerError("Invalid HEIF clean aperture denominator.");
		return numerator / denominator;
	}

}

package vision.formats.__internal;

#if format
import vision.ds.ByteArray;
import haxe.io.BytesOutput;
import vision.ds.Image;
import vision.ds.ImageFormat;
import vision.exceptions.ImageSavingFailed;
import format.png.Writer as PngWriter;
import format.png.Tools as PngTools;
import format.png.Data;
import format.bmp.Writer as BmpWriter;
import format.bmp.Tools as BmpTools;
import format.jpg.Writer as JpegWriter;
import format.jpg.Data as JpegData;

@:access(vision.ds.Image)
class FormatImageExporter {
    
	/**
        Exports an image to `PNG`

        @param image The image to export
        @return The bytes of the exported image
        @throws ImageSavingFailed If something goes wrong (for example, the image is invalid or device is out of memory)
	**/
	public static function png(image:Image):ByteArray {
		try {
			var output = new BytesOutput();
			var writer = new PngWriter(output);
			#if lua
			var data = buildPngDataWithoutNativeDeflate(image);
			#else
			var data = PngTools.build32ARGB(image.width, image.height, image.underlying.sub(Image.OFFSET, image.underlying.length - Image.OFFSET));
			#end
			writer.write(data);
			return output.getBytes();
		} catch (e) {
            throw new ImageSavingFailed(ImageFormat.PNG, e.message);
		}
	}

	#if lua
	/**
		Builds a PNG payload without calling `haxe.zip.Compress`.

		Haxe's Lua standard library does not implement that compressor. PNG permits
		stored DEFLATE blocks, so this keeps PNG export functional without adding a
		native Lua dependency. The result is larger than a normally compressed PNG.
	**/
	static function buildPngDataWithoutNativeDeflate(image:Image):Data {
		var scanlines = haxe.io.Bytes.alloc(image.width * image.height * 4 + image.height);
		var source = image.underlying;
		var writeIndex = 0;
		var readIndex = Image.OFFSET;
		for (_ in 0...image.height) {
			scanlines.set(writeIndex++, 0);
			for (_ in 0...image.width) {
				scanlines.set(writeIndex++, source.get(readIndex + 1));
				scanlines.set(writeIndex++, source.get(readIndex + 2));
				scanlines.set(writeIndex++, source.get(readIndex + 3));
				scanlines.set(writeIndex++, source.get(readIndex));
				readIndex += 4;
			}
		}

		var png:Data = new List();
		png.add(CHeader({
			width: image.width,
			height: image.height,
			colbits: 8,
			color: ColTrue(true),
			interlaced: false
		}));
		png.add(CData(deflateStored(scanlines)));
		png.add(CEnd);
		return png;
	}

	/**
		Creates a zlib stream composed of uncompressed DEFLATE blocks.

		The format library's PNG writer expects its IDAT data in this form. Stored
		blocks avoid Haxe's unimplemented Lua compressor while retaining a standards-
		compliant PNG stream that its existing reader can inflate.
	**/
	static function deflateStored(input:haxe.io.Bytes):haxe.io.Bytes {
		var output = new BytesOutput();
		output.writeByte(0x78);
		output.writeByte(0x01);

		var offset = 0;
		do {
			var length = Std.int(Math.min(0xFFFF, input.length - offset));
			var isFinalBlock = offset + length == input.length;
			output.writeByte(isFinalBlock ? 1 : 0);
			output.writeByte(length & 0xFF);
			output.writeByte((length >>> 8) & 0xFF);
			var inverseLength = 0xFFFF - length;
			output.writeByte(inverseLength & 0xFF);
			output.writeByte((inverseLength >>> 8) & 0xFF);
			output.write(input.sub(offset, length));
			offset += length;
		} while (offset < input.length);

		var a = 1;
		var b = 0;
		for (index in 0...input.length) {
			a = (a + input.get(index)) % 65521;
			b = (b + a) % 65521;
		}
		output.writeByte((b >>> 8) & 0xFF);
		output.writeByte(b & 0xFF);
		output.writeByte((a >>> 8) & 0xFF);
		output.writeByte(a & 0xFF);
		return output.getBytes();
	}
	#end

    /**
        Exports an image to `JPEG`    
    
        @param image The image to export
        @return The bytes of the exported image
        @throws ImageSavingFailed If something goes wrong (for example, the image is invalid or device is out of memory)
    **/
    public static function bmp(image:Image):ByteArray {
        try {
            var output = new BytesOutput();
            var writer = new BmpWriter(output);
            var data = BmpTools.buildFromARGB(image.width, image.height, image.underlying.sub(Image.OFFSET, image.underlying.length - Image.OFFSET));
            writer.write(data);
            return output.getBytes();
        } catch (e) {
            throw new ImageSavingFailed(ImageFormat.BMP, e.message);
        }
    }

    /**
        Exports an image to `JPEG`

        @param image The image to export 
        @return The bytes of the exported image
        @throws ImageSavingFailed If something goes wrong (for example, the image is invalid or device is out of memory)    
    **/
    public static function jpeg(image:Image):ByteArray {
        try {
            var output = new BytesOutput();
            var writer = new JpegWriter(output);
            var rawPixelData = image.underlying.sub(Image.OFFSET, image.underlying.length - Image.OFFSET);
            writer.write({
                pixels: rawPixelData,
                width: image.width,
                height: image.height,
                quality: 1.0
            });
            return output.getBytes();
        } catch (e) {
            throw new ImageSavingFailed(ImageFormat.JPEG, e.message);
        }
    }
}
#end

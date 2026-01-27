package vision.formats.__internal;

import vision.ds.PixelFormat;
#if format
import vision.ds.ByteArray;
import haxe.io.BytesOutput;
import vision.ds.Image;
import vision.ds.ImageFormat;
import vision.exceptions.ImageSavingFailed;
import format.png.Writer as PngWriter;
import format.png.Tools as PngTools;
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
			var data = PngTools.build32ARGB(image.width, image.height, image.underlying.sub(Image.OFFSET, image.underlying.length - Image.OFFSET));
			writer.write(data);
			return output.getBytes();
		} catch (e) {
            throw new ImageSavingFailed(ImageFormat.PNG, e.message);
        }
	}

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
            var rawPixelData = PixelFormat.convertPixelFormat(image.underlying.sub(Image.OFFSET, image.underlying.length - Image.OFFSET), PixelFormat.ARGB, PixelFormat.RGB);
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

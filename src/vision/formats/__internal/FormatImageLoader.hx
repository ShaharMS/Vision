package vision.formats.__internal;
#if format
import haxe.io.BytesInput;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.ds.ByteArray;
import format.png.Reader as PngReader;
import format.png.Tools as PngTools;
import format.bmp.Reader as BmpReader;
import format.bmp.Tools as BmpTools;

@:access(vision.ds.Image)
class FormatImageLoader {
    
    /**
        Load an image from bytes.

        @param bytes The bytes of the image, in PNG format
        @return The loaded image
        @throws ImageLoadingFailed if the loaded image is not a PNG
        @throws ImageLoadingFailed if the PNG has incorrect header data.
    **/
    public static function png(bytes:ByteArray):Image {
        try {
            var reader = new PngReader(new BytesInput(bytes));
            var data = reader.read();
            var header = PngTools.getHeader(data);
            var bytes = PngTools.extract32(data);
            PngTools.reverseBytes(bytes);
            var image = new Image(header.width, header.height);
            try {
                image.underlying.blit(Image.OFFSET, bytes, 0, bytes.length - 1);
                return image;
            } catch (e) {
                #if !vision_quiet 
                throw new ImageLoadingFailed(PNG, e.message); 
                #end
            }
        } catch (e:haxe.Exception) {
            #if !vision_quiet 
            throw new ImageLoadingFailed(PNG, e.message); 
            #end
        }
    }

    /**
        Load an image from bytes.

        @param bytes The bytes of the image, in BMP format
        @return The loaded image
        @throws ImageLoadingFailed if the loaded image is not a BMP
        @throws ImageLoadingFailed if the BMP has incorrect header data, and reports it has more bytes than it should.
    **/
    public static function bmp(bytes:ByteArray):Image {
        try {
            var reader = new BmpReader(new haxe.io.BytesInput(bytes));
            var data = reader.read();
            var pixels = BmpTools.extractARGB(data);
            var header = data.header;
            var image = new Image(header.width, header.height);
            try {
                image.underlying.blit(Image.OFFSET, pixels, 0, pixels.length - 1);
                return image;
            } catch (e) {
                #if !vision_quiet 
                throw new ImageLoadingFailed(BMP, e.message);
                #end
            }
        } catch (e:haxe.Exception) {
            #if !vision_quiet
            throw new ImageLoadingFailed(BMP, e.message);
            #end
        }

    }
}

#end
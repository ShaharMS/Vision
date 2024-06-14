package vision.helpers;
#if format
import haxe.io.BytesInput;
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.ds.ByteArray;
import format.png.Reader;
import format.png.Tools;
import format.bmp.Reader;
import format.bmp.Tools;

@:access(vision.ds.Image)
class FormatImageLoader {
    
    public static function png(bytes:ByteArray) {
        try {
            var reader = new Reader(new BytesInput(bytes));
            var data = reader.read();
            var header = Tools.getHeader(data);
            var bytes = Tools.extract32(data);
            Tools.reverseBytes(bytes);
            var image = new Image(header.width, header.height);
            try {
                image.underlying.blit(Image.OFFSET, bytes, 0, bytes.length - 1);
            } catch (e) #if !vision_quiet throw new ImageLoadingFailed(PNG, e.message);#end
        } catch (e:haxe.Exception) {
            throw new ImageLoadingFailed(PNG, e.message);
        }
    }

    public static function bmp(bytes:ByteArray) {
        try {
            var reader = new Reader(new haxe.io.BytesInput(bytes));
            var data = reader.read();
            var pixels = format.bmp.Tools.extractARGB(data);
            var header = data.header;
            var image = new Image(header.width, header.height);
            try {
                image.underlying.blit(Image.OFFSET, pixels, 0, pixels.length - 1);
            } catch (e) #if !vision_quiet throw new ImageLoadingFailed(BMP, e.message);#end
        } catch (e:haxe.Exception) {
            throw new ImageLoadingFailed(BMP, e.message);
        }

    }
}

#end
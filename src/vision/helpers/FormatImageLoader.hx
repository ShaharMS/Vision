package vision.helpers;
#if format
import vision.ds.Image;
import vision.exceptions.ImageLoadingFailed;
import vision.ds.ByteArray;

@:access(vision.ds.Image)
class FormatImageLoader {
    
    public static function png(bytes:ByteArray) {
        try {
            var reader = new format.png.Reader(new haxe.io.BytesInput(data));
            var data = reader.read();
            var header = format.png.Tools.getHeader(data);
            var bytes = format.png.Tools.extract32(data);
            format.png.Tools.reverseBytes(bytes);
            var image = new Image(header.width, header.height);
            try {
                image.underlying.blit(Image.OFFSET, bytes, 0, bytes.length - 1);
            } catch (e) #if !vision_quiet throw new ImageLoadingFailed(PNG, e.message);#end
        } catch (e:haxe.Exception) {
            #if vision_quiet
            if(onComplete != null)
                onComplete(new Image(100, 100));
            #else
            throw new ImageLoadingFailed(PNG, e.message);
            #end
        }
    }

}

#end
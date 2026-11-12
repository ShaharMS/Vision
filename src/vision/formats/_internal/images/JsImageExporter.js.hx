package vision.formats._internal.images;

import vision.ds.ImageFormat;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import vision.ds.ByteArray;
import haxe.io.Path;
import js.Browser;
import vision.ds.Image;
import vision.tools.ImageTools;

using vision.tools.ImageTools;
using StringTools;

class JsImageExporter {

    public static function saveToFileAsync(image:Image, path:String, format:ImageFormat) {
        var streamType = imageFormatToStreamType(format);
        var href = if (format == JPEG || format == WEBP)
            'data:application/octet-stream;base64,' + Base64.encode(ImageTools.exportToBytes(image, format))
        else if (format == VISION)
            'data:application/octet-stream;base64,' + Base64.encode(saveToBytesSync(image, streamType))
        else
            image.toJsCanvas().toDataURL(streamType, 1.0).replace(streamType, "application/octet-stream");
  		var link = Browser.document.createAnchorElement();
  		link.download = Path.withoutDirectory(path);
  		link.href = href;
  		link.click();
    }

    public static function saveToBytesSync(image:Image, streamType:String):ByteArray {
        var canvas = image.toJsCanvas();
        var dataURL = canvas.toDataURL(streamType, 1.0);
        var base64Data = dataURL.substring(dataURL.indexOf(",") + 1);
        return Base64.decode(base64Data);

    }

    public static function imageFormatToStreamType(format:ImageFormat):String {
        return switch format {
            case PNG: "image/png";
            case JPEG: "image/jpeg";
            case WEBP: "image/webp";
            case BMP: "image/bmp";
            case VISION: "application/octet-stream";
        }
    }

}
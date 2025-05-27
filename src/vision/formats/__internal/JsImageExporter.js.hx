package vision.formats.__internal;

import vision.ds.ImageFormat;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import vision.ds.ByteArray;
import haxe.io.Path;
import js.Browser;
import vision.ds.Image;

using vision.tools.ImageTools;
using StringTools;

class JsImageExporter {

    public static function saveToFileAsync(image:Image, path:String, format:ImageFormat) {
        var canvas = image.toJsCanvas();
        var streamType = imageFormatToStreamType(format);
        var href = format != RAW ? 
            canvas.toDataURL(streamType, 1.0).replace(streamType, "application/octet-stream") :
            'data:application/octet-stream;base64,' + Base64.encode(saveToBytesSync(image, streamType));
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
            case BMP: "image/bmp";
            case RAW: "application/octet-stream";
        }
    }

}
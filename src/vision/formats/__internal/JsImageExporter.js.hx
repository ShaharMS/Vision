package vision.formats.__internal;

import haxe.crypto.Base64;
import haxe.io.Bytes;
import vision.ds.ByteArray;
import haxe.io.Path;
import js.Browser;
import vision.ds.Image;

using vision.tools.ImageTools;
using StringTools;

class JsImageExporter {

    public static function saveToFileAsync(image:Image, path:String, streamType:String) {
        var canvas = image.toJsCanvas();
  		var i = canvas.toDataURL(streamType, 1.0).replace(streamType, "image/octet-stream");
  		var link = Browser.document.createAnchorElement();
  		link.download = new Path(path).file + ".png";
  		link.href = i;
  		link.click();
    }

    public static function saveToBytesSync(image:Image, streamType:String):ByteArray {
        var canvas = image.toJsCanvas();
        var dataURL = canvas.toDataURL(streamType, 1.0);
        var base64Data = dataURL.substring(dataURL.indexOf(",") + 1);
        return Base64.decode(base64Data);

    }
}
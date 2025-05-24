package vision.formats.__internal;

import haxe.io.Path;
import vision.exceptions.WebResponseError;
import vision.exceptions.ImageLoadingFailed;
import js.lib.Promise;
import js.Browser;
import js.html.URL;
import js.lib.Uint8Array;
import js.html.Blob;
import vision.ds.ByteArray;
import vision.ds.Image;

using StringTools;

class JsImageLoader {
    
    public static function loadAsync(path:String, source:Image, callback:(Image) -> Void) {
        var imgElement = js.Browser.document.createImageElement();
		imgElement.src = path;
		imgElement.crossOrigin = "Anonymous";
		imgElement.onload = () -> {
			var canvas = js.Browser.document.createCanvasElement();

			canvas.width = imgElement.width;
			canvas.height = imgElement.height;

			canvas.getContext2d().drawImage(imgElement, 0, 0);

			if (source == null) source = new Image(imgElement.width, imgElement.height);

			var imageData = canvas.getContext2d().getImageData(0, 0, source.width, source.height);

			var i = 0;
			while (i < imageData.data.length) {
			  for (o in 0...4) {
          		source.underlying[i + (@:privateAccess Image.OFFSET + 1) + o] = imageData.data[i + o];
        		}
				i += 4;
			}

			callback(source);
		}
    }

	public static function loadURLSync(url:String):Image {
		var img = Browser.document.createImageElement();
	
		img.src = url;

		var promiseStatus = 2;
		var promise = new Promise<Image>((resolve, reject) -> {
			img.onload = () -> {
				resolve(img);
				promiseStatus = 1;
			};
			img.onerror = (e) -> {
				reject(e);
				promiseStatus = 0;
			};
		});

		while (promiseStatus == 2) {
			Browser.window.requestAnimationFrame(null);
		}

		URL.revokeObjectURL(url);

		if (promiseStatus == 0) {
			throw new WebResponseError(img.src, "Failed to load image");
		}

		var canvas = Browser.document.createCanvasElement();
		canvas.width = img.width;
		canvas.height = img.height;
		canvas.getContext2d().drawImage(img, 0, 0);
		var imageData = canvas.getContext2d().getImageData(0, 0, img.width, img.height);
		
		var visionImage = new Image(img.width, img.height);
		var i = 0;
		while (i < imageData.data.length) {
			for (o in 0...4) {
				visionImage.underlying[@:privateAccess Image.OFFSET + 1 + i + o] = imageData.data[i + o];
			}
			i += 4;
		}
		

		return visionImage;
	}

	public static function loadBytesSync(bytes:ByteArray, fileType:String):Image {
		var blob = new Blob([Uint8Array.from(bytes)], { type: fileType });
		var url = URL.createObjectURL(blob);
		return loadURLSync(url);
	}

	public static function loadFileSync(filePath:String):Image {
		if (!filePath.startsWith("file:///")) {
			filePath = Path.normalize(filePath);
			filePath = "file:///" + filePath;
		}

		return loadURLSync(filePath);
	}
	
}
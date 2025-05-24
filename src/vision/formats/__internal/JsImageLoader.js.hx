package vision.formats.__internal;

import vision.ds.Image;

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

}
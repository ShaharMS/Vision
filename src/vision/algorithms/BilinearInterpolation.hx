package vision.algorithms;

import vision.ds.Image;
import vision.ds.Color;

class BilinearInterpolation {
	public static function interpolate(image:Image, width:Int, height:Int):Image {
		var resized = new Image(width, height);
		var xMulitiplier = image.width / width;
		var yMulitiplier = image.height / height;
		resized.forEachPixel((x, y, c) -> {
			var color = image.getFloatingPixel(x * xMulitiplier, y * yMulitiplier);
			resized.setPixel(x, y, color);
		});

		return resized;
	}
}

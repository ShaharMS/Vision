package vision.algorithms;

import vision.ds.Image;
import vision.ds.Color;

class BilinearInterpolation {
	public static function interpolate(image:Image, width:Int, height:Int):Image {
		final resized = new Image(width, height);
		final xMulitiplier = image.width / width;
		final yMulitiplier = image.height / height;
		resized.forEachPixel((x, y, c) -> {
			final color = image.getFloatingPixel(x * xMulitiplier, y * yMulitiplier);
			resized.setPixel(x, y, color);
		});

		return resized;
	}
}

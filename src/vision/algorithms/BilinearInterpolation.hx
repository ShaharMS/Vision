package vision.algorithms;

import vision.exceptions.OutOfBounds;
import vision.ds.Image;

class BilinearInterpolation {
	public static function interpolate(image:Image, width:Int, height:Int):Image {
		final resized = new Image(width, height);
		final xMultiplier = image.width / width - 1 / width;
		final yMultiplier = image.height / height - 1 / height;
		resized.forEachPixel((x, y, c) -> {
			final color = image.getFloatingPixel(x * xMultiplier, y * yMultiplier);
			resized.setPixel(x, y, color);			
		});

		return resized;
	}
}

package vision.algorithms;

import vision.ds.Image;

class BilinearInterpolation {
	public static function interpolate(image:Image, width:Int, height:Int):Image {
		final resized = new Image(width, height);
		final xMultiplier = image.width / width;
		final yMultiplier = image.height / height;
		resized.forEachPixel((x, y, c) -> {
			final color = image.getFloatingPixel(x * xMultiplier, y * yMultiplier);
			resized.setPixel(x, y, color);
		});

		return resized;
	}
}

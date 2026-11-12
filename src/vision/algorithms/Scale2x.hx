package vision.algorithms;

import vision.ds.Image;
import vision.exceptions.VisionException;

/** Doubles pixel art using the Scale2x neighborhood rules. **/
class Scale2x {
	public static function rescale(image:Image):Image {
		if (image.width * 1.0 * image.height * 16 > 0x7fffffff || image.width > 0x3fffffff || image.height > 0x3fffffff)
			throw new VisionException("The rescaled image is too large.", "Scale2x Error");

		final result = new Image(image.width * 2, image.height * 2);
		for (y in 0...image.height)
			for (x in 0...image.width) {
				final center = image.getUnsafePixel(x, y);
				final above = y == 0 ? center : image.getUnsafePixel(x, y - 1);
				final below = y + 1 == image.height ? center : image.getUnsafePixel(x, y + 1);
				final left = x == 0 ? center : image.getUnsafePixel(x - 1, y);
				final right = x + 1 == image.width ? center : image.getUnsafePixel(x + 1, y);
				final edgesDiffer = above != below && left != right;
				final dx = x * 2, dy = y * 2;
				result.setUnsafePixel(dx, dy, edgesDiffer && left == above ? left : center);
				result.setUnsafePixel(dx + 1, dy, edgesDiffer && above == right ? right : center);
				result.setUnsafePixel(dx, dy + 1, edgesDiffer && left == below ? left : center);
				result.setUnsafePixel(dx + 1, dy + 1, edgesDiffer && below == right ? right : center);
			}
		return result;
	}
}

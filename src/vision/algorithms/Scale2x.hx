package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageStorage;
import vision.exceptions.VisionException;

/** Doubles pixel art using Scale2x with optional corner support. **/
class Scale2x {
	public static function rescale(image:Image, includeCorners:Bool = true):Image {
		if (image.width * 1.0 * image.height * 16 > 0x7fffffff - ImageStorage.PIXEL_OFFSET
			|| image.width > 0x3fffffff || image.height > 0x3fffffff #if !vision_higher_width_cap || image.width > 0x7fff #end)
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
				if (edgesDiffer) {
					result.setUnsafePixel(dx, dy, choose(center, left, above, includeCorners ? image.getSafePixel(x - 1, y - 1) : center));
					result.setUnsafePixel(dx + 1, dy, choose(center, right, above, includeCorners ? image.getSafePixel(x + 1, y - 1) : center));
					result.setUnsafePixel(dx, dy + 1, choose(center, left, below, includeCorners ? image.getSafePixel(x - 1, y + 1) : center));
					result.setUnsafePixel(dx + 1, dy + 1, choose(center, right, below, includeCorners ? image.getSafePixel(x + 1, y + 1) : center));
				} else {
					result.setUnsafePixel(dx, dy, center);
					result.setUnsafePixel(dx + 1, dy, center);
					result.setUnsafePixel(dx, dy + 1, center);
					result.setUnsafePixel(dx + 1, dy + 1, center);
				}
			}
		return result;
	}

	static inline function choose(center:Color, horizontal:Color, vertical:Color, corner:Color):Color {
		if (horizontal == vertical) return horizontal;
		// The corner is farther away. It can break a tie between cardinal neighbors,
		// but a color seen only in the corner cannot replace the center.
		return corner == horizontal || corner == vertical ? corner : center;
	}
}

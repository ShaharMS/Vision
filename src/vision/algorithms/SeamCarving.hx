package vision.algorithms;

import vision.ds.Image;
import vision.ds.Color;
import vision.exceptions.VisionException;

/**
	Content-aware shrinking using Avidan and Shamir's minimum-energy seams (2007).
	Recomputes RGB gradient energy after each removal, finds a globally cheapest
	8-connected seam by dynamic programming, then copies the surviving pixels.
	Horizontal removal uses the same algorithm on a transposed image.
**/
class SeamCarving {
	/** Returns a new image; removes vertical seams before horizontal seams. **/
	public static function compute(image:Image, width:Int, height:Int):Image {
		if (width < 1 || height < 1 || width > image.width || height > image.height) {
			throw new VisionException("Carve dimensions must be positive and no larger than the source.", "Invalid Carve Size");
		}
		var result = image.clone();
		while (result.width > width) result = removeVertical(result);
		if (result.height > height) {
			result = transpose(result);
			while (result.width > height) result = removeVertical(result);
			result = transpose(result);
		}
		return result;
	}

	static function transpose(image:Image):Image {
		var result = new Image(image.height, image.width);
		for (y in 0...image.height) for (x in 0...image.width) result.setPixel(y, x, image.getPixel(x, y));
		return result;
	}

	// RGB L1 central differences, clamped at the image borders. Alpha is preserved
	// verbatim when copying survivors but does not influence seam energy.
	static inline function difference(a:Color, b:Color):Float {
		return Math.abs(a.red - b.red) + Math.abs(a.green - b.green) + Math.abs(a.blue - b.blue);
	}

	static function removeVertical(image:Image):Image {
		var width = image.width;
		var height = image.height;
		var parents = new Array<Int>();
		var previous = new Array<Float>();
		for (y in 0...height) {
			var current = new Array<Float>();
			for (x in 0...width) {
				var energy = difference(image.getPixel(x > 0 ? x - 1 : x, y), image.getPixel(x + 1 < width ? x + 1 : x, y))
					+ difference(image.getPixel(x, y > 0 ? y - 1 : y), image.getPixel(x, y + 1 < height ? y + 1 : y));
				var parent = x;
				var cost = 0.;
				if (y > 0) {
					// Equal costs select the leftmost predecessor and endpoint.
					parent = x > 0 ? x - 1 : x;
					cost = previous[parent];
					var end = x + 1 < width ? x + 1 : x;
					for (candidate in (parent + 1)...(end + 1)) {
						if (previous[candidate] < cost) {
							parent = candidate;
							cost = previous[candidate];
						}
					}
				}
				parents.push(parent);
				current.push(energy + cost);
			}
			previous = current;
		}
		var seam = new Array<Int>();
		var endpoint = 0;
		for (x in 1...width) if (previous[x] < previous[endpoint]) endpoint = x;
		var row = height;
		while (row > 0) {
			row--;
			seam[row] = endpoint;
			endpoint = parents[row * width + endpoint];
		}
		var result = new Image(width - 1, height);
		for (y in 0...height) for (x in 0...(width - 1)) {
			result.setPixel(x, y, image.getPixel(x < seam[y] ? x : x + 1, y));
		}
		return result;
	}
}

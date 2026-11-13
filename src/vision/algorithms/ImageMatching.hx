package vision.algorithms;

import vision.ds.Image;
import vision.ds.ImageMatch;
import vision.ds.specifics.ImageMatchingTechnique;

/** Searches for an unscaled template at whole-pixel offsets. **/
class ImageMatching {
	public static function find(image:Image, template:Image, technique:ImageMatchingTechnique, minimumScore:Float, maxMatches:Int):Array<ImageMatch> {
		final matches:Array<ImageMatch> = [];
		if (template.width == 0 || template.height == 0 || template.width > image.width || template.height > image.height) return matches;

		for (y in 0...image.height - template.height + 1)
			for (x in 0...image.width - template.width + 1) {
				final score = switch (technique) {
					case Exact, ColorDifference: compareColors(image, template, x, y, technique == Exact);
					case NormalizedCorrelation: correlate(image, template, x, y);
				};
				if (score >= minimumScore) {
					final match:ImageMatch = {bounds: {x: x, y: y, width: template.width, height: template.height}, score: score};
					if (maxMatches == 1) {
						if (matches.length == 0 || score > matches[0].score) matches[0] = match;
						if (score == 1) return matches;
					} else {
						matches.push(match);
					}
				}
			}

		if (technique != Exact) matches.sort(compareMatches);
		return maxMatches > 0 && matches.length > maxMatches ? matches.slice(0, maxMatches) : matches;
	}

	static function compareColors(image:Image, template:Image, x:Int, y:Int, exact:Bool):Float {
		var difference = 0.0;
		for (ty in 0...template.height)
			for (tx in 0...template.width) {
				final source = image.getUnsafePixel(x + tx, y + ty);
				final target = template.getUnsafePixel(tx, ty);
				if (source == target) continue;
				if (exact) return -1;
				difference += Math.abs(source.red - target.red) + Math.abs(source.green - target.green)
					+ Math.abs(source.blue - target.blue) + Math.abs(source.alpha - target.alpha);
			}
		return 1 - difference / (1020.0 * template.width * template.height);
	}

	static function correlate(image:Image, template:Image, x:Int, y:Int):Float {
		var count = 0.0;
		var sourceSum = 0.0;
		var targetSum = 0.0;
		var sourceSquares = 0.0;
		var targetSquares = 0.0;
		var products = 0.0;
		var difference = 0.0;
		for (ty in 0...template.height)
			for (tx in 0...template.width) {
				final target = template.getUnsafePixel(tx, ty);
				if (target.alpha == 0) continue;
				final source = image.getUnsafePixel(x + tx, y + ty);
				if (source.alpha == 0) return -1;
				count += 3;
				sourceSum += source.red + source.green + source.blue;
				targetSum += target.red + target.green + target.blue;
				sourceSquares += source.red * source.red + source.green * source.green + source.blue * source.blue;
				targetSquares += target.red * target.red + target.green * target.green + target.blue * target.blue;
				products += source.red * target.red + source.green * target.green + source.blue * target.blue;
				difference += Math.abs(source.red - target.red) + Math.abs(source.green - target.green) + Math.abs(source.blue - target.blue);
			}
		if (count == 0) return -1;
		final sourceVariance = sourceSquares - sourceSum * sourceSum / count;
		final targetVariance = targetSquares - targetSum * targetSum / count;
		if (sourceVariance <= 0 || targetVariance <= 0) return 1 - difference / (255 * count);
		final correlation = (products - sourceSum * targetSum / count) / Math.sqrt(sourceVariance * targetVariance);
		return Math.max(0, Math.min(1, (correlation + 1) / 2));
	}

	static function compareMatches(a:ImageMatch, b:ImageMatch):Int {
		if (a.score != b.score) return a.score > b.score ? -1 : 1;
		if (a.bounds.y != b.bounds.y) return a.bounds.y - b.bounds.y;
		return a.bounds.x - b.bounds.x;
	}
}

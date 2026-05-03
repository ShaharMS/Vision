package vision.algorithms;

import haxe.ds.ArraySort;
import vision.ds.HarrisCorner2D;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.specifics.HarrisCornerOptions;

class HarrisCorners {
	public static function detect(response:Matrix2D, options:HarrisCornerOptions):Array<HarrisCorner2D> {
		var threshold = computeThreshold(response, options.relativeThreshold);
		if (threshold < 0) return [];
		var candidates = collectCandidates(response, options, threshold);
		sortCorners(candidates);
		return applyDistanceAndLimit(candidates, options.minimumDistance, options.maxCorners);
	}

	static function computeThreshold(response:Matrix2D, relativeThreshold:Float):Float {
		var strongest = findStrongestPositiveResponse(response);
		if (strongest <= 0) return -1.0;
		var factor = relativeThreshold < 0 ? 0.0 : relativeThreshold;
		return strongest * factor;
	}

	static function findStrongestPositiveResponse(response:Matrix2D):Float {
		var strongest = 0.0;
		for (y in 0...response.height) {
			for (x in 0...response.width) {
				var value = response.get(x, y);
				if (value > strongest) strongest = value;
			}
		}
		return strongest;
	}

	static function collectCandidates(response:Matrix2D, options:HarrisCornerOptions, threshold:Float):Array<HarrisCorner2D> {
		var corners:Array<HarrisCorner2D> = [];
		var margin = normalizeBorderMargin(options.borderMargin);
		if (margin * 2 >= response.width || margin * 2 >= response.height) return corners;
		for (y in margin...response.height - margin) {
			for (x in margin...response.width - margin) {
				var value = response.get(x, y);
				if (value <= 0 || value < threshold) continue;
				if (!isLocalMaximum(response, x, y, value)) continue;
				corners.push(new HarrisCorner2D(new Point2D(x, y), value));
			}
		}
		return corners;
	}

	static inline function normalizeBorderMargin(borderMargin:Int):Int {
		return borderMargin < 0 ? 0 : borderMargin;
	}

	static function isLocalMaximum(response:Matrix2D, x:Int, y:Int, value:Float):Bool {
		var startX = x > 0 ? x - 1 : 0;
		var startY = y > 0 ? y - 1 : 0;
		var endX = x + 1 < response.width ? x + 1 : response.width - 1;
		var endY = y + 1 < response.height ? y + 1 : response.height - 1;
		for (neighborY in startY...endY + 1) {
			for (neighborX in startX...endX + 1) {
				if (neighborX == x && neighborY == y) continue;
				var neighborValue = response.get(neighborX, neighborY);
				if (neighborValue > value) return false;
				if (neighborValue == value && compareCoordinates(neighborX, neighborY, x, y) < 0) return false;
			}
		}
		return true;
	}

	static function sortCorners(corners:Array<HarrisCorner2D>):Void {
		ArraySort.sort(corners, compareCorners);
	}

	static function compareCorners(left:HarrisCorner2D, right:HarrisCorner2D):Int {
		if (left.score > right.score) return -1;
		if (left.score < right.score) return 1;
		return compareCoordinates(Std.int(left.point.x), Std.int(left.point.y), Std.int(right.point.x), Std.int(right.point.y));
	}

	static function compareCoordinates(leftX:Int, leftY:Int, rightX:Int, rightY:Int):Int {
		if (leftY < rightY) return -1;
		if (leftY > rightY) return 1;
		if (leftX < rightX) return -1;
		if (leftX > rightX) return 1;
		return 0;
	}

	static function applyDistanceAndLimit(candidates:Array<HarrisCorner2D>, minimumDistance:Float, maxCorners:Int):Array<HarrisCorner2D> {
		var corners:Array<HarrisCorner2D> = [];
		var minimumDistanceSquared = minimumDistance > 0 ? minimumDistance * minimumDistance : 0.0;
		for (candidate in candidates) {
			if (!isFarEnough(candidate, corners, minimumDistanceSquared)) continue;
			corners.push(candidate);
			if (maxCorners > 0 && corners.length >= maxCorners) break;
		}
		return corners;
	}

	static function isFarEnough(candidate:HarrisCorner2D, corners:Array<HarrisCorner2D>, minimumDistanceSquared:Float):Bool {
		if (minimumDistanceSquared <= 0) return true;
		for (corner in corners) {
			var deltaX = corner.point.x - candidate.point.x;
			var deltaY = corner.point.y - candidate.point.y;
			if (deltaX * deltaX + deltaY * deltaY < minimumDistanceSquared) return false;
		}
		return true;
	}
}
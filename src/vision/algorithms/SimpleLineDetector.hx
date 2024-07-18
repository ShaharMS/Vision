package vision.algorithms;

import vision.tools.MathTools;
import vision.ds.Int16Point2D;
import vision.ds.Line2D;
import vision.ds.Image;
import vision.ds.IntPoint2D;

/**
 * An iterative, partially recursive line detection implementation by [Shahar Marcus](https://www.github.com/ShaharMS).
 */
class SimpleLineDetector {
	public static var image:Image;

	public static function findLineFromPoint(image:Image, point:Int16Point2D, minLineLength:Float, preferTTB:Bool = false, preferRTL:Bool = false):Line2D {
		final startX = point.x, startY = point.y;
		final yArr = preferTTB ? [0, 1, 2] : [0, -1, -2];
		final xArr = preferRTL ? [0, -1, -2] : [0, 1, 2];
		if (!image.hasPixel(point.x, point.y) || image.getPixel(point.x, point.y) == 0) return null;

		// now, were going to start looking for points around the point to find the entire line.
		var prev:Null<Int16Point2D> = null;
		var prev2:Null<Int16Point2D> = null;
		function expand() {
			for (X in xArr) {
				for (Y in yArr) {
					if (X == 0 && Y == 0 || !image.hasPixel(point.x + X, point.y + Y)) continue;
					if (image.getPixel(point.x + X, point.y + Y).red == 255) {
						point.x = point.x + X;
						point.y = point.y + Y;

						// used to prevent infinite recursion
						if (prev == null) {
							prev = p(point.x, point.y);
						} else {
							prev2 = p(prev.x, prev.y);
							prev = p(point.x, point.y);
						}
						if ((if (preferTTB) Y else X) == 0) {
							if ((point.x == prev.x && point.y == prev.y) || (point.x == prev2.x && point.y == prev2.y)) {
								return;
							}
						}
						expand();
					}
				}
			}
		}
		expand();
		var line = new Line2D({x: startX, y: startY}, point);

		if (line.length > minLineLength) {
			return line;
		}
		return null;
	}

	/**
		Returns the percentage of the line that covers an actual line in the given,
		**Black And White** image.
	**/
	public static function lineCoveragePercentage(image:Image, line:Line2D):Float {
		var coveredPixels = 0, totalPixels = 0;
		if (line == null) return 0;
		final p1 = IntPoint2D.fromPoint2D(line.start);
		final p2 = IntPoint2D.fromPoint2D(line.end);
		var x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y;
		var dx = Math.abs(x2 - x1);
		var dy = Math.abs(y2 - y1);
		var sx = (x1 < x2) ? 1 : -1;
		var sy = (y1 < y2) ? 1 : -1;
		var err = dx - dy;
		// were going to check for the longest gap using an array of integers
		// each time a gap is getting longer, we'll set the array at the index of the
		// current length of the gap to 1
		// then, the max length should be the length of the array
		var gapChecker:Array<Int> = [];
		var currentGap = 1;
		while (true) {
			if (image.hasPixel(x1, y1)) {
				if (image.getPixel(Std.int(x1), Std.int(y1)).red == 255) {
					coveredPixels++;
					currentGap = 0;
				} else {
					gapChecker[currentGap] = 1;
					currentGap++;
				}
			}
			totalPixels++;
			if (x1 == x2 && y1 == y2) break;
			var e2 = 2 * err;
			if (e2 > -dy) {
				err -= dy;
				x1 += sx;
			}
			if (e2 < dx) {
				err += dx;
				y1 += sy;
			}
		}
		return (coveredPixels /*The biggest gap */ - gapChecker.length) / totalPixels * 100;
	}

	public static function correctLines(lines:Array<Line2D>, distanceThreshold:Float = 3, degError:Float = 7):Array<Line2D> {
		trace('Original line Count: ${lines.length}');
		var filteredLines:Array<Line2D> = [];

		// Were going to use a series of filters:

		// First: intersection + degrees: if A intersects B, is only `degError` degrees acuter/obtuser, and is shorter than B, its removed.

		for (i in 0...lines.length) {
			var longer = lines[i];
			if (longer == null) continue;

			for (j in 0...lines.length) {
				if (i == j) continue;
				var candidate = lines[j];
				if (candidate == null) continue;
				if (candidate.intersect(longer) == null) continue;
				if (Math.abs(candidate.degrees - longer.degrees) > degError) continue;
				if (candidate.length <= longer.length) { 
					lines[j] = null;
				} else {
					lines[i] = new Line2D(candidate.start.copy(), candidate.end.copy());
					lines[j] = null;
				}
			}
		}

		lines = lines.filter(l -> l != null);
		trace('First pass: ${lines.length}');


		// Second: folowing lines: if A's end/start is close to B's start/end, and A is only `degError` degrees acuter/obtuser than B, A and B should be combined.
		for (i in 0...lines.length) {
			var base = lines[i];
			if (base == null) continue;

			for (j in 0...lines.length) {
				if (i == j) continue;
				var candidate = lines[j];
				if (candidate == null) continue;
				if (Math.abs(candidate.degrees - base.degrees) > degError) continue;
				if (MathTools.distanceBetweenLines2D(base, candidate) > distanceThreshold) continue;
				var baseR, baseL;
				if (base.start.x >= base.end.x) {
					baseR = base.start;
					baseL = base.end;
				} else {
					baseL = base.start;
					baseR = base.end;
				}
				var candidateR, candidateL;
				if (candidate.start.x >= candidate.end.x) {
					candidateR = candidate.start;
					candidateL = candidate.end;
				} else {
					candidateL = candidate.start;
					candidateR = candidate.end;
				}

				if (baseL.distanceTo(candidateR) <= distanceThreshold) {
					lines[i] = new Line2D(baseR, candidateL);
					lines[j] = null;
					continue;
				}
				if (baseR.distanceTo(candidateL) <= distanceThreshold) {
					lines[i] = new Line2D(baseL, candidateR);
					lines[j] = null;
					continue;
				}
			}
		}
		lines = lines.filter(l -> l != null);
		trace('Second pass: ${lines.length}');
		return lines;
	}

	static extern inline function p(x:Int = 0, y:Int = 0) {
		return new Int16Point2D(x, y);
	}

	public function new(image:Image) {}
}

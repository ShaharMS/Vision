package vision.algorithms;

import vision.ds.Int16Point2D;
import vision.exceptions.VisionException;
import haxe.display.Display.Package;
import vision.ds.IntPoint2D;
import vision.tools.MathTools;
import vision.ds.Color;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Image;

using vision.tools.MathTools;
private typedef S = SimpleLineDetector;
/**
 * An iterative, partially recursive line detection implementation by [Shahar Marcus](https://www.github.com/ShaharMS).
 */
class SimpleLineDetector {

	public static var cachedPoints:Array<Int16Point2D> = [];

	public static var image:Image;

	static inline function p(x:Int = 0, y:Int = 0) {
		return new Int16Point2D(x, y);
	}


	public static function findLineFromPoint(point:Int16Point2D, minLineLength:Float, maxGap:Int = 1):Line2D {
		if (image.getUnsafePixel(point.x, point.y) == 0 || cachedPoints.contains(point)) return null;
		final start = point;
		var pointCheckOrder:Array<Int16Point2D> = [p(1, 1), p(0, 1), p(-1, 1), p(0, 1), p(0, -1), p(-1, 1), p(-1, 0), p(-1, -1)];
		var cwp:Null<Int16Point2D> = point;
		var prev:Null<Int> = 0, prev2:Null<Int> = 0;
		var safetyNet = 0;
		while (cwp != null) {
			safetyNet++;
			if (safetyNet % 10 == 0) trace(cwp.toString());
			if (safetyNet > 5000) throw new VisionException("Too Many Iterations on point " + cwp.toString() + ". This should not occur.", "Line Detection Failure");
			cwp = null;
			for (p in pointCheckOrder) {
				if (prev2 != S.p(p.x + cwp.x, p.y + cwp.y) && image.getUnsafePixel(p.x + cwp.x, p.y + cwp.y) == 0xFFFFFFFF) {
					cwp.x = cwp.x + p.x;
					cwp.y = cwp.y + p.y;
				}
			}
			prev = cwp;
			prev2 = prev;
			if (prev == cwp || prev2 == cwp) break;
			cachedPoints.push(cwp);
		}

		var line = new Line2D(start, cwp);
		if (line.length >= minLineLength) return line; 
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
			if (image.hasPixel(Std.int(x1), Std.int(y1)) && image.getPixel(Std.int(x1), Std.int(y1)).red == 255) {
				coveredPixels++;
				currentGap = 0;
			} else {
				gapChecker[currentGap] = 1;
				currentGap++;
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

	static function depositPoints(x1:Float, y1:Float, x2:Float, y2:Float) {
		var dx = Math.abs(x2 - x1);
		var dy = Math.abs(y2 - y1);
		var sx = (x1 < x2) ? 1 : -1;
		var sy = (y1 < y2) ? 1 : -1;
		var err = dx - dy;
		while (true) {
			//cachedPoints.push(p(x1, y1));
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
	}
}

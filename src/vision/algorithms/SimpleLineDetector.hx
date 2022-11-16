package vision.algorithms;

import vision.exceptions.VisionException;
import haxe.display.Display.Package;
import vision.ds.IntPoint2D;
import vision.tools.MathTools;
import vision.ds.Color;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Image;

using vision.tools.MathTools;

/**
 * An iterative, partially recursive line detection implementation by [Shahar Marcus](https://www.github.com/ShaharMS).
 */
class SimpleLineDetector {

	public static var cachedPoints:Array<IntPoint2D> = [];

	public static var image:Image;

	public static function findLineFromPoint(point:IntPoint2D, minLineLength:Float, maxGap:Int = 1):Line2D {
		if (image.getUnsafePixel(point.x, point.y) == 0) return null;
		final startX = point.x, startY = point.y;
		final xArr = [2, 1, 0];
		final yArr = [0, 1, -1, 2, -2];
		// return if a dir wasn't found

		var cwp = point.copy();
		var iter = 0;
		var continueDetection = true;
		while (continueDetection) {
			iter++;
			continueDetection = false;
			if (iter > 20000) throw new VisionException("Too Many Iterations on point " + cwp.toString() + ". This should not occur.", "Line Detection Failure");
			if (cwp.x >= image.width || cwp.y >= image.height) break;
			for (y in [1, -1, 0, 2, -2]) {
				//unrolled X for loop for convenience
				if (y != 0 && image.hasPixel(cwp.x, cwp.y + y) && image.getUnsafePixel(cwp.x, cwp.y + y).red == 255) {
					cwp.x += 0;
					cwp.y += y;
					continueDetection = true;
					break;
				} else if (image.hasPixel(cwp.x + 1, cwp.y + y) && image.getUnsafePixel(cwp.x + 1, cwp.y + y).red == 255) {
					cwp.x += 1;
					cwp.y += y;
					continueDetection = true;
					break;
				} else if (image.hasPixel(cwp.x + 2, cwp.y + y) && image.getUnsafePixel(cwp.x + 2, cwp.y + y).red == 255) {
					cwp.x += 2;
					cwp.y += y;
					continueDetection = true;
					break;
				}
			}
		}			
	

		// finished finding lines, now try returning it

		var line = new Line2D({x: startX, y: startY}, cwp);

		if (line.length > minLineLength) {
			return line;
		}

		var cwp = point.copy();
		var iter = 0;
		var continueDetection = true;
		while (continueDetection) {
			iter++;
			continueDetection = false;
			if (iter > 10000) throw new VisionException("Too Many Iterations on point " + cwp.toString() + ". This should not occur.", "Line Detection Failure");
			if (cwp.x >= image.width || cwp.y >= image.height) break;
			for (x in [1, 0, 2]) {
				//unrolled X for loop for convenience
				if (image.hasPixel(cwp.x + x, cwp.y + 1) && image.getUnsafePixel(cwp.x + x, cwp.y + 1).red == 255) {
					cwp.x += x;
					cwp.y += 1;
					continueDetection = true;
					break;
				} else if (image.hasPixel(cwp.x + x, cwp.y - 1) && image.getUnsafePixel(cwp.x + x, cwp.y - 1).red == 255) {
					cwp.x += x;
					cwp.y += -1;
					continueDetection = true;
					break;
				} else if (image.hasPixel(cwp.x + x, cwp.y + 2) && image.getUnsafePixel(cwp.x + x, cwp.y + 2).red == 255) {
					cwp.x += x;
					cwp.y += 2;
					continueDetection = true;
					break;
				} else if (image.hasPixel(cwp.x + x, cwp.y - 2) && image.getUnsafePixel(cwp.x + x, cwp.y - 2).red == 255) {
					cwp.x += x;
					cwp.y += -2;
					continueDetection = true;
					break;
				}
			}
		}			
	

		// finished finding lines, now try returning it

		var line = new Line2D({x: startX, y: startY}, cwp);

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
			cachedPoints.push({x: x1, y: y1});
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

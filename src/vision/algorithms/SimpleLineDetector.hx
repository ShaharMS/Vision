package vision.algorithms;

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
		var broken = false;
		final startX = point.x, startY = point.y;
		final xArr = [0, 1, 2];
		final yArr = [0, 1, -1, 2, -2];
		var dirX:Int = 0, dirY:Int = 0;
		var gap:Int = 0;
		//find the line's direction
		for (x in xArr) {
			for (y in yArr) {
				if (!image.hasPixel(x, y)) continue;
				if (image.getUnsafePixel(x,y).red == 0) continue;
				dirX = x; dirY = y;
				broken = true;
				break;
			}
			if (broken) break;
		}
		broken = false;
		//return if a dir wasn't found
		if (dirX == 0 && dirY == 0) return null;

		var cwp = point.copy();
		var continueOrgLoop = false;
		while (true) {
			trace(cwp, dirX, dirY);
			if (cwp.x >= image.width) break;
			if (image.hasPixel(cwp.x + dirX, cwp.y + dirY) && image.getPixel(cwp.x + dirX, cwp.y + dirY).red == 255) {
				cwp.x += dirX;
				cwp.y += dirY;
				continue;
			}
			else if (dirY > 0) {
				for (y in [1, 2]) {
					if (image.hasPixel(cwp.x + dirX, cwp.y + y) && image.getPixel(cwp.x + dirX, cwp.y + y).red == 255) {
						cwp.x += dirX;
						cwp.y += y + dirY;
						continueOrgLoop = true;
						break;
					}
				}
			} else {
				for (y in [-1, -2]) {
					if (image.hasPixel(cwp.x + dirX, cwp.y + y) && image.getPixel(cwp.x + dirX, cwp.y + y).red == 255) {
						cwp.x += dirX;
						cwp.y += y + dirY;
						continueOrgLoop = true;
						break;
					}
				}
			}

			if (continueOrgLoop) continue else break;
		}


		//finished finding lines, now try returning it

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
		if (line == null)
			return 0;
		final p1 = IntPoint2D.fromPoint2D(line.start);
		final p2 = IntPoint2D.fromPoint2D(line.end);
		var x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y;
		var dx = Math.abs(x2 - x1);
		var dy = Math.abs(y2 - y1);
		var sx = (x1 < x2) ? 1 : -1;
		var sy = (y1 < y2) ? 1 : -1;
		var err = dx - dy;
		//were going to check for the longest gap using an array of integers
		//each time a gap is getting longer, we'll set the array at the index of the
		//current length of the gap to 1
		//then, the max length should be the length of the array
		var gapChecker:Array<Int> = [];
		var currentGap = 1;
		while (true) {
			if (image.getPixel(Std.int(x1), Std.int(y1)).red == 255) {
				coveredPixels++;
				currentGap = 0;
			} else {
				gapChecker[currentGap] = 1;
				currentGap++;
			}
			
			totalPixels++;
			if (x1 == x2 && y1 == y2)
				break;
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
		return (coveredPixels /*The biggest gap */- gapChecker.length) / totalPixels * 100;
	}

	static function depositPoints(x1:Float, y1:Float, x2:Float, y2:Float) {
		var dx = Math.abs(x2 - x1);
		var dy = Math.abs(y2 - y1);
		var sx = (x1 < x2) ? 1 : -1;
		var sy = (y1 < y2) ? 1 : -1;
		var err = dx - dy;
		while (true) {
			cachedPoints.push({x: x1, y: y1});
			if (x1 == x2 && y1 == y2)
				break;
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

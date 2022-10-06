package vision.algorithms;

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
	public static function findLineFromPoint(image:Image, point:IntPoint2D, minLineLength:Float, preferTTB = false, preferRTL = false):Line2D {
		final startX = point.x, startY = point.y;
		final yArr = preferTTB ? [0, 1, 2] : [0, -1, -2];
		final xArr = preferRTL ? [0, -1, -2] : [0, 1, 2];
		if (!image.hasPixel(point.x, point.y) || image.getPixel(point.x, point.y) == 0)
			return null;

		// now, were going to start looking for points around the point to find the entire line.
		var prev:Point2D = null;
		var prev2:Point2D = null;
		function expand() {
			for (X in xArr) {
				for (Y in yArr) {
					if (X == 0 && Y == 0 || !image.hasPixel(point.x + X, point.y + Y))
						continue;
					if (image.getPixel(point.x + X, point.y + Y).to24Bit() == Color.WHITE) {
						point.x = point.x + X;
						point.y = point.y + Y;

						// used to prevent infinite recursion
						if (prev == null) {
							prev = {x: point.x, y: point.y};
						} else {
							prev2 = {x: prev.x, y: prev.y};
							prev = {x: point.x, y: point.y};
						}
						if ((if (preferTTB) Y else X) == 0) {
							if ((point.x == prev.x && point.y == prev.y) || (point.x == prev2.x && point.y == prev2.y)) {
								return;
							}
							trace(point, prev, prev2);
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
		while (true) {
			if (image.hasPixel(x1, y1)) {
				if (image.getPixel(Std.int(x1), Std.int(y1)).to24Bit() == Color.WHITE) {
					coveredPixels++;
				}
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
		return coveredPixels / totalPixels * 100;
	}
}

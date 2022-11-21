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

	/**
		Shortcut for
		```haxe
		new Int16Point2D(x, y)
		```
	**/
	static inline function p(x:Int = 0, y:Int = 0) {
		return new Int16Point2D(x, y);
	}


	public static function findLineFromPoint(point:Int16Point2D, minLineLength:Float, maxGap:Int = 1):Null<Line2D> {
		if(point.x >= 0 && point.y >= 0) return null;
		if((point.x /* + image.x */ < image.width /* + image.x */) || (point.y /* + image.y */ < image.height /* + image.x*/))
			return null;

		/*if (image.getUnsafePixel(point.x, point.y) != 0xFFFFFFFF || cachedPoints.contains(point)) {
			trace('point unsafe');
			return null;
		}
		if (!image.hasPixel(point.x, point.y)) {
			trace('unreal point');
			return null;
		}*/
		final start = p(point.x, point.y);
		var pointCheckOrder:Array<Int16Point2D> = [p(1, 0), p(1, 1), p(1, -1), p(-1, 0), p(-1, 1), p(-1, -1), p(0, 1), p(0, -1)];
		var cwp:Null<Int16Point2D> = p(point.x, point.y);
		var safetyNet = 0;
		var voided:Bool = false;
		/* 
			A positive/negative integer, calculated during the processing of the first few pixels.
			When positive, the point (0, -1) will be removed from the detection calculations. when negative, the opposite
			point gets removed.
		*/
		var dir:Float = 0;
		while (!voided) {
			safetyNet++;
			if (safetyNet == 5 || safetyNet == 10) {
				dir = MathTools.degreesFromPointToPoint2D(start, cwp);
				if (dir > 0) {
					if (dir < 90) pointCheckOrder = [p(1, 0), p(1, -1), p(1, -1), p(0, -1)];
					else if (dir > 90) pointCheckOrder = [p(-1, 0), p(-1, -1), p(-1, -1), p(0, -1)];
					else pointCheckOrder = [p(0, -1), p(1, -1), p(-1, -1), p(1, 0), p(-1, 0)];
				} else if (dir < 0) {
					if (dir > -90) pointCheckOrder = [p(1, 0), p(1, 1), p(1, 1), p(0, 1)];
					else if (dir < -90) pointCheckOrder = [p(-1, 0), p(-1, 1), p(-1, 1), p(0, 1)];
					else pointCheckOrder = [p(0, 1), p(1, 1), p(-1, 1), p(1, 0), p(-1, 0)];
				} else {
					pointCheckOrder = [p(1, 0), p(1, -1), p(1, -1), p(0, -1), p(0, 1)];
				}
			}
			if (safetyNet > 1000) break;//throw new VisionException("Too Many Iterations on point " + cwp.toString() + ". This should not occur.", "Line Detection Failure");
			voided = true;
			for (p in pointCheckOrder) {
				if (image.hasPixel(p.x + cwp.x, p.y + cwp.y) && image.getUnsafePixel(p.x + cwp.x, p.y + cwp.y) == 0xFFFFFFFF) {
					if (p != S.p(0, 1) && p != S.p(1, 0)) trace(p.toString());
					cwp = S.p(cwp.x + p.x, cwp.y + p.y);
					voided = false;
				} 
			}
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

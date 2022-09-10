package vision.algorithms;

import vision.ds.IntPoint2D;
import vision.tools.MathTools;
import vision.ds.Color;
import vision.ds.Point2D;
import vision.ds.LineSegment2D;
import vision.ds.Image;

using vision.tools.MathTools;

class SimpleLineDetector {
	
	public static function findLineFromPoint(image:Image, point:IntPoint2D, minLineGap:Float, minLineLength:Float):LineSegment2D {
		var startX = point.x, startY = point.y;
		var yArr = [0, 1, -1, 2, -2];
		var xArr = [0, 1, -1, 2, -2];
		var preferredDirection:IntPoint2D = new IntPoint2D(0,0);
		if (image[point.x] == null || image[point.x][point.y] == null || image[point.x][point.y] == 0) return null;

		//first, were going to detect the general direction the line goes in - this is used to detect crossed lines.
		function findPreference() {
			for (prefX in xArr) {
				for (prefY in yArr) {
					if (prefX == 0 && prefY == 0) continue;
					if (!image.hasPixel(point.x + prefX, point.y + prefY)) continue;
					if (image.getPixel(point.x + prefX, point.y + prefY).to24Bit() == Color.WHITE) {
						preferredDirection = new IntPoint2D(prefX, prefY);
					}
				}
			}
		}
		findPreference();

		var xs = xArr.copy();
		var ys = yArr.copy();
		xs.remove(2);
		xs.remove(-2);
		ys.remove(2);
		ys.remove(-2);
		if (preferredDirection.x > 0) {
			xs.remove(-1);
		} else if (preferredDirection.x < 0) {
			xs.remove(1);
		} else {
			xs.remove(-1);
		}

		if (preferredDirection.y > 0) {
			ys.remove(-1);
		} else if (preferredDirection.y < 0) {
			ys.remove(1);
		} else {
			ys.remove(-1);
		}

		var mightStop = false;
		var lValue = 0.;
		var lastValue = 0.;
		function expand() {
			final X = preferredDirection.x, Y = preferredDirection.y;
			if (image[point.x + X] == null || image[point.x + X][point.y + Y] == null) {
				return;
			}
			if (image.getPixel(point.x + X, point.y + Y).to24Bit() == Color.WHITE) {
				point.x = point.x + X;
				point.y = point.y + Y;
				expand();
			} else {
				//check if the pixel's neighbors can continue the line, and keep the direction

				for (x in xs) {
					for (y in ys) {
						if (x == 0 && y == 0) continue;
						if (image.hasPixel(point.x + x, point.y + y) && image.getPixel(point.x + x, point.y + y).to24Bit() == Color.WHITE) {
							point.x = point.x + x;
							point.y = point.y + y;
							expand();
						}
					}
				}
			}
		}
		expand();
		var line = new LineSegment2D({x: startX, y: startY}, point);
		
		if (line.length > minLineLength){
			return line;
		} 
		return null;
	}

	public static function getDistanceFromPointToLine(line:LineSegment2D, pointX:Int, pointY:Int):Float {
		var a:Float = line.end.y - line.start.y;
		var b:Float = line.start.x - line.end.x;
		var c:Float = a * (line.start.x) + b * (line.start.y);
		var d:Float = a * (pointX) + b * (pointY) - c;
		return Math.abs(d / Math.sqrt(a * a + b * b));
	}

	/**
		Returns the percentage of the line that covers an actual line in the given,
		**Black And White** image.
	**/
	public static function lineCoveragePercentage(image:Image, line:LineSegment2D) {
		var coveredPixels = 0, totalPixels = 0;
		var p1 = IntPoint2D.fromPoint2D(line.start);
        var p2 = IntPoint2D.fromPoint2D(line.end);
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
            if (x1 == x2 && y1 == y2) break;
            var e2 = 2 * err;
            if (e2 > -dy) { err -= dy; x1 += sx; }
            if (e2 < dx) { err += dx; y1 += sy; }
        }
		return coveredPixels / totalPixels * 100;
	}
}
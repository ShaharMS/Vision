package vision.algorithms;

import vision.tools.MathUtils;
import vision.ds.Color;
import vision.ds.Point2D;
import vision.ds.LineSegment2D;
import vision.ds.Image;

class SimpleLineDetector {
	
	public static function findLineFromPoint(image:Image, point:Point2D, minLineGap:Float, minLineLength:Float, preferTTB = false):LineSegment2D {
		var startX = point.x, startY = point.y;
		var yArr = preferTTB ? [0, 1, 2, 3] :[0, -1, 1, 2, -2];
		var xArr = preferTTB ? [0, -1, 1, 2, -2] : [1, 2, 3, 0];
		if (image[point.x] == null || image[point.x][point.y] == null || image[point.x][point.y] == 0) return null;
		// first - basic check to see if this point is close to / on the line. if so, its probably detecting an
		// already detected line.
		
		//now, were going to start looking for points around the point to find the entire line.
		var prev:Point2D = null;
		var prev2:Point2D = null;
		function expand() {
			for (X in xArr) {
				for (Y in yArr) {
					if (X == 0 && Y == 0 || image[point.x + X] == null || image[point.x + X][point.y + Y] == null) continue;
					if (image.getPixel(point.x + X, point.y + Y).to24Bit() == Color.WHITE) {
						point.x = point.x + X;
						point.y = point.y + Y;

						//used to prevent recursion
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
		var p1 = line.start;
        var p2 = line.end;
        var x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y;
        var dx = Math.abs(x2 - x1);
        var dy = Math.abs(y2 - y1);
        var sx = (x1 < x2) ? 1 : -1;
        var sy = (y1 < y2) ? 1 : -1;
        var err = dx - dy;
        while (true) {
            if (image.hasPixel(x1, y1)) {
				if (image.getPixel(x1, y1).to24Bit() == Color.WHITE) {
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
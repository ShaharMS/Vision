package vision.algorithms;

import vision.ds.Point2D;
import vision.ds.LineSegment2D;
import vision.ds.Image;

class SimpleLineDetector {
	
	static var linePositions:Array<LineSegment2D> = [];

	public static function findLineFromPoint(image:Image, point:Point2D, minLineGap:Float):LineSegment2D {
		var startX = point.x, startY = point.y;

		if (image[point.x] == null || image[point.x][point.y] == null || image[point.x][point.y] == 0) return null;
		// first - basic check to see if this point is close to / on the line. if so, its probably detecting an
		// already detected line.
		if (linePositions.length != 0) {
			for (l in linePositions) {
				var distance = getDistanceFromPointToLine(l, point.x, point.y);
				if (distance < minLineGap) {
					return null;
				}
			}
		}
		//now, were going to start looking for points around the point to find the entire line.
		function expand() {
			for (X in 1...3) {
				for (Y in -1...2) {
					if (X == 0 && Y == 0 || image[point.x + X] == null || image[point.x + X][point.y + Y] == null) continue;
					if (image[point.x + X][point.y + Y] == 1) {
						point.x = point.x + X;
						point.y = point.y + Y;
						expand();
					}
				}
			}
		}
		expand();
		//now, we should have found the end of the line - lets return it
		return new LineSegment2D({x: startX, y: startY}, point);
	}

	public static function getDistanceFromPointToLine(line:LineSegment2D, pointX:Int, pointY:Int):Float {
		var a:Float = line.end.y - line.start.y;
		var b:Float = line.start.x - line.end.x;
		var c:Float = a * (line.start.x) + b * (line.start.y);
		var d:Float = a * (pointX) + b * (pointY) - c;
		return Math.abs(d / Math.sqrt(a * a + b * b));
	}

	@:noCompletion public static inline function clearPositionalInfo() {
		linePositions = [];
	}
}
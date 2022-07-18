/*package vision.algorithms;

import vision.ds.Image;
import vision.ds.Point2D;
import haxe.ds.Vector;
import haxe.Timer;

class LineDetector {


	public function new() {
		for (X in 0...imageData.length) {
			for (Y in 0...imageData[X].length) {
				var line2D = findLineFromPoint(X, Y);
				if (line2D == null) continue;
				if (line2D.length > MIN_LINE_LENGTH) {
					linePositions.push(line2D);
				}
			}
		}
	}

	function findLineFromPoint(imageData:Image, point:Point2D):Line2D {
		var startX = point.x, startY = point.y;

		if (imageData[point.x] == null || imageData[point.x][point.y] == null || imageData[point.x][point.y] == 0) return null;
		// first - basic check to see if this point is close to / on the line. if so, its probably detecting an
		// already detected line.
		if (linePositions.length != 0) {
			for (l in linePositions) {
				var distance = getDistanceFromPointToLine(l.startX, l.startY, l.endX, l.endY, x, y);
				if (distance < MIN_LINE_GAP) {
					return null;
				}
			}
		}
		//now, were going to start looking for points around the point to find the entire line.
		function expand() {
			for (X in 1...3) {
				for (Y in -1...2) {
					if (X == 0 && Y == 0 || imageData[point.x + X] == null || imageData[point.x + X][point.y + Y] == null) continue;
					if (imageData[point.x + X][point.y + Y] == 1) {
						point.x = point.x + X;
						point.y = point.y + Y;
						expand();
					}
				}
			}
		}
		expand();
		//now, we should have found the end of the line - lets return it
		return new Line2D(startX, startY, x, y);
	}

	public static function getDistanceFromPointToLine(startX:Int, startY:Int, endX:Int, endY:Int, pointX:Int, pointY:Int):Float {
		var a:Float = endY - startY;
		var b:Float = startX - endX;
		var c:Float = a * (startX) + b * (startY);
		var d:Float = a * (pointX) + b * (pointY) - c;
		return Math.abs(d / Math.sqrt(a * a + b * b));
	}
}

class Line2D {
	public var length(default, null):Float;

	public var angle(default, null):Float;

	public var startX(default, null):Int;

	public var startY(default, null):Int;

	public var endX(default, null):Int;

	public var endY(default, null):Int;

	public function new(startX:Int, startY:Int, endX:Int, endY:Int) {
		this.startX = startX;
		this.startY = startY;
		this.endX = endX;
		this.endY = endY;
		this.angle = calcAngle(new Point(startX, startY), new Point(endX, endY));
		this.length = Math.sqrt((startX - endX) * (startX - endX) + (startY - endY) * (startY - endY));
	}

	public function toString() {
		return '\n ($startX, $startY) --> ($endX, $endY)';
	}

	public static function calcAngle(p1:Point, p2:Point) {
		var dx:Float = p1.x - p2.x;
		var dy:Float = p1.y - p2.y;
		var j:Float = Math.atan2(dy, dx) * (180 / Math.PI) - 180;
		return j;
	}
}
*/
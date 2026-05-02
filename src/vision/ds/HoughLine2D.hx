package vision.ds;

class HoughLine2D {
	public var rho(default, null):Float;
	public var theta(default, null):Float;
	public var votes(default, null):Float;

	public inline function new(rho:Float, theta:Float, votes:Float = 0) {
		this.rho = rho;
		this.theta = theta;
		this.votes = votes;
	}

	public inline function copy():HoughLine2D {
		return new HoughLine2D(rho, theta, votes);
	}

	public inline function pointOnLine():Point2D {
		return new Point2D(Math.cos(theta) * rho, Math.sin(theta) * rho);
	}

	public inline function toRay2D():Ray2D {
		return new Ray2D(pointOnLine(), null, null, theta + Math.PI / 2);
	}

	public function toLine2D(width:Int, height:Int):Null<Line2D> {
		if (width <= 0 || height <= 0) return null;

		var intersections:Array<Point2D> = [];
		var maxX = width - 1;
		var maxY = height - 1;
		var cosTheta = Math.cos(theta);
		var sinTheta = Math.sin(theta);

		if (!isNearZero(sinTheta)) {
			addIntersection(intersections, 0, rho / sinTheta, width, height);
			addIntersection(intersections, maxX, (rho - maxX * cosTheta) / sinTheta, width, height);
		}

		if (!isNearZero(cosTheta)) {
			addIntersection(intersections, rho / cosTheta, 0, width, height);
			addIntersection(intersections, (rho - maxY * sinTheta) / cosTheta, maxY, width, height);
		}

		if (intersections.length < 2) return null;

		var start = intersections[0];
		var end = intersections[1];
		var maxDistance = start.distanceTo(end);

		for (i in 0...intersections.length) {
			for (j in i + 1...intersections.length) {
				var distance = intersections[i].distanceTo(intersections[j]);
				if (distance > maxDistance) {
					start = intersections[i];
					end = intersections[j];
					maxDistance = distance;
				}
			}
		}

		return new Line2D(start, end);
	}

	@:keep
	public inline function toString():String {
		return 'HoughLine2D(rho=$rho, theta=$theta, votes=$votes)';
	}

	static inline function isNearZero(value:Float):Bool {
		return Math.abs(value) <= 0.000001;
	}

	static function addIntersection(points:Array<Point2D>, x:Float, y:Float, width:Int, height:Int):Void {
		if (!isInside(x, y, width, height)) return;
		for (point in points) {
			if (Math.abs(point.x - x) <= 0.000001 && Math.abs(point.y - y) <= 0.000001) {
				return;
			}
		}
		points.push(new Point2D(x, y));
	}

	static inline function isInside(x:Float, y:Float, width:Int, height:Int):Bool {
		return x >= 0 && x <= width - 1 && y >= 0 && y <= height - 1;
	}
}
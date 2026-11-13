package vision.ds;

/**
	A closed polygon with one exterior ring and optional interior holes.

	Coordinates are in image space, with x increasing right and y increasing down.
	Rings close automatically between the last and first vertices. Ring winding is
	irrelevant. For area and containment, supply simple rings with disjoint holes
	inside the exterior. The constructor keeps the supplied arrays and points by
	reference. Use `copy()` to edit a separate polygon.

	```haxe
	var polygon = new Polygon([{x: 0, y: 0}, {x: 20, y: 0}, {x: 10, y: 16}]);
	polygon.points[2].y = 24;
	trace(polygon.area);
	image.fillPolygon(polygon, Color.LIME);
	```
**/
class Polygon {
	/** The editable exterior vertices, in boundary order. **/
	public var points:Array<Point2D>;
	/** The editable interior rings, each in boundary order. **/
	public var holes:Array<Array<Point2D>>;
	/** Exterior area minus hole areas, in square coordinate units. **/
	public var area(get, never):Float;
	/** Total length of the exterior and hole boundaries. **/
	public var perimeter(get, never):Float;
	/** Integer bounds enclosing the exterior. Empty exteriors have zero bounds. **/
	public var bounds(get, never):Rectangle;

	/**
		Creates a polygon from editable rings.

		@param points The exterior vertices, with finite coordinates.
		@param holes Optional interior rings, with finite coordinates.
	**/
	public function new(points:Array<Point2D>, ?holes:Array<Array<Point2D>>) {
		this.points = points;
		this.holes = holes == null ? [] : holes;
	}

	/**
		Tests whether a point is inside the exterior and outside every hole.

		The crossing test uses half-open boundaries. For an axis-aligned rectangle
		the top and left edges are included, and the bottom and right are excluded.

		@param point The point to test.
		@return Whether the polygon contains the point.
	**/
	public function contains(point:Point2D):Bool {
		if (!ringContains(points, point)) return false;
		for (hole in holes)
			if (ringContains(hole, point)) return false;
		return true;
	}

	/** Returns a deep copy of the exterior and all holes. **/
	public function copy():Polygon {
		return new Polygon([for (point in points) point.copy()], [for (hole in holes) [for (point in hole) point.copy()]]);
	}

	function get_area():Float {
		var total = ringArea(points);
		for (hole in holes) total -= ringArea(hole);
		return total;
	}

	function get_perimeter():Float {
		var total = ringLength(points);
		for (hole in holes) total += ringLength(hole);
		return total;
	}

	function get_bounds():Rectangle {
		if (points.length == 0) return {x: 0, y: 0, width: 0, height: 0};
		var left = points[0].x;
		var right = left;
		var top = points[0].y;
		var bottom = top;
		for (point in points) {
			left = Math.min(left, point.x);
			right = Math.max(right, point.x);
			top = Math.min(top, point.y);
			bottom = Math.max(bottom, point.y);
		}
		final x = Math.floor(left);
		final y = Math.floor(top);
		return {x: x, y: y, width: Math.ceil(right) - x, height: Math.ceil(bottom) - y};
	}

	static function ringContains(ring:Array<Point2D>, point:Point2D):Bool {
		if (ring.length < 3) return false;
		var inside = false;
		var previous = ring[ring.length - 1];
		for (current in ring) {
			if ((previous.y > point.y) != (current.y > point.y)
				&& point.x < previous.x + (point.y - previous.y) / (current.y - previous.y) * (current.x - previous.x))
				inside = !inside;
			previous = current;
		}
		return inside;
	}

	static function ringArea(ring:Array<Point2D>):Float {
		if (ring.length < 3) return 0;
		var sum = 0.0;
		var previous = ring[ring.length - 1];
		for (current in ring) {
			sum += previous.x * current.y - current.x * previous.y;
			previous = current;
		}
		return Math.abs(sum) / 2;
	}

	static function ringLength(ring:Array<Point2D>):Float {
		if (ring.length < 2) return 0;
		var length = 0.0;
		var previous = ring[ring.length - 1];
		for (current in ring) {
			length += previous.distanceTo(current);
			previous = current;
		}
		return length;
	}
}

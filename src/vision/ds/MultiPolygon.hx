package vision.ds;

/** An editable collection of polygons, each with its own exterior and holes. **/
class MultiPolygon {
	/** The editable members, kept by reference. **/
	public var polygons:Array<Polygon>;
	/** The number of member polygons. **/
	public var length(get, never):Int;
	/** Sum of member areas. Overlapping areas contribute once per member. **/
	public var area(get, never):Float;
	/** Sum of member perimeters, including holes. **/
	public var perimeter(get, never):Float;
	/** Integer bounds enclosing all nonempty member exteriors. **/
	public var bounds(get, never):Rectangle;

	/**
		Creates a collection of polygons.

		@param polygons The editable member array, or an empty array if omitted.
	**/
	public function new(?polygons:Array<Polygon>) {
		this.polygons = polygons == null ? [] : polygons;
	}

	/**
		Tests whether any member contains a point.

		@param point The point to test.
		@return Whether any member contains the point.
	**/
	public function contains(point:Point2D):Bool {
		for (polygon in polygons)
			if (polygon.contains(point)) return true;
		return false;
	}

	/** Returns a deep copy of every member polygon. **/
	public function copy():MultiPolygon {
		return new MultiPolygon([for (polygon in polygons) polygon.copy()]);
	}

	inline function get_length():Int {
		return polygons.length;
	}

	function get_area():Float {
		var total = 0.0;
		for (polygon in polygons) total += polygon.area;
		return total;
	}

	function get_perimeter():Float {
		var total = 0.0;
		for (polygon in polygons) total += polygon.perimeter;
		return total;
	}

	function get_bounds():Rectangle {
		var bounds:Rectangle = null;
		for (polygon in polygons) {
			if (polygon.points.length == 0) continue;
			final member = polygon.bounds;
			if (bounds == null) {
				bounds = member;
			} else {
				final right = Std.int(Math.max(bounds.x + bounds.width, member.x + member.width));
				final bottom = Std.int(Math.max(bounds.y + bounds.height, member.y + member.height));
				bounds.x = Std.int(Math.min(bounds.x, member.x));
				bounds.y = Std.int(Math.min(bounds.y, member.y));
				bounds.width = right - bounds.x;
				bounds.height = bottom - bounds.y;
			}
		}
		return bounds == null ? {x: 0, y: 0, width: 0, height: 0} : bounds;
	}
}

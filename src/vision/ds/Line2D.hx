package vision.ds;

class Line2D {
    public var point:Point2D;

    public var slope(default, set):Float;

    public var degrees(default, set):Float;

    public var radians(default, set):Float;

    public var yIntercept(get, never):Float;

    public var xIntercept(get, never):Float;

    /**
        @param point a point on the line
        @param m the slope of the line, optional - you can pass the angle/radians instead, and set this to null
        @param angle the angle of the line, optional - you can pass the slope/radians instead, and set this to null
        @param radians the radians of the line, optional - you can pass the slope/angle instead, and not set this
    **/
    public function new(point:Point2D, ?m:Float, ?degrees:Float, ?radians:Float) {
        this.point = point;
        if (m != null) {
            this.slope = m;
            this.degrees = MathUtils.degreesFromSlope(m);
            this.radians = MathUtils.radiansFromSlope(m);
        } else if (degrees != null) {
            this.degrees = degrees;
            this.slope = MathUtils.slopeFromDegrees(degrees);
            this.radians = MathUtils.radiansFromDegrees(degrees);
        } else if (radians != null) {
            this.radians = radians;
            this.slope = MathUtils.slopeFromRadians(radians);
            this.degrees = MathUtils.degreesFromRadians(radians);
        }
    }

	function set_slope(value:Float):Float {
		Reflect.setField(this, "degrees", MathUtils.degreesFromSlope(value));
        Reflect.setField(this, "radians", MathUtils.radiansFromSlope(value));
        return slope = value;
	}

	function set_degrees(value:Float):Float {
		Reflect.setField(this, "slope", MathUtils.slopeFromDegrees(value));
        Reflect.setField(this, "radians", MathUtils.radiansFromDegrees(value));
        return degrees = value;
	}

    function set_radians(value:Float):Float {
        Reflect.setField(this, "slope", MathUtils.slopeFromRadians(value));
        Reflect.setField(this, "degrees", MathUtils.degreesFromRadians(value));
        return radians = value;
    }

    function get_yIntercept() {
        var px:Float = point.x, py:Float = point.y;
        if (px > 0) {
            while (px > 0) {
                px--;
                py -= slope;
            }
        } else if (px < 0) {
            while (px < 0) {
                px++;
                py += slope;
            }
        }
        return py;
    }

    function get_xIntercept() {
        var px:Float = point.x, py:Float = point.y;
        if (py > 0) {
            while (py > 0) {
                py--;
                px -= 1 / slope;
            }
        } else if (py < 0) {
            while (py < 0) {
                py++;
                px += 1 / slope;
            }
        }
        return px;
    }


    public static function from2Points(point1:Point2D, point2:Point2D) {
        var s = (point2.y - point1.y) / (point2.x - point1.x);
        return new Line2D(point1, s);
    }
}
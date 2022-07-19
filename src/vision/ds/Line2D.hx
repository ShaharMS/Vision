package vision.ds;

class Line2D {
    public var point:Point2D;

    public var slope(default, set):Float;

    public var angle(default, set):Float;

    /**
        @param point a point on the line
        @param m the slope of the line, optional - you can pass the angle instead, and set this to null
        @param angle the angle of the line, optional - you can pass the slope instead 
    **/
    public function new(point:Point2D, ?m:Float, ?angle:Float) {
        this.point = point;
        if (m != null) {
            this.slope = m;
            this.angle = angleFromSlope(m);
        } else if (angle != null) {
            this.angle = angle;
            this.slope = slopeFromAngle(angle);
        }
    }
        
    function angleFromSlope(slope:Float) {
        return Math.atan(slope) * 180 / Math.PI;
    }

    function slopeFromAngle(angle:Float) {
        return Math.tan(angle);
    }

	function set_slope(value:Float):Float {
		Reflect.setField(this, "angle", angleFromSlope(value));
        return slope = value;
	}

	function set_angle(value:Float):Float {
		Reflect.setField(this, "slope", slopeFromAngle(value));
        return angle = value;
	}

    public static function from2Points(point1:Point2D, point2:Point2D) {
        var slope = (point2.y - point1.y) / (point2.x - point1.x);
        return new Line2D(point1, slope);
    }
}
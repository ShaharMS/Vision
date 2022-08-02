package vision.ds;

import vision.tools.MathTools;

class Ray2D {
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
            this.degrees = MathTools.degreesFromSlope(m);
            this.radians = MathTools.radiansFromSlope(m);
        } else if (degrees != null) {
            this.degrees = degrees;
            this.slope = MathTools.slopeFromDegrees(degrees);
            this.radians = MathTools.radiansFromDegrees(degrees);
        } else if (radians != null) {
            this.radians = radians;
            this.slope = MathTools.slopeFromRadians(radians);
            this.degrees = MathTools.degreesFromRadians(radians);
        }
    }

	function set_slope(value:Float):Float {
		@:bypassAccessor degrees = MathTools.degreesFromSlope(value);
        @:bypassAccessor radians = MathTools.radiansFromSlope(value);
        return slope = value;
	}

	function set_degrees(value:Float):Float {
		@:bypassAccessor slope = MathTools.slopeFromDegrees(value);
        @:bypassAccessor radians = MathTools.radiansFromDegrees(value);
        return degrees = value;
	}

    function set_radians(value:Float):Float {
        @:bypassAccessor slope = MathTools.slopeFromRadians(value);
        @:bypassAccessor degrees = MathTools.degreesFromRadians(value);
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
        return new Ray2D(point1, s);
    }

    public static function fromThetaAndRho(theta:Float, rho:Float) {
        return new Ray2D(new Point2D(rho * MathTools.cos(theta), rho * MathTools.sin(theta)), MathTools.slopeFromRadians(theta));
    }

    public function getPointAtX(x:Int):Point2D {
        //you have the slope, and the x value, find the y value
        return new Point2D(x, Std.int(slope * x + yIntercept));
    }

    public function getPointAtY(y:Int):Point2D {
        //you have the slope, and the y value, find the x value
        return new Point2D(Std.int(y / slope), y);
    }
}
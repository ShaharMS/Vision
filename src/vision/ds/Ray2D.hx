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
            this.degrees = MathTools.slopeToDegrees(m);
            this.radians = MathTools.slopeToRadians(m);
        } else if (degrees != null) {
            this.degrees = degrees;
            this.slope = MathTools.degreesToSlope(degrees);
            this.radians = MathTools.degreesToRadians(degrees);
        } else if (radians != null) {
            this.radians = radians;
            this.slope = MathTools.radiansToSlope(radians);
            this.degrees = MathTools.radiansToDegrees(radians);
        }
    }

	function set_slope(value:Float):Float {
		@:bypassAccessor degrees = MathTools.slopeToDegrees(value);
        @:bypassAccessor radians = MathTools.slopeToRadians(value);
        return slope = value;
	}

	function set_degrees(value:Float):Float {
		@:bypassAccessor slope = MathTools.degreesToSlope(value);
        @:bypassAccessor radians = MathTools.degreesToRadians(value);
        return degrees = value;
	}

    function set_radians(value:Float):Float {
        @:bypassAccessor slope = MathTools.radiansToSlope(value);
        @:bypassAccessor degrees = MathTools.radiansToDegrees(value);
        return radians = value;
    }

    function get_yIntercept() {
        var px:Float = point.x, py:Float = point.y;
        if (px > 0) {
            return py - (slope * px);
        }
        return py + (slope * px);
    }

    function get_xIntercept() {
        var px:Float = point.x, py:Float = point.y;
        if (py > 0) {
            return (py - (slope * px)) / slope;
        }
        return (py + (slope * px)) / slope;
    }


    public static function from2Points(point1:Point2D, point2:Point2D) {
        var s = (point2.y - point1.y) / (point2.x - point1.x);
        return new Ray2D(point1, s);
    }

    public function getPointAtX(x:Int):Point2D {
        //you have the slope, and the x value, find the y value
        return new Point2D(x, slope * x + yIntercept);
    }

    public function getPointAtY(y:Int):Point2D {
        //you have the slope, and the y value, find the x value
        return new Point2D((y - yIntercept) / slope, y);
    }

    public function intersect(ray:Ray2D):Point2D {
        return MathTools.intersectionBetweenRays2D(this, ray);
    }
}
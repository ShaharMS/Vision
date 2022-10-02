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
	public inline function new(point:Point2D, ?m:Float, ?degrees:Float, ?radians:Float) {
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

	inline function set_slope(value:Float):Float {
		@:bypassAccessor degrees = MathTools.slopeToDegrees(value);
        @:bypassAccessor radians = MathTools.slopeToRadians(value);
        return slope = value;
	}

	inline function set_degrees(value:Float):Float {
		@:bypassAccessor slope = MathTools.degreesToSlope(value);
        @:bypassAccessor radians = MathTools.degreesToRadians(value);
        return degrees = value;
	}

    inline function set_radians(value:Float):Float {
        @:bypassAccessor slope = MathTools.radiansToSlope(value);
        @:bypassAccessor degrees = MathTools.radiansToDegrees(value);
        return radians = value;
    }

    inline function get_yIntercept() {
        var px:Float = point.x, py:Float = point.y;
        if (px > 0) {
            return py - (slope * px);
        }
        return py + (slope * px);
    }

    inline function get_xIntercept() {
        var px:Float = point.x, py:Float = point.y;
        if (py > 0) {
            return (py - (slope * px)) / slope;
        }
        return (py + (slope * px)) / slope;
    }


	public static inline function from2Points(point1:Point2D, point2:Point2D) {
        var s = (point2.y - point1.y) / (point2.x - point1.x);
        return new Ray2D(point1, s);
    }

	public inline function getPointAtX(x:Float):Point2D {
        //you have the slope, and the x value, find the y value
        return new Point2D(x, slope * x + yIntercept);
    }

    public inline function getPointAtY(y:Float):Point2D {
        //you have the slope, and the y value, find the x value
        return new Point2D((y - yIntercept) / slope, y);
    }

    public inline function intersect(ray:Ray2D):Point2D {
        return MathTools.intersectionBetweenRays2D(this, ray);
    }

    /**
     * Gets the point on `this` ray, which is `distance` points away
     * from `start`.
     * 
     * In order to avoid returning two points (since
     * any point on the ray has 2 points with the exact same distance from it),
     * you have the `goPositive` value.
     * 
     * 
     * @param startXPos The `x` position to start from.
     * @param distance The distance from `start` to the resulting point.
     * @param goPositive Whether or not the resulting point is in front/behind `start`. `true` means in front, `false` means behind.
     */
	public inline function findPointWithDistance(startXPos:Float, distance:Float, goPositive:Bool = true) {
        // Were going to step one point to the right, and chek how much distance was covered.
        // After checking, were going to devide distance with the distance between start to start(y + 1)
        // Make sure to not surpass `distance`
        distance = MathTools.abs(distance);
        var start = getPointAtX(startXPos);
        var step = MathTools.distanceBetweenPoints(getPointAtX(start.y + 1), start);
        var diff = distance / step;
        return getPointAtY(start.y + if (goPositive) diff else -diff);
    }
}
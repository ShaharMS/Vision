package vision.ds;

import vision.tools.MathTools;

@:structInit
class Point3D {
    
    /**
		The x-coordinate of the point.
	**/
    public var x:Float;

    /**
		The y-coordinate of the point.
	**/
    public var y:Float;

    /**
		The z-coordinate of the point.
	**/
    public var z:Float;

    /**
		Initializes a new instance of the Point3D class with the specified x, y and z coordinates.

		you can construct a Point3D object by using the following syntax too:
		```haxe
		var point:Point3D = {x: 10, y: -4, z: 5};
		```    
	**/
    public function new(x:Float, y:Float, z:Float) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    /**
		Gets the distance between `this` and `point`.

		If `this` and `point` are have the same `x`, `y` and `z` position, `0` is returned.

		@param point The second point to calculate the distance to
		@return A `Float` representing the distance. `0` if `this` and `point` are congruent.
	**/
    public function distanceTo(point:Point3D) {
        return MathTools.distanceBetweenPoints(this, point);
    }

    /**
		Returns a new `Point3D` instance, similar to this one.
	**/
    public function copy() {
        return new Point3D(x, y, z);
    }

    /**
		Returns a `String` representations of this `Point3D`.
	**/
    public function toString() {
        return '($x, $y, $z)';
    }
}
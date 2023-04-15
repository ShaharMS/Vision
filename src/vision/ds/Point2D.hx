package vision.ds;

import vision.tools.MathTools;

@:structInit
class Point2D {
	/**
		The x-coordinate of the point.
	**/
	public var x:Float;

	/**
		The y-coordinate of the point.
	**/
	public var y:Float;

	/**
		Initializes a new instance of the Point2D class with the specified x and y coordinates.

		you can construct a Point2D object by using the following syntax too:
		```haxe
		var point:Point2D = {x: 10, y: 20};
		```    
	**/
	public inline function new(x:Float = 0, y:Float = 0) {
		this.x = x;
		this.y = y;
	}

	/**
		Returns a `String` representations of this `Point2D`.
	**/
	public inline function toString():String {
		return '($x, $y)';
	}

	/**
		Returns a new `Point2D` instance, similar to this one.
	**/
	public inline function copy():Point2D {
		return {x: x, y: y};
	}

	/**
		Gets the distance between `this` and `point`.

		If `this` and `point` are haxe the same `x` & `y` position, `0` is returned.

		@param point The second point to calculate the distance to
		@return A `Float` representing the distance. `0` if `this` and `point` are congruent.
	**/
	public inline function distanceTo(point:Point2D):Float {
		return MathTools.distanceBetweenPoints(this, point);
	}
}

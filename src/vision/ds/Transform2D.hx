package vision.ds;

import vision.algorithms.PerspectiveWarp;
import vision.ds.specifics.PointTransformationPair;
import vision.exceptions.VisionException;
import vision.tools.MathTools.*;
import vision.ds.Point3D;
import vision.exceptions.MatrixShapeError;

/**
	A 3x3 homogeneous map from 2D coordinates to 2D coordinates. The matrix
	multiplies the column vector (x, y, 1). `apply` divides the resulting x
	and y by the homogeneous coordinate w.

	A transform can be passed to any parameter of type `Matrix2D`. The
	conversion produces an independent matrix, as does `toMatrix()`.
**/
abstract Transform2D(Matrix2D) {
	// Coefficients are arranged in rows as [a, c, tx], [b, d, ty], [e, f, w].
	/** Input x's contribution to output x. **/
	public var a(get, set):Float;
	inline function get_a() return this.get(0, 0);
	inline function set_a(value:Float) return setCoefficient(0, 0, value);

	/** Input x's contribution to output y. **/
	public var b(get, set):Float;
	inline function get_b() return this.get(0, 1);
	inline function set_b(value:Float) return setCoefficient(0, 1, value);

	/** Input y's contribution to output x. **/
	public var c(get, set):Float;
	inline function get_c() return this.get(1, 0);
	inline function set_c(value:Float) return setCoefficient(1, 0, value);

	/** Input y's contribution to output y. **/
	public var d(get, set):Float;
	inline function get_d() return this.get(1, 1);
	inline function set_d(value:Float) return setCoefficient(1, 1, value);

	/** Input x's contribution to the homogeneous denominator. **/
	public var e(get, set):Float;
	inline function get_e() return this.get(0, 2);
	inline function set_e(value:Float) return setCoefficient(0, 2, value);

	/** Input y's contribution to the homogeneous denominator. **/
	public var f(get, set):Float;
	inline function get_f() return this.get(1, 2);
	inline function set_f(value:Float) return setCoefficient(1, 2, value);

	/** Constant coefficient of the horizontal numerator. **/
	public var tx(get, set):Float;
	inline function get_tx() return this.get(2, 0);
	inline function set_tx(value:Float) return setCoefficient(2, 0, value);

	/** Constant coefficient of the vertical numerator. **/
	public var ty(get, set):Float;
	inline function get_ty() return this.get(2, 1);
	inline function set_ty(value:Float) return setCoefficient(2, 1, value);

	private inline function setCoefficient(x:Int, y:Int, value:Float):Float {
		if (!Math.isFinite(value)) throw new VisionException("Transform coefficients must be finite numbers.", "Transform Error");
		return this.set(x, y, value);
	}

	private inline function new(matrix:Matrix2D) {
		this = matrix;
	}

	/** Copies a finite 3x3 matrix into a transform. **/
	public static function fromMatrix(matrix:Matrix2D):Transform2D {
		if (matrix == null || matrix.width != 3 || matrix.height != 3 || matrix.underlying.length != 9)
			throw new MatrixShapeError("Transform2D requires a 3x3 matrix.", "Transform Error");
		for (value in matrix.underlying.inner) {
			if (#if !static value == null || #end !Math.isFinite(value))
				throw new VisionException("Transform coefficients must be finite numbers.", "Transform Error");
		}
		return new Transform2D(matrix.clone());
	}

	/** Creates a transform from three rows. The last row defaults to [0, 0, 1]. **/
	public static function fromRows(xRow:Array<Float>, yRow:Array<Float>, ?homogeneousRow:Array<Float>):Transform2D {
		return fromMatrix(Matrix2D.fromRows([xRow, yRow, homogeneousRow == null ? [0, 0, 1] : homogeneousRow]));
	}

	/** Returns an independent copy of the coefficient matrix. **/
	@:to public inline function toMatrix():Matrix2D {
		return this.clone();
	}

	/** Whether the homogeneous denominator is constant and nonzero. **/
	public inline function isAffine():Bool {
		return this.get(0, 2) == 0 && this.get(1, 2) == 0 && this.get(2, 2) != 0;
	}

	/** Maps a point, throwing if it has no finite image under this transform. **/
	public inline function apply(point:Point2D):Point2D {
		return project(applyHomogeneous(new Point3D(point.x, point.y, 1)));
	}

	/** Multiplies a homogeneous coordinate (x, y, w) by this matrix. **/
	public inline function applyHomogeneous(point:Point3D):Point3D {
		return new Point3D(
			point.x * this.get(0, 0) + point.y * this.get(1, 0) + point.z * this.get(2, 0),
			point.x * this.get(0, 1) + point.y * this.get(1, 1) + point.z * this.get(2, 1),
			point.x * this.get(0, 2) + point.y * this.get(1, 2) + point.z * this.get(2, 2)
		);
	}

	@:allow(vision.Vision)
	private static inline function project(point:Point3D):Point2D {
		var x = point.x / point.z;
		var y = point.y / point.z;
		if (point.z == 0 || !Math.isFinite(point.z) || !Math.isFinite(x) || !Math.isFinite(y))
			throw new VisionException("Point has no finite image under this transform.", "Transform Error");
		return new Point2D(x, y);
	}

	/** Returns a transform that applies this transform first, then `next`. **/
	public inline function then(next:Transform2D):Transform2D {
		return fromMatrix(Matrix2D.multiplyMatrices(next, this));
	}

	/** Returns the inverse. A singular transform cannot be inverted. **/
	public inline function inverse():Transform2D {
		return fromMatrix(this.invert());
	}

	/** Returns the identity coordinate map. **/
	public static inline function identity():Transform2D {
		return new Transform2D(Matrix2D.identity(3));
	}

	/** Rotates about `origin` (the coordinate origin by default), in degrees. **/
	public static inline function rotationDegrees(angle:Float, ?origin:Point2D):Transform2D {
		return rotationRadians(angle * Math.PI / 180, origin);
	}

	/** Rotates about `origin` (the coordinate origin by default), in radians. **/
	public static inline function rotationRadians(angle:Float, ?origin:Point2D):Transform2D {
		var c = Math.cos(angle);
		var s = Math.sin(angle);
		var x = origin == null ? 0 : origin.x;
		var y = origin == null ? 0 : origin.y;
		return fromRows([c, -s, x - c * x + s * y], [s, c, y - s * x - c * y]);
	}

	/** Translates by the given horizontal and vertical offsets. **/
	public static inline function translation(x:Float = 0, y:Float = 0):Transform2D {
		return fromRows([1, 0, x], [0, 1, y]);
	}

	/** Scales the x and y axes independently. **/
	public static inline function scale(x:Float = 1, y:Float = 1):Transform2D {
		return fromRows([x, 0, 0], [0, y, 0]);
	}

	/** Adds `x * input.y` to x and `y * input.x` to y. **/
	public static inline function shear(x:Float = 0, y:Float = 0):Transform2D {
		return fromRows([1, x, 0], [y, 1, 0]);
	}

	/** Reflects across the line through `origin` at `angle` to the x axis. **/
	public static function reflection(angle:Float, degrees:Bool = true, ?origin:Point2D):Transform2D {
		var c = degrees ? cosd(2 * angle) : Math.cos(2 * angle);
		var s = degrees ? sind(2 * angle) : Math.sin(2 * angle);
		var x = origin == null ? 0 : origin.x;
		var y = origin == null ? 0 : origin.y;
		return fromRows([c, s, x - c * x - s * y], [s, -c, y - s * x + c * y]);
	}

	/** Fits a projective map from four source points to their corresponding destinations. **/
	public static function perspective(pointPairs:Array<PointTransformationPair>):Transform2D {
		var source = [for (pair in pointPairs) pair.from];
		var destination = [for (pair in pointPairs) pair.to];
		return fromMatrix(PerspectiveWarp.generateMatrix(source, destination));
	}

	/** Scales apparent size by 1/z about `towards` (the coordinate origin by default). **/
	public static inline function depth(z:Float, ?towards:Point2D):Transform2D {
		if (z == 0) throw new VisionException("Depth must be nonzero.", "Transform Error");
		return fromRows(
			[1, 0, towards == null ? 0 : towards.x * (z - 1)],
			[0, 1, towards == null ? 0 : towards.y * (z - 1)],
			[0, 0, z]
		);
	}
}

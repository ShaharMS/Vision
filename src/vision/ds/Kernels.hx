package vision.ds;

import vision.algorithms.Gauss;
import vision.exceptions.VisionException;

/** Named convolution kernels. Each factory returns a fresh, mutable matrix. **/
class Kernels {
	/** Leaves each pixel unchanged. **/
	public static function identity():Matrix2D {
		return Matrix2D.fromRows([[1]]);
	}

	/** A normalized 3x3 uniform blur. **/
	public static function boxBlur():Matrix2D {
		return new Matrix2D(3, 3, 1.0 / 9);
	}

	/** A normalized Gaussian blur with positive odd size and positive finite sigma. **/
	public static function gaussian(size:Int, sigma:Float):Matrix2D {
		if (size <= 0 || size % 2 == 0 || !Math.isFinite(sigma) || sigma <= 0)
			throw new VisionException("Gaussian requires a positive odd size and positive finite sigma.", "Kernel Error");
		return Gauss.create2DKernelOfSize(size, sigma);
	}

	/** A cross-shaped Laplacian with center coefficient -4. **/
	public static function laplacianPositive():Matrix2D {
		return assemble3x3(0, 1, -4);
	}

	/** A cross-shaped Laplacian with center coefficient +4. **/
	public static function laplacianNegative():Matrix2D {
		return assemble3x3(0, -1, 4);
	}

	/** A ridge detector that weights all eight neighbors equally. **/
	public static function ridgeDetection():Matrix2D {
		return assemble3x3(-1, -1, 4);
	}

	/** A ridge detector with a larger center coefficient. **/
	public static function ridgeDetectionAggressive():Matrix2D {
		return assemble3x3(-1, -1, 7.75);
	}

	/** Sharpens using a center weight of 5 and four adjacent weights of -1. **/
	public static function sharpen():Matrix2D {
		return assemble3x3(0, -1, 5);
	}

	/** A 5x5 unsharp mask with unit total weight. **/
	public static function unsharpMasking():Matrix2D {
		return assemble5x5(1, 4, 6, 16, 24, -476).multiplyWithScalar(-1.0 / 256);
	}

	/** Builds a symmetric 3x3 kernel from its corner, edge, and center weights. **/
	public static function assemble3x3(corner:Float, edge:Float, center:Float):Matrix2D {
		return Matrix2D.fromRows([[corner, edge, corner], [edge, center, edge], [corner, edge, corner]]);
	}

	/** Builds a symmetric 5x5 kernel from weights on its outer and inner rings. **/
	public static function assemble5x5(farCorner:Float, farEdge:Float, edge:Float, midCorner:Float, midEdge:Float, center:Float):Matrix2D {
		return Matrix2D.fromRows([
			[farCorner, farEdge, edge, farEdge, farCorner],
			[farEdge, midCorner, midEdge, midCorner, farEdge],
			[edge, midEdge, center, midEdge, edge],
			[farEdge, midCorner, midEdge, midCorner, farEdge],
			[farCorner, farEdge, edge, farEdge, farCorner]
		]);
	}
}

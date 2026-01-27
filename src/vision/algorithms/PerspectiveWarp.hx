package vision.algorithms;

import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.exceptions.VisionException;

using vision.tools.MathTools;

class PerspectiveWarp {

	public static function generateMatrix(destinationPoints:Array<Point2D>, sourcePoints:Array<Point2D>):Matrix2D {
		if (destinationPoints == null || sourcePoints == null) {
			#if vision_quiet
			return Matrix2D.IDENTITY();
			#else
			throw new VisionException("Expected 4 source points and 4 destination points.", "Perspective Warp Error");
			#end
		}
		if (sourcePoints.length != 4 || destinationPoints.length != 4) {
			#if vision_quiet
			return Matrix2D.IDENTITY();
			#else
			throw new VisionException("Expected 4 source points and 4 destination points.", "Perspective Warp Error");
			#end
		}

		var M = new Matrix2D(3, 3);
		var a = new Matrix2D(8, 8);
		a.fill(0);
		var b = [for (_ in 0...8) 0.];

		// "Magic" matrix construction
		for (i in 0...4) {
			a.set(0, i, destinationPoints[i].x);
			a.set(3, i + 4, destinationPoints[i].x);
			a.set(1, i, destinationPoints[i].y);
			a.set(4, i + 4, destinationPoints[i].y);
			a.set(2, i, 1);
			a.set(5, i + 4, 1);
			a.set(6, i, -destinationPoints[i].x * sourcePoints[i].x);
			a.set(7, i, -destinationPoints[i].y * sourcePoints[i].x);
			a.set(6, i + 4, -destinationPoints[i].x * sourcePoints[i].y);
			a.set(7, i + 4, -destinationPoints[i].y * sourcePoints[i].y);
			b[i] = sourcePoints[i].x;
			b[i + 4] = sourcePoints[i].y;

		}

		var x = Cramer.solveVariablesFor(a, b);
		x[8] = 1.;

		for (i in 0...3) {
			M.set(0, i, x[i * 3]);
			M.set(1, i, x[i * 3 + 1]);
			M.set(2, i, x[i * 3 + 2]);
		}

		return M;
	}
}
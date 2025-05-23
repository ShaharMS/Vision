package vision.algorithms;

import vision.ds.Matrix2D;
import vision.ds.Point2D;

using vision.tools.MathTools;

class PerspectiveWarp {

	public static function generateMatrix(destinationPoints:Array<Point2D>, sourcePoints:Array<Point2D>):Matrix2D {
		if (sourcePoints.length != 4 || sourcePoints.length != 4) throw ""; // todo

		var M = new Matrix2D(3, 3);
		var a:Array<Array<Float>> = [for (_ in 0...8) [for (_ in 0...8) 0.]];
		var b = [for (_ in 0...8) 0.];

		// "Magic" matrix construction
		for (i in 0...4) {
			a[i][0] = a[i + 4][3] = destinationPoints[i].x;
			a[i][1] = a[i + 4][4] = destinationPoints[i].y;
			a[i][2] = a[i + 4][5] = 1;
			a[i][3] = a[i][4] = a[i][5] = a[i + 4][0] = a[i + 4][1] = a[i + 4][2] = 0;
			a[i][6] = -destinationPoints[i].x * sourcePoints[i].x;
			a[i][7] = -destinationPoints[i].y * sourcePoints[i].x;
			a[i + 4][6] = -destinationPoints[i].x * sourcePoints[i].y;
			a[i + 4][7] = -destinationPoints[i].y * sourcePoints[i].y;
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
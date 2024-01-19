package vision.algorithms;

import haxe.io.Float32Array;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.Array2D;
import vision.tools.MathTools;

using vision.tools.MathTools;

import haxe.ds.Vector;
import vision.ds.Point3D;
import vision.ds.Point2D;
import vision.ds.specifics.PointTransformationPair;

class PerspectiveWarp {
	public static function generateMatrix(sourcePoints:Array<Point2D>, destinationPoints:Array<Point2D>):Matrix2D {
		if (destinationPoints.length != 4 || sourcePoints.length != 4) throw ""; // todo

		var M = new Matrix2D(3, 3);
		var a:Array<Array<Float>> = [[], [], [], [], [], [], [], []];
		var b = new Array<Float>();

		for (i in 0...4) {
			a[i][0] = a[i + 4][3] = sourcePoints[i].x;
			a[i][1] = a[i + 4][4] = sourcePoints[i].y;
			a[i][2] = a[i + 4][5] = 1;
			a[i][3] = a[i][4] = a[i][5] = a[i + 4][0] = a[i + 4][1] = a[i + 4][2] = 0;
			a[i][6] = -sourcePoints[i].x * destinationPoints[i].x;
			a[i][7] = -sourcePoints[i].y * destinationPoints[i].x;
			a[i + 4][6] = -sourcePoints[i].x * destinationPoints[i].y;
			a[i + 4][7] = -sourcePoints[i].y * destinationPoints[i].y;
			b[i] = destinationPoints[i].x;
			b[i + 4] = destinationPoints[i].y;
		}

		trace(a);
		trace(b);

		var x = Cramer.solveVariablesFor(a, b);
		trace(x);
		x[8] = 1.;

		for (i in 0...3) {
			M.set(0, i, x[i * 3]);
			M.set(1, i, x[i * 3 + 1]);
			M.set(2, i, x[i * 3 + 2]);
		}

		trace(M);

		return M;
	}

	public static function applyMatrix(image:Image, matrix:Matrix2D) {
		var outputImage:Image = new Image(image.width, image.height);

		for (y in 0...image.height) {
			for (x in 0...image.width) {
				var processed = matrix.transformPoint(new Point3D(x, y, 1));
				var transformedPoint = new Point2D(processed.x / processed.z, processed.y / processed.z);
				if (MathTools.random() > 0.99) trace(processed, transformedPoint);
				var color:Int = image.getFloatingPixel(transformedPoint.x, transformedPoint.y);
				outputImage.setPixel(x, y, color);
			}
		}

		return outputImage;
	}
}

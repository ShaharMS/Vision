package vision.algorithms;

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
        if (destinationPoints.length != 4 || sourcePoints.length != 4) throw ""; //todo
        
        var M = new Matrix2D(3, 3);
        var a = new Array2D<Float>(8, 8);
        var b = new Vector<Float>(8);

        for (i in 0...4) {
            a.setMultiple([{x: i, y: 0}, {x: i + 4, y: 3}], sourcePoints[i].x);
            a.setMultiple([{x: i, y: 1}, {x: i + 4, y: 4}], sourcePoints[i].y);
            a.setMultiple([{x: i, y: 2}, {x: i + 4, y: 5}], 1);
            a.setMultiple([{x: i, y: 3}, {x: i, y: 4}, {x: i, y: 5}, {x: i, y: 6}, {x: i + 4, y: 0}, {x: i + 4, y: 1}, {x: i + 4, y: 2}], 0);
            a.set(i, 6, -sourcePoints[i].x * destinationPoints[i].x);
            a.set(i, 7, -sourcePoints[i].y * destinationPoints[i].x);
            a.set(i + 4, 6, -sourcePoints[i].x * destinationPoints[i].y);
            a.set(i + 4, 7, -sourcePoints[i].y * destinationPoints[i].y);
            b.set(i, destinationPoints[i].x);
            b.set(i + 4, destinationPoints[i].y);
        }
    
        trace(a);
        trace(b.toArray());

        var x = Cramer.solveVariablesFor(a, b.toArray());
        trace(x);
        x[8] = 1.;

        for (i in 0...3) {
            M.set(i, 0, x[i * 3]);
            M.set(i, 1, x[i * 3 + 1]);
            M.set(i, 2, x[i * 3 + 2]);
        }

        return M;

    }

    public static function applyMatrix(image:Image, matrix:Matrix2D) {
        var outputImage: Image = new Image(image.width, image.height);

        for (y in 0...image.height) {
            for (x in 0...image.width) {
                var processed = matrix * [[x, y, 1]];
                var transformedPoint = new Point2D(processed.get(0, 0) / processed.get(0, 2), processed.get(0, 1) / processed.get(0, 2));
                var color: Int = image.getFloatingPixel(transformedPoint.x, transformedPoint.y);
                outputImage.setPixel(x, y, color);
            }
        }

        return outputImage;

    }

}
package vision.algorithms;

import vision.tools.MathTools;
using vision.tools.MathTools;
import haxe.ds.Vector;
import vision.ds.Point3D;
import vision.ds.Point2D;
import vision.ds.specifics.PointTransformationPair;

class PerspectiveWarp {
    
    public static function generateMatrix(sourcePoints:Array<Point2D>, destinationPoints:Array<Point2D>) {
        if (destinationPoints.length != 4 || sourcePoints.length != 4) throw ""; //todo
        var A:Array<Array<Vector<Float>>> = [];

        for (i in 0...4) {
            A.push(getCoefficients(sourcePoints[i], destinationPoints[i], i));
        }

        var B = [for (_ in 0...4) [0, 0, -1]].flatten();
        Formula
    }


    public static function getCoefficients(original:Point2D, transformed:Point2D, n:Int) {
        var resultingVectors:Array<Vector<Float>> = [];
        var castedTransformed:Point3D = {x: transformed.x, y: transformed.y, z: 1};
        var dimensions = 3;

        for (i in 0...dimensions) {
            var currentVector = new Vector<Float>(dimensions * 4, 0);
            currentVector[i] = original.x;
            currentVector[dimensions + i] = original.y;
            currentVector[dimensions * 2 + i] = i != 2 ? 1 : 0;
            currentVector[dimensions * 3 + n - 1] = -(i == 0 ? castedTransformed.x : i == 1 ? castedTransformed.y : castedTransformed.z);
        
            resultingVectors.push(currentVector);
        }

        return resultingVectors;
    }
}
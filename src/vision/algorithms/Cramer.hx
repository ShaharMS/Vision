package vision.algorithms;

import haxe.ds.Vector;
import vision.ds.Array2D;

/**
    Solve a system of linear equations using Cramer's rule.

    Ported from Java to Haxe, by [Shahar Marcus](https://www.github.com/ShaharMS)
**/
class Cramer {
    
    public static function solve(a:Array2D<Float>, b:Array<Float>):Array<Float> {
        var size = b.length;
        var tempMatrix = new Array2D<Float>(size, size);

        var x = new Vector<Float>(size);

        var detCohef = calculateDeterminant(a, size);

        for (i in 0...size) {
            for (k in 0...size) {
               for (l in 0...size) {
                   tempMatrix.set(k, l, a.get(k, l));
               } 
            }

            for (k in 0...size) {
                tempMatrix.set(k, i, b[k]);
            }

            var det = calculateDeterminant(tempMatrix, size);
            x[i] = det / detCohef;
        }

        return x.toArray();
    }

    public static function calculateDeterminant(m:Array2D<Float>, size:Int):Float {
        switch size {
            case 0: return 0;
            case 1: return m.get(0, 0);
            case 2: return m.get(0, 0) * m.get(1, 1) - m.get(0, 1) * m.get(1, 0);
            case _: {
                var sum = 0.;
                var multiplier = -1;
                for (i in 0...size) {
                    multiplier *= -1;
                    var nM = copyMatrix(m, size, i);
                    var det = multiplier * m.get(0, i) * calculateDeterminant(nM, size - 1);
                    sum += det;
                }

                return sum;
            }
        }
    }

    public static function copyMatrix(m:Array2D<Float>, size:Int, col:Int):Array2D<Float> {
        var sizeM = size - 1;
        var result = new Array2D<Float>(sizeM, sizeM);
        var nI = 0;

        for (i in 1...size) {
            var nJ = 0;
            for (j in 0...size) {
                if (j == col) continue;
                result.set(nI, nJ, m.get(i, j));
            }

            nI++;
        }

        return result;
    }
}
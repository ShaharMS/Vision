package vision.algorithms;

import vision.exceptions.InvalidCramerSetup;
import vision.exceptions.InvalidCramerCoefficientsMatrix;
import vision.ds.Matrix2D;
import vision.algorithms.GaussJordan;
import vision.tools.MathTools;

/**
    Solve a system of linear equations using Cramer's rule.

    A solution can be provided, as long as there as many variables as there are equations.  
    Variables are solved as such:

    given a system of `n` equations and `n` variables:
    ```txt
    Ax + By + Cz = D
    Ex + Fy + Gz = H
    Ix + Jy + Kz = L
    ```

    A matrix and a vector are constructed: 
     - A matrix for the coefficients of the variables across the equations:
    ```
    ┌           ┐
    │ A   B   C │
    │ E   F   G │
    │ I   J   K │
    └           ┘
    ```
     - And a vector for their solutions:
    ```
    ┌   ┐
    │ D │
    │ H │
    │ L │
    └   ┘
    ```

    According to Cramer's rule, given these components, 
    you can extract the values of the variables using the formula:
    
    ```txt
         det(Aₙ) 
    xₙ = --------
         det(A)
    ```

     - xₙ - the solution of the `n`th variable, from left to right
     - Aₙ - the coefficients matrix, with it's `n`th column replaced with the solution vector 
     - A - the unchanged coefficients matrix.

    Made by [Shahar Marcus](https://www.github.com/ShaharMS)
**/
class Cramer {


    public static function solveVariablesFor(coefficients:Matrix2D, solutions:Array<Float>):Array<Float> {
        #if vision_quiet
        if (coefficients.columns != solutions.length || coefficients.rows != solutions.length) {
            if (coefficients.columns >= solutions.length && coefficients.rows >= solutions.length) {
                coefficients = coefficients.getSubMatrix(0, 0, solutions.length, solutions.length);
            }
            else {
                var minDim = MathTools.min(coefficients.columns, coefficients.rows);
                coefficients = coefficients.getSubMatrix(0, 0, minDim, minDim);
                solutions = solutions.slice(0, minDim);
            }
        }
        #else
        if (coefficients.columns != coefficients.rows) throw new InvalidCramerCoefficientsMatrix(coefficients);
        if (coefficients.rows != solutions.length) throw new InvalidCramerSetup(coefficients, solutions);
        #end

        #if cppia
        var n = coefficients.height;
        if (n == 2) {
            var inner = coefficients.underlying.inner;
            var a = inner[0];
            var b = inner[1];
            var c = inner[2];
            var d = inner[3];
            var det = a * d - b * c;
            if (Math.abs(det) < 1e-12) {
                #if vision_quiet
                return [for (_ in 0...n) 0.0];
                #else
                throw "Matrix is not invertible";
                #end
            }
            var x = (solutions[0] * d - b * solutions[1]) / det;
            var y = (a * solutions[1] - solutions[0] * c) / det;
            return [x, y];
        }
        var augmented = new Matrix2D(n + 1, n);
        for (row in 0...n) {
            for (col in 0...n) {
                augmented.set(col, row, coefficients.get(col, row));
            }
            augmented.set(n, row, solutions[row]);
        }

        for (i in 0...n) {
            var pivotRow = i;
            for (r in (i + 1)...n) {
                if (Math.abs(augmented.get(i, r)) > Math.abs(augmented.get(i, pivotRow))) {
                    pivotRow = r;
                }
            }
            if (Math.abs(augmented.get(i, pivotRow)) < 1e-12) {
                #if vision_quiet
                return [for (_ in 0...n) 0.0];
                #else
                throw "Matrix is not invertible";
                #end
            }
            if (pivotRow != i) {
                for (col in 0...n + 1) {
                    var temp = augmented.get(col, i);
                    augmented.set(col, i, augmented.get(col, pivotRow));
                    augmented.set(col, pivotRow, temp);
                }
            }

            var pivot = augmented.get(i, i);
            for (col in 0...n + 1) {
                augmented.set(col, i, augmented.get(col, i) / pivot);
            }

            for (row in 0...n) {
                if (row == i) continue;
                var factor = augmented.get(i, row);
                if (factor == 0) continue;
                for (col in 0...n + 1) {
                    augmented.set(col, row, augmented.get(col, row) - factor * augmented.get(col, i));
                }
            }
        }

        var variables:Array<Float> = [];
        for (row in 0...n) {
            variables.push(augmented.get(n, row));
        }
        return variables;
        #else
        var A = coefficients.clone();
        var replacedA = A.clone();

        var variables = [];

        for (i in 0...solutions.length) {
            replacedA = A.clone();
            replacedA.setColumn(i, solutions);
            variables.push(replacedA.getDeterminant() / A.getDeterminant());
        }

        return variables;
        #end
    }

}
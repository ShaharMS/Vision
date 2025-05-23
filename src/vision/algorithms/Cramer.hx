package vision.algorithms;

import vision.exceptions.InvalidCramerSetup;
import vision.exceptions.InvalidCramerCoefficientsMatrix;
import vision.tools.MathTools;
import vision.ds.Matrix2D;
import haxe.ds.Vector;
import vision.ds.Array2D;

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

        var A = coefficients.clone();
        var replacedA = A.clone();

        var variables = [];

        for (i in 0...solutions.length) {
            replacedA = A.clone();
            replacedA.setColumn(i, solutions);
            variables.push(replacedA.getDeterminant() / A.getDeterminant());
        }

        return variables;
    }

}
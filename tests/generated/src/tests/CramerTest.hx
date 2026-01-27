package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.Cramer;
import vision.exceptions.InvalidCramerSetup;
import vision.exceptions.InvalidCramerCoefficientsMatrix;
import vision.ds.Matrix2D;

@:access(vision.algorithms.Cramer)
class CramerTest extends utest.Test {

    function test_solveVariablesFor_2x2_system() {
        // Solve system: 2x + y = 5, x + 3y = 6
        // Solution: x = 1.8, y = 1.4
        var coefficients = new Matrix2D(2, 2);
        coefficients.set(0, 0, 2); coefficients.set(1, 0, 1);  // 2x + 1y
        coefficients.set(0, 1, 1); coefficients.set(1, 1, 3);  // 1x + 3y
        var solutions = [5.0, 6.0];
        var result = Cramer.solveVariablesFor(coefficients, solutions);
        Assert.notNull(result);
        Assert.equals(2, result.length);
        Assert.floatEquals(1.8, result[0]);
        Assert.floatEquals(1.4, result[1]);
    }

    function test_solveVariablesFor_3x3_system() {
        // Solve: x + y + z = 6, 2x - y + z = 3, x + 2y - z = 2
        // Solution: x = 1, y = 2, z = 3
        var coefficients = new Matrix2D(3, 3);
        coefficients.set(0, 0, 1); coefficients.set(1, 0, 1); coefficients.set(2, 0, 1);   // x + y + z
        coefficients.set(0, 1, 2); coefficients.set(1, 1, -1); coefficients.set(2, 1, 1);  // 2x - y + z
        coefficients.set(0, 2, 1); coefficients.set(1, 2, 2); coefficients.set(2, 2, -1);  // x + 2y - z
        var solutions = [6.0, 3.0, 2.0];
        var result = Cramer.solveVariablesFor(coefficients, solutions);
        Assert.equals(3, result.length);
        Assert.floatEquals(1.0, result[0]);
        Assert.floatEquals(2.0, result[1]);
        Assert.floatEquals(3.0, result[2]);
    }

    function test_solveVariablesFor_identity_matrix() {
        // With identity matrix, solutions are the variable values directly
        // 1x + 0y = 5, 0x + 1y = 7 => x = 5, y = 7
        var coefficients = new Matrix2D(2, 2);
        coefficients.set(0, 0, 1); coefficients.set(1, 0, 0);
        coefficients.set(0, 1, 0); coefficients.set(1, 1, 1);
        var solutions = [5.0, 7.0];
        var result = Cramer.solveVariablesFor(coefficients, solutions);
        Assert.floatEquals(5.0, result[0]);
        Assert.floatEquals(7.0, result[1]);
    }

    function test_solveVariablesFor_negative_solution() {
        // Solve: x + y = 0, x - y = 4 => x = 2, y = -2
        var coefficients = new Matrix2D(2, 2);
        coefficients.set(0, 0, 1); coefficients.set(1, 0, 1);
        coefficients.set(0, 1, 1); coefficients.set(1, 1, -1);
        var solutions = [0.0, 4.0];
        var result = Cramer.solveVariablesFor(coefficients, solutions);
        Assert.floatEquals(2.0, result[0]);
        Assert.floatEquals(-2.0, result[1]);
    }

    function test_solveVariablesFor_fractional_coefficients() {
        // Solve: 0.5x + 0.5y = 1, x - y = 0 => x = 1, y = 1
        var coefficients = new Matrix2D(2, 2);
        coefficients.set(0, 0, 0.5); coefficients.set(1, 0, 0.5);
        coefficients.set(0, 1, 1.0); coefficients.set(1, 1, -1.0);
        var solutions = [1.0, 0.0];
        var result = Cramer.solveVariablesFor(coefficients, solutions);
        Assert.floatEquals(1.0, result[0]);
        Assert.floatEquals(1.0, result[1]);
    }

    function test_solveVariablesFor_zero_solutions() {
        // Solve: x + y = 0, x - y = 0 => x = 0, y = 0
        var coefficients = new Matrix2D(2, 2);
        coefficients.set(0, 0, 1); coefficients.set(1, 0, 1);
        coefficients.set(0, 1, 1); coefficients.set(1, 1, -1);
        var solutions = [0.0, 0.0];
        var result = Cramer.solveVariablesFor(coefficients, solutions);
        Assert.floatEquals(0.0, result[0]);
        Assert.floatEquals(0.0, result[1]);
    }

}

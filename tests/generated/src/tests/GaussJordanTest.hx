package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.GaussJordan;
import vision.ds.Matrix2D;

@:access(vision.algorithms.GaussJordan)
class GaussJordanTest extends utest.Test {

    function test_invert_2x2_matrix() {
        // Create an invertible 2x2 matrix: [[4, 7], [2, 6]]
        // Determinant = 4*6 - 7*2 = 24 - 14 = 10 (non-zero, so invertible)
        var matrix = new Matrix2D(2, 2);
        matrix.set(0, 0, 4); matrix.set(1, 0, 7);
        matrix.set(0, 1, 2); matrix.set(1, 1, 6);
        var result = GaussJordan.invert(matrix);
        Assert.notNull(result);
        Assert.equals(2, result.width);
        Assert.equals(2, result.height);
    }

    function test_invert_identity_matrix() {
        // Identity matrix is its own inverse
        var matrix = new Matrix2D(2, 2);
        matrix.set(0, 0, 1); matrix.set(1, 0, 0);
        matrix.set(0, 1, 0); matrix.set(1, 1, 1);
        var result = GaussJordan.invert(matrix);
        Assert.notNull(result);
        Assert.floatEquals(1.0, result.get(0, 0), 0.01);
        Assert.floatEquals(0.0, result.get(1, 0), 0.01);
        Assert.floatEquals(0.0, result.get(0, 1), 0.01);
        Assert.floatEquals(1.0, result.get(1, 1), 0.01);
    }

    function test_createIdentityMatrix() {
        var result:Matrix2D = GaussJordan.createIdentityMatrix(3);
        Assert.notNull(result);
        // Diagonal should be 1s
        Assert.floatEquals(1.0, result.get(0, 0));
        Assert.floatEquals(1.0, result.get(1, 1));
        Assert.floatEquals(1.0, result.get(2, 2));
        // Off-diagonal should be 0s
        Assert.floatEquals(0.0, result.get(1, 0));
        Assert.floatEquals(0.0, result.get(0, 1));
    }

    function test_createIdentityMatrix_size_1() {
        var result:Matrix2D = GaussJordan.createIdentityMatrix(1);
        Assert.equals(1, result.rows);
        Assert.equals(1, result.columns);
        Assert.floatEquals(1.0, result.get(0, 0));
    }

    function test_augmentMatrix() {
        var matrix:Array<Array<Float>> = [[1.0, 2.0], [3.0, 4.0]];
        var identity:Array<Array<Float>> = [[1.0, 0.0], [0.0, 1.0]];
        var result:Matrix2D = GaussJordan.augmentMatrix(matrix, identity);
        Assert.equals(2, result.height);
        Assert.equals(4, result.width); // Original 2 + identity 2
        Assert.floatEquals(1.0, result.get(0, 0));
        Assert.floatEquals(2.0, result.get(1, 0));
        Assert.floatEquals(1.0, result.get(2, 0));
        Assert.floatEquals(0.0, result.get(3, 0));
    }

    function test_swapRows() {
        var matrix = new Matrix2D(2, 2);
        matrix.set(0, 0, 1.0); matrix.set(1, 0, 2.0);
        matrix.set(0, 1, 3.0); matrix.set(1, 1, 4.0);
        GaussJordan.swapRows(matrix, 0, 1);
        Assert.floatEquals(3.0, matrix.get(0, 0));
        Assert.floatEquals(4.0, matrix.get(1, 0));
        Assert.floatEquals(1.0, matrix.get(0, 1));
        Assert.floatEquals(2.0, matrix.get(1, 1));
    }

    function test_extractMatrix() {
        var matrix = new Matrix2D(4, 2);
        matrix.set(0, 0, 1.0); matrix.set(1, 0, 2.0); matrix.set(2, 0, 3.0); matrix.set(3, 0, 4.0);
        matrix.set(0, 1, 5.0); matrix.set(1, 1, 6.0); matrix.set(2, 1, 7.0); matrix.set(3, 1, 8.0);
        var result:Matrix2D = GaussJordan.extractMatrix(matrix, 2, [2, 3]);
        Assert.equals(2, result.height);
        Assert.equals(2, result.width);
        Assert.floatEquals(3.0, result.get(0, 0));
        Assert.floatEquals(4.0, result.get(1, 0));
        Assert.floatEquals(7.0, result.get(0, 1));
        Assert.floatEquals(8.0, result.get(1, 1));
    }

}

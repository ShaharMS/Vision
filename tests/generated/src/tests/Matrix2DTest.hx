package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Matrix2D;
import vision.ds.Point2D;
import vision.ds.Matrix2D;

@:access(vision.ds.Matrix2D)
class Matrix2DTest extends utest.Test {

    // Shared test fixtures
    static var testImage:vision.ds.Image;
    static var blackImage:vision.ds.Image;
    static var gradientImage:vision.ds.Image;

    public function setup() {
        if (testImage == null) {
            testImage = new vision.ds.Image(100, 100);
            blackImage = new vision.ds.Image(100, 100, 0xFF000000);
            gradientImage = createGradientImage(100, 100);
        }
    }

    static function createGradientImage(w:Int, h:Int):vision.ds.Image {
        var img = new vision.ds.Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                var r = Std.int((x / w) * 255);
                var g = Std.int((y / h) * 255);
                var b = Std.int(((x + y) / (w + h)) * 255);
                img.setPixel(x, y, vision.ds.Color.fromRGBA(r, g, b, 255));
            }
        }
        return img;
    }

    function test_underlying() {
        var result = vision.ds.Matrix2D.underlying;
        Assert.notNull(result);
    }

    function test_rows() {
        var result = vision.ds.Matrix2D.rows;
        Assert.notNull(result);
    }

    function test_columns() {
        var result = vision.ds.Matrix2D.columns;
        Assert.notNull(result);
    }

    function test_invert() {
        var this = [];
        var result = vision.ds.Matrix2D.invert(this);
        Assert.notNull(result);
    }

    function test_getDeterminant() {
        var this = [];
        var result = vision.ds.Matrix2D.getDeterminant(this);
        Assert.notNull(result);
    }

    function test_getTrace() {
        var this = [];
        var result = vision.ds.Matrix2D.getTrace(this);
        Assert.notNull(result);
    }

    function test_getAverage() {
        var this = [];
        var result = vision.ds.Matrix2D.getAverage(this);
        Assert.notNull(result);
    }

    function test_multiplyWithScalar() {
        var this = [];
        var scalar = 0.0;
        var result = vision.ds.Matrix2D.multiplyWithScalar(this, scalar);
        Assert.notNull(result);
    }

    function test_clone() {
        var this = [];
        var result = vision.ds.Matrix2D.clone(this);
        Assert.notNull(result);
    }

    function test_map() {
        var this = [];
        var mappingFunction = (_) -> 0.0;
        var result = vision.ds.Matrix2D.map(this, mappingFunction);
        Assert.notNull(result);
    }

    function test_getSubMatrix() {
        var this = [];
        var fromX = 0;
        var fromY = 0;
        var toX = null;
        var toY = null;
        var result = vision.ds.Matrix2D.getSubMatrix(this, fromX, fromY, toX, toY);
        Assert.notNull(result);
    }

    function test_getColumn() {
        var this = [];
        var x = 0;
        var result = vision.ds.Matrix2D.getColumn(this, x);
        Assert.notNull(result);
    }

    function test_getRow() {
        var this = [];
        var y = 0;
        var result = vision.ds.Matrix2D.getRow(this, y);
        Assert.notNull(result);
    }

    function test_setColumn() {
        var this = [];
        var x = 0;
        var arr = [];
        vision.ds.Matrix2D.setColumn(this, x, arr);
        Assert.pass();
    }

    function test_setRow() {
        var this = [];
        var y = 0;
        var arr = [];
        vision.ds.Matrix2D.setRow(this, y, arr);
        Assert.pass();
    }

    function test_insertColumn() {
        var this = [];
        var x = 0;
        var arr = [];
        var result = vision.ds.Matrix2D.insertColumn(this, x, arr);
        Assert.notNull(result);
    }

    function test_insertRow() {
        var this = [];
        var y = 0;
        var arr = [];
        var result = vision.ds.Matrix2D.insertRow(this, y, arr);
        Assert.notNull(result);
    }

    function test_removeColumn() {
        var this = [];
        var x = 0;
        var result = vision.ds.Matrix2D.removeColumn(this, x);
        Assert.notNull(result);
    }

    function test_removeRow() {
        var this = [];
        var y = 0;
        var result = vision.ds.Matrix2D.removeRow(this, y);
        Assert.notNull(result);
    }

    function test_toString() {
        var this = [];
        var precision = 0;
        var pretty = false;
        var result = vision.ds.Matrix2D.toString(this, precision, pretty);
        Assert.notNull(result);
    }

    function test_IDENTITY() {
        var result = vision.ds.Matrix2D.IDENTITY();
        Assert.notNull(result);
    }

    function test_ROTATION() {
        var angle = 0.0;
        var degrees = null;
        var origin = null;
        var result = vision.ds.Matrix2D.ROTATION(angle, degrees, origin);
        Assert.notNull(result);
    }

    function test_TRANSLATION() {
        var x = 0.0;
        var y = 0.0;
        var result = vision.ds.Matrix2D.TRANSLATION(x, y);
        Assert.notNull(result);
    }

    function test_SCALE() {
        var scaleX = 0.0;
        var scaleY = 0.0;
        var result = vision.ds.Matrix2D.SCALE(scaleX, scaleY);
        Assert.notNull(result);
    }

    function test_SHEAR() {
        var shearX = 0.0;
        var shearY = 0.0;
        var result = vision.ds.Matrix2D.SHEAR(shearX, shearY);
        Assert.notNull(result);
    }

    function test_REFLECTION() {
        var angle = 0.0;
        var degrees = null;
        var origin = null;
        var result = vision.ds.Matrix2D.REFLECTION(angle, degrees, origin);
        Assert.notNull(result);
    }

    function test_PERSPECTIVE() {
        var pointPairs = [];
        var result = vision.ds.Matrix2D.PERSPECTIVE(pointPairs);
        Assert.notNull(result);
    }

    function test_DEPTH() {
        var z = 0.0;
        var towards = null;
        var result = vision.ds.Matrix2D.DEPTH(z, towards);
        Assert.notNull(result);
    }

    function test_createFilled() {
        var rows = null;
        var result = vision.ds.Matrix2D.createFilled(rows);
        Assert.notNull(result);
    }

    function test_createTransformation() {
        var xRow = [];
        var yRow = [];
        var homogeneousRow = null;
        var result = vision.ds.Matrix2D.createTransformation(xRow, yRow, homogeneousRow);
        Assert.notNull(result);
    }

    function test_multiplyMatrices() {
        var a = new vision.ds.Matrix2D(3, 3);
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.multiplyMatrices(a, b);
        Assert.notNull(result);
    }

    function test_addMatrices() {
        var a = new vision.ds.Matrix2D(3, 3);
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.addMatrices(a, b);
        Assert.notNull(result);
    }

    function test_subtractMatrices() {
        var a = new vision.ds.Matrix2D(3, 3);
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.subtractMatrices(a, b);
        Assert.notNull(result);
    }

    function test_divideMatrices() {
        var a = new vision.ds.Matrix2D(3, 3);
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.divideMatrices(a, b);
        Assert.notNull(result);
    }

    function test_multiply() {
        var this = [];
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.multiply(this, b);
        Assert.notNull(result);
    }

    function test_add() {
        var this = [];
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.add(this, b);
        Assert.notNull(result);
    }

    function test_subtract() {
        var this = [];
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.subtract(this, b);
        Assert.notNull(result);
    }

    function test_divide() {
        var this = [];
        var b = new vision.ds.Matrix2D(3, 3);
        var result = vision.ds.Matrix2D.divide(this, b);
        Assert.notNull(result);
    }

}

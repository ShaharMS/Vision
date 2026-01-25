package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Array2D;
import vision.ds.Point2D;

@:access(vision.ds.Array2D)
class Array2DTest extends utest.Test {

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

    function test_inner() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.inner;
        Assert.notNull(result);
    }

    function test_width() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.width;
        Assert.notNull(result);
    }

    function test_height() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.height;
        Assert.notNull(result);
    }

    function test_length() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.length;
        Assert.notNull(result);
    }

    function test_get() {
        var x = 0;
        var y = 0;
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.get(x, y);
        Assert.notNull(result);
    }

    function test_set() {
        var x = 0;
        var y = 0;
        var val = cast 0;
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.set(x, y, val);
        Assert.notNull(result);
    }

    function test_setMultiple() {
        var points = [];
        var val = cast 0;
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        instance.setMultiple(points, val);
        Assert.pass();
    }

    function test_row() {
        var y = 0;
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.row(y);
        Assert.notNull(result);
    }

    function test_column() {
        var x = 0;
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.column(x);
        Assert.notNull(result);
    }

    function test_iterator() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.iterator();
        Assert.notNull(result);
    }

    function test_fill() {
        var value = cast 0;
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.fill(value);
        Assert.notNull(result);
    }

    function test_clone() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.clone();
        Assert.notNull(result);
    }

    function test_toString() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.toString();
        Assert.notNull(result);
    }

    function test_to2DArray() {
        var ctor_width = 0;
        var ctor_height = 0;
        var ctor_fillWith = null;
        var instance = new vision.ds.Array2D(ctor_width, ctor_height, ctor_fillWith);
        var result = instance.to2DArray();
        Assert.notNull(result);
    }

}

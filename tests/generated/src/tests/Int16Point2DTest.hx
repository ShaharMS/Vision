package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Int16Point2D;

@:access(vision.ds.Int16Point2D)
class Int16Point2DTest extends utest.Test {

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

    function test_x() {
        var result = vision.ds.Int16Point2D.x;
        Assert.notNull(result);
    }

    function test_y() {
        var result = vision.ds.Int16Point2D.y;
        Assert.notNull(result);
    }

    function test_toString() {
        var this = 0;
        var result = vision.ds.Int16Point2D.toString(this);
        Assert.notNull(result);
    }

    function test_toPoint2D() {
        var this = 0;
        var result = vision.ds.Int16Point2D.toPoint2D(this);
        Assert.notNull(result);
    }

    function test_toIntPoint2D() {
        var this = 0;
        var result = vision.ds.Int16Point2D.toIntPoint2D(this);
        Assert.notNull(result);
    }

    function test_toInt() {
        var this = 0;
        var result = vision.ds.Int16Point2D.toInt(this);
        Assert.notNull(result);
    }

}

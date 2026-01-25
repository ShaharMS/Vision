package tests;

import utest.Assert;
import utest.Async;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;

@:access(vision.ds.IntPoint2D)
class IntPoint2DTest extends utest.Test {

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
        var result = vision.ds.IntPoint2D.x;
        Assert.notNull(result);
    }

    function test_y() {
        var result = vision.ds.IntPoint2D.y;
        Assert.notNull(result);
    }

    function test_toPoint2D() {
        var this = null;
        var result = vision.ds.IntPoint2D.toPoint2D(this);
        Assert.notNull(result);
    }

    function test_fromPoint2D() {
        var p = new vision.ds.Point2D(0.0, 0.0);
        var result = vision.ds.IntPoint2D.fromPoint2D(p);
        Assert.notNull(result);
    }

    function test_toString() {
        var this = null;
        var result = vision.ds.IntPoint2D.toString(this);
        Assert.notNull(result);
    }

    function test_copy() {
        var this = null;
        var result = vision.ds.IntPoint2D.copy(this);
        Assert.notNull(result);
    }

    function test_distanceTo() {
        var this = null;
        var point = new vision.ds.IntPoint2D(0, 0);
        var result = vision.ds.IntPoint2D.distanceTo(this, point);
        Assert.notNull(result);
    }

    function test_degreesTo() {
        var this = null;
        var point = new vision.ds.Point2D(0.0, 0.0);
        var result = vision.ds.IntPoint2D.degreesTo(this, point);
        Assert.notNull(result);
    }

    function test_radiansTo() {
        var this = null;
        var point = new vision.ds.Point2D(0.0, 0.0);
        var result = vision.ds.IntPoint2D.radiansTo(this, point);
        Assert.notNull(result);
    }

}

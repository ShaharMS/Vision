package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Line2D;
import vision.ds.Ray2D;
import vision.ds.Point2D;
import vision.ds.Line2D;

@:access(vision.ds.Line2D)
class Line2DTest extends utest.Test {

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

    function test_fromRay2D() {
        var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
        var result = vision.ds.Line2D.fromRay2D(ray);
        Assert.notNull(result);
    }

    function test_length() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.length;
        Assert.notNull(result);
    }

    function test_slope() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.slope;
        Assert.notNull(result);
    }

    function test_degrees() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.degrees;
        Assert.notNull(result);
    }

    function test_radians() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.radians;
        Assert.notNull(result);
    }

    function test_start() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.start;
        Assert.notNull(result);
    }

    function test_end() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.end;
        Assert.notNull(result);
    }

    function test_middle() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.middle;
        Assert.notNull(result);
    }

    function test_intersect() {
        var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.intersect(line);
        Assert.notNull(result);
    }

    function test_distanceTo() {
        var line = new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0));
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.distanceTo(line);
        Assert.notNull(result);
    }

    function test_toString() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.toString();
        Assert.notNull(result);
    }

    function test_toRay2D() {
        var ctor_start = new vision.ds.Point2D(0.0, 0.0);
        var ctor_end = new vision.ds.Point2D(0.0, 0.0);
        var instance = new vision.ds.Line2D(ctor_start, ctor_end);
        var result = instance.toRay2D();
        Assert.notNull(result);
    }

}

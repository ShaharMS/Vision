package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Ray2D;
import vision.ds.Ray2D;
import vision.ds.Point2D;

@:access(vision.ds.Ray2D)
class Ray2DTest extends utest.Test {

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

    function test_from2Points() {
        var point1 = new vision.ds.Point2D(0.0, 0.0);
        var point2 = new vision.ds.Point2D(0.0, 0.0);
        var result = vision.ds.Ray2D.from2Points(point1, point2);
        Assert.notNull(result);
    }

    function test_point() {
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.point;
        Assert.notNull(result);
    }

    function test_slope() {
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.slope;
        Assert.notNull(result);
    }

    function test_degrees() {
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.degrees;
        Assert.notNull(result);
    }

    function test_radians() {
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.radians;
        Assert.notNull(result);
    }

    function test_yIntercept() {
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.yIntercept;
        Assert.notNull(result);
    }

    function test_xIntercept() {
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.xIntercept;
        Assert.notNull(result);
    }

    function test_getPointAtX() {
        var x = 0.0;
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.getPointAtX(x);
        Assert.notNull(result);
    }

    function test_getPointAtY() {
        var y = 0.0;
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.getPointAtY(y);
        Assert.notNull(result);
    }

    function test_intersect() {
        var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.intersect(ray);
        Assert.notNull(result);
    }

    function test_distanceTo() {
        var ray = new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0);
        var ctor_point = new vision.ds.Point2D(0.0, 0.0);
        var ctor_m = null;
        var ctor_degrees = null;
        var ctor_radians = null;
        var instance = new vision.ds.Ray2D(ctor_point, ctor_m, ctor_degrees, ctor_radians);
        var result = instance.distanceTo(ray);
        Assert.notNull(result);
    }

}

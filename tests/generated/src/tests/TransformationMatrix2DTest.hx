package tests;

import utest.Assert;
import utest.Async;
import vision.ds.TransformationMatrix2D;
import vision.ds.Matrix2D;

@:access(vision.ds.TransformationMatrix2D)
class TransformationMatrix2DTest extends utest.Test {

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
        var result = vision.ds.TransformationMatrix2D.underlying;
        Assert.notNull(result);
    }

    function test_a() {
        var result = vision.ds.TransformationMatrix2D.a;
        Assert.notNull(result);
    }

    function test_b() {
        var result = vision.ds.TransformationMatrix2D.b;
        Assert.notNull(result);
    }

    function test_c() {
        var result = vision.ds.TransformationMatrix2D.c;
        Assert.notNull(result);
    }

    function test_d() {
        var result = vision.ds.TransformationMatrix2D.d;
        Assert.notNull(result);
    }

    function test_e() {
        var result = vision.ds.TransformationMatrix2D.e;
        Assert.notNull(result);
    }

    function test_f() {
        var result = vision.ds.TransformationMatrix2D.f;
        Assert.notNull(result);
    }

    function test_tx() {
        var result = vision.ds.TransformationMatrix2D.tx;
        Assert.notNull(result);
    }

    function test_ty() {
        var result = vision.ds.TransformationMatrix2D.ty;
        Assert.notNull(result);
    }

    function test_transformPoint() {
        var this = new vision.ds.Matrix2D(3, 3);
        var point = new vision.ds.Point3D(0.0, 0.0, 0.0);
        var result = vision.ds.TransformationMatrix2D.transformPoint(this, point);
        Assert.notNull(result);
    }

}

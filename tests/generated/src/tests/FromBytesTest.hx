package tests;

import utest.Assert;
import utest.Async;
import vision.formats.from.FromBytes;
import vision.ds.ByteArray;

@:access(vision.formats.from.FromBytes)
@:build(tests.macros.InvalidTestSkipper.build())
class FromBytesTest extends utest.Test {

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

    function test_png() {
        var bytes = new vision.ds.ByteArray(100);
        var instance = new vision.formats.from.FromBytes();
        var result = instance.png(bytes);
        Assert.notNull(result);
    }

    function test_bmp() {
        var bytes = new vision.ds.ByteArray(100);
        var instance = new vision.formats.from.FromBytes();
        var result = instance.bmp(bytes);
        Assert.notNull(result);
    }

    function test_jpeg() {
        var bytes = new vision.ds.ByteArray(100);
        var instance = new vision.formats.from.FromBytes();
        var result = instance.jpeg(bytes);
        Assert.notNull(result);
    }

}

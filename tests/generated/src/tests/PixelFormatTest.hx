package tests;

import utest.Assert;
import utest.Async;
import vision.ds.PixelFormat;
import vision.ds.ByteArray;

@:access(vision.ds.PixelFormat)
class PixelFormatTest extends utest.Test {

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

    function test_convertPixelFormat() {
        var bytes = new vision.ds.ByteArray(100);
        var from = null;
        var to = null;
        var result = vision.ds.PixelFormat.convertPixelFormat(bytes, from, to);
        Assert.notNull(result);
    }

}

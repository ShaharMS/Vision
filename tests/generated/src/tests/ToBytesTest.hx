package tests;

import utest.Assert;
import utest.Async;
import vision.formats.to.ToBytes;
import vision.ds.Image;

@:access(vision.formats.to.ToBytes)
class ToBytesTest extends utest.Test {

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
        var image = gradientImage;
        var instance = new vision.formats.to.ToBytes();
        var result = instance.png(image);
        Assert.notNull(result);
    }

    function test_bmp() {
        var image = gradientImage;
        var instance = new vision.formats.to.ToBytes();
        var result = instance.bmp(image);
        Assert.notNull(result);
    }

    function test_jpeg() {
        var image = gradientImage;
        var instance = new vision.formats.to.ToBytes();
        var result = instance.jpeg(image);
        Assert.notNull(result);
    }

}

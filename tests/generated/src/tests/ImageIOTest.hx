package tests;

import utest.Assert;
import utest.Async;
import vision.formats.ImageIO;
import vision.formats.from.From;
import vision.formats.to.To;
import vision.ds.Image;
import vision.ds.Color;

@:access(vision.formats.ImageIO)
class ImageIOTest extends utest.Test {

    static var gradientImage:Image;

    public function setup() {
        if (gradientImage == null) {
            gradientImage = createGradientImage(50, 50);
        }
    }

    static function createGradientImage(w:Int, h:Int):Image {
        var img = new Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                var r = Std.int((x / w) * 255);
                var g = Std.int((y / h) * 255);
                var b = Std.int(((x + y) / (w + h)) * 255);
                img.setPixel(x, y, Color.fromRGBA(r, g, b, 255));
            }
        }
        return img;
    }

    function test_from_is_not_null() {
        Assert.notNull(ImageIO.from);
    }

    function test_to_is_not_null() {
        Assert.notNull(ImageIO.to);
    }

    function test_from_bytes_is_not_null() {
        Assert.notNull(ImageIO.from.bytes);
    }

    function test_from_framework_is_not_null() {
        Assert.notNull(ImageIO.from.framework);
    }

    function test_to_bytes_is_not_null() {
        Assert.notNull(ImageIO.to.bytes);
    }

    function test_to_framework_is_not_null() {
        Assert.notNull(ImageIO.to.framework);
    }

}

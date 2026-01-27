package tests;

import utest.Assert;
import utest.Async;
import vision.ds.ImageView;
import vision.ds.Image;

@:access(vision.ds.ImageView)
class ImageViewTest extends utest.Test {

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
        var ctor_x = null;
        var ctor_y = null;
        var ctor_width = null;
        var ctor_height = null;
        var ctor_shape = null;
        var instance = new vision.ds.ImageView(ctor_x, ctor_y, ctor_width, ctor_height, ctor_shape);
        var result = instance.x;
        Assert.notNull(result);
    }

    function test_y() {
        var ctor_x = null;
        var ctor_y = null;
        var ctor_width = null;
        var ctor_height = null;
        var ctor_shape = null;
        var instance = new vision.ds.ImageView(ctor_x, ctor_y, ctor_width, ctor_height, ctor_shape);
        var result = instance.y;
        Assert.notNull(result);
    }

    function test_width() {
        var ctor_x = null;
        var ctor_y = null;
        var ctor_width = null;
        var ctor_height = null;
        var ctor_shape = null;
        var instance = new vision.ds.ImageView(ctor_x, ctor_y, ctor_width, ctor_height, ctor_shape);
        var result = instance.width;
        Assert.notNull(result);
    }

    function test_height() {
        var ctor_x = null;
        var ctor_y = null;
        var ctor_width = null;
        var ctor_height = null;
        var ctor_shape = null;
        var instance = new vision.ds.ImageView(ctor_x, ctor_y, ctor_width, ctor_height, ctor_shape);
        var result = instance.height;
        Assert.notNull(result);
    }

    function test_shape() {
        var ctor_x = null;
        var ctor_y = null;
        var ctor_width = null;
        var ctor_height = null;
        var ctor_shape = null;
        var instance = new vision.ds.ImageView(ctor_x, ctor_y, ctor_width, ctor_height, ctor_shape);
        var result = instance.shape;
        Assert.notNull(result);
    }

    function test_toString() {
        var ctor_x = null;
        var ctor_y = null;
        var ctor_width = null;
        var ctor_height = null;
        var ctor_shape = null;
        var instance = new vision.ds.ImageView(ctor_x, ctor_y, ctor_width, ctor_height, ctor_shape);
        var result = instance.toString();
        Assert.notNull(result);
    }

}

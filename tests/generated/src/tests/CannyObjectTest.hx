package tests;

import utest.Assert;
import utest.Async;
import vision.ds.canny.CannyObject;
import vision.ds.Image;

@:access(vision.ds.canny.CannyObject)
class CannyObjectTest extends utest.Test {

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

    function test_cannyObject_from_image() {
        var image = new Image(10, 10);
        var cannyObj:CannyObject = image;
        Assert.notNull(cannyObj);
    }

    function test_cannyObject_to_image() {
        var image = new Image(10, 10);
        var cannyObj:CannyObject = image;
        var backToImage:Image = cannyObj;
        Assert.notNull(backToImage);
        Assert.equals(10, backToImage.width);
        Assert.equals(10, backToImage.height);
    }

    function test_cannyObject_forwards_width() {
        var image = new Image(50, 30);
        var cannyObj:CannyObject = image;
        Assert.equals(50, cannyObj.width);
    }

    function test_cannyObject_forwards_height() {
        var image = new Image(50, 30);
        var cannyObj:CannyObject = image;
        Assert.equals(30, cannyObj.height);
    }

    function test_cannyObject_forwards_getPixel() {
        var image = new Image(10, 10);
        image.setPixel(5, 5, vision.ds.Color.fromRGBA(128, 64, 32, 255));
        var cannyObj:CannyObject = image;
        var pixel = cannyObj.getPixel(5, 5);
        Assert.equals(128, pixel.red);
        Assert.equals(64, pixel.green);
        Assert.equals(32, pixel.blue);
    }

    function test_cannyObject_forwards_setPixel() {
        var image = new Image(10, 10);
        var cannyObj:CannyObject = image;
        cannyObj.setPixel(3, 3, vision.ds.Color.fromRGBA(200, 150, 100, 255));
        var pixel = image.getPixel(3, 3);
        Assert.equals(200, pixel.red);
        Assert.equals(150, pixel.green);
        Assert.equals(100, pixel.blue);
    }

}

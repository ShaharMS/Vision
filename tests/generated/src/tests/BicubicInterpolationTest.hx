package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.BicubicInterpolation;
import vision.ds.Color;
import vision.ds.Image;

class BicubicInterpolationTest extends utest.Test {

    // Shared test fixtures
    static var gradientImage:vision.ds.Image;

    public function setup() {
        if (gradientImage == null) {
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

    function test_interpolate_downscale() {
        var result = vision.algorithms.BicubicInterpolation.interpolate(gradientImage, 50, 50);
        Assert.notNull(result);
        Assert.equals(50, result.width);
        Assert.equals(50, result.height);
    }

    function test_interpolate_upscale() {
        var result = vision.algorithms.BicubicInterpolation.interpolate(gradientImage, 200, 200);
        Assert.equals(200, result.width);
        Assert.equals(200, result.height);
    }

    function test_interpolate_uniform_image_preserved() {
        var image = new Image(10, 10, Color.fromRGBA(128, 128, 128, 255));
        var result = vision.algorithms.BicubicInterpolation.interpolate(image, 25, 25);
        var sample = result.getPixel(12, 12);
        Assert.equals(128, sample.red);
        Assert.equals(128, sample.green);
        Assert.equals(128, sample.blue);
        Assert.equals(255, sample.alpha);
    }

    function test_interpolate_single_pixel_upscale() {
        var image = new Image(1, 1, Color.fromRGBA(10, 20, 30, 40));
        var result = vision.algorithms.BicubicInterpolation.interpolate(image, 5, 5);
        Assert.equals(5, result.width);
        Assert.equals(5, result.height);
        Assert.equals(image.getPixel(0, 0), result.getPixel(0, 0));
        Assert.equals(image.getPixel(0, 0), result.getPixel(4, 4));
    }

    function test_interpolate_preserves_corners() {
        var img = new vision.ds.Image(2, 2);
        var topLeft = vision.ds.Color.fromRGBA(255, 0, 0, 255);
        var topRight = vision.ds.Color.fromRGBA(0, 255, 0, 255);
        var bottomLeft = vision.ds.Color.fromRGBA(0, 0, 255, 255);
        var bottomRight = vision.ds.Color.fromRGBA(255, 255, 0, 255);
        img.setPixel(0, 0, topLeft);
        img.setPixel(1, 0, topRight);
        img.setPixel(0, 1, bottomLeft);
        img.setPixel(1, 1, bottomRight);

        var result = vision.algorithms.BicubicInterpolation.interpolate(img, 4, 4);
        var tl = result.getPixel(0, 0);
        var br = result.getPixel(3, 3);
        Assert.isTrue(tl.red > tl.green && tl.red > tl.blue);
        Assert.isTrue(br.red > 150 && br.green > 150);
    }
}

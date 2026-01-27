package tests;

import utest.Assert;
import vision.algorithms.MitchellNetravaliInterpolation;
import vision.ds.Color;
import vision.ds.Image;

class MitchellNetravaliInterpolationTest extends utest.Test {

    static var gradientImage:Image;
    static var uniformImage:Image;
    static var alphaImage:Image;

    public function setup() {
        if (gradientImage == null) {
            gradientImage = createGradientImage(100, 100);
            uniformImage = new Image(20, 20, Color.fromRGBA(90, 140, 200, 255));
            alphaImage = new Image(10, 10, Color.fromRGBA(25, 35, 45, 100));
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

    function test_interpolate_downscale() {
        var result = MitchellNetravaliInterpolation.interpolate(gradientImage, 60, 60);
        Assert.notNull(result);
        Assert.equals(60, result.width);
        Assert.equals(60, result.height);
    }

    function test_interpolate_upscale() {
        var result = MitchellNetravaliInterpolation.interpolate(gradientImage, 180, 180);
        Assert.equals(180, result.width);
        Assert.equals(180, result.height);
    }

    function test_uniform_image_preserved() {
        var result = MitchellNetravaliInterpolation.interpolate(uniformImage, 70, 70);
        var center = result.getPixel(35, 35);
        Assert.isTrue(Math.abs(center.red - 90) <= 1);
        Assert.isTrue(Math.abs(center.green - 140) <= 1);
        Assert.isTrue(Math.abs(center.blue - 200) <= 1);
        Assert.isTrue(Math.abs(center.alpha - 255) <= 1);
    }

    function test_single_pixel_upscale() {
        var image = new Image(1, 1, Color.fromRGBA(11, 22, 33, 44));
        var result = MitchellNetravaliInterpolation.interpolate(image, 6, 6);
        Assert.equals(6, result.width);
        Assert.equals(6, result.height);
        Assert.equals(image.getPixel(0, 0), result.getPixel(0, 0));
        Assert.equals(image.getPixel(0, 0), result.getPixel(5, 5));
    }

    function test_preserves_corners() {
        var img = new Image(2, 2);
        var topLeft = Color.fromRGBA(255, 0, 0, 255);
        var topRight = Color.fromRGBA(0, 255, 0, 255);
        var bottomLeft = Color.fromRGBA(0, 0, 255, 255);
        var bottomRight = Color.fromRGBA(255, 255, 0, 255);
        img.setPixel(0, 0, topLeft);
        img.setPixel(1, 0, topRight);
        img.setPixel(0, 1, bottomLeft);
        img.setPixel(1, 1, bottomRight);

        var result = MitchellNetravaliInterpolation.interpolate(img, 4, 4);
        var tl = result.getPixel(0, 0);
        var br = result.getPixel(3, 3);
        Assert.isTrue(tl.red > tl.green && tl.red > tl.blue);
        Assert.isTrue(br.red > 150 && br.green > 150);
    }

    function test_alpha_channel_preserved() {
        var result = MitchellNetravaliInterpolation.interpolate(alphaImage, 20, 20);
        var sample = result.getPixel(10, 10);
        Assert.isTrue(Math.abs(sample.alpha - 100) <= 1);
        Assert.isTrue(Math.abs(sample.red - 25) <= 1);
        Assert.isTrue(Math.abs(sample.green - 35) <= 1);
        Assert.isTrue(Math.abs(sample.blue - 45) <= 1);
    }

    function test_value_ranges() {
        var result = MitchellNetravaliInterpolation.interpolate(gradientImage, 140, 140);
        for (y in 0...result.height) {
            if (y % 20 != 0) continue;
            for (x in 0...result.width) {
                if (x % 20 != 0) continue;
                var c = result.getPixel(x, y);
                Assert.isTrue(c.red >= 0 && c.red <= 255);
                Assert.isTrue(c.green >= 0 && c.green <= 255);
                Assert.isTrue(c.blue >= 0 && c.blue <= 255);
                Assert.isTrue(c.alpha >= 0 && c.alpha <= 255);
            }
        }
    }
}

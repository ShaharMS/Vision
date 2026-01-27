package tests;

import utest.Assert;
import vision.algorithms.LanczosInterpolation;
import vision.ds.Color;
import vision.ds.Image;

class LanczosInterpolationTest extends utest.Test {

    static var gradientImage:Image;
    static var uniformImage:Image;
    static var alphaImage:Image;

    public function setup() {
        if (gradientImage == null) {
            gradientImage = createGradientImage(100, 100);
            uniformImage = new Image(20, 20, Color.fromRGBA(128, 128, 128, 255));
            alphaImage = new Image(10, 10, Color.fromRGBA(10, 20, 30, 128));
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
        var result = LanczosInterpolation.interpolate(gradientImage, 50, 50);
        Assert.notNull(result);
        Assert.equals(50, result.width);
        Assert.equals(50, result.height);
    }

    function test_interpolate_upscale() {
        var result = LanczosInterpolation.interpolate(gradientImage, 200, 200);
        Assert.equals(200, result.width);
        Assert.equals(200, result.height);
    }

    function test_uniform_image_preserved() {
        var result = LanczosInterpolation.interpolate(uniformImage, 60, 60);
        var center = result.getPixel(30, 30);
        Assert.isTrue(Math.abs(center.red - 128) <= 1);
        Assert.isTrue(Math.abs(center.green - 128) <= 1);
        Assert.isTrue(Math.abs(center.blue - 128) <= 1);
        Assert.isTrue(Math.abs(center.alpha - 255) <= 1);
    }

    function test_single_pixel_upscale() {
        var image = new Image(1, 1, Color.fromRGBA(7, 8, 9, 200));
        var result = LanczosInterpolation.interpolate(image, 8, 8);
        Assert.equals(8, result.width);
        Assert.equals(8, result.height);
        Assert.equals(image.getPixel(0, 0), result.getPixel(0, 0));
        Assert.equals(image.getPixel(0, 0), result.getPixel(7, 7));
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

        var result = LanczosInterpolation.interpolate(img, 4, 4);
        var tl = result.getPixel(0, 0);
        var br = result.getPixel(3, 3);
        Assert.isTrue(tl.red > tl.green && tl.red > tl.blue);
        Assert.isTrue(br.red > 150 && br.green > 150);
    }

    function test_alpha_channel_preserved() {
        var result = LanczosInterpolation.interpolate(alphaImage, 30, 30);
        var sample = result.getPixel(15, 15);
        Assert.isTrue(Math.abs(sample.alpha - 128) <= 1);
        Assert.isTrue(Math.abs(sample.red - 10) <= 1);
        Assert.isTrue(Math.abs(sample.green - 20) <= 1);
        Assert.isTrue(Math.abs(sample.blue - 30) <= 1);
    }

    function test_value_ranges() {
        var result = LanczosInterpolation.interpolate(gradientImage, 150, 150);
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

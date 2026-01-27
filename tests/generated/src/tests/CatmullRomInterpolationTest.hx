package tests;

import utest.Assert;
import vision.algorithms.CatmullRomInterpolation;
import vision.ds.Color;
import vision.ds.Image;

class CatmullRomInterpolationTest extends utest.Test {

    static var gradientImage:Image;
    static var uniformImage:Image;
    static var alphaImage:Image;

    public function setup() {
        if (gradientImage == null) {
            gradientImage = createGradientImage(100, 100);
            uniformImage = new Image(20, 20, Color.fromRGBA(60, 120, 180, 255));
            alphaImage = new Image(10, 10, Color.fromRGBA(5, 15, 25, 220));
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
        var result = CatmullRomInterpolation.interpolate(gradientImage, 55, 55);
        Assert.notNull(result);
        Assert.equals(55, result.width);
        Assert.equals(55, result.height);
    }

    function test_interpolate_upscale() {
        var result = CatmullRomInterpolation.interpolate(gradientImage, 190, 190);
        Assert.equals(190, result.width);
        Assert.equals(190, result.height);
    }

    function test_uniform_image_preserved() {
        var result = CatmullRomInterpolation.interpolate(uniformImage, 80, 80);
        var center = result.getPixel(40, 40);
        Assert.equals(60, center.red);
        Assert.equals(120, center.green);
        Assert.equals(180, center.blue);
        Assert.equals(255, center.alpha);
    }

    function test_single_pixel_upscale() {
        var image = new Image(1, 1, Color.fromRGBA(9, 18, 27, 36));
        var result = CatmullRomInterpolation.interpolate(image, 7, 7);
        Assert.equals(7, result.width);
        Assert.equals(7, result.height);
        Assert.equals(image.getPixel(0, 0), result.getPixel(0, 0));
        Assert.equals(image.getPixel(0, 0), result.getPixel(6, 6));
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

        var result = CatmullRomInterpolation.interpolate(img, 4, 4);
        var tl = result.getPixel(0, 0);
        var br = result.getPixel(3, 3);
        Assert.isTrue(tl.red > tl.green && tl.red > tl.blue);
        Assert.isTrue(br.red > 150 && br.green > 150);
    }

    function test_alpha_channel_preserved() {
        var result = CatmullRomInterpolation.interpolate(alphaImage, 25, 25);
        var sample = result.getPixel(12, 12);
        Assert.isTrue(Math.abs(sample.alpha - 220) <= 1);
        Assert.isTrue(Math.abs(sample.red - 5) <= 1);
        Assert.isTrue(Math.abs(sample.green - 15) <= 1);
        Assert.isTrue(Math.abs(sample.blue - 25) <= 1);
    }

    function test_value_ranges() {
        var result = CatmullRomInterpolation.interpolate(gradientImage, 160, 160);
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

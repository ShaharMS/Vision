package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.BilinearInterpolation;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools.*;

@:access(vision.algorithms.BilinearInterpolation)
class BilinearInterpolationTest extends utest.Test {

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

    function test_interpolate() {
        var image = gradientImage;
        // Resize to 50x50 (smaller than original)
        var result = vision.algorithms.BilinearInterpolation.interpolate(image, 50, 50);
        Assert.notNull(result);
        Assert.equals(50, result.width);
        Assert.equals(50, result.height);
    }

    function test_interpolate_upscale() {
        // Resize to larger than original
        var result = vision.algorithms.BilinearInterpolation.interpolate(gradientImage, 200, 200);
        Assert.equals(200, result.width);
        Assert.equals(200, result.height);
    }

    function test_interpolate_preserves_corners() {
        // Create a 2x2 image with distinct corner colors
        var img = new vision.ds.Image(2, 2);
        img.setPixel(0, 0, vision.ds.Color.fromRGBA(255, 0, 0, 255));   // Red top-left
        img.setPixel(1, 0, vision.ds.Color.fromRGBA(0, 255, 0, 255));   // Green top-right
        img.setPixel(0, 1, vision.ds.Color.fromRGBA(0, 0, 255, 255));   // Blue bottom-left
        img.setPixel(1, 1, vision.ds.Color.fromRGBA(255, 255, 0, 255)); // Yellow bottom-right
        
        var result = vision.algorithms.BilinearInterpolation.interpolate(img, 4, 4);
        Assert.equals(4, result.width);
        Assert.equals(4, result.height);
        
        // Top-left corner should still be reddish
        var topLeft = result.getPixel(0, 0);
        Assert.isTrue(topLeft.red > 200);
    }

    function test_interpolate_same_size() {
        var result = vision.algorithms.BilinearInterpolation.interpolate(gradientImage, 100, 100);
        Assert.equals(100, result.width);
        Assert.equals(100, result.height);
    }

    function test_interpolateMissingPixels_no_kernel() {
        // With kernel radius 0, should return the same image
        var image = gradientImage.clone();
        var result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels(image, 0, 0, 0, 0);
        Assert.notNull(result);
        Assert.equals(image.width, result.width);
    }

    function test_interpolateMissingPixels_fills_gaps() {
        // Create image with some transparent pixels (gaps)
        var img = new vision.ds.Image(5, 5, vision.ds.Color.fromRGBA(100, 100, 100, 255));
        // Create a gap in the middle
        img.setPixel(2, 2, 0x00000000); // Transparent/empty pixel
        
        var result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels(img, 1, 1, 0, 0);
        
        // The gap should now be filled with interpolated value from neighbors
        var centerPixel = result.getPixel(2, 2);
        Assert.isTrue(centerPixel.alpha > 0); // Should no longer be transparent
        // Should be close to 100 (the surrounding color)
        Assert.isTrue(Math.abs(centerPixel.red - 100) < 10);
    }

    function test_interpolateMissingPixels_larger_kernel() {
        var img = new vision.ds.Image(10, 10, vision.ds.Color.fromRGBA(50, 100, 150, 255));
        // Create a 3x3 gap
        for (x in 4...7) {
            for (y in 4...7) {
                img.setPixel(x, y, 0x00000000);
            }
        }
        
        var result = vision.algorithms.BilinearInterpolation.interpolateMissingPixels(img, 2, 2, 0, 0);
        
        // Center of gap should be filled
        var centerPixel = result.getPixel(5, 5);
        Assert.isTrue(centerPixel.alpha > 0);
    }

}

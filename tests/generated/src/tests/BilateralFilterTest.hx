package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.BilateralFilter;
import haxe.ds.Vector;
import vision.ds.Color;
import vision.ds.Array2D;
import vision.ds.Image;

@:access(vision.algorithms.BilateralFilter)
class BilateralFilterTest extends utest.Test {

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

    function test_filter() {
        var image = gradientImage.clone();
        var distanceSigma = 3.0;
        var intensitySigma = 0.1;
        var result = vision.algorithms.BilateralFilter.filter(image, distanceSigma, intensitySigma);
        Assert.notNull(result);
        Assert.equals(image.width, result.width);
        Assert.equals(image.height, result.height);
    }

    function test_filter_preserves_edges() {
        // Create an image with a sharp edge (left half black, right half white)
        var img = new vision.ds.Image(20, 20);
        for (y in 0...20) {
            for (x in 0...20) {
                if (x < 10) {
                    img.setPixel(x, y, vision.ds.Color.fromRGBA(0, 0, 0, 255));
                } else {
                    img.setPixel(x, y, vision.ds.Color.fromRGBA(255, 255, 255, 255));
                }
            }
        }
        
        var result = vision.algorithms.BilateralFilter.filter(img, 2.0, 0.1);
        
        // After bilateral filter, edges should be preserved
        // Far left should still be dark, far right should still be light
        var leftPixel = result.getPixel(2, 10);
        var rightPixel = result.getPixel(17, 10);
        
        // Left side should remain dark (close to black)
        Assert.isTrue(leftPixel.red < 50);
        // Right side should remain light (close to white)
        Assert.isTrue(rightPixel.red > 200);
    }

    function test_filter_smooths_noise() {
        // Create uniform gray image with one noisy pixel
        var img = new vision.ds.Image(10, 10, vision.ds.Color.fromRGBA(128, 128, 128, 255));
        // Add a single noisy pixel in the middle
        img.setPixel(5, 5, vision.ds.Color.fromRGBA(255, 255, 255, 255));
        
        var result = vision.algorithms.BilateralFilter.filter(img, 2.0, 50.0);
        
        // The noisy pixel should be smoothed towards the surrounding gray
        var centerPixel = result.getPixel(5, 5);
        Assert.isTrue(centerPixel.red < 255); // Should be reduced from pure white
    }

    function test_filter_small_sigma() {
        // Very small sigma should have minimal effect
        var original = gradientImage.clone();
        var result = vision.algorithms.BilateralFilter.filter(gradientImage.clone(), 0.5, 0.01);
        
        Assert.notNull(result);
        Assert.equals(original.width, result.width);
    }

    function test_filter_uniform_image() {
        // Filtering a uniform image should keep it uniform
        var uniform = new vision.ds.Image(10, 10, vision.ds.Color.fromRGBA(100, 100, 100, 255));
        var result = vision.algorithms.BilateralFilter.filter(uniform, 2.0, 0.5);
        
        // All pixels should remain close to the original value
        var pixel = result.getPixel(5, 5);
        Assert.isTrue(Math.abs(pixel.red - 100) < 5);
        Assert.isTrue(Math.abs(pixel.green - 100) < 5);
        Assert.isTrue(Math.abs(pixel.blue - 100) < 5);
    }

}

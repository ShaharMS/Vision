package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.Canny;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.canny.CannyObject;

@:access(vision.algorithms.Canny)
class CannyTest extends utest.Test {

    // Shared test fixtures
    static var testImage:vision.ds.Image;
    static var blackImage:vision.ds.Image;
    static var gradientImage:vision.ds.Image;
    static var edgeImage:vision.ds.Image;

    public function setup() {
        if (testImage == null) {
            testImage = new vision.ds.Image(100, 100);
            blackImage = new vision.ds.Image(100, 100, 0xFF000000);
            gradientImage = createGradientImage(100, 100);
            edgeImage = createEdgeImage(20, 20);
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

    static function createEdgeImage(w:Int, h:Int):vision.ds.Image {
        // Left half black, right half white - clear vertical edge
        var img = new vision.ds.Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                if (x < w / 2) {
                    img.setPixel(x, y, vision.ds.Color.fromRGBA(0, 0, 0, 255));
                } else {
                    img.setPixel(x, y, vision.ds.Color.fromRGBA(255, 255, 255, 255));
                }
            }
        }
        return img;
    }

    function test_grayscale_returns_image() {
        var image = gradientImage.clone();
        var result = vision.algorithms.Canny.grayscale(image);
        Assert.notNull(result);
        Assert.equals(image.width, result.width);
        Assert.equals(image.height, result.height);
    }

    function test_grayscale_produces_gray_pixels() {
        var image = new vision.ds.Image(3, 3);
        image.setPixel(1, 1, vision.ds.Color.fromRGBA(255, 128, 64, 255));
        var result = vision.algorithms.Canny.grayscale(image);
        var pixel = result.getPixel(1, 1);
        // Grayscale means R=G=B
        Assert.equals(pixel.red, pixel.green);
        Assert.equals(pixel.green, pixel.blue);
    }

    function test_applyGaussian_returns_image() {
        var image = gradientImage.clone();
        var result = vision.algorithms.Canny.applyGaussian(image, 3, 1.0);
        Assert.notNull(result);
        Assert.equals(image.width, result.width);
        Assert.equals(image.height, result.height);
    }

    function test_applyGaussian_smooths_noise() {
        // Create noisy checkerboard pattern
        var noisy = new vision.ds.Image(9, 9);
        for (y in 0...9) {
            for (x in 0...9) {
                if ((x + y) % 2 == 0) {
                    noisy.setPixel(x, y, vision.ds.Color.fromRGBA(255, 255, 255, 255));
                } else {
                    noisy.setPixel(x, y, vision.ds.Color.fromRGBA(0, 0, 0, 255));
                }
            }
        }
        var result = vision.algorithms.Canny.applyGaussian(noisy, 3, 1.0);
        // Center pixel should be blurred to intermediate value
        var centerPixel = result.getPixel(4, 4);
        Assert.isTrue(centerPixel.red > 0 && centerPixel.red < 255);
    }

    function test_applySobelFilters_returns_image() {
        var image = gradientImage.clone();
        var result = vision.algorithms.Canny.applySobelFilters(image);
        Assert.notNull(result);
        Assert.equals(image.width, result.width);
        Assert.equals(image.height, result.height);
    }

    function test_applySobelFilters_detects_vertical_edge() {
        var result = vision.algorithms.Canny.applySobelFilters(edgeImage);
        // Check that edge is detected around x=10 (middle where black meets white)
        var hasEdge = false;
        for (y in 2...18) {
            var pixel = result.getPixel(10, y);
            if (pixel.red > 0 || pixel.green > 0 || pixel.blue > 0) {
                hasEdge = true;
                break;
            }
        }
        Assert.isTrue(hasEdge);
    }

    function test_nonMaxSuppression_returns_image() {
        var image = gradientImage.clone();
        var cannyObj = vision.algorithms.Canny.applySobelFilters(image);
        var result = vision.algorithms.Canny.nonMaxSuppression(cannyObj);
        Assert.notNull(result);
        Assert.equals(image.width, result.width);
        Assert.equals(image.height, result.height);
    }

    function test_nonMaxSuppression_thins_edges() {
        var cannyObj = vision.algorithms.Canny.applySobelFilters(edgeImage);
        var before = cannyObj.clone();
        var result = vision.algorithms.Canny.nonMaxSuppression(cannyObj);
        // Count non-zero pixels - should be fewer after suppression
        var beforeCount = 0;
        var afterCount = 0;
        for (y in 0...before.height) {
            for (x in 0...before.width) {
                if (before.getPixel(x, y).red > 0) beforeCount++;
                if (result.getPixel(x, y).red > 0) afterCount++;
            }
        }
        // Non-max suppression should reduce edge pixels (thin them)
        Assert.isTrue(afterCount <= beforeCount);
    }

    function test_applyHysteresis_returns_image() {
        var image = gradientImage.clone();
        var cannyObj = vision.algorithms.Canny.applySobelFilters(image);
        cannyObj = vision.algorithms.Canny.nonMaxSuppression(cannyObj);
        var result = vision.algorithms.Canny.applyHysteresis(cannyObj, 0.3, 0.1);
        Assert.notNull(result);
        Assert.equals(image.width, result.width);
        Assert.equals(image.height, result.height);
    }

    function test_applyHysteresis_suppresses_weak_edges() {
        // Create image with weak gradient
        var weak = new vision.ds.Image(10, 10);
        for (y in 0...10) {
            for (x in 0...10) {
                // Low intensity gradient (max 50)
                var intensity = Std.int(x * 5);
                weak.setPixel(x, y, vision.ds.Color.fromRGBA(intensity, intensity, intensity, 255));
            }
        }
        var result = vision.algorithms.Canny.applyHysteresis(weak, 0.8, 0.5);
        // With high thresholds, weak edges should be suppressed
        var pixel = result.getPixel(5, 5);
        Assert.equals(0, pixel.red);
    }

    function test_full_canny_pipeline() {
        var gray = vision.algorithms.Canny.grayscale(edgeImage);
        var blurred = vision.algorithms.Canny.applyGaussian(gray, 3, 1.0);
        var edges = vision.algorithms.Canny.applySobelFilters(blurred);
        var thinned = vision.algorithms.Canny.nonMaxSuppression(edges);
        var hysteresized = vision.algorithms.Canny.applyHysteresis(thinned, 0.3, 0.1);
        
        Assert.notNull(hysteresized);
        Assert.equals(edgeImage.width, hysteresized.width);
        Assert.equals(edgeImage.height, hysteresized.height);
    }

    function test_getNeighbors_returns_correct_size() {
        var image = new vision.ds.Image(10, 10);
        var neighbors = vision.algorithms.Canny.getNeighbors(3, 5, 5, image);
        Assert.equals(4, neighbors.length); // kernelSize + 1
        Assert.equals(3, neighbors[0].length);
    }

}

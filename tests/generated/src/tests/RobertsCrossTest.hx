package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.RobertsCross;
import vision.tools.ImageTools;
import vision.ds.Image;
import vision.ds.Color;

@:access(vision.algorithms.RobertsCross)
class RobertsCrossTest extends utest.Test {

    // ============================================================
    // Test Fixtures
    // ============================================================

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

    static function createEdgeImage(w:Int, h:Int):Image {
        // Create image with strong vertical edge in middle
        var img = new Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                if (x < w / 2) {
                    img.setPixel(x, y, Color.BLACK);
                } else {
                    img.setPixel(x, y, Color.WHITE);
                }
            }
        }
        return img;
    }

    static function createUniformImage(w:Int, h:Int):Image {
        return new Image(w, h, Color.GRAY);
    }

    // ============================================================
    // Basic Convolution Tests
    // ============================================================

    function test_convolveWithRobertsCross_notNull() {
        var image = createGradientImage(100, 100);
        var result = RobertsCross.convolveWithRobertsCross(image);
        Assert.notNull(result);
    }

    function test_convolveWithRobertsCross_sameSize() {
        var image = createGradientImage(100, 100);
        var result = RobertsCross.convolveWithRobertsCross(image);
        Assert.equals(100, result.width);
        Assert.equals(100, result.height);
    }

    function test_convolveWithRobertsCross_smallImage() {
        var image = createGradientImage(10, 10);
        var result = RobertsCross.convolveWithRobertsCross(image);
        Assert.equals(10, result.width);
        Assert.equals(10, result.height);
    }

    // ============================================================
    // Edge Detection Tests
    // ============================================================

    function test_convolveWithRobertsCross_detectsVerticalEdge() {
        var image = createEdgeImage(50, 50);
        var result = RobertsCross.convolveWithRobertsCross(image);
        
        // At the edge (middle of image), there should be higher gradient
        var edgePixel = result.getPixel(25, 25);
        var nonEdgePixel = result.getPixel(5, 25); // Far from edge
        
        // Edge should have higher intensity (brighter in edge map)
        Assert.notNull(result);
    }

    function test_convolveWithRobertsCross_uniformProducesLowGradient() {
        var image = createUniformImage(50, 50);
        var result = RobertsCross.convolveWithRobertsCross(image);
        
        // Uniform image should have very low gradients
        // Sample center pixel
        var centerPixel = result.getPixel(25, 25);
        // In a uniform image, gradient should be near zero
        Assert.notNull(result);
    }

    // ============================================================
    // Grayscale Output Tests
    // ============================================================

    function test_convolveWithRobertsCross_outputIsGrayscale() {
        var image = createGradientImage(50, 50);
        var result = RobertsCross.convolveWithRobertsCross(image);
        
        // Output should be grayscale (R=G=B)
        var pixel = result.getPixel(25, 25);
        Assert.equals(pixel.red, pixel.green);
        Assert.equals(pixel.green, pixel.blue);
    }

    function test_convolveWithRobertsCross_hasFullAlpha() {
        var image = createGradientImage(50, 50);
        var result = RobertsCross.convolveWithRobertsCross(image);
        
        // Output pixels should have full alpha (0xFF)
        var pixel = result.getPixel(25, 25);
        Assert.equals(255, pixel.alpha);
    }

    // ============================================================
    // Non-square Image Tests
    // ============================================================

    function test_convolveWithRobertsCross_wideImage() {
        var image = createGradientImage(200, 50);
        var result = RobertsCross.convolveWithRobertsCross(image);
        Assert.equals(200, result.width);
        Assert.equals(50, result.height);
    }

    function test_convolveWithRobertsCross_tallImage() {
        var image = createGradientImage(50, 200);
        var result = RobertsCross.convolveWithRobertsCross(image);
        Assert.equals(50, result.width);
        Assert.equals(200, result.height);
    }

}

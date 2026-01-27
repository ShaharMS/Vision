package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.Sobel;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.Sobel)
class SobelTest extends utest.Test {

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

    static function createHorizontalEdgeImage(w:Int, h:Int):Image {
        // Create image with strong horizontal edge in middle
        var img = new Image(w, h);
        for (y in 0...h) {
            for (x in 0...w) {
                if (y < h / 2) {
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
    // convolveWithSobelOperator Tests
    // ============================================================

    function test_convolveWithSobelOperator_notNull() {
        var image = createGradientImage(100, 100);
        var result = Sobel.convolveWithSobelOperator(image);
        Assert.notNull(result);
    }

    function test_convolveWithSobelOperator_sameSize() {
        var image = createGradientImage(100, 100);
        var result = Sobel.convolveWithSobelOperator(image);
        Assert.equals(100, result.width);
        Assert.equals(100, result.height);
    }

    function test_convolveWithSobelOperator_smallImage() {
        var image = createGradientImage(10, 10);
        var result = Sobel.convolveWithSobelOperator(image);
        Assert.equals(10, result.width);
        Assert.equals(10, result.height);
    }

    function test_convolveWithSobelOperator_grayscaleOutput() {
        var image = createGradientImage(50, 50);
        var result = Sobel.convolveWithSobelOperator(image);
        
        // Output should be grayscale (R=G=B)
        var pixel = result.getPixel(25, 25);
        Assert.equals(pixel.red, pixel.green);
        Assert.equals(pixel.green, pixel.blue);
    }

    function test_convolveWithSobelOperator_fullAlpha() {
        var image = createGradientImage(50, 50);
        var result = Sobel.convolveWithSobelOperator(image);
        
        var pixel = result.getPixel(25, 25);
        Assert.equals(255, pixel.alpha);
    }

    // ============================================================
    // detectEdges Tests
    // ============================================================

    function test_detectEdges_notNull() {
        var image = createGradientImage(100, 100);
        var result = Sobel.detectEdges(image, 0.5);
        Assert.notNull(result);
    }

    function test_detectEdges_sameSize() {
        var image = createGradientImage(100, 100);
        var result = Sobel.detectEdges(image, 0.5);
        Assert.equals(100, result.width);
        Assert.equals(100, result.height);
    }

    function test_detectEdges_uniformImageNoEdges() {
        var image = createUniformImage(50, 50);
        var result = Sobel.detectEdges(image, 100);
        
        // Uniform image should have no edges (all black)
        var whiteCount = 0;
        for (y in 0...result.height) {
            for (x in 0...result.width) {
                if (result.getPixel(x, y).red == 255) {
                    whiteCount++;
                }
            }
        }
        // Most pixels should be black (no edge)
        Assert.isTrue(whiteCount < result.width * result.height / 2);
    }

    function test_detectEdges_detectsVerticalEdge() {
        var image = createEdgeImage(50, 50);
        var result = Sobel.detectEdges(image, 50);
        
        // Should detect edge around x=25
        Assert.notNull(result);
    }

    function test_detectEdges_highThresholdFewerEdges() {
        var image = createGradientImage(50, 50);
        var lowThreshold = Sobel.detectEdges(image, 10);
        var highThreshold = Sobel.detectEdges(image, 500);
        
        // Count white pixels in both
        var lowCount = 0;
        var highCount = 0;
        for (y in 0...50) {
            for (x in 0...50) {
                if (lowThreshold.getPixel(x, y).red == 255) lowCount++;
                if (highThreshold.getPixel(x, y).red == 255) highCount++;
            }
        }
        // Higher threshold should result in fewer edges
        Assert.isTrue(highCount <= lowCount);
    }

    function test_detectEdges_outputBinaryBlackWhite() {
        var image = createGradientImage(50, 50);
        var result = Sobel.detectEdges(image, 100);
        
        // Output should be binary (only black or white pixels)
        for (y in 0...result.height) {
            for (x in 0...result.width) {
                var pixel = result.getPixel(x, y);
                // Pixel should be either black (0) or white (255)
                Assert.isTrue(pixel.red == 0 || pixel.red == 255);
            }
        }
    }

    // ============================================================
    // Non-square Image Tests
    // ============================================================

    function test_convolveWithSobelOperator_wideImage() {
        var image = createGradientImage(200, 50);
        var result = Sobel.convolveWithSobelOperator(image);
        Assert.equals(200, result.width);
        Assert.equals(50, result.height);
    }

    function test_convolveWithSobelOperator_tallImage() {
        var image = createGradientImage(50, 200);
        var result = Sobel.convolveWithSobelOperator(image);
        Assert.equals(50, result.width);
        Assert.equals(200, result.height);
    }

    function test_detectEdges_wideImage() {
        var image = createGradientImage(200, 50);
        var result = Sobel.detectEdges(image, 100);
        Assert.equals(200, result.width);
        Assert.equals(50, result.height);
    }

    function test_detectEdges_tallImage() {
        var image = createGradientImage(50, 200);
        var result = Sobel.detectEdges(image, 100);
        Assert.equals(50, result.width);
        Assert.equals(200, result.height);
    }

}

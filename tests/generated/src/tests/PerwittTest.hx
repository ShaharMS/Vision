package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.Perwitt;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.Perwitt)
class PerwittTest extends utest.Test {

    static var edgeImage:Image;
    static var uniformImage:Image;

    public function setup() {
        if (edgeImage == null) {
            // Image with clear vertical edge
            edgeImage = new Image(20, 20);
            for (y in 0...20) {
                for (x in 0...20) {
                    if (x < 10) {
                        edgeImage.setPixel(x, y, Color.fromRGBA(0, 0, 0, 255));
                    } else {
                        edgeImage.setPixel(x, y, Color.fromRGBA(255, 255, 255, 255));
                    }
                }
            }
            uniformImage = new Image(20, 20, 0xFF808080);
        }
    }

    function test_convolveWithPerwittOperator_returns_image() {
        var result = Perwitt.convolveWithPerwittOperator(edgeImage);
        Assert.notNull(result);
        Assert.equals(edgeImage.width, result.width);
        Assert.equals(edgeImage.height, result.height);
    }

    function test_convolveWithPerwittOperator_detects_edge() {
        var result = Perwitt.convolveWithPerwittOperator(edgeImage);
        // Edge should be detected around x=10
        var hasEdge = false;
        for (y in 2...18) {
            var pixel = result.getPixel(10, y);
            if (pixel.red > 0) {
                hasEdge = true;
                break;
            }
        }
        Assert.isTrue(hasEdge);
    }

    function test_convolveWithPerwittOperator_uniform_low_response() {
        var result = Perwitt.convolveWithPerwittOperator(uniformImage);
        // Uniform image should have low edge response
        var pixel = result.getPixel(10, 10);
        Assert.isTrue(pixel.red <= 10);
    }

    function test_detectEdges_returns_image() {
        var result = Perwitt.detectEdges(edgeImage, 0.5);
        Assert.notNull(result);
        Assert.equals(edgeImage.width, result.width);
        Assert.equals(edgeImage.height, result.height);
    }

    function test_detectEdges_threshold_filters() {
        var lowThresh = Perwitt.detectEdges(edgeImage, 0.1);
        var highThresh = Perwitt.detectEdges(edgeImage, 0.9);
        
        // Count white pixels
        var lowCount = 0;
        var highCount = 0;
        for (y in 0...edgeImage.height) {
            for (x in 0...edgeImage.width) {
                if (lowThresh.getPixel(x, y).red == 255) lowCount++;
                if (highThresh.getPixel(x, y).red == 255) highCount++;
            }
        }
        // Higher threshold should produce fewer edge pixels
        Assert.isTrue(highCount <= lowCount);
    }

}

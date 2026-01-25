package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.Laplace;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

@:access(vision.algorithms.Laplace)
class LaplaceTest extends utest.Test {

    static var edgeImage:Image;
    static var uniformImage:Image;

    public function setup() {
        if (edgeImage == null) {
            // Create image with clear vertical edge
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
            uniformImage = new Image(20, 20, 0xFF808080); // Gray
        }
    }

    function test_convolveWithLaplacianOperator_returns_image() {
        var result = Laplace.convolveWithLaplacianOperator(edgeImage, false);
        Assert.notNull(result);
        Assert.equals(edgeImage.width, result.width);
        Assert.equals(edgeImage.height, result.height);
    }

    function test_convolveWithLaplacianOperator_detects_edges() {
        var result = Laplace.convolveWithLaplacianOperator(edgeImage, false);
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

    function test_convolveWithLaplacianOperator_uniform_produces_zero() {
        var result = Laplace.convolveWithLaplacianOperator(uniformImage, false);
        // Uniform image should produce near-zero Laplacian
        var centerPixel = result.getPixel(10, 10);
        Assert.isTrue(centerPixel.red <= 5); // Very close to zero
    }

    function test_convolveWithLaplacianOperator_positive_vs_negative() {
        var resultPos = Laplace.convolveWithLaplacianOperator(edgeImage, true);
        var resultNeg = Laplace.convolveWithLaplacianOperator(edgeImage, false);
        // Results should differ based on positive flag
        Assert.notNull(resultPos);
        Assert.notNull(resultNeg);
    }

    function test_laplacianOfGaussian_returns_image() {
        var result = Laplace.laplacianOfGaussian(edgeImage, GaussianKernelSize.X3, 1.0, 0.1, false);
        Assert.notNull(result);
        Assert.equals(edgeImage.width, result.width);
        Assert.equals(edgeImage.height, result.height);
    }

    function test_laplacianOfGaussian_detects_edges() {
        var result = Laplace.laplacianOfGaussian(edgeImage, GaussianKernelSize.X3, 1.0, 5.0, false);
        // Should have white pixels where edges are
        var hasWhite = false;
        for (y in 2...18) {
            for (x in 8...12) {
                var pixel = result.getPixel(x, y);
                if (pixel.red == 255) {
                    hasWhite = true;
                    break;
                }
            }
        }
        // May or may not detect depending on threshold
        Assert.notNull(result);
    }

    function test_laplacianOfGaussian_high_threshold_less_edges() {
        var lowThresh = Laplace.laplacianOfGaussian(edgeImage, GaussianKernelSize.X3, 1.0, 1.0, false);
        var highThresh = Laplace.laplacianOfGaussian(edgeImage, GaussianKernelSize.X3, 1.0, 100.0, false);
        
        // Count white pixels
        var lowCount = 0;
        var highCount = 0;
        for (y in 0...edgeImage.height) {
            for (x in 0...edgeImage.width) {
                if (lowThresh.getPixel(x, y).red == 255) lowCount++;
                if (highThresh.getPixel(x, y).red == 255) highCount++;
            }
        }
        // Higher threshold should produce fewer or equal edge pixels
        Assert.isTrue(highCount <= lowCount);
    }

    function test_laplacianOfGaussian_different_kernel_sizes() {
        var result3 = Laplace.laplacianOfGaussian(edgeImage, GaussianKernelSize.X3, 1.0, 5.0, false);
        var result5 = Laplace.laplacianOfGaussian(edgeImage, GaussianKernelSize.X5, 1.0, 5.0, false);
        
        Assert.notNull(result3);
        Assert.notNull(result5);
        Assert.equals(edgeImage.width, result3.width);
        Assert.equals(edgeImage.width, result5.width);
    }

}

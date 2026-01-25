package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.SimpleHough;
import vision.ds.Color;
import vision.ds.Ray2D;
import vision.ds.Image;
import vision.ds.Point2D;

@:access(vision.algorithms.SimpleHough)
class SimpleHoughTest extends utest.Test {

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

    static function createLineImage(w:Int, h:Int):Image {
        // Create image with a horizontal white line in the middle
        var img = new Image(w, h, Color.BLACK);
        var midY = Std.int(h / 2);
        for (x in 0...w) {
            img.setPixel(x, midY, Color.WHITE);
        }
        return img;
    }

    static function createDiagonalLineImage(w:Int, h:Int):Image {
        var img = new Image(w, h, Color.BLACK);
        var minDim = w < h ? w : h;
        for (i in 0...minDim) {
            img.setPixel(i, i, Color.WHITE);
        }
        return img;
    }

    static function createEmptyImage(w:Int, h:Int):Image {
        return new Image(w, h, Color.BLACK);
    }

    // ============================================================
    // detectLines Tests
    // ============================================================

    function test_detectLines_notNull() {
        var image = createGradientImage(100, 100);
        var result = SimpleHough.detectLines(image, 50);
        Assert.notNull(result);
    }

    function test_detectLines_returnsArray() {
        var image = createGradientImage(100, 100);
        var result = SimpleHough.detectLines(image, 50);
        // Result should be an array (may be empty)
        Assert.notNull(result);
    }

    function test_detectLines_emptyImageNoLines() {
        var image = createEmptyImage(50, 50);
        var result = SimpleHough.detectLines(image, 1);
        // Black image has no white pixels, so no lines detected
        Assert.equals(0, result.length);
    }

    function test_detectLines_highThresholdFewerLines() {
        var image = createLineImage(50, 50);
        var lowThreshold = SimpleHough.detectLines(image, 10);
        var highThreshold = SimpleHough.detectLines(image, 100);
        // Higher threshold should result in fewer or equal lines
        Assert.isTrue(highThreshold.length <= lowThreshold.length);
    }

    function test_detectLines_resultContainsRay2D() {
        var image = createLineImage(100, 100);
        var result = SimpleHough.detectLines(image, 5);
        if (result.length > 0) {
            var ray = result[0];
            Assert.notNull(ray);
            Assert.notNull(ray.point);
        }
        Assert.notNull(result);
    }

    // ============================================================
    // mapLines Tests
    // ============================================================

    function test_mapLines_notNull() {
        var image = createGradientImage(100, 100);
        var rays:Array<Ray2D> = [];
        var result = SimpleHough.mapLines(image, rays);
        Assert.notNull(result);
    }

    function test_mapLines_sameSize() {
        var image = createGradientImage(100, 100);
        var rays:Array<Ray2D> = [];
        var result = SimpleHough.mapLines(image, rays);
        Assert.equals(100, result.width);
        Assert.equals(100, result.height);
    }

    function test_mapLines_emptyRays() {
        var image = createGradientImage(50, 50);
        var rays:Array<Ray2D> = [];
        var result = SimpleHough.mapLines(image, rays);
        // With no rays, image should be unchanged (or at least same size)
        Assert.equals(50, result.width);
    }

    function test_mapLines_withRays() {
        var image = createEmptyImage(100, 100);
        var point:Point2D = {x: 50, y: 0};
        var rays:Array<Ray2D> = [new Ray2D(point, null, 90)];
        var result = SimpleHough.mapLines(image, rays);
        Assert.notNull(result);
        // Line should be drawn with CYAN
    }

    function test_mapLines_multipleRays() {
        var image = createEmptyImage(100, 100);
        var point1:Point2D = {x: 25, y: 0};
        var point2:Point2D = {x: 75, y: 0};
        var rays:Array<Ray2D> = [
            new Ray2D(point1, null, 90),
            new Ray2D(point2, null, 45)
        ];
        var result = SimpleHough.mapLines(image, rays);
        Assert.notNull(result);
        Assert.equals(100, result.width);
    }

    // ============================================================
    // Integration Tests
    // ============================================================

    function test_detectAndMap_integration() {
        var image = createLineImage(100, 100);
        var detected = SimpleHough.detectLines(image, 5);
        var mapped = SimpleHough.mapLines(new Image(100, 100, Color.BLACK), detected);
        Assert.notNull(mapped);
        Assert.equals(100, mapped.width);
        Assert.equals(100, mapped.height);
    }

}

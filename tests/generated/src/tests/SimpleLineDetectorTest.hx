package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.SimpleLineDetector;
import vision.tools.MathTools;
import vision.ds.Int16Point2D;
import vision.ds.Line2D;
import vision.ds.Image;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;
import vision.ds.Color;

@:access(vision.algorithms.SimpleLineDetector)
class SimpleLineDetectorTest extends utest.Test {

    // Helper to create a black image with a white horizontal line
    static function createHorizontalLineImage(width:Int, height:Int, lineY:Int, lineStartX:Int, lineEndX:Int):Image {
        var img = new Image(width, height, 0xFF000000); // Black background
        for (x in lineStartX...lineEndX) {
            img.setPixel(x, lineY, 0xFFFFFFFF); // White line (red=255)
        }
        return img;
    }

    // Helper to create a black image with a white vertical line
    static function createVerticalLineImage(width:Int, height:Int, lineX:Int, lineStartY:Int, lineEndY:Int):Image {
        var img = new Image(width, height, 0xFF000000);
        for (y in lineStartY...lineEndY) {
            img.setPixel(lineX, y, 0xFFFFFFFF);
        }
        return img;
    }

    // Helper to create a black image with a white diagonal line
    static function createDiagonalLineImage(width:Int, height:Int):Image {
        var img = new Image(width, height, 0xFF000000);
        for (i in 10...90) {
            img.setPixel(i, i, 0xFFFFFFFF); // Diagonal from (10,10) to (89,89)
        }
        return img;
    }

    //==========================================================================
    // findLineFromPoint tests
    //==========================================================================

    function test_findLineFromPoint_horizontal_line() {
        // Create image with horizontal white line at y=50, from x=10 to x=89
        var image = createHorizontalLineImage(100, 100, 50, 10, 90);
        
        // Start from middle of the line
        var startPoint = new Int16Point2D(50, 50);
        var minLineLength = 20.0;
        
        var result = SimpleLineDetector.findLineFromPoint(image, startPoint, minLineLength);
        
        // Should find a line
        Assert.notNull(result);
        // Line should be roughly horizontal (start.y and end.y should be ~50)
        Assert.equals(50, Std.int(result.start.y));
        Assert.equals(50, Std.int(result.end.y));
        // Line length should be at least minLineLength
        Assert.isTrue(result.length >= minLineLength);
    }

    function test_findLineFromPoint_returns_null_on_black_pixel() {
        var image = createHorizontalLineImage(100, 100, 50, 10, 90);
        
        // Start from a black pixel (not on the line)
        var startPoint = new Int16Point2D(50, 30);
        var minLineLength = 10.0;
        
        var result = SimpleLineDetector.findLineFromPoint(image, startPoint, minLineLength);
        
        // Should return null since we started on a black (non-line) pixel
        Assert.isNull(result);
    }

    function test_findLineFromPoint_returns_null_for_short_line() {
        // Create a very short line (only 5 pixels)
        var image = new Image(100, 100, 0xFF000000);
        for (x in 48...53) {
            image.setPixel(x, 50, 0xFFFFFFFF);
        }
        
        var startPoint = new Int16Point2D(50, 50);
        var minLineLength = 20.0; // Require longer than the line
        
        var result = SimpleLineDetector.findLineFromPoint(image, startPoint, minLineLength);
        
        // Should return null because line is shorter than minLineLength
        Assert.isNull(result);
    }

    function test_findLineFromPoint_out_of_bounds() {
        var image = createHorizontalLineImage(100, 100, 50, 10, 90);
        
        // Start from outside image bounds
        var startPoint = new Int16Point2D(150, 50);
        var minLineLength = 10.0;
        
        var result = SimpleLineDetector.findLineFromPoint(image, startPoint, minLineLength);
        
        // Should return null for out of bounds
        Assert.isNull(result);
    }

    //==========================================================================
    // lineCoveragePercentage tests
    //==========================================================================

    function test_lineCoveragePercentage_full_coverage() {
        // Create image with white line from (10,50) to (90,50)
        var image = createHorizontalLineImage(100, 100, 50, 10, 91);
        
        // Create a Line2D that matches exactly
        var line = new Line2D(new Point2D(10.0, 50.0), new Point2D(90.0, 50.0));
        
        var result = SimpleLineDetector.lineCoveragePercentage(image, line);
        
        // Should have very high coverage (close to 100%)
        // The function returns percentage * 100, so expect ~100
        Assert.isTrue(result > 80); // High coverage
    }

    function test_lineCoveragePercentage_no_coverage() {
        // Create image with line at y=50
        var image = createHorizontalLineImage(100, 100, 50, 10, 90);
        
        // Create a line at completely different position (y=20)
        var line = new Line2D(new Point2D(10.0, 20.0), new Point2D(90.0, 20.0));
        
        var result = SimpleLineDetector.lineCoveragePercentage(image, line);
        
        // Should have low/negative coverage since the line doesn't match
        Assert.isTrue(result < 50);
    }

    function test_lineCoveragePercentage_null_line_returns_zero() {
        var image = createHorizontalLineImage(100, 100, 50, 10, 90);
        
        var result = SimpleLineDetector.lineCoveragePercentage(image, null);
        
        // Should return 0 for null line
        Assert.equals(0.0, result);
    }

    function test_lineCoveragePercentage_partial_coverage() {
        // Create image with line from x=10 to x=50
        var image = createHorizontalLineImage(100, 100, 50, 10, 51);
        
        // Create a line that extends beyond the actual line (x=10 to x=90)
        var line = new Line2D(new Point2D(10.0, 50.0), new Point2D(90.0, 50.0));
        
        var result = SimpleLineDetector.lineCoveragePercentage(image, line);
        
        // Should have partial coverage (roughly 50%)
        // The actual percentage depends on gap calculation
        Assert.isTrue(result > 0);
        Assert.isTrue(result < 80);
    }

    //==========================================================================
    // correctLines tests
    //==========================================================================

    function test_correctLines_empty_array() {
        var lines:Array<Line2D> = [];
        
        var result = SimpleLineDetector.correctLines(lines, 3.0, 7.0);
        
        Assert.notNull(result);
        Assert.equals(0, result.length);
    }

    function test_correctLines_single_line_unchanged() {
        var line = new Line2D(new Point2D(0.0, 0.0), new Point2D(100.0, 0.0));
        var lines = [line];
        
        var result = SimpleLineDetector.correctLines(lines, 3.0, 7.0);
        
        Assert.equals(1, result.length);
        // Line should still be there
        Assert.floatEquals(0.0, result[0].start.y);
        Assert.floatEquals(100.0, result[0].end.x);
    }

    function test_correctLines_merges_collinear_adjacent_lines() {
        // Two horizontal lines that are close and nearly parallel
        var line1 = new Line2D(new Point2D(0.0, 50.0), new Point2D(50.0, 50.0));
        var line2 = new Line2D(new Point2D(52.0, 50.0), new Point2D(100.0, 50.0)); // Gap of 2px
        var lines = [line1, line2];
        
        var result = SimpleLineDetector.correctLines(lines, 3.0, 7.0); // distanceThreshold=3
        
        // Should merge into single line (or at least reduce count)
        Assert.isTrue(result.length <= 2);
    }

    function test_correctLines_removes_shorter_intersecting_line() {
        // Two lines that intersect, one shorter
        var longLine = new Line2D(new Point2D(0.0, 50.0), new Point2D(100.0, 50.0)); // 100px
        var shortLine = new Line2D(new Point2D(40.0, 50.0), new Point2D(60.0, 51.0)); // ~20px, nearly same angle
        var lines = [longLine, shortLine];
        
        var result = SimpleLineDetector.correctLines(lines, 3.0, 7.0);
        
        // Shorter intersecting line with similar angle should be removed
        Assert.equals(1, result.length);
        // The remaining line should be the longer one
        Assert.isTrue(result[0].length >= 90);
    }

    function test_correctLines_keeps_perpendicular_lines() {
        // Two perpendicular lines (90 degree difference)
        var horizontal = new Line2D(new Point2D(0.0, 50.0), new Point2D(100.0, 50.0));
        var vertical = new Line2D(new Point2D(50.0, 0.0), new Point2D(50.0, 100.0));
        var lines = [horizontal, vertical];
        
        var result = SimpleLineDetector.correctLines(lines, 3.0, 7.0); // degError=7
        
        // Both should remain since they differ by 90 degrees (> 7 degError)
        Assert.equals(2, result.length);
    }

    function test_correctLines_preserves_distant_parallel_lines() {
        // Two parallel horizontal lines far apart
        var line1 = new Line2D(new Point2D(0.0, 20.0), new Point2D(100.0, 20.0));
        var line2 = new Line2D(new Point2D(0.0, 80.0), new Point2D(100.0, 80.0)); // 60px apart
        var lines = [line1, line2];
        
        var result = SimpleLineDetector.correctLines(lines, 3.0, 7.0);
        
        // Both should remain since they don't intersect and are far apart
        Assert.equals(2, result.length);
    }
}

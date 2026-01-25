package tests;

import utest.Assert;
import vision.ds.Image;
import vision.ds.Color;
import vision.ds.Point2D;
import vision.ds.IntPoint2D;
import vision.ds.Line2D;
import vision.ds.Ray2D;
import vision.ds.Rectangle;
import vision.ds.ImageView;
import vision.ds.ImageViewShape;

@:access(vision.ds.Image)
class ImageTest extends utest.Test {

    //==========================================================================
    // Construction and basic properties
    //==========================================================================

    function test_constructor() {
        var img = new Image(50, 30, 0xFFFF0000);
        Assert.equals(50, img.width);
        Assert.equals(30, img.height);
        Assert.equals(0xFFFF0000, img.getPixel(0, 0));
    }

    function test_constructor_default_color() {
        var img = new Image(10, 10);
        Assert.equals(10, img.width);
        Assert.equals(10, img.height);
    }

    function test_from2DArray() {
        var array:Array<Array<Int>> = [
            [0xFFFF0000, 0xFF00FF00, 0xFF0000FF],
            [0xFF000000, 0xFFFFFFFF, 0xFF808080]
        ];
        var result = Image.from2DArray(array);
        
        Assert.equals(3, result.width);
        Assert.equals(2, result.height);
        Assert.equals(0xFFFF0000, result.getPixel(0, 0)); // Red at top-left
        Assert.equals(0xFF0000FF, result.getPixel(2, 0)); // Blue at top-right
        Assert.equals(0xFFFFFFFF, result.getPixel(1, 1)); // White at center-bottom
    }

    //==========================================================================
    // Pixel get/set operations
    //==========================================================================

    function test_setPixel_and_getPixel() {
        var img = new Image(10, 10, 0xFF000000);
        img.setPixel(5, 5, 0xFFFF0000);
        Assert.equals(0xFFFF0000, img.getPixel(5, 5));
    }

    function test_getSafePixel_valid() {
        var img = new Image(10, 10, 0xFF123456);
        Assert.equals(0xFF123456, img.getSafePixel(5, 5));
    }

    function test_getSafePixel_out_of_bounds() {
        var img = new Image(10, 10, 0xFF123456);
        Assert.equals(0, img.getSafePixel(100, 100));
        Assert.equals(0, img.getSafePixel(-1, 0));
    }

    function test_setSafePixel() {
        var img = new Image(10, 10, 0xFF000000);
        img.setSafePixel(5, 5, 0xFFFF0000);
        Assert.equals(0xFFFF0000, img.getPixel(5, 5));
        
        // Out of bounds should not crash
        img.setSafePixel(100, 100, 0xFFFF0000);
        Assert.isTrue(true); // Just verify no exception
    }

    function test_getFloatingPixel() {
        var img = new Image(10, 10, 0xFFFFFFFF);
        // Floating point coordinate interpolates between pixels
        var result = img.getFloatingPixel(5.5, 5.5);
        Assert.notNull(result);
    }

    function test_setFloatingPixel() {
        var img = new Image(10, 10, 0xFF000000);
        img.setFloatingPixel(5.5, 5.5, 0xFFFF0000);
        // Should affect nearby pixels
        Assert.isTrue(true); // Verify no exception
    }

    function test_paintPixel() {
        var img = new Image(10, 10, 0xFFFFFFFF); // White background
        img.paintPixel(5, 5, 0x80FF0000); // Semi-transparent red
        // Paint should blend, not fully replace
        var result:Color = img.getPixel(5, 5);
        Assert.notNull(result);
    }

    function test_hasPixel() {
        var img = new Image(10, 10);
        Assert.isTrue(img.hasPixel(0, 0));
        Assert.isTrue(img.hasPixel(9, 9));
        Assert.isFalse(img.hasPixel(10, 10));
        Assert.isFalse(img.hasPixel(-1, 0));
        Assert.isFalse(img.hasPixel(0, -1));
    }

    //==========================================================================
    // Pixel move operations
    //==========================================================================

    function test_movePixel() {
        var img = new Image(10, 10, 0xFF000000);
        img.setPixel(0, 0, 0xFFFF0000); // Red at origin
        img.movePixel(0, 0, 5, 5, 0xFF00FF00); // Move to (5,5), fill old with green
        
        Assert.equals(0xFFFF0000, img.getPixel(5, 5)); // Red moved here
        Assert.equals(0xFF00FF00, img.getPixel(0, 0)); // Green filled old spot
    }

    function test_moveSafePixel() {
        var img = new Image(10, 10, 0xFF000000);
        img.setPixel(0, 0, 0xFFFF0000);
        
        // Move within bounds
        img.moveSafePixel(0, 0, 5, 5, 0xFF00FF00);
        Assert.equals(0xFFFF0000, img.getPixel(5, 5));
        
        // Move out of bounds should not crash
        img.moveSafePixel(100, 100, 5, 5, 0xFF0000FF);
        Assert.isTrue(true);
    }

    //==========================================================================
    // Copy operations
    //==========================================================================

    function test_copyPixelFrom() {
        var source = new Image(10, 10, 0xFFFF0000); // Red
        var target = new Image(10, 10, 0xFF000000); // Black
        
        target.copyPixelFrom(source, 5, 5);
        Assert.equals(0xFFFF0000, target.getPixel(5, 5));
    }

    function test_copyPixelTo() {
        var source = new Image(10, 10, 0xFFFF0000); // Red
        var target = new Image(10, 10, 0xFF000000); // Black
        
        source.copyPixelTo(target, 5, 5);
        Assert.equals(0xFFFF0000, target.getPixel(5, 5));
    }

    function test_copyImageFrom() {
        var source = new Image(10, 10, 0xFFFF0000);
        var target = new Image(10, 10, 0xFF000000);
        
        target.copyImageFrom(source);
        Assert.equals(0xFFFF0000, target.getPixel(0, 0));
        Assert.equals(0xFFFF0000, target.getPixel(9, 9));
    }

    function test_getImagePortion() {
        var img = new Image(20, 20, 0xFFFF0000);
        var rect:Rectangle = {x: 5, y: 5, width: 10, height: 10};
        
        var portion = img.getImagePortion(rect);
        Assert.equals(10, portion.width);
        Assert.equals(10, portion.height);
        Assert.equals(0xFFFF0000, portion.getPixel(0, 0));
    }

    function test_setImagePortion() {
        var img = new Image(20, 20, 0xFF000000);
        var portion = new Image(5, 5, 0xFFFF0000);
        var rect:Rectangle = {x: 5, y: 5, width: 5, height: 5};
        
        img.setImagePortion(rect, portion);
        Assert.equals(0xFFFF0000, img.getPixel(5, 5));
        Assert.equals(0xFF000000, img.getPixel(0, 0)); // Outside portion
    }

    //==========================================================================
    // Drawing operations
    //==========================================================================

    function test_drawLine() {
        var img = new Image(20, 20, 0xFF000000);
        img.drawLine(0, 0, 19, 19, 0xFFFF0000); // Diagonal red line
        
        // Check that diagonal pixels are set
        Assert.equals(0xFFFF0000, img.getPixel(0, 0));
        Assert.equals(0xFFFF0000, img.getPixel(10, 10));
        Assert.equals(0xFFFF0000, img.getPixel(19, 19));
    }

    function test_drawLine2D() {
        var img = new Image(20, 20, 0xFF000000);
        var line = new Line2D(new Point2D(0.0, 0.0), new Point2D(19.0, 0.0));
        img.drawLine2D(line, 0xFFFF0000); // Horizontal red line
        
        Assert.equals(0xFFFF0000, img.getPixel(0, 0));
        Assert.equals(0xFFFF0000, img.getPixel(10, 0));
        Assert.equals(0xFFFF0000, img.getPixel(19, 0));
    }

    function test_drawRay2D() {
        var img = new Image(20, 20, 0xFF000000);
        var ray = new Ray2D(new Point2D(0.0, 10.0), 0.0); // Horizontal ray
        img.drawRay2D(ray, 0xFFFF0000);
        
        // Ray should draw horizontally from origin
        Assert.equals(0xFFFF0000, img.getPixel(10, 10));
    }

    function test_fillRect() {
        var img = new Image(20, 20, 0xFF000000);
        img.fillRect(5, 5, 10, 10, 0xFFFF0000);
        
        // Inside rect
        Assert.equals(0xFFFF0000, img.getPixel(5, 5));
        Assert.equals(0xFFFF0000, img.getPixel(10, 10));
        Assert.equals(0xFFFF0000, img.getPixel(14, 14));
        
        // Outside rect
        Assert.equals(0xFF000000, img.getPixel(0, 0));
        Assert.equals(0xFF000000, img.getPixel(19, 19));
    }

    function test_drawRect() {
        var img = new Image(20, 20, 0xFF000000);
        img.drawRect(5, 5, 10, 10, 0xFFFF0000);
        
        // Border pixels
        Assert.equals(0xFFFF0000, img.getPixel(5, 5));
        Assert.equals(0xFFFF0000, img.getPixel(14, 5));
        Assert.equals(0xFFFF0000, img.getPixel(5, 14));
        
        // Inside should remain black (unfilled)
        Assert.equals(0xFF000000, img.getPixel(10, 10));
    }

    function test_drawCircle() {
        var img = new Image(30, 30, 0xFF000000);
        img.drawCircle(15, 15, 10, 0xFFFF0000);
        
        // Center should remain black (unfilled circle)
        Assert.equals(0xFF000000, img.getPixel(15, 15));
        // Some point on the edge should be red
        Assert.equals(0xFFFF0000, img.getPixel(15, 5)); // Top of circle
    }

    function test_fillCircle() {
        var img = new Image(30, 30, 0xFF000000);
        img.fillCircle(15, 15, 10, 0xFFFF0000);
        
        // Center should be filled
        Assert.equals(0xFFFF0000, img.getPixel(15, 15));
        // Outside should remain black
        Assert.equals(0xFF000000, img.getPixel(0, 0));
    }

    function test_drawEllipse() {
        var img = new Image(30, 20, 0xFF000000);
        img.drawEllipse(15, 10, 10, 5, 0xFFFF0000);
        
        // Center should remain unfilled
        Assert.equals(0xFF000000, img.getPixel(15, 10));
    }

    function test_fillEllipse() {
        var img = new Image(30, 20, 0xFF000000);
        img.fillEllipse(15, 10, 10, 5, 0xFFFF0000);
        
        // Center should be filled
        Assert.equals(0xFFFF0000, img.getPixel(15, 10));
    }

    function test_drawQuadraticBezier() {
        var img = new Image(30, 30, 0xFF000000);
        var line = new Line2D(new Point2D(0.0, 15.0), new Point2D(29.0, 15.0));
        var control = new IntPoint2D(15, 0);
        img.drawQuadraticBezier(line, control, 0xFFFF0000);
        
        // Start and end points should be set
        Assert.equals(0xFFFF0000, img.getPixel(0, 15));
        Assert.equals(0xFFFF0000, img.getPixel(29, 15));
    }

    function test_drawCubicBezier() {
        var img = new Image(30, 30, 0xFF000000);
        var line = new Line2D(new Point2D(0.0, 15.0), new Point2D(29.0, 15.0));
        var control1 = new IntPoint2D(10, 0);
        var control2 = new IntPoint2D(20, 29);
        img.drawCubicBezier(line, control1, control2, 0xFFFF0000);
        
        // Start and end should be set
        Assert.equals(0xFFFF0000, img.getPixel(0, 15));
        Assert.equals(0xFFFF0000, img.getPixel(29, 15));
    }

    //==========================================================================
    // Fill color operations
    //==========================================================================

    function test_fillColor() {
        var img = new Image(10, 10, 0xFFFFFFFF); // White
        img.drawRect(2, 2, 6, 6, 0xFF000000); // Black border
        img.fillColor(new IntPoint2D(0, 0), 0xFFFF0000); // Fill outside with red
        
        // Outside the rect should be red
        Assert.equals(0xFFFF0000, img.getPixel(0, 0));
        // Inside the rect should still be white
        Assert.equals(0xFFFFFFFF, img.getPixel(5, 5));
    }

    //==========================================================================
    // Clone, mirror, flip
    //==========================================================================

    function test_clone() {
        var img = new Image(10, 10, 0xFFFF0000);
        img.setPixel(5, 5, 0xFF00FF00);
        
        var cloned = img.clone();
        Assert.equals(10, cloned.width);
        Assert.equals(10, cloned.height);
        Assert.equals(0xFFFF0000, cloned.getPixel(0, 0));
        Assert.equals(0xFF00FF00, cloned.getPixel(5, 5));
        
        // Modifying clone should not affect original
        cloned.setPixel(5, 5, 0xFF0000FF);
        Assert.equals(0xFF00FF00, img.getPixel(5, 5));
    }

    function test_mirror() {
        var img = new Image(10, 10, 0xFF000000);
        img.setPixel(0, 5, 0xFFFF0000); // Red on left
        
        var mirrored = img.mirror();
        Assert.equals(0xFFFF0000, mirrored.getPixel(9, 5)); // Red now on right
        Assert.equals(0xFF000000, mirrored.getPixel(0, 5)); // Left is now black
    }

    function test_flip() {
        var img = new Image(10, 10, 0xFF000000);
        img.setPixel(5, 0, 0xFFFF0000); // Red on top
        
        var flipped = img.flip();
        Assert.equals(0xFFFF0000, flipped.getPixel(5, 9)); // Red now on bottom
        Assert.equals(0xFF000000, flipped.getPixel(5, 0)); // Top is now black
    }

    //==========================================================================
    // Stamp operation
    //==========================================================================

    function test_stamp() {
        var bg = new Image(20, 20, 0xFF000000);
        var stamp = new Image(5, 5, 0xFFFF0000);
        
        var result = bg.stamp(5, 5, stamp);
        
        // Stamp area should be red
        Assert.equals(0xFFFF0000, result.getPixel(5, 5));
        Assert.equals(0xFFFF0000, result.getPixel(9, 9));
        
        // Outside stamp should remain black
        Assert.equals(0xFF000000, result.getPixel(0, 0));
        Assert.equals(0xFF000000, result.getPixel(15, 15));
    }

    //==========================================================================
    // Resize and rotate
    //==========================================================================

    function test_resize() {
        var img = new Image(10, 10, 0xFFFF0000);
        var resized = img.resize(20, 20);
        
        Assert.equals(20, resized.width);
        Assert.equals(20, resized.height);
        // Color should be preserved (roughly)
        var c:Color = resized.getPixel(10, 10);
        Assert.equals(255, c.red);
    }

    function test_resize_half() {
        var img = new Image(20, 20, 0xFFFF0000);
        var resized = img.resize(10, 10);
        
        Assert.equals(10, resized.width);
        Assert.equals(10, resized.height);
    }

    function test_rotate() {
        var img = new Image(10, 10, 0xFFFF0000);
        var rotated = img.rotate(0.0); // No rotation
        
        Assert.notNull(rotated);
        Assert.equals(0xFFFF0000, rotated.getPixel(5, 5));
    }

    //==========================================================================
    // Coordinate conversions
    //==========================================================================

    function test_center() {
        var img = new Image(100, 80);
        var c = img.center();
        
        Assert.floatEquals(50.0, c.x);
        Assert.floatEquals(40.0, c.y);
    }

    function test_pixelToRelative() {
        var img = new Image(100, 100);
        var rel = img.pixelToRelative(50.0, 50.0);
        
        Assert.floatEquals(0.5, rel.x);
        Assert.floatEquals(0.5, rel.y);
    }

    function test_pixelToRelative_corner() {
        var img = new Image(100, 100);
        var rel = img.pixelToRelative(0.0, 0.0);
        
        Assert.floatEquals(0.0, rel.x);
        Assert.floatEquals(0.0, rel.y);
    }

    function test_relativeToPixel() {
        var img = new Image(100, 100);
        var pixel = img.relativeToPixel(0.5, 0.5);
        
        Assert.floatEquals(50.0, pixel.x);
        Assert.floatEquals(50.0, pixel.y);
    }

    //==========================================================================
    // View operations
    //==========================================================================

    function test_hasView() {
        var img = new Image(10, 10);
        Assert.isFalse(img.hasView());
    }

    function test_setView_and_hasView() {
        var img = new Image(10, 10);
        var view:ImageView = {x: 2, y: 2, width: 5, height: 5, shape: ImageViewShape.RECTANGLE};
        
        img.setView(view);
        Assert.isTrue(img.hasView());
    }

    function test_getView() {
        var img = new Image(10, 10);
        var view:ImageView = {x: 2, y: 2, width: 5, height: 5, shape: ImageViewShape.RECTANGLE};
        img.setView(view);
        
        var retrieved = img.getView();
        Assert.equals(2, retrieved.x);
        Assert.equals(2, retrieved.y);
        Assert.equals(5, retrieved.width);
        Assert.equals(5, retrieved.height);
    }

    function test_removeView() {
        var img = new Image(10, 10);
        var view:ImageView = {x: 2, y: 2, width: 5, height: 5, shape: ImageViewShape.RECTANGLE};
        img.setView(view);
        
        img.removeView();
        Assert.isFalse(img.hasView());
    }

    function test_hasPixelInView() {
        var img = new Image(10, 10);
        var view:ImageView = {x: 2, y: 2, width: 5, height: 5, shape: ImageViewShape.RECTANGLE};
        
        Assert.isTrue(img.hasPixelInView(3, 3, view)); // Inside
        Assert.isFalse(img.hasPixelInView(0, 0, view)); // Outside
    }

    //==========================================================================
    // Iteration
    //==========================================================================

    function test_forEachPixel() {
        var img = new Image(5, 5, 0xFFFF0000);
        var count = 0;
        
        img.forEachPixel((x, y, color) -> {
            count++;
            Assert.equals(0xFFFF0000, color);
        });
        
        Assert.equals(25, count); // 5x5 = 25 pixels
    }

    function test_iterator() {
        var img = new Image(3, 3, 0xFFFF0000);
        var count = 0;
        
        for (pixel in img) {
            count++;
            Assert.equals(0xFFFF0000, pixel.color);
        }
        
        Assert.equals(9, count);
    }

    //==========================================================================
    // String representation
    //==========================================================================

    function test_toString() {
        var img = new Image(10, 20);
        var str = img.toString();
        
        Assert.notNull(str);
        Assert.isTrue(str.length > 0);
    }
}

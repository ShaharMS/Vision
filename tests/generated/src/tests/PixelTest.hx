package tests;

import utest.Assert;
import utest.Async;
import vision.ds.Pixel;
import vision.ds.Color;

@:access(vision.ds.Pixel)
class PixelTest extends utest.Test {

    function test_constructor() {
        var pixel = new Pixel(10, 20, Color.fromRGBA(255, 128, 64, 255));
        Assert.equals(10, pixel.x);
        Assert.equals(20, pixel.y);
        Assert.notNull(pixel.color);
    }

    function test_x_coordinate() {
        var pixel = new Pixel(5, 0, 0xFFFFFFFF);
        Assert.equals(5, pixel.x);
    }

    function test_y_coordinate() {
        var pixel = new Pixel(0, 15, 0xFFFFFFFF);
        Assert.equals(15, pixel.y);
    }

    function test_color() {
        var color = Color.fromRGBA(100, 150, 200, 255);
        var pixel = new Pixel(0, 0, color);
        Assert.equals(100, pixel.color.red);
        Assert.equals(150, pixel.color.green);
        Assert.equals(200, pixel.color.blue);
    }

    function test_x_is_mutable() {
        var pixel = new Pixel(0, 0, 0xFFFFFFFF);
        pixel.x = 42;
        Assert.equals(42, pixel.x);
    }

    function test_y_is_mutable() {
        var pixel = new Pixel(0, 0, 0xFFFFFFFF);
        pixel.y = 99;
        Assert.equals(99, pixel.y);
    }

    function test_color_is_mutable() {
        var pixel = new Pixel(0, 0, 0xFF000000);
        pixel.color = Color.fromRGBA(255, 0, 0, 255);
        Assert.equals(255, pixel.color.red);
        Assert.equals(0, pixel.color.green);
    }

    function test_struct_init() {
        var pixel:Pixel = {x: 7, y: 8, color: 0xFFABCDEF};
        Assert.equals(7, pixel.x);
        Assert.equals(8, pixel.y);
    }

}

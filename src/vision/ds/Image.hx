package vision.ds;

import vision.exceptions.OutOfBounds;
import haxe.ds.Vector;

import vision.ds.Matrix;
import vision.ds.Color;

/**
    Represents a 2D image, as a matrix of Colors.
**/
abstract Image(Matrix<Null<Color>>) {
    
    /**
        The width of the image.
    **/
    public var width(get, never):Int;
    function get_width() return this.length;

    /**
        The height of the image.
    **/
    public var height(get, never):Int;
    function get_height() return this[0].length;

    /**
        Creates a new image of the given size. Onces created, the image cannot be resized.

        @param width The width of the image.
        @param height The height of the image.
        @param color The color to fill the image with. if unspecified, the image is transparent.
    **/
    public function new(width:Int, height:Int, ?color:Int = 0x00000000) {
        this = new Matrix<Null<Color>>(width);
        for (i in 0...this.length) {
            this[i] = new Vector<Null<Color>>(height);
            for (j in 0...this[i].length) {
                this[i][j] = Color.fromInt(color);
            }
        }
    }

    /**
        Gets the color of the pixel at the given coordinates.

        @param x The x coordinate of the pixel.
        @param y The y coordinate of the pixel.
    **/
    public function getPixel(x:Int, y:Int):Color {
        if (x < 0 || x >= this.length || y < 0 || y >= this[x].length) {
            throw new OutOfBounds(cast this, new Point2D(x, y));
        }
        return this[x][y];
    }

    /**
        Sets the color of the pixel at the given coordinates.

        @param x The x coordinate of the pixel.
        @param y The y coordinate of the pixel.
        @param color The color to set the pixel to.
    **/
    public function setPixel(x:Int, y:Int, color:Color) {
        if (x < 0 || x >= this.length || y < 0 || y >= this[x].length) {
            throw new OutOfBounds(cast this, new Point2D(x, y));
        }
        this[x][y] = color;
    }

    /**
        Sets the color of a pixel, but doesnt completely overwrite the pixel:

        - if the color of the new pixel is the same as the old pixel, the old pixel is kept.
        - if the alpha of the new pixel is 0, the old pixel is kept.
        - if the alpha of the new pixel is 255, the new pixel is kept.
        - if the alpha of the new pixel is between 0 and 255, the new pixel is blended with the old pixel.

        @param x The x coordinate of the pixel.
        @param y The y coordinate of the pixel.
        @param color The color to set the pixel to. pay attention to the alpha value.
    **/
    public function paintPixel(x:Int, y:Int, color:Color) {
        if (x < 0 || x >= this.length || y < 0 || y >= this[x].length) {
            throw new OutOfBounds(cast this, new Point2D(x, y));
        }
        var oldColor = this[x][y];
        var newAlpha = color.alpha;
        var oldAlpha = oldColor.alpha;
        if (newAlpha == 0) {
            return;
        } else if (newAlpha == 255) {
            this[x][y] = color;
        } else {
            var newRed = color.red;
            var newGreen = color.green;
            var newBlue = color.blue;
            var oldRed = oldColor.red;
            var oldGreen = oldColor.green;
            var oldBlue = oldColor.blue;
            var newRed = (newRed * newAlpha + oldRed * oldAlpha * (255 - newAlpha)) / 255;
            var newGreen = (newGreen * newAlpha + oldGreen * oldAlpha * (255 - newAlpha)) / 255;
            var newBlue = (newBlue * newAlpha + oldBlue * oldAlpha * (255 - newAlpha)) / 255;
            this[x][y] = Color.fromRGB(Std.int(newRed), Std.int(newGreen), Std.int(newBlue), oldAlpha + newAlpha);
        }
    }

    /**
        Sets a rectangle of pixels to the given color, essentially filling it with the given color.

        @param rect The rectangle to fill: The fill starts at (x, y) and 
        extends to (x + width, y + height), not including the endpoints.
        @param color The color to fill that rectangular portion with.
    **/
    public function setColorOfRect(rect:Rectangle, color:Color) {
        for (x in rect.x...rect.x + rect.width) {
            for (y in rect.y...rect.y + rect.height) {
                setPixel(x, y, color);
            }
        }
    }

    /**
        Returns a portion of the image, specified by a rectangle.

        @param rect The rectangle specifying the portion of the image to return.

        @return A new image containing the specified portion of the original image.
    **/
    public function getImagePortion(rect:Rectangle):Image {
        var subImage = new Image(rect.width, rect.height, 0);
        for (x in rect.x...rect.x + rect.width) {
            for (y in rect.y...rect.y + rect.height) {
                subImage.setPixel(x - rect.x, y - rect.y, getPixel(x, y));
            }
        }
        return subImage;
    }

    /**
        Gets the image as a string.
    **/
    public function toString():String {
        var s = "\n";
        for (i in 0...this.length) {
            for (j in 0...this[i].length) {
                s += this[i][j].toString();
            }
            s += "\n";
        }
        return s;
    }

    //--------------------------------------------------------------------------
    // Graphics Drawing Methods
    //--------------------------------------------------------------------------

    /**
        Draws a line from (x1, y1) to (x2, y2) using the given color.
    **/
    public function drawLine(x1:Int, y1:Int, x2:Int, y2:Int, color:Color) {
        var dx = Math.abs(x2 - x1);
        var dy = Math.abs(y2 - y1);
        var sx = (x1 < x2) ? 1 : -1;
        var sy = (y1 < y2) ? 1 : -1;
        var err = dx - dy;
        while (true) {
            setPixel(x1, y1, color);
            if (x1 == x2 && y1 == y2) break;
            var e2 = 2 * err;
            if (e2 > -dy) { err -= dy; x1 += sx; }
            if (e2 < dx) { err += dx; y1 += sy; }
        }
    }

    /**
        Draws a circle of the given color:

         - The center of the circle is at (X, Y)
         - The radius of the circle is r
         - Anti-aliasing will not be used.
    **/
    public function drawCircle(X:Int, Y:Int, r:Int, color:Color) {
        var x = -r, y = 0, err = 2 - 2 * r, startX = X, startY = Y;
        do {
            setPixel(X - x, Y + y, color);
            setPixel(X - y, Y - x, color);
            setPixel(X + x, Y - y, color);
            setPixel(X + y, Y + x, color);
            r = err;
            if (r <= y) {
                err += ++y * 2 + 1;
            }
            if (r > x || err > y) {
                err += ++x * 2 + 1;
            }
        } while (x < 0);
    }

    /**
        Clones this image.
    **/
    public function clone():Image {
        var clone = new Image(width, height, 0);
        for (i in 0...this.length) {
            for (j in 0...this[i].length) {
                clone.setPixel(i, j, this[i][j]);
            }
        }
        return clone;
    }


    //--------------------------------------------------------------------------
    // Operators
    //--------------------------------------------------------------------------

    @:op([]) @:noCompletion function image_array_read(index:Int) {
        return this[index];
    }
        
    @:op([]) @:noCompletion function image_array_write(index:Int, value:Vector<Null<Color>>) {
        this[index] = value;
    }




















    //--------------------------------------------------------------------------
    // Framework-specific methods
    //--------------------------------------------------------------------------
}
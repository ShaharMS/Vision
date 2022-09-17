package vision.ds;

import haxe.ds.List;
import haxe.Int64;
import haxe.ds.Vector;

import vision.ds.Matrix;
import vision.ds.Color;

import vision.exceptions.OutOfBounds;

import vision.tools.ImageTools;
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

        @throws OutOfBounds if the coordinates are out of bounds.
        @return The color of the pixel at the given coordinates.
    **/
    public function getPixel(x:Int, y:Int):Color {
        if (x < 0 || x >= this.length || y < 0 || y >= this[x].length) {
            throw new OutOfBounds(cast this, new IntPoint2D(x, y));
        }
        return this[x][y];
    }

    /**
        Sets the color of the pixel at the given coordinates.

        @param x The x coordinate of the pixel.
        @param y The y coordinate of the pixel.
        @param color The color to set the pixel to.

        @throws OutOfBounds if the pixel is out of bounds.
    **/
    public function setPixel(x:Int, y:Int, color:Color) {
        if (x < 0 || x >= this.length || y < 0 || y >= this[x].length) {
            throw new OutOfBounds(cast this, new IntPoint2D(x, y));
        }
        this[x][y] = color;
    }

    /**
        Checks if the given coordinates are within the bounds of the image.

        @param x The x coordinate of the pixel.
        @param y The y coordinate of the pixel.

        @return True if the coordinates are within the bounds of the image.
    **/
    public function hasPixel(x:Int, y:Int):Bool {
        return x >= 0 && x < this.length && y >= 0 && y < this[x].length;
    }

    /**
        Copies a pixel from the given image to this image.

        @param x The x coordinate of the pixel.
        @param y The y coordinate of the pixel.
        @param image The image to copy the pixel from.

        @throws OutOfBounds if the given coordinates are outside the bounds of the image.
        @return The color of the pixel at the given coordinates.
    **/
    public function copyPixel(x:Int, y:Int, image:Image):Color {
        if (x < 0 || x >= this.length || y < 0 || y >= this[x].length) {
            throw new OutOfBounds(cast this, new IntPoint2D(x, y));
        }
        this[x][y] = image[x][y];
        return this[x][y];
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
            throw new OutOfBounds(cast this, new IntPoint2D(x, y));
        }
        var oldColor = this[x][y];
        var newColor = Color.fromRGBAFloat(
            color.redFloat * color.alphaFloat + oldColor.redFloat * (1 - color.alphaFloat),
            color.greenFloat * color.alphaFloat + oldColor.greenFloat * (1 - color.alphaFloat),
            color.blueFloat * color.alphaFloat + oldColor.blueFloat * (1 - color.alphaFloat),
            1);
        setPixel(x, y, newColor);
    }

    /**
        Sets a rectangle of pixels to the given color, essentially filling it with the given color.

        @param rect The rectangle to fill: The fill starts at (x, y) and extends to (x + width, y + height), not including the endpoints.
        @param color The color to fill that rectangular portion with.
    **/
    public function fillRect(x:Int, y:Int, width:Int, height:Int, color:Color) {
        for (X in x...x + width) {
            for (Y in y...y + height) {
                setPixel(X, Y, color);
            }
        }
    }

    /**
        Draws a rectangular outline of the given color.

        This function is a shortcut for just doing repeated calls to drawLine.

        @param rect The rectangle to draw the outline of.
        @param color The color to draw the outline with.
    **/
    public function drawRect(x:Int, y:Int, width:Int, height:Int, color:Color) {
        drawLine(x, y, x + width, y, color);
        drawLine(x + width, y, x + width, y + height, color);
        drawLine(x + width, y + height, x, y + height, color);
        drawLine(x, y + height, x, y, color);
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
        Sets a portion of the image, specified by a rectangle, to another image.

        @param rect The rectangle specifying the portion of the image to set.
        @param image The image to set the portion of the image to.

        @throws OutOfBounds if the portion of the image to set is outside the bounds of the original image.
    **/
    public function setImagePortion(rect:Rectangle, image:Image) {
        if (rect.x < 0 || rect.x + rect.width > this.length || rect.y < 0 || rect.y + rect.height > this[0].length) {
            throw new OutOfBounds(cast this, {x: rect.x, y: rect.y});
        }
        for (x in rect.x...rect.x + rect.width) {
            for (y in rect.y...rect.y + rect.height) {
                setPixel(x, y, image.getPixel(x - rect.x, y - rect.y));
            }
        }
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
        Draws an infine line specified by a Ray2D object.

        **Notice** - The (0, 0) point is **not** the same is `image.getPixel(0, 0)`,
        but rather the bottom left corner of the image - `image.getPixel(0, image.height - 1)`.

        This "vertical flip" is done to match the way the ray is draw on the cartesian plane.

        @param line The line to draw.
        @param color The color to draw the line with.

        @see Ray2D
    **/
    public function drawRay2D(line:Ray2D, color:Color) {
        var p1 = IntPoint2D.fromPoint2D(line.getPointAtY(0));
        var p2 = IntPoint2D.fromPoint2D(line.getPointAtY(height - 1));
        var x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y;
        var dx = Math.abs(x2 - x1);
        var dy = Math.abs(y2 - y1);
        var sx = (x1 < x2) ? 1 : -1;
        var sy = (y1 < y2) ? 1 : -1;
        var err = dx - dy;
        while (true) {
            if (hasPixel(x1, y1)) {
                setPixel(x1, y1, color);
            }
            if (x1 == x2 && y1 == y2) break;
            var e2 = 2 * err;
            if (e2 > -dy) { err -= dy; x1 += sx; }
            if (e2 < dx) { err += dx; y1 += sy; }
        }
    }

    /**
        Draws a `LineSegment2D` object using the given color.

        If the line segment is not completely within the image, 
        it doesnt throw an error, but just draws the part of the 
        line segment that is within the image.

        @param line The line segment to draw.
        @param color The color to draw the line segment with.

        @see LineSegment2D
    **/
    public function drawLineSegment2D(line:LineSegment2D, color:Color) {
        var p1 = IntPoint2D.fromPoint2D(line.start);
        var p2 = IntPoint2D.fromPoint2D(line.end);
        var x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y;
        var dx = Math.abs(x2 - x1);
        var dy = Math.abs(y2 - y1);
        var sx = (x1 < x2) ? 1 : -1;
        var sy = (y1 < y2) ? 1 : -1;
        var err = dx - dy;
        while (true) {
            if (hasPixel(x1, y1)) {
                setPixel(x1, y1, color);
            }
            if (x1 == x2 && y1 == y2) break;
            var e2 = 2 * err;
            if (e2 > -dy) { err -= dy; x1 += sx; }
            if (e2 < dx) { err += dx; y1 += sy; }
        }
    }

    /**
        Draws a curved line specified by a line and one control point.

        This method draws a quadratic Bezier curve.

        @param line The line to draw.
        @param control The control point of the curve.
        @param color The color to draw the line with.
        @param accuracy The number of iterations to use when drawing the curve. the higher the number, the more iterations are used, and the more accurate the curve is. for example, accuracy of 100 will draw the curve with 100 iterations, and will draw 100 points on the curve. **default is 1000**

        @see LineSegment2D
    **/
    public function drawQuadraticBezier(line:LineSegment2D, control:IntPoint2D, color:Color, ?accuracy:Float = 1000) {
        
        function bezier(t:Float, p0:IntPoint2D, p1:IntPoint2D, p2:IntPoint2D):IntPoint2D {
            var t2 = t * t;
            var t3 = t2 * t;
            return new Point2D(
                p0.x * (1 - t) * (1 - t) + p1.x * 2 * t * (1 - t) + p2.x * t * t,
                p0.y * (1 - t) * (1 - t) + p1.y * 2 * t * (1 - t) + p2.y * t * t
            );
        }
        
        var p0 = IntPoint2D.fromPoint2D(line.start);
        var p1 = IntPoint2D.fromPoint2D(line.end);
        var p2 = IntPoint2D.fromPoint2D(control);
        var i = 0.;
        var step = 1 / accuracy;
        while (i <= 1) {
            var p = bezier(i, p0, p1, p2);
            if (hasPixel(p.x, p.y)) {
                setPixel(p.x, p.y, color);
            }
            i += step;
        }
    }

    /**
        Draws a curved line specified by a line and two control points.

        This method draws a cubic Bezier curve.

        @param line The line to draw.
        @param control1 The first control point of the curve.
        @param control2 The second control point of the curve.
        @param color The color to draw the curve with.
        @param accuracy The number of iterations to use when drawing the curve. the higher the number, the more iterations are used, and the more accurate the curve is. for example, accuracy of 100 will draw the curve with 100 iterations, and will draw 100 points on the curve. **default is 1000**

        @see LineSegment2D
    **/
    public function drawCubicBezier(line:LineSegment2D, control1:IntPoint2D, control2:IntPoint2D, color:Color, ?accuracy:Float = 1000) {
        
        function bezier(t:Float, p0:IntPoint2D, p1:IntPoint2D, p2:IntPoint2D, p3:IntPoint2D):IntPoint2D {
            var cX = 3 * (p1.x - p0.x),
                bX = 3 * (p2.x - p1.x) - cX,
                aX = p3.x - p0.x - cX - bX;
                  
            var cY = 3 * (p1.y - p0.y),
                bY = 3 * (p2.y - p1.y) - cY,
                aY = p3.y - p0.y - cY - bY;
                  
            var x = (aX * Math.pow(t, 3)) + (bX * Math.pow(t, 2)) + (cX * t) + p0.x;
            var y = (aY * Math.pow(t, 3)) + (bY * Math.pow(t, 2)) + (cY * t) + p0.y;
                  
            return {x: x, y: y};
        }

        var i = 0.;
        var step = 1 / accuracy;
        while (i < 1) {
            var p = bezier(i, line.start, line.end, control1, control2);
            if (hasPixel(p.x, p.y)) {
                setPixel(p.x, p.y, color);
            }
            i += step;
        }
    }

    /**
        Draws a circle of the given color:

         - The center of the circle is at (X, Y)
         - The radius of the circle is r
         - Anti-aliasing will not be used.

        @param x The x coordinate of the center of the circle.
        @param y The y coordinate of the center of the circle.
        @param r The radius of the circle.
        @param color The color to draw the circle with.
    **/
    public function drawCircle(X:Int, Y:Int, r:Int, color:Color) {
        var x = -r, y = 0, err = 2 - 2 * r;
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
        Draws an ellipse of the given color:

         - The center of the ellipse is at (X, Y)
         - The radius of the ellipse is r
         - Anti-aliasing will not be used.

        @param centerX The x coordinate of the center of the ellipse.
        @param centerY The y coordinate of the center of the ellipse.
        @param radiusX The x radius of the ellipse.
        @param radiusY The y radius of the ellipse.
        @param color The color to draw the ellipse with.
    **/
    public function drawEllipse(centerX:Int, centerY:Int, radiusX:Int, radiusY:Int, color:Color) {
        var x:Int, y:Int, xChange:Float, yChange:Float, ellipseError:Float, twoASquare:Float, twoBSquare:Float, stoppingX:Float, stoppingY:Float;
        twoASquare = 2 * radiusX * radiusX;
        twoBSquare = 2 * radiusY * radiusY;
        x = radiusX - 1;
        //weird fix for that one pixel bulging
        var b = true;
        y = 0;
        xChange = radiusY * radiusY * (1 - 2 * radiusX);
        yChange = radiusX * radiusX;
        ellipseError = 0;
        stoppingX = twoBSquare * radiusX;
        stoppingY = 0;
        while (stoppingX >= stoppingY) {
            setPixel(centerX + x, centerY + y, color);
            setPixel(centerX - x, centerY + y, color);
            setPixel(centerX + x, centerY - y, color);
            setPixel(centerX - x, centerY - y, color);
            if (b) {x++; b = false;}
            if (ellipseError <= 0) {
                y++;
                stoppingY += twoASquare;
                ellipseError += yChange;
                yChange += twoASquare;
            }
            if (ellipseError > 0) {
                x--;
                stoppingX -= twoBSquare;
                ellipseError += xChange;
                xChange += twoBSquare;
            }
        }
        ellipseError = radiusY * radiusY / 4 - radiusX * radiusX * (radiusY - 0.5);
        x = 0;
        y = radiusY;
        xChange = radiusY * radiusY;
        yChange = radiusX * radiusX * (1 - 2 * radiusY);
        stoppingX = 0;
        stoppingY = twoASquare * radiusY;
        while (stoppingX <= stoppingY) {
            setPixel(centerX + x, centerY + y, color);
            setPixel(centerX - x, centerY + y, color);
            setPixel(centerX + x, centerY - y, color);
            setPixel(centerX - x, centerY - y, color);
            if (ellipseError <= 0) {
                x++;
                stoppingX += twoBSquare;
                ellipseError += xChange;
                xChange += twoBSquare;
            }
            if (ellipseError > 0) {
                y--;
                stoppingY -= twoASquare;
                ellipseError += yChange;
                yChange += twoASquare;
            }
        }
        
    }

    /**
        Recursively fills a section of the image. the section filled has to match
        `position`'s color.

        when the fill encounters a color that is not `position`'s color, it
        will stop filling in that direction.

        **Warning** - this function is recursive. This function is not slow, but can trigger
        a stack overflow if used on large images. This is only here so an implementation will be available.

        @param position The position to start filling at. you can use a Point2D or IntPoint2D.
        @param color The color to fill with.
    **/
    public function fillColorRecursive(position:IntPoint2D, color:Color) {
        var originalColor = getPixel(position.x, position.y);

        function expandFill(x:Int, y:Int) {
            if (x < 0 || x >= this.length || y < 0 || y >= this[x].length) {
                return;
            }
            if (getPixel(x, y) == color) return;
            if (getPixel(x, y) == originalColor) {
                setPixel(x, y, color);
                expandFill(x + 1, y);
                expandFill(x - 1, y);
                expandFill(x, y + 1);
                expandFill(x, y - 1);
            }
        }
        expandFill(position.x, position.y);
    }

    /**
        Fills a section of the image. the section filled has to match
        `position`'s color.

        This uses the BFS `Breadth First Search` algorithm

        @param position The position to start filling at. you can use a Point2D or IntPoint2D.
        @param color The color to fill with.
    **/
    public function fillColor(position:IntPoint2D, color:Color) {

        var queue = new List<IntPoint2D>();
        queue.push({x: position.x, y: position.y});
        var explored:Array<Int64> = [];
        var originalColor = getPixel(position.x, position.y);
        function fill(v:IntPoint2D) {
            if (hasPixel(v.x, v.y) && getPixel(v.x, v.y) == originalColor && !explored.contains(Int64.make(v.x, v.y))) {
                queue.push({x: v.x, y: v.y});
                setPixel(v.x, v.y, color);
            }
        }
        while (queue.length > 0) {
            var v = queue.pop();
            explored.push(Int64.make(v.x, v.y));
            fill({x: v.x + 1, y: v.y    });
            fill({x: v.x    , y: v.y + 1});
            fill({x: v.x - 1, y: v.y    });
            fill({x: v.x    , y: v.y - 1});
        }
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

    public function mirror():Image {
        this.sort((e, f) -> 1);
        return cast this;
    }

    public function flip():Image {
        for (x in 0...width) {
            this[x].sort((e, f) -> 1);
        }
        return cast this;
    }

    //--------------------------------------------------------------------------
    // Convinience
    //--------------------------------------------------------------------------

     /**
        Gets the image as a string.

        @param special When using the `Console.hx` haxelib, images can be prined to the console
        with color. set this to false if you dont want this to happen. Set to `true` by default.
    **/
    public function toString(?special:Bool = true):String {
        if (!special) {
            return Std.string(this);
        }
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
    #if flixel
    @:to public function toFlxSprite():flixel.FlxSprite {
        ImageTools.toFlxSprite(this);
    }
    @:from public static function fromFlxSprite(sprite:flixel.FlxSprite):Image {
        return ImageTools.fromFlxSprite(sprite);
    }
    #end
    #if openfl
    @:to public function toBitmapData():flash.display.BitmapData {
        return ImageTools.toBitmapData(this);
    }
    @:from public static function fromBitmapData(bitmapData:flash.display.BitmapData):Image {
        return ImageTools.fromBitmapData(bitmapData);
    }
    @:from public static function fromShape(shape:flash.display.Shape):Image {
        return ImageTools.fromShape(shape);
    }
    @:from public static function fromSprite(sprite:flash.display.Sprite):Image {
        return ImageTools.fromSprite(sprite);
    }
    #end
    #if lime
    @:to public function toLimeImage():lime.graphics.Image {
        return ImageTools.toLimeImage(this);
    }
    @:from public static function fromLimeImage(image:lime.graphics.Image):Image {
        return ImageTools.fromLimeImage(image);
    }
    #end
    #if kha
    @:from public static function fromKhaImage(image:kha.Image):Image {
        return ImageTools.fromKhaImage(image);
    }
    #end
    #if heaps
    @:from public static function fromHeapsBitmapData(bitmapData:hxd.BitmapData):Image {
        return ImageTools.fromHeapsBitmapData(bitmapData);
    }
    #end

    //--------------------------------------------------------------------------
    // Other From/Tos
    //--------------------------------------------------------------------------

    @:from public static function from2DArray(array:Array<Array<Color>>):Image {
        var maxLength = 0;
        for (arr in array) {
            if (arr.length > maxLength) maxLength = arr.length;
        }

        var image = new Image(array.length, maxLength);
        for (i in 0...array.length) {
            image[i] = Vector.fromArrayCopy(array[i]);
        }

        return image;
    }    
}
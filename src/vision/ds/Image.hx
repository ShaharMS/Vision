package vision.ds;

import haxe.io.UInt8Array;
import vision.exceptions.Unimplemented;
import vision.tools.MathTools;
import vision.algorithms.BilinearInterpolation;
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
abstract Image(UInt8Array) {
	/**
	 * the first 4 bytes represent width.
	 */
	static var OFFSET = 4;

	/**
		Returns the underlying type of this abstract.
	**/
	public var underlying(get, #if vision_allow_resize set #else never #end):UInt8Array;

	inline function get_underlying() {
		return this;
	}

	#if vision_allow_resize
	inline function set_underlying(bytes:UInt8Array) {
		return this = bytes;
	}
	#end

	/**
		The width of the image.
	**/
	public var width(get, #if vision_allow_resize set #else never #end):Int;

	inline function get_width() {
		return this[0] | this[1] << 8 | this[2] << 16 | this[3] << 24;
	}

	#if vision_allow_resize
	inline function set_width(value:Int) {
		resize(value, height);
	}
	#end

	/**
		The height of the image.
	**/
	public var height(get, #if vision_allow_resize set #else never #end):Int;

	inline function get_height()
		return Math.ceil((this.length - OFFSET) / (width * 4));

	#if vision_allow_resize
	inline function set_height(value:Int) {
		resize(width, value);
	}
	#end

	/**
		Creates a new image of the given size. Onces created, the image cannot be resized.

		@param width The width of the image.
		@param height The height of the image.
		@param color The color to fill the image with. if unspecified, the image is transparent.
	**/
	public inline function new(width:Int, height:Int, ?color:Color = 0x00000000) {
		this = new UInt8Array(width * height * 4 + OFFSET);
		this[0] = width & 0xFF;
		this[1] = width >> 8 & 0xFF;
		this[2] = width >> 16 & 0xFF;
		this[3] = width >> 24 & 0xFF;
		var i = 4;
		while (i < this.length) {
			this[i] = color.alpha;
			this[i + 1] = color.red;
			this[i + 2] = color.green;
			this[i + 3] = color.blue;
			i += 4;
		}
	}

	inline function getColorFromStartingBytePos(position:Int):Color {
		position += OFFSET;
		var c = new Color();
		c.alpha = this[position];
		c.red = this[position + 1];
		c.green = this[position + 2];
		c.blue = this[position + 3];

		return c;
	}

	inline function setColorFromStartingBytePos(position:Int, c:Color) {
		position += OFFSET;
		this[position] = c.alpha;
		this[position + 1] = c.red;
		this[position + 2] = c.green;
		this[position + 3] = c.blue;

		return c;
	}

	/**
		Gets the color of the pixel at the given coordinates.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@throws OutOfBounds if the coordinates are out of bounds.
		@return The color of the pixel at the given coordinates.
	**/
	public inline function getPixel(x:Int, y:Int):Color {
		if (!hasPixel(x, y)) {
			#if !vision_quiet
			throw new OutOfBounds(cast this, new IntPoint2D(x, y));
			#else
			var gettable:IntPoint2D = new IntPoint2D(0, 0);
			var ox = x;
			var oy = y;
			if (ox < 0 && oy < 0)
				gettable.x = gettable.y = 0;
			else if (ox < 0 && oy >= height) {
				gettable.x = 0;
				gettable.y = height - 1;
			} else if (ox >= width && oy < 0) {
				gettable.x = width - 1;
				gettable.y = 0;
			} else if (ox >= width && oy >= height) {
				gettable.x = width - 1;
				gettable.y = height - 1;
			} else if (ox < 0) {
				gettable.x = 0;
				gettable.y = oy;
			} else if (oy < 0) {
				gettable.x = ox;
				gettable.y = 0;
			} else if (ox >= width) {
				gettable.x = width - 1;
				gettable.y = oy;
			} else if (oy >= height) {
				gettable.x = ox;
				gettable.y = height - 1;
			}
			x = gettable.x;
			y = gettable.y;
			#end
		}
		return getColorFromStartingBytePos((y * width + x) * 4);
	}

	/**
		Gets the color of the pixel at the given coordinates.

		Coordinates outside the bounds of the image are allowed.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@return The color of the pixel at the given coordinates.
	**/
	public inline function getSafePixel(x:Int, y:Int):Color {
		if (!hasPixel(x, y)) {
			var gettable:IntPoint2D = new IntPoint2D(0, 0);
			var ox = x;
			var oy = y;
			if (ox < 0 && oy < 0)
				gettable.x = gettable.y = 0;
			else if (ox < 0 && oy >= height) {
				gettable.x = 0;
				gettable.y = height - 1;
			} else if (ox >= width && oy < 0) {
				gettable.x = width - 1;
				gettable.y = 0;
			} else if (ox >= width && oy >= height) {
				gettable.x = width - 1;
				gettable.y = height - 1;
			} else if (ox < 0) {
				gettable.x = 0;
				gettable.y = oy;
			} else if (oy < 0) {
				gettable.x = ox;
				gettable.y = 0;
			} else if (ox >= width) {
				gettable.x = width - 1;
				gettable.y = oy;
			} else if (oy >= height) {
				gettable.x = ox;
				gettable.y = height - 1;
			}
			return getPixel(gettable.x, gettable.y);
		}
		return getPixel(x, y);
	}

	/**
		Gets the color of the pixel at the given coordinates.
		These coordinates can also be of type `Float`, in which case
		the value returned should be an interpolation of the surrounding, physical pixels:

		### How Does This Work?

		Lets say we want the pixel at `(0.5, 0.5)`:
		```
		(0,0)   (1,0)                                     
														 
			  ·     < Y (0.5)                      
														 
		(0,1)   (1,1)                                     
			  ^                                           
			X (0.5)                                        
		```

		First, we're going to calculate the actual fraction - the means, extracting the numbetrs after the decimal point:

			final xFraction = x - Std.int(x);
			final yFraction = y - Std.int(y);


		Then, we just multiply each of the surrounding pixel's value by it's distance from the initial X value (using `xFraction` and `yFraction`):

			final pixelsBeforeYMultiplier = 1 - yFraction, pixelsAfterYMultiplier = yFraction;
			final pixelsBeforeXMultiplier = 1 - xFraction, pixelsAfterXMultiplier = xFraction;
			final bottomLayer = pixelsBeforeYMultiplier * (pixelsBeforeXMultiplier * getPixel(Std.int(x), Std.int(y)) + pixelsAfterXMultiplier * getPixel(Std.int(x) + 1, Std.int(y)));
			final topLayer = pixelsAfterYMultiplier * (pixelsBeforeXMultiplier * getPixel(Std.int(x), Std.int(y) + 1) + pixelsAfterXMultiplier * getPixel(Std.int(x) + 1, Std.int(y) + 1));


		And add the two layers to get the result:


			var finalColor:Color = Std.int(bottomLayer + topLayer);


		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@throws OutOfBounds if the coordinates are out of bounds.
		@return The color of the pixel at the given coordinates.
	**/
	public inline function getFloatingPixel(x:Float, y:Float):Color {
		#if !vision_quiet
		if (!hasPixel(Math.ceil(x), Math.ceil(y)))
			throw new OutOfBounds(cast this, {x: x, y: y});
		#end
		final yfrac = y - Std.int(y), xfrac = x - Std.int(x);
		return Std.int((1 - yfrac) * ((1 - xfrac) * getPixel(Std.int(x), Std.int(y)) + xfrac * getPixel(Std.int(x) + 1, Std.int(y)))
			+ yfrac * ((1 - xfrac) * getPixel(Std.int(x), Std.int(y) + 1) + xfrac * getPixel(Std.int(x) + 1, Std.int(y) + 1)));
	}

	/**
		Sets the color of the pixel at the given coordinates.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.
		@param color The color to set the pixel to.

		@throws OutOfBounds if the pixel is out of bounds.
	**/
	public inline function setPixel(x:Int, y:Int, color:Color) {
		if (!hasPixel(x, y)) {
			#if vision_quiet
			return;
			#else
			throw new OutOfBounds(cast this, new IntPoint2D(x, y));
			#end
		}
		setColorFromStartingBytePos((y * width + x) * 4, color);
	}

	/**
		Checks if the given coordinates are within the bounds of the image.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@return True if the coordinates are within the bounds of the image.
	**/
	public inline function hasPixel(x:Int, y:Int):Bool {
		return (x >= 0 && y >= 0 && x < width && y < height);
	}

	/**
		Copies a pixel from the given image to this image.

		@param image The image to copy the pixel from.
		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@throws OutOfBounds if the given coordinates are outside the bounds of one or both of the images
		@return The color of the pixel at the given coordinates.
	**/
	public inline function copyPixelFrom(image:Image, x:Int, y:Int):Color {
		final c = image.getPixel(x, y);
		setPixel(x, y, c);
		return c;
	}

	/**
		Copies a pixel from the given image to this image.

		@param image The image to copy the pixel to.
		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@throws OutOfBounds if the given coordinates are outside the bounds of one or both of the images
		@return The color of the pixel at the given coordinates.
	**/
	public inline function copyPixelTo(image:Image, x:Int, y:Int):Color {
		final c = getPixel(x, y);
		image.setPixel(x, y, c);
		return c;
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
	public inline function paintPixel(x:Int, y:Int, color:Color) {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			throw new OutOfBounds(cast this, new IntPoint2D(x, y));
		}
		var oldColor = getPixel(x, y);
		var newColor = Color.fromRGBAFloat(color.redFloat * color.alphaFloat
			+ oldColor.redFloat * (1 - color.alphaFloat),
			color.greenFloat * color.alphaFloat
			+ oldColor.greenFloat * (1 - color.alphaFloat),
			color.blueFloat * color.alphaFloat
			+ oldColor.blueFloat * (1 - color.alphaFloat), 1);
		setPixel(x, y, newColor);
	}

	/**
		Sets a rectangle of pixels to the given color, essentially filling it with the given color.

		@param rect The rectangle to fill: The fill starts at (x, y) and extends to (x + width, y + height), not including the endpoints.
		@param color The color to fill that rectangular portion with.
	**/
	public inline function fillRect(x:Int, y:Int, width:Int, height:Int, color:Color) {
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
	public inline function drawRect(x:Int, y:Int, width:Int, height:Int, color:Color) {
		drawLine(x, y, x + width, y, color);
		drawLine(x + width, y, x + width, y + height, color);
		drawLine(x + width, y + height, x, y + height, color);
		drawLine(x, y + height, x, y, color);
	}

	/**
		Returns a portion of the image, specified by a rectangle.

		@param rect The rectangle specifying the portion of the image to return.

		@throws OutOfBounds if the portion of the image to get is outside the bounds of the original image.
		@return A new image containing the specified portion of the original image.
	**/
	public inline function getImagePortion(rect:Rectangle):Image {
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
	public inline function setImagePortion(rect:Rectangle, image:Image) {
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
	public inline function drawLine(x1:Int, y1:Int, x2:Int, y2:Int, color:Color) {
		var dx = Math.abs(x2 - x1);
		var dy = Math.abs(y2 - y1);
		var sx = (x1 < x2) ? 1 : -1;
		var sy = (y1 < y2) ? 1 : -1;
		var err = dx - dy;
		while (true) {
			setPixel(x1, y1, color);
			if (x1 == x2 && y1 == y2)
				break;
			var e2 = 2 * err;
			if (e2 > -dy) {
				err -= dy;
				x1 += sx;
			}
			if (e2 < dx) {
				err += dx;
				y1 += sy;
			}
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
	public inline function drawRay2D(line:Ray2D, color:Color) {
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
			if (x1 == x2 && y1 == y2)
				break;
			var e2 = 2 * err;
			if (e2 > -dy) {
				err -= dy;
				x1 += sx;
			}
			if (e2 < dx) {
				err += dx;
				y1 += sy;
			}
		}
	}

	/**
		Draws a `Line2D` object using the given color.

		If the line segment is not completely within the image, 
		it doesnt throw an error, but just draws the part of the 
		line segment that is within the image.

		@param line The line segment to draw.
		@param color The color to draw the line segment with.

		@see Line2D
	**/
	public inline function drawLine2D(line:Line2D, color:Color) {
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
			if (x1 == x2 && y1 == y2)
				break;
			var e2 = 2 * err;
			if (e2 > -dy) {
				err -= dy;
				x1 += sx;
			}
			if (e2 < dx) {
				err += dx;
				y1 += sy;
			}
		}
	}

	/**
		Draws a curved line specified by a line and one control point.

		This method draws a quadratic Bezier curve.

		@param line The line to draw.
		@param control The control point of the curve.
		@param color The color to draw the line with.
		@param accuracy The number of iterations to use when drawing the curve. the higher the number, the more iterations are used, and the more accurate the curve is. for example, accuracy of 100 will draw the curve with 100 iterations, and will draw 100 points on the curve. **default is 1000**

		@see Line2D
	**/
	public inline function drawQuadraticBezier(line:Line2D, control:IntPoint2D, color:Color, ?accuracy:Float = 1000) {
		function bezier(t:Float, p0:IntPoint2D, p1:IntPoint2D, p2:IntPoint2D):IntPoint2D {
			var t2 = t * t;
			var t3 = t2 * t;
			return new Point2D(p0.x * (1 - t) * (1 - t)
				+ p1.x * 2 * t * (1 - t)
				+ p2.x * t * t,
				p0.y * (1 - t) * (1 - t)
				+ p1.y * 2 * t * (1 - t)
				+ p2.y * t * t);
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

		@see Line2D
	**/
	public inline function drawCubicBezier(line:Line2D, control1:IntPoint2D, control2:IntPoint2D, color:Color, ?accuracy:Float = 1000) {
		inline function bezier(t:Float, p0:IntPoint2D, p1:IntPoint2D, p2:IntPoint2D, p3:IntPoint2D):IntPoint2D {
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
			var p =
			inline bezier(i, line.start, line.end, control1, control2);
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
	public inline function drawCircle(X:Int, Y:Int, r:Int, color:Color) {
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
	public inline function drawEllipse(centerX:Int, centerY:Int, radiusX:Int, radiusY:Int, color:Color) {
		var x:Int,
			y:Int,
			xChange:Float,
			yChange:Float,
			ellipseError:Float,
			twoASquare:Float,
			twoBSquare:Float,
			stoppingX:Float,
			stoppingY:Float;
		twoASquare = 2 * radiusX * radiusX;
		twoBSquare = 2 * radiusY * radiusY;
		x = radiusX - 1;
		// weird fix for that one pixel bulging
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
			if (b) {
				x++;
				b = false;
			}
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
			if (x < 0 || x >= height || y < 0 || y >= width) {
				return;
			}
			if (getPixel(x, y) == color)
				return;
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
		var pc = 0;
		inline function fill(v:IntPoint2D) {
			if (pc >= 100000) {
				trace("fillColor: too much iterations");
				queue.clear();
				return;
			}
			if (hasPixel(v.x, v.y) && getPixel(v.x, v.y) == originalColor && !explored.contains(Int64.make(v.x, v.y))) {
				pc++;
				queue.push({x: v.x, y: v.y});
				setPixel(v.x, v.y, color);
			}
		}
		while (queue.length > 0) {
			var v = queue.pop();
			explored.push(Int64.make(v.x, v.y));
			fill({x: v.x + 1, y: v.y});
			fill({x: v.x, y: v.y + 1});
			fill({x: v.x - 1, y: v.y});
			fill({x: v.x, y: v.y - 1});
		}
	}

	/**
		Fills a section of the image. the section filled has to be bordered by pixels of color `borderColor`.

		This uses the BFS `Breadth First Search` algorithm

		@param position The position to start filling at. you can use a Point2D or IntPoint2D.
		@param color The color to fill with.
		@param borderColor The color upon which to stop filling.
	**/
	public function fillUntilColor(position:IntPoint2D, color:Color, borderColor:Color) {
		var queue = new List<IntPoint2D>();
		queue.push({x: position.x, y: position.y});
		var explored:Array<Int64> = [];
		var pc = 0;
		function fill(v:IntPoint2D) {
			if (pc >= 100000) {
				trace("fillColor: too much iterations");
				queue.clear();
				return;
			}
			if (!hasPixel(v.x, v.y))
				return;
			if (explored.contains(Int64.make(v.x, v.y)))
				return;
			if (getPixel(v.x, v.y) == color)
				return;
			if (getPixel(v.x, v.y) != borderColor) {
				pc++;
				queue.push({x: v.x, y: v.y});
				setPixel(v.x, v.y, color);
			}
		}
		while (queue.length > 0) {
			var v = queue.pop();
			explored.push(Int64.make(v.x, v.y));
			fill({x: v.x + 1, y: v.y});
			fill({x: v.x, y: v.y + 1});
			fill({x: v.x - 1, y: v.y});
			fill({x: v.x, y: v.y - 1});
		}
	}

	/**
		Clones this image.
	**/
	public function clone():Image {
		var clone = new Image(width, height, 0);
		for (i in 0...width) {
			for (j in 0...height) {
				clone.setPixel(i, j, getPixel(i, j));
			}
		}
		return clone;
	}

	//--------------------------------------------------------------------------
	// General Manipuation
	//--------------------------------------------------------------------------

	public function mirror():Image {
		var inter = clone();
		forEachPixel((x, y, color) -> {
			setPixel(x, y, inter.getPixel(inter.width - x - 1, y));
		});
		return cast this;
	}

	public function flip():Image {
		var inter = clone();
		forEachPixel((x, y, color) -> {
			setPixel(x, y, inter.getPixel(x, inter.height - y - 1));
		});
		return cast this;
	}

	public inline function resize(newWidth:Int, newHeight:Int, ?algorithm:ImageResizeAlgorithm):Image {
		if (algorithm == null)
			algorithm = ImageTools.defaultResizeAlgorithm;
		switch algorithm {
			case BilinearInterpolation:
				this = cast BilinearInterpolation.interpolate(cast this, newWidth, newHeight);
			case BicubicInterpolation:
				throw new Unimplemented("Bicubic Interpolation");
			case NearestNeighbor:
				{
					var image = new Image(newWidth, newHeight);
					var xMulitiplier = image.width / width;
					var yMulitiplier = image.height / height;
					forEachPixel((x, y, color) -> {
						var color = image.getPixel(MathTools.floor(x * xMulitiplier), MathTools.floor(y * yMulitiplier));
						image.setPixel(x, y, color);
					});
				}
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
		var prevY = 0;
		forEachPixel((x, y, color) -> {
			if (prevY != y) {
				prevY = y;
				s += "\n";
			}
			s += color.toString();
		});
		return s;
	}

	public inline function forEachPixel(callback:(x:Int, y:Int, color:Color) -> Void) {
		for (x in 0...width) {
			for (y in 0...height) {
				callback(x, y, getPixel(x, y));
			}
		}
	}

	public inline function iterator():Iterator<Pixel> {
		return new PixelIterator(cast this);
	}

	//--------------------------------------------------------------------------
	// Framework-specific methods
	//--------------------------------------------------------------------------
	#if flixel
	@:to public function toFlxSprite():flixel.FlxSprite {
		return ImageTools.toFlxSprite(cast this);
	}

	@:from public static function fromFlxSprite(sprite:flixel.FlxSprite):Image {
		return ImageTools.fromFlxSprite(sprite);
	}
	#end

	#if openfl
	@:to public function toBitmapData():flash.display.BitmapData {
		return ImageTools.toBitmapData(cast this);
	}

	@:from public static function fromBitmapData(bitmapData:flash.display.BitmapData):Image {
		return ImageTools.fromBitmapData(bitmapData);
	}

	@:to public function toShape():flash.display.Shape {
		return ImageTools.toShape(cast this);
	}

	@:from public static function fromShape(shape:flash.display.Shape):Image {
		return ImageTools.fromShape(shape);
	}

	@:to public function toSprite():flash.display.Sprite {
		return ImageTools.toSprite(cast this);
	}

	@:from public static function fromSprite(sprite:flash.display.Sprite):Image {
		return ImageTools.fromSprite(sprite);
	}
	#end

	#if lime
	@:to public function toLimeImage():lime.graphics.Image {
		return ImageTools.toLimeImage(cast this);
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
    @:from public static function fromHeapsPixels(pixels:hxd.Pixels):Image {
        return ImageTools.fromHeapsPixels(pixels);
    }
    @:to public function toHeapsPixels():hxd.Pixels {
        return ImageTools.toHeapsPixels(cast this);
    }
    #end

	//--------------------------------------------------------------------------
	// Other From/Tos
	//--------------------------------------------------------------------------

	@:from public static function from2DArray(array:Array<Array<Color>>):Image {
		var maxLength = 0;
		for (arr in array) {
			if (arr.length > maxLength)
				maxLength = arr.length;
		}

		var image = new Image(array.length, maxLength);
		for (x in 0...array.length) {
			for (y in 0...array[x].length) {
				image.setPixel(x, y, array[x][y]);
			}
		}

		return image;
	}
}

private class PixelIterator {
	var i = 4;
	var img:Image;

	public inline function new(img:Image) {
		this.img = img;
	}

	public inline function next():Pixel {
		final x = i % img.width;
		final y = Math.floor(i / img.width);
		var pixel:Pixel = {x: x, y: y, color: img.getPixel(x, y)};
		i += 4;
		return pixel;
	}

	public inline function hasNext():Bool {
		return i < (cast img:UInt8Array).length;
	}
}

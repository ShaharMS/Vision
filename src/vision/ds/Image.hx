package vision.ds;

import haxe.io.Bytes;
import vision.ds.ByteArray;
import haxe.io.UInt8Array;
import vision.exceptions.Unimplemented;
import vision.tools.MathTools;
import vision.algorithms.BilinearInterpolation;
import haxe.ds.List;
import haxe.Int64;
import vision.ds.Color;
import vision.exceptions.OutOfBounds;
import vision.tools.ImageTools;

using vision.tools.MathTools;

/**
	Represents a 2D image, as a matrix of Colors.
**/
abstract Image(ByteArray) {
	/**
		the first 4 bytes represent image width,
		the next 8 bytes are the x & y position of an image view, if defined,
		the next 8 bytes are the width & height of an image view, if defined,
	**/
	static var OFFSET = 21;

	static var WIDTH_BYTES = 4;
	static var VIEW_XY_BYTES = 8;
	static var VIEW_WH_BYTES = 8;
	static var VIEW_SHAPE_BYTES = 1;
	static var DATA_GAP = 4;

	/**
		Returns the underlying type of this abstract.
	**/
	public var underlying(get, #if vision_allow_resize set #else never #end):ByteArray;

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
		return this.getInt32(0);
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
		this = new ByteArray(width * height * 4 + OFFSET);
		this.setInt32(0, width);
		this.setInt32(WIDTH_BYTES, 0);
		this.setInt32(WIDTH_BYTES + DATA_GAP, 0);
		this.setInt32(WIDTH_BYTES + VIEW_XY_BYTES, width);
		this.setInt32(WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP, height);
		this.setInt32(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES, 0);
		var i = OFFSET;
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
		return new Color(this[position] << 24 | this[position + 1] << 16 | this[position + 2] << 8 | this[position + 3]); 
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
			return getSafePixel(x, y);
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
			return getPixel(x.clamp(0, width), y.clamp(0, height));
		}
		return getPixel(x, y);
	}

	@:allow(vision)
	inline function getUnsafePixel(x:Int, y:Int):Color {
		return getColorFromStartingBytePos((y * width + x) * 4);
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

		First, we're going to calculate the actual fraction - the means, extracting the numbers after the decimal point:

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
		final yFraction = y - Std.int(y), xFraction = x - Std.int(x);
		final red =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).red + xFraction * getPixel(Std.int(x) + 1, Std.int(y)).red) + yFraction * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y) + 1).red + xFraction * getPixel(Std.int(x) + 1, Std.int(y) + 1).red));
		final green =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).green + xFraction * getPixel(Std.int(x) + 1, Std.int(y)).green) + yFraction * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y) + 1).green + xFraction * getPixel(Std.int(x) + 1, Std.int(y) + 1).green));
		final blue =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).blue + xFraction * getPixel(Std.int(x) + 1, Std.int(y)).blue) + yFraction * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y) + 1).blue + xFraction * getPixel(Std.int(x) + 1, Std.int(y) + 1).blue));
		final alpha =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).alpha + xFraction * getPixel(Std.int(x) + 1, Std.int(y)).alpha) + yFraction * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y) + 1).alpha + xFraction * getPixel(Std.int(x) + 1, Std.int(y) + 1).alpha));
		return Color.fromRGBA(red, green, blue, alpha);
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
			#else
			throw new OutOfBounds(cast this, new IntPoint2D(x, y));
			#end
		} else {
			if (hasCurrentView()) {
				final view = getCurrentView();
				if (x < view.x + view.width && y < view.y + view.height && x >= view.x && y >= view.y) {
					setColorFromStartingBytePos((y * width + x) * 4, color);
				}
			} else {
				setColorFromStartingBytePos((y * width + x) * 4, color);
			}
		}	
		
	}

	inline function setInsideView(x:Int, y:Int, color:Color) {
		
	}

	public inline function hasPixelInView(x:Int, y:Int):Bool {
		var has = false;
		final view = getCurrentView();
		switch view.shape {
			case RECTANGLE: has = (x < view.x + view.width && y < view.y + view.height && x >= view.x && y >= view.y);
			case ELLIPSE: {
				//calculate the focal points of the ellipse
				//c^2 = a^2 - b^2
				if (view.width > view.height) {
					final c = MathTools.sqrt((view.width)*(view.width) - (view.height)*(view.height));
					final dc = new Point2D(view.x + view.width / 2 + c, view.y + view.height / 2).distanceBetweenPoints(new Point2D(x, y));
					final dmc = new Point2D(view.x + view.width / 2 - c, view.y + view.height / 2).distanceBetweenPoints(new Point2D(x, y));
					has = dc + dmc < view.width * 2;
				} else {

				}
			}
		}
		return has;
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
		return image.copyPixelFrom(cast this, x, y);
	}

	/**
		Sets the color of a pixel, but doesn't completely overwrite the pixel:

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
		Draws an intine line specified by a Ray2D object.

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
		it doesn't throw an error, but just draws the part of the 
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
	 	Fills a circle with the given color:

		 - The center of the circle is at (X, Y)
		 - The radius of the circle is r
		 - Anti-aliasing will not be used.

		@param x The x coordinate of the center of the circle.
		@param y The y coordinate of the center of the circle.
		@param r The radius of the circle.
		@param color The color to draw the circle with.
	**/
	public inline function fillCircle(X:Int, Y:Int, r:Int, color:Color) {
		var points:Array<IntPoint2D> = [];
		var x = -r, y = 0, err = 2 - 2 * r;
		do {
			points.push({x: X + x, y: Y - y});
			points.push({x: X - x, y: Y + y});
			points.push({x: X - y, y: Y - x});
			points.push({x: X + y, y: Y + x});
			r = err;
			if (r <= y) {
				err += ++y * 2 + 1;
			}
			if (r > x || err > y) {
				err += ++x * 2 + 1;
			}
		} while (x < 0);

		var values:Array<Array<Int>> = [];
		for (p in points) {
			if (values[p.x] == null) values[p.x] = [];
			values[p.x].push(p.y);
		}

		for (y in 0...values.length) {
			if (values[y] == null) continue;
			var min:Int = MathTools.min(values[y]);
			var max:Int = MathTools.max(values[y]);
			for (i in min...max + 1) setPixel(i, y, color);
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
			setPixel(X + x, Y - y, color);
			setPixel(X - x, Y + y, color);
			setPixel(X - y, Y - x, color);
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
		inline function fill(point:IntPoint2D) {
			if (pc >= 100000) {
				trace("fillColor: too much iterations");
				queue.clear();
				return;
			}
			if (hasPixel(point.x, point.y) && getPixel(point.x, point.y) == originalColor && !explored.contains(Int64.make(point.x, point.y))) {
				pc++;
				queue.push({x: point.x, y: point.y});
				setPixel(point.x, point.y, color);
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
		inline function fill(point:IntPoint2D) {
			if (pc >= 100000) {
				trace("fillColor: too much iterations");
				queue.clear();
				return;
			}
			if (!hasPixel(point.x, point.y))
				return;
			if (explored.contains(Int64.make(point.x, point.y)))
				return;
			if (getPixel(point.x, point.y) == color)
				return;
			if (getPixel(point.x, point.y) != borderColor) {
				pc++;
				queue.push({x: point.x, y: point.y});
				setPixel(point.x, point.y, color);
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

		Useful if you want to operate on `this` image, without modifying it:

			var blurred = Vision.gaussianBlur(image.clone());
	**/
	public function clone():Image {
		return cast this.sub(0, this.length);
	}

	//--------------------------------------------------------------------------
	// General Manipulation
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
					var xMultiplier = image.width / width;
					var yMultiplier = image.height / height;
					forEachPixel((x, y, color) -> {
						var color = image.getPixel(MathTools.floor(x * xMultiplier), MathTools.floor(y * yMultiplier));
						image.setPixel(x, y, color);
					});
				}
		}

		return cast this;
	}

	//--------------------------------------------------------------------------
	// Convenience
	//--------------------------------------------------------------------------

	/**
		Gets the image as a string.

		@param special When using the `Console.hx` haxelib, images can be printed to the console
		with color. set this to false if you don't want this to happen. Set to `true` by default.
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
		final view = getCurrentView();
		for (x in 0...width) {
			for (y in 0...height) {
				if (hasCurrentView()) {
					if (x >= view.x && y >= view.y && x < view.x + view.width && y < view.y + view.height) callback(x, y, getUnsafePixel(x, y));
				} else {
					callback(x, y, getUnsafePixel(x, y));
				}
			}
		}
	}

	public inline function iterator():Iterator<Pixel> {
		return new PixelIterator(cast this);
	}

	//--------------------------------------------------------------------------
	// Image View
	//--------------------------------------------------------------------------

	public inline function hasCurrentView():Bool {
		return (
			this.getInt32(WIDTH_BYTES) != 0 ||
			this.getInt32(WIDTH_BYTES + DATA_GAP) != 0 ||
			this.getInt32(WIDTH_BYTES + VIEW_XY_BYTES) != width ||
			this.getInt32(WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP) != height ||
			this.getInt32(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES) != 0
		);
	}

	public inline function setCurrentView(x:Int, y:Int, width:Int, height:Int, shape:ImageViewShape):Image {
		this.setInt32(WIDTH_BYTES, x);
		this.setInt32(WIDTH_BYTES + DATA_GAP, y);
		this.setInt32(WIDTH_BYTES + VIEW_XY_BYTES, width);
		this.setInt32(WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP, height);
		this.setInt32(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES, shape);
		trace(getCurrentView());
		return cast this;
	}

	public inline function getCurrentView():{x:Int, y:Int, width:Int, height:Int, shape:ImageViewShape} {
		return {
			x: this.getInt32(WIDTH_BYTES),
			y: this.getInt32(WIDTH_BYTES + DATA_GAP),
			width: this.getInt32(WIDTH_BYTES + VIEW_XY_BYTES),
			height: this.getInt32(WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP),
			shape: this.getInt32(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES),
		}
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

	@:to public function toShape():openfl.display.Shape {
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
		return i < (cast img:ByteArray).length;
	}
}

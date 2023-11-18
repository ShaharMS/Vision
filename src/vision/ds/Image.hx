package vision.ds;

import vision.algorithms.GaussJordan;
import vision.ds.Matrix2D;
import haxe.Resource;
import vision.ds.ByteArray;
import vision.exceptions.Unimplemented;
import vision.tools.MathTools;
import vision.algorithms.BilinearInterpolation;
import haxe.ds.List;
import haxe.Int64;
import vision.ds.Color;
import vision.exceptions.OutOfBounds;
import vision.tools.ImageTools;
import vision.helpers.TextDrawer;
using vision.tools.MathTools;
import vision.tools.MathTools.*;

/**
	Represents a 2D image, as a matrix of Colors.
**/
@:transitive
abstract Image(ByteArray) {
	#if vision_higher_width_cap
	/**
		the first 4 bytes represent image width,  
		the next 8 bytes are the `x` & `y` position of an image view,  
		the next 8 bytes are the `width` & `height` of an image view,
		the last byte represents view shape
	**/
	#else
	/**
		the first 2 bytes represent image width,  
		the next 4 bytes are the `x` & `y` position of an image view,  
		the next 4 bytes are the `width` & `height` of an image view,
		the last byte represents view shape
	**/
	#end
	static var OFFSET = #if vision_higher_width_cap 21 #else 11 #end;

	static var WIDTH_BYTES = #if vision_higher_width_cap 4 #else 2 #end;
	static var VIEW_XY_BYTES = #if vision_higher_width_cap 8 #else 4 #end;
	static var VIEW_WH_BYTES = #if vision_higher_width_cap 8 #else 4 #end;
	static var VIEW_SHAPE_BYTES = 1;
	static var DATA_GAP = #if vision_higher_width_cap 4 #else 2 #end;

	/**
		Returns the underlying type of this abstract.
	**/
	public var underlying(get, #if vision_allow_resize set #else never #end):ByteArray;

	inline function get_underlying() {
		return this;
	}

	#if vision_allow_resize
	inline function set_underlying(bytes:ByteArray) {
		return this = bytes;
	}
	#end

	/**
		The width of the image.
	**/
	public var width(get, #if vision_allow_resize set #else never #end):Int;

	inline function get_width() {
		return #if vision_higher_width_cap this.getInt32(0) #else this.getUInt16(0) #end;
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
	    The current image's `ImageView`. You can get/set this field to change the view, but changing it's values won't effect anything.

		`ImageView`s disallow setting pixels on parts outside of the view. That's useful when you want to operate
		on a certain part of the image, without modifying other portions/copying pixels around.
	**/
	public var view(get, set):ImageView;

	inline function get_view():ImageView {
		return getView();
	}

	inline function set_view(view:ImageView):ImageView {
		setView(view);
		return view;
	}

	/**
		Creates a new image of the given size. Once is created, the image cannot be resized.

		@param width The width of the image.
		@param height The height of the image.
		@param color The color to fill the image with. if unspecified, the image is transparent.
	**/
	public inline function new(width:Int, height:Int, color:Color = 0x00000000) {
		this = new ByteArray(width * height * 4 + OFFSET);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (0, width);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES, 0);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + DATA_GAP, 0);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES, 0);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP, 0);
		this.set(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES, 0);
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

	//--------------------------------------------------------------------------
	// Pixels
	//--------------------------------------------------------------------------



	//--------------------------------------------------------------------------
	// Getters
	//--------------------------------------------------------------------------



	/**
		Gets the color of the pixel at the given coordinates.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@throws OutOfBounds if the coordinates are outside the bounds of the image.
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
		return getPixel(x.clamp(0, width - 1), y.clamp(0, height - 1));
	}

	@:allow(vision)
	inline function getUnsafePixel(x:Int, y:Int):Color {
		return getColorFromStartingBytePos((y * width + x) * 4);
	}

	/**
		Gets the color of the pixel at the given coordinates.
		These coordinates can also be of type `Float`, in which case
		the value returned should be an interpolation of the surrounding, physical pixels.

		**This Operation is safe - Out of bound coordinates won't throw an error, and will instead use the closest pixel.**

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

		@return The color of the pixel at the given coordinates.
	**/
	public inline function getFloatingPixel(x:Float, y:Float):Color {

		if (!hasPixel(Math.ceil(x), Math.ceil(y)) || !hasPixel(Math.floor(x), Math.floor(y))) {
			x = x.boundFloat(0, width - 1);
			y = y.boundFloat(0, height - 1);
		}
		final yFraction = y - Std.int(y), xFraction = x - Std.int(x);
		final red =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).red + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y)).red) + yFraction * ((1 - xFraction) * getSafePixel(Std.int(x), Std.int(y) + 1).red + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y) + 1).red));
		final green =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).green + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y)).green) + yFraction * ((1 - xFraction) * getSafePixel(Std.int(x), Std.int(y) + 1).green + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y) + 1).green));
		final blue =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).blue + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y)).blue) + yFraction * ((1 - xFraction) * getSafePixel(Std.int(x), Std.int(y) + 1).blue + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y) + 1).blue));
		final alpha =  Std.int((1 - yFraction) * ((1 - xFraction) * getPixel(Std.int(x), Std.int(y)).alpha + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y)).alpha) + yFraction * ((1 - xFraction) * getSafePixel(Std.int(x), Std.int(y) + 1).alpha + xFraction * getSafePixel(Std.int(x) + 1, Std.int(y) + 1).alpha));
		return Color.fromRGBA(red, green, blue, alpha);
	}

	

	//--------------------------------------------------------------------------
	// Setters
	//--------------------------------------------------------------------------



	/**
		Sets the color of the pixel at the given coordinates.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.
		@param color The color to set the pixel to.

		@throws OutOfBounds if the coordinates are outside the bounds of the image.
	**/
	public inline function setPixel(x:Int, y:Int, color:Color) {
		if (!hasPixel(x, y)) {
			#if vision_quiet
			#else
			throw new OutOfBounds(cast this, new IntPoint2D(x, y));
			#end
		} else {
			if (hasView()) {
				if (hasPixelInView(x, y)) {
					setColorFromStartingBytePos((y * width + x) * 4, color);
				}
			} else {
				setColorFromStartingBytePos((y * width + x) * 4, color);
			}
		}	
		
	}

	public inline function setSafePixel(x:Int, y:Int, color:Color) {
		x = x.clamp(0, width - 1);
		y = y.clamp(0, height - 1);
		if (hasView()) {
			if (hasPixelInView(x, y)) {
				setColorFromStartingBytePos((y * width + x) * 4, color);
			}
		} else {
			setColorFromStartingBytePos((y * width + x) * 4, color);
		}
	}

	public inline function setFloatingPixel(x:Float, y:Float, color:Color) {
		if (!hasPixel(Math.ceil(x), Math.ceil(y)) || !hasPixel(Math.floor(x), Math.floor(y))) {
			setFloatingPixel(x.boundFloat(0, width - 1), y.boundFloat(0, height - 1), color);
			return;
		}
		final yFraction = y - Std.int(y), xFraction = x - Std.int(x);

		// (0, 0) strength: (1 - xFraction, 1 - yFraction)
		// (0, 1) strength: (1 - xFraction,     yFraction)
		// (1, 0) strength: (	 xFraction, 1 - yFraction)
		// (1, 1) strength: (	 xFraction,     yFraction)
		setPixel(x.floor(), y.floor(), Color.fromRGBAFloat(((1 - xFraction) + (1 - yFraction)) / 2 * color.redFloat, ((1 - xFraction) + (1 - yFraction)) / 2 * color.greenFloat, ((1 - xFraction) + (1 - yFraction)) / 2 * color.blueFloat, color.alphaFloat));
		if (!y.isInt()) setPixel(x.floor(), y.ceil() , Color.fromRGBAFloat(((1 - xFraction) + (    yFraction)) / 2 * color.redFloat, ((1 - xFraction) + (    yFraction)) / 2 * color.greenFloat, ((1 - xFraction) + (    yFraction)) / 2 * color.blueFloat, color.alphaFloat));
		if (!x.isInt()) setPixel(x.ceil() , y.floor(), Color.fromRGBAFloat(((    xFraction) + (1 - yFraction)) / 2 * color.redFloat, ((    xFraction) + (1 - yFraction)) / 2 * color.greenFloat, ((    xFraction) + (1 - yFraction)) / 2 * color.blueFloat, color.alphaFloat));
		if (!x.isInt() && !y.isInt()) setPixel(x.ceil() , y.ceil() , Color.fromRGBAFloat(((    xFraction) + (    yFraction)) / 2 * color.redFloat, ((    xFraction) + (    yFraction)) / 2 * color.greenFloat, ((    xFraction) + (    yFraction)) / 2 * color.blueFloat, color.alphaFloat));
	}

	@:allow(vision)
	inline function setUnsafePixel(x:Int, y:Int, color:Color) {
		setColorFromStartingBytePos((y * width + x) * 4, color);
	}



	//--------------------------------------------------------------------------
	// Painters
	//--------------------------------------------------------------------------



	/**
		Sets the color of a pixel, but doesn't completely overwrite the pixel:

		- if the color of the new pixel is the same as the old pixel, the old pixel is kept.
		- if the alpha of the new pixel is 0, the old pixel is kept.
		- if the alpha of the new pixel is 255, the new pixel is kept.
		- if the alpha of the new pixel is between 0 and 255, the new pixel is blended with the old pixel.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.
		@param color The color to set the pixel to. Pay attention to the alpha value.
		@throws OutOfBounds if the coordinates are outside the bounds of the image.
	**/
	public inline function paintPixel(x:Int, y:Int, color:Color) {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			#if !vision_quiet
			throw new OutOfBounds(cast this, new IntPoint2D(x, y));
			#end
		} else if (color.alphaFloat == 1) {
			setPixel(x, y, color);
		} else {
			var oldColor = getPixel(x, y);
			var newColor = Color.fromRGBAFloat(
				color.redFloat * color.alphaFloat + oldColor.redFloat * (1 - color.alphaFloat),
				color.greenFloat * color.alphaFloat + oldColor.greenFloat * (1 - color.alphaFloat), 
				color.blueFloat * color.alphaFloat + oldColor.blueFloat * (1 - color.alphaFloat), 
				oldColor.alphaFloat + (1 - oldColor.alphaFloat) * color.alphaFloat
			);
			setPixel(x, y, newColor);
		}
	}

	public inline function paintFloatingPixel(x:Float, y:Float, color:Color) {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			paintFloatingPixel(x.boundFloat(0, width - 1), y.boundFloat(0, height - 1), color);
		} else if (x.isInt() && y.isInt()) {
			paintPixel(x.floor(), y.floor(), color);
		} else {
			
			final yFraction = y - Std.int(y), xFraction = x - Std.int(x);

			// (0, 0) strength: (1 - xFraction, 1 - yFraction)
			// (0, 1) strength: (1 - xFraction,     yFraction)
			// (1, 0) strength: (	 xFraction, 1 - yFraction)
			// (1, 1) strength: (	 xFraction,     yFraction)
			final ix = x.floor(), iy = y.floor();
			for (posX in [0, 1]) {
				if (posX == 1 && x == ix) continue;
				for (posY in [0, 1]) {
					if (posY == 1 && y == iy) continue;
					var oldColor = getPixel(ix + posX, iy + posY);
					color.alphaFloat = ((if (posX == 0) 1 - xFraction else xFraction) + (if (posY == 0) 1 - yFraction else yFraction)) / 2;
					var newColor = Color.fromRGBAFloat(
						color.redFloat * color.alphaFloat + oldColor.redFloat * (1 - color.alphaFloat),
						color.greenFloat * color.alphaFloat + oldColor.greenFloat * (1 - color.alphaFloat), 
						color.blueFloat * color.alphaFloat + oldColor.blueFloat * (1 - color.alphaFloat), 
						oldColor.alphaFloat + (1 - oldColor.alphaFloat) * color.alphaFloat
					);
					setPixel(ix + posX, iy + posY, newColor);
				}
			}
			
		}
	}

	public inline function paintSafePixel(x:Int, y:Int, color:Int) {
		paintPixel(x.clamp(0, width - 1), y.clamp(0, height - 1), color);
	}

	@:allow(vision)
	inline function paintUnsafePixel(x:Int, y:Int, color:Color) {
		var oldColor = getUnsafePixel(x, y);
		var newColor = Color.fromRGBAFloat(
			color.redFloat * color.alphaFloat + oldColor.redFloat * (1 - color.alphaFloat),
			color.greenFloat * color.alphaFloat + oldColor.greenFloat * (1 - color.alphaFloat), 
			color.blueFloat * color.alphaFloat + oldColor.blueFloat * (1 - color.alphaFloat), 
			oldColor.alphaFloat + (1 - oldColor.alphaFloat) * color.alphaFloat
		);
		setUnsafePixel(x, y, newColor);
		
	}

	//--------------------------------------------------------------------------
	// Checks
	//--------------------------------------------------------------------------



	/**
		Checks if the given coordinates are within the bounds of the image.

		@param x The x coordinate of the pixel.
		@param y The y coordinate of the pixel.

		@return True if the coordinates are within the bounds of the image.
	**/
	public inline function hasPixel(x:Int, y:Int):Bool {
		return (x >= 0 && y >= 0 && x < width && y < height);
	}

	//

	//--------------------------------------------------------------------------
	// Copying & Pasting
	//--------------------------------------------------------------------------

	/**
		Moves the pixel at `(fromX, fromY)` to `(toX, toY)` and resets the color at `(fromX, fromY)`.

		@param fromX The x-coordinate of the pixel to move.
		@param fromY The y-coordinate of the pixel to move.
		@param toX The x-coordinate of the pixel to set to the color of `(fromX, fromY)` to.
		@param toY The y-coordinate of the pixel to set to the color of `(fromX, fromY)` to.
		@param oldPixelResetColor After moving the pixel, the color of the pixel at `(fromX, fromY)` resets to `0x00000000`. To change that color, set this parameter
	**/
	public function movePixel(fromX:Int, fromY:Int, toX:Int, toY:Int, oldPixelResetColor:Color) {
		setPixel(toX, toY, getPixel(fromX, fromY));
		setPixel(fromX, fromY, oldPixelResetColor);
	}

	/**
		Moves the pixel at `(fromX, fromY)` to `(toX, toY)` and resets the color at `(fromX, fromY)`. Values outside teh bounds of `this` image are allowed.

		@param fromX The x-coordinate of the pixel to move.
		@param fromY The y-coordinate of the pixel to move.
		@param toX The x-coordinate of the pixel to set to the color of `(fromX, fromY)` to.
		@param toY The y-coordinate of the pixel to set to the color of `(fromX, fromY)` to.
		@param oldPixelResetColor After moving the pixel, the color of the pixel at `(fromX, fromY)` resets to `0x00000000`. To change that color, set this parameter
	**/
	public function moveSafePixel(fromX:Int, fromY:Int, toX:Int, toY:Int, oldPixelResetColor:Color) {
		setSafePixel(toX, toY, getSafePixel(fromX, fromY));
		setSafePixel(fromX, fromY, oldPixelResetColor);
	}

	/**
		Moves the pixel at `(fromX, fromY)` to `(toX, toY)` and resets the color at `(fromX, fromY)`. Fractional values are allowed.
		
		This Operation is safe - Out of bound coordinates won't throw an error, and will instead use the closest pixel.

		@param fromX The x-coordinate of the pixel to move.
		@param fromY The y-coordinate of the pixel to move.
		@param toX The x-coordinate of the pixel to set to the color of `(fromX, fromY)` to.
		@param toY The y-coordinate of the pixel to set to the color of `(fromX, fromY)` to.
		@param oldPixelResetColor After moving the pixel, the color of the pixel at `(fromX, fromY)` resets to `0x00000000`. To change that color, set this parameter
	**/
	public function moveFloatingPixel(fromX:Float, fromY:Float, toX:Float, toY:Float, oldPixelResetColor:Color) {
		setFloatingPixel(toX, toY, getFloatingPixel(fromX, fromY));
		setFloatingPixel(fromX, fromY, oldPixelResetColor);
	}

	public function moveUnsafePixel(fromX:Int, fromY:Int, toX:Int, toY:Int, oldPixelResetColor:Color) {
		setUnsafePixel(toX, toY, getUnsafePixel(fromX, fromY));
		setUnsafePixel(fromX, fromY, oldPixelResetColor);
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
		var safety = 0;
		while (true && safety++ < 10000) {
			setSafePixel(x1, y1, color);
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

		var safetyNet = 0;
		while (true && safetyNet++ <= 10000) {
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
		Draws a curved line specified by a line and one control point.

		This method draws a quadratic Bezier curve.

		@param line The line to draw.
		@param control The control point of the curve.
		@param color The color to draw the line with.
		@param accuracy The number of iterations to use when drawing the curve. the higher the number, the more iterations are used, and the more accurate the curve is. for example, accuracy of 100 will draw the curve with 100 iterations, and will draw 100 points on the curve. **default is 1000**

		@see Line2D
	**/
	public inline function drawQuadraticBezier(line:Line2D, control:IntPoint2D, color:Color, accuracy:Float = 1000) {
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
		@param accuracy The number of iterations to use when drawing the curve. The higher the number, the more iterations are used, and the more accurate the curve is. For example: accuracy of 100 will draw the curve with 100 iterations, and will draw 100 points on the curve. **default is 1000**

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

	// https://github.com/Laerdal/opentype.hx/issues/2
	// /**
	// 	Draws a string at position `(x, y)` with font-size `size`.

	// 	Text drawing starts from the top-left corner of the text.

	// 	@param x The x coordinate of the top-left corner of the text
	// 	@param y The y coordinate of the top-left corner of the text
	// 	@param text The text to draw
	// 	@param size The font-size to use
	// **/
	// public function drawText(x:Int, y:Int, text:String, size:Int) {
	// 	if (TextDrawer.reportDependencies()) TextDrawer.drawTextOnImage(cast this, x, y, size, text, Resource.getBytes("NotoSans-Regular.ttf"))
	// }

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

		@param position The position to start filling at. You can use a Point2D or IntPoint2D.
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

		@param position The position to start filling at. You can use a Point2D or IntPoint2D.
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

		@param position The position to start filling at. You can use a Point2D or IntPoint2D.
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
		if (this == null) {
			trace("Warning: Cloning a null image");
		}
		return cast this.sub(0, this.length);
	}

	//--------------------------------------------------------------------------
	// General Manipulation
	//--------------------------------------------------------------------------

	public inline function mirror():Image {
		var inter = clone();
		forEachPixelInView((x, y, color) -> {
			setUnsafePixel(x, y, inter.getUnsafePixel(inter.width - x - 1, y));
		});
		return cast this;
	}

	public inline function flip():Image {
		var inter = clone();
		forEachPixelInView((x, y, color) -> {
			setUnsafePixel(x, y, inter.getUnsafePixel(x, inter.height - y - 1));
		});
		return cast this;
	}

	/**
	 * Stamps the given image onto this image, with the stamped image's top left corner being at (`X`, `Y`).
	 * 
	 * 
	 * @param X The X coordinate of the top left corner of the stamped image.
	 * @param Y The Y coordinate of the top left corner of the stamped image
	 * @param image The image to stamp. Alpha values are respected.
	 * @return this image after stamping the given image onto it.
	 */
	public inline function stamp(X:Int, Y:Int, image:Image):Image {
		for (x in X...X + image.width) {
			for (y in Y...Y + image.height) {
				paintPixel(x, y, image.getUnsafePixel(x - X, y - Y));
			}
		}
		return cast this;
	}

	

	/**
		Resizes the image according to `algorithm`, to `newWidth` by `newHeight`.

		@param newWidth The width to resize to. if assigned to `-1`, the image resizes to the given `newHeight`, and keeps the aspect-ratio of the original image.
		@param newHeight The height to resize to. if assigned to `-1`, the image resizes to the given `newWidth`, and keeps the aspect-ratio of the original image.
		@param algorithm Which algorithm to use. You can use the algorithms available in `ImageResizeAlgorithm`. If no algorithm is specified, uses `ImageTools.defaultResizeAlgorithm`.
		@return this image, after resizing.
	**/
	public inline function resize(newWidth:Int = -1, newHeight:Int = -1, ?algorithm:ImageResizeAlgorithm):Image {
		if (newWidth == -1 && newHeight == -1) return cast this;
		if (newWidth == -1) {
			newWidth = Std.int(((newHeight / height) * width));
		} else if (newHeight == -1) {
			newHeight = Std.int(((newWidth / width) * height));
		} 
		trace(newWidth, newHeight);
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
					var xMultiplier = width / image.width;
					var yMultiplier = height / image.height;
					image.forEachPixel((x, y, color) -> {
						var color = getPixel(MathTools.floor(x * xMultiplier), MathTools.floor(y * yMultiplier));
						image.setPixel(x, y, color);
					});
					this = image.underlying;
				}
		}

		return cast this;
	}

	/**
		Rotates this image's pixel by `angle` degrees\radians.  
		Notice - rotating an image and then re-rotating to the image's previous state won't bring you exactly the same image.

		@param angle The angle to rotate by.
		@param degrees if `true`, `angle` is in degrees. Otherwise, `angle` is in radians.
		@param expandImageBounds Whether to expand the image's bounds to fit the rotated image. Default is `true`.
	**/
	public inline function rotate(angle:Float, ?degrees:Bool = true, expandImageBounds:Bool = true):Image {
		final center = new Point2D(width / 2, height / 2);
		final radians = if (degrees) angle.degreesToRadians() else angle;

		// Calculate the dimensions of the rotated image
        var sinTheta:Float = Math.sin(angle);
        var cosTheta:Float = Math.cos(angle);
        var newWidth:Int = if (expandImageBounds) Math.ceil(Math.abs(width * cosTheta) + Math.abs(height * sinTheta)) else width;
        var newHeight:Int = if (expandImageBounds) Math.ceil(Math.abs(width * sinTheta) + Math.abs(height * cosTheta)) else height;

        // Create a new image with black background
        var rotatedImage:Image = new Image(newWidth, newHeight);

        // Calculate the center of the new image
        var centerX:Float = newWidth / 2;
        var centerY:Float = newHeight / 2;

        // Calculate the center of the original image
        var originalCenterX:Float = width / 2;
        var originalCenterY:Float = height / 2;

        // Iterate over each pixel of the rotated image
        for (x in 0...rotatedImage.width) {
            for (y in 0...rotatedImage.height) {
                // Calculate the coordinates in the original image
                var rotatedX:Float = cosTheta * (x - centerX) + sinTheta * (y - centerY) + originalCenterX;
                var rotatedY:Float = -sinTheta * (x - centerX) + cosTheta * (y - centerY) + originalCenterY;

                // Check if the calculated coordinates are within the bounds of the original image
                if (rotatedX >= 0 && rotatedX < width && rotatedY >= 0 && rotatedY < height) {
                    // Get the pixel value from the original image and set it in the rotated image
                    var pixelValue = getFloatingPixel(rotatedX, rotatedY);
                    rotatedImage.setPixel(x, y, pixelValue);
                }
            }
        }

		this = rotatedImage.underlying;
		return cast this;
	}

	//--------------------------------------------------------------------------
	// Convenience
	//--------------------------------------------------------------------------

	/**
		Gets the image as a string.

		@param special When using the `Console.hx` haxelib, images can be printed to the console
		with color. Set this to false if you don't want this to happen. Set to `true` by default.
	**/
	public function toString(special:Bool = true):String {
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

	/**
	    Iterates over each pixel inside this image, from left to right, top to bottom.
	    @param callback A function to dispatch on each pixel: Arguments contain the X & Y of the pixel, and its color.
	**/
	public inline function forEachPixel(callback:(x:Int, y:Int, color:Color) -> Void) {
		for (x in 0...width) {
			for (y in 0...height) {
				callback(x, y, getUnsafePixel(x, y));
			}
		}
	}

	/**
	    Iterates over each pixel inside this image, from left to right, top to bottom.

		This function differs from `forEachPixel` by not dispatching `callback()` 
		on pixels outside of the currently set `ImageView`.

		If an `ImageView` isn't set, this function will call `forEachPixel` instead to increase performance. 

		@param callback A function to dispatch on each pixel: Arguments contain the X & Y of the pixel, and its color. Won't dispatch for pixels outside of the currently set view.
	**/
	public inline function forEachPixelInView(callback:(x:Int, y:Int, color:Color) -> Void) {
		if (!hasView()) {
			forEachPixel(callback);
			return;
		}
		for (x in 0...width) {
			for (y in 0...height) {
				if (hasPixelInView(x, y)) {
					callback(x, y, getUnsafePixel(x, y));
				}
			}
		}
	}

	/**
	    Returns an iterator over this image's pixels.
	**/
	public inline function iterator():Iterator<Pixel> {
		return new PixelIterator(cast this);
	}

	//--------------------------------------------------------------------------
	// Image View
	//--------------------------------------------------------------------------

	/**
	    Checks whether or not this image currently has a view

		If `view`'s dimensions are all 0'ed out, or are greater than/the same as the image's dimensions, this will return false.
	**/
	public inline function hasView():Bool {
		return (
			#if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES) != 0 ||
			#if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES + DATA_GAP) != 0 ||
			#if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES) != 0 ||
			#if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP) != 0 ||
			this.get(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES) != 0
		);
	}

	/**
	    Sets the current `ImageView`, and returns this image.

		If `view`'s dimensions are all 0'ed out, or are greater than/the same as the image's dimensions, `hasView()` will return false.

		If you want to remove the currently set `ImageView`, check out `removeView()`.

		@param view The `ImageView` to set to.
		@return This image, after applying the view.
	**/
	public inline function setView(view:ImageView):Image {
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES, view.x);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + DATA_GAP, view.y);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES, view.width >= width ? 0 : view.width);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP, view.height >= height ? 0 : view.width);
		this.set(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES, view.shape);
		return cast this;
	}

	/**
	    Gets the currently set `ImageView`.
	**/
	public inline function getView():ImageView {
		return {
			x: 		#if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES),
			y: 		#if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES + DATA_GAP),
			width: 	#if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES),
			height: #if vision_higher_width_cap this.getInt32 #else this.getUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP),
			shape: 	this.get(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES),
		}
	}

	/**
	    Removes the currently set `ImageView`, and returns this image.
	**/
	public inline function removeView():Image {
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES, 0);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + DATA_GAP, 0);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES, 0);
		#if vision_higher_width_cap this.setInt32 #else this.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP, 0);
		this.set(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES, 0);
		return cast this;
	}

	/**
	    Checks whether or not the given pixel in coordinates `(x, y)` is inside the given `ImageView`, 
		or inside currently set `ImageView` (if `v` is `null`).

		If `v` is null, and this image's view isn't set (check out `hasView()` for more details), 
		this function calls `hasPixel()` to remove unnecessary calculations.

		@param x The x position of the pixel
		@param y The y position of the pixel
		@param v A view to check against, or `null` if you want to check against this image's view.
		@return Whether or not the given pixel is inside the view.
	**/
	public inline function hasPixelInView(x:Int, y:Int, ?v:ImageView):Bool {
		if (!hasView() && v == null) {
			return hasPixel(x, y);
		}
		var has = false;
		final view = v != null ? v : view; //reduces calls to get_view
		switch view.shape {
			case RECTANGLE: has = (x < (view.x + view.width) && y < (view.y + view.height) && x >= (view.x) && y >= (view.y));
			case RECTANGLE_INVERTED: has = !(x < (view.x + view.width) && y < (view.y + view.height) && x >= (view.x) && y >= (view.y));
			case RHOMBUS: has = ((x - view.x - view.width / 2).abs() / (view.width / 2) + (y - view.y - view.height / 2).abs() / (view.height / 2) <= 1);
			case RHOMBUS_INVERTED: has = !((x - view.x - view.width / 2).abs() / (view.width / 2) + (y - view.y - view.height / 2).abs() / (view.height / 2) <= 1);
			case ELLIPSE, ELLIPSE_INVERTED: {
				//calculate the focal points of the ellipse
				//F = sqrt(a^2 - b^2)
				//a = major axis / 2
				//b = minor axis / 2
				if (view.width > view.height) {
					final a = view.width / 2;
					final b = view.height / 2;
					final c = Math.sqrt(a * a - b * b);
					final f1 = new Point2D(view.x + view.width / 2 - c, view.y + view.height / 2);
					final f2 = new Point2D(view.x + view.width / 2 + c, view.y + view.height / 2);
					final p = new IntPoint2D(x, y);
					has = f1.distanceBetweenPoints(p) + f2.distanceBetweenPoints(p) <= view.width;
					if (view.shape == ELLIPSE_INVERTED) has = !has;
				} else if (view.height > view.width) {
					final a = view.height / 2;
					final b = view.width / 2;
					final c = Math.sqrt(a * a - b * b);
					final f1 = new Point2D(view.x + view.width / 2, view.y + view.height / 2 - c);
					final f2 = new Point2D(view.x + view.width / 2, view.y + view.height / 2 + c);
					final p = new IntPoint2D(x, y);
					has = f1.distanceBetweenPoints(p) + f2.distanceBetweenPoints(p) <= view.height;
					if (view.shape == ELLIPSE_INVERTED) has = !has;
				} else {
					//just check if the distance from the point to the center is larger than the radius of the circle
					has = new Point2D(x, y).distanceBetweenPoints(new Point2D(view.x + view.width / 2, view.y + view.height / 2)) <= (view.width / 2);
					if (view.shape == ELLIPSE_INVERTED) has = !has;
				}
			}
		}
		return has;
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
	
	#if js
	@:from public static function fromJsCanvas(canvas:js.html.CanvasElement):Image {
        return ImageTools.fromJsCanvas(canvas);
    }
    @:to public function toJsCanvas():js.html.CanvasElement {
        return ImageTools.toJsCanvas(cast this);
    }
	@:from public static function fromJsImage(image:js.html.ImageElement):Image {
		return ImageTools.fromJsImage(image);
    }
	@:to public function toJsImage():js.html.ImageElement {
		return ImageTools.toJsImage(cast this);
    }
	#end

	#if haxeui_core
	@:from public static function fromHaxeUIImage(image:haxe.ui.components.Image):Image {
		return ImageTools.fromHaxeUIImage(image);
	}

	@:to public function toHaxeUIImage():haxe.ui.components.Image {
		return ImageTools.toHaxeUIImage(cast this);
	}

	@:from public static function fromHaxeUIImageData(image:haxe.ui.backend.ImageData):Image {
		return ImageTools.fromHaxeUIImageData(image);
	}

	@:to public function toHaxeUIImageData():haxe.ui.backend.ImageData {
		return ImageTools.toHaxeUIImageData(cast this);
	}
	#end

	//--------------------------------------------------------------------------
	// Other From/Tos
	//--------------------------------------------------------------------------

	/**
		Takes a 2D array of colors, and returns an image `array[0].length` pixels wide and `array.length` pixels tall.

		The array is not altered.

		@param array the 2-dimensional color array. Make sure `array[0]`'s length is your desired image width.
		@return a new `Image`
	**/
	@:from public static inline function from2DArray(array:Array<Array<Color>>):Image {

		var h = array.length;
		var w = array[0].length;

		var byteArray:ByteArray = new ByteArray(w * h * 4 + OFFSET);
		var flat = array.flatten();
		for (i in 0...flat.length) {
			var color = flat[i];
			byteArray[OFFSET + i * 4] 	  = color.alpha;
			byteArray[OFFSET + i * 4 + 1] = color.red;
			byteArray[OFFSET + i * 4 + 2] = color.green;
			byteArray[OFFSET + i * 4 + 3] = color.blue;
		}

		#if vision_higher_width_cap byteArray.setInt32 #else byteArray.setUInt16 #end (0, w);
		#if vision_higher_width_cap byteArray.setInt32 #else byteArray.setUInt16 #end (WIDTH_BYTES, 0);
		#if vision_higher_width_cap byteArray.setInt32 #else byteArray.setUInt16 #end (WIDTH_BYTES + DATA_GAP, 0);
		#if vision_higher_width_cap byteArray.setInt32 #else byteArray.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES, 0);
		#if vision_higher_width_cap byteArray.setInt32 #else byteArray.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP, 0);
		byteArray.set(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES, 0);

		return cast byteArray;
	}

	/**
		Returns a new, 2-dimensional array, with each cell containing the pixel on the image at it's indices (`array[x][y]` = `image.getPixel(x, y)`)
		@return a 2D array of colors.
	**/
	@:to public inline function to2DArray():Array<Array<Color>> {
		var arr = [];
		for (i in 0...height) {
			arr[i] = [];
			for (j in 0...width) {
				arr[i][j] = getUnsafePixel(j, i);
			}
		}

		return arr;
	}

	/**
		Takes a `ByteArray`/`haxe.io.Bytes` instance and some stats, and returns a new image instance
		that correctly represents the colors inside `bytes` at the given size
		@param bytes The byte array to be used. **Make it's color format is `ARGB`.** if it isn't, use `PixelFormat.convertPixelFormat(bytes, fromFormat, ARGB)`
		@param width The width of the returned image.
		@param height Optional, the height of the returned image. determined automatically, can be overridden by setting this parameter
	**/
	public static inline function fromBytes(bytes:ByteArray, width:Int, ?height:Int) {
		var h = height != null ? height : (bytes.length / 4 / width).ceil();
		var array = new ByteArray(width * h * 4 + OFFSET);
		array.fill(0, array.length, 0);
		#if vision_higher_width_cap array.setInt32 #else array.setUInt16 #end (0, width);
		#if vision_higher_width_cap array.setInt32 #else array.setUInt16 #end (WIDTH_BYTES, 0);
		#if vision_higher_width_cap array.setInt32 #else array.setUInt16 #end (WIDTH_BYTES + DATA_GAP, 0);
		#if vision_higher_width_cap array.setInt32 #else array.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES, 0);
		#if vision_higher_width_cap array.setInt32 #else array.setUInt16 #end (WIDTH_BYTES + VIEW_XY_BYTES + DATA_GAP, 0);
		array.set(WIDTH_BYTES + VIEW_XY_BYTES + VIEW_WH_BYTES, 0);

		array.blit(OFFSET, bytes, 0, bytes.length);

		return cast array;
	}

	/**
		Returns a `ByteArray` of format `ARGB` of the pixels of this image.
		@return A new `ByteArray`
	**/
	@:to overload public extern inline function toBytes():ByteArray {
		return underlying.sub(OFFSET, underlying.length - OFFSET);
	}

	/**
		Returns a `ByteArray` of format `colorFormat` of the pixels of this image.
		@param colorFormat The wanted color format of the returned `ByteArray`.
		@return A new `ByteArray`
	**/
	overload public extern inline function toBytes(?colorFormat:PixelFormat = ARGB) {
		return inline PixelFormat.convertPixelFormat(underlying.sub(OFFSET, underlying.length - OFFSET), ARGB, colorFormat);
	}

	//--------------------------------------------------------------------------
	// Operators
	//--------------------------------------------------------------------------
	@:op(A | B) static inline function image_or_image(lhs:Image, rhs:Image):Image {
		lhs.forEachPixelInView((x, y, color) -> {
			lhs.setUnsafePixel(x, y, color | rhs.getUnsafePixel(x, y));
		});
		return lhs;
	}

	@:op(A ^ B) static inline function image_xor_image(lhs:Image, rhs:Image):Image {
		lhs.forEachPixelInView((x, y, color) -> {
			lhs.setUnsafePixel(x, y, color ^ rhs.getUnsafePixel(x, y));
		});
		return lhs;
	}

	@:op(A & B) static inline function image_and_image(lhs:Image, rhs:Image):Image {
		lhs.forEachPixelInView((x, y, color) -> {
			lhs.setUnsafePixel(x, y, color & rhs.getUnsafePixel(x, y));
		});
		return lhs;
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

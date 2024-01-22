package vision.ds;

/**
	A structure useful for representing a pixel in an image.
**/
@:structInit
class Pixel {

	/**
		The column on which the pixel is on 
	**/
	public var x:Int;

	/**
		The row on which the pixel is on 
	**/
	public var y:Int;

	/**
		The color of the pixel, in `ARGB` format.
	**/
	public var color:Color;

	/**
		@param x The row on which the pixel is on 
		@param y The column on which the pixel is on 
		@param color The color of the pixel, in `ARGB` format.
	**/
	public inline function new(x:Int, y:Int, color:Color) {
		this.x = x;
		this.y = y;
		this.color = color;
	}
}

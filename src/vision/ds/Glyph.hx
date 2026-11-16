package vision.ds;

import vision.algorithms.TextDrawing;

/**
	An individual outline entry in a font.

	A glyph can represent one character, multiple equivalent characters,
	a ligature, or an entry with no direct text representation.
**/
@:allow(vision.ds.Font)
@:allow(vision.algorithms.TextDrawing)
class Glyph {
	/** The font that owns this glyph. Glyph indices are local to this font. **/
	public final font:Font;

	/** The glyph index in `font`. **/
	public final id:Int;

	/** Horizontal advance in font units. A blank glyph can still have a positive advance. **/
	public var advance(get, never):Int;

	/** A text representation, preferring a known ligature sequence when one exists. **/
	public var text(get, never):Null<String>;

	function new(font:Font, id:Int) {
		this.font = font;
		this.id = id;
	}

	/**
		Returns all character and standard ligature representations known for this glyph.

		@return An independent array. An unmapped entry has no representations.
	**/
	public function getRepresentations():Array<String> {
		return font.glyphRepresentations(id);
	}

	/**
		Measures the glyph outline relative to its drawing origin.

		The horizontal origin is the pen position. The vertical origin is
		the baseline, with positive coordinates pointing down. The bounds
		include the outline's control points and are rounded out to pixels.

		@param size The font size in pixels
		@return The enclosing rectangle, or a zero-sized rectangle for a blank glyph
		@throws TextDrawingError If the requested size or bounds cannot be represented
	**/
	public function getBounds(size:Float = 16):Rectangle {
		return TextDrawing.glyphBounds(this, size);
	}

	/**
		Renders the glyph outline into a new transparent image.

		The image is fitted to the outline. A glyph without an outline
		returns an empty image when padding is zero.

		@param size The font size in pixels
		@param color The color used to fill the outline
		@param padding Transparent pixels to add on each side
		@return The rendered glyph image
		@throws TextDrawingError If the size, padding, or resulting dimensions are invalid
	**/
	public function toImage(size:Float = 16, color:Color = Color.BLACK, padding:Int = 0):Image {
		return TextDrawing.glyphImage(this, size, color, padding);
	}

	inline function get_advance():Int return font.data.advance(id);

	function get_text():Null<String> {
		final values = getRepresentations();
		return values.length == 0 ? null : values[0];
	}
}

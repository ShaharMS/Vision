package vision.ds;

import haxe.ds.IntMap;
import haxe.io.Bytes;
import haxe.iterators.StringIteratorUnicode;
import vision.algorithms.TextDrawing;
import vision.ds.specifics.TextOptions;
import vision.exceptions.FontLoadingError;
import vision.formats._internal.Otf;
import vision.formats._internal.Ttf;
import vision.formats._internal.Woff;
import vision.formats._internal.Woff2;
import vision.formats._internal.fonts.FontData;
import vision.formats._internal.fonts.FontTable;

/**
	A reusable font face loaded from font bytes.

	A font provides its character repertoire, individual glyphs, and text
	rendering on any Vision target. A single font represents one face. Load
	the regular, bold, and italic files individually to use those styles.

	```haxe
	final font = Font.fromBytes(fontBytes);
	final title = font.toImage("Vision", {size: 32}, 4);
	final letter = font.getGlyph("V");
	if (letter != null) {
		final icon = letter.toImage(24);
	}
	```
**/
@:allow(vision.algorithms.TextDrawing)
@:allow(vision.ds.Glyph)
class Font {
	static final latinLigatures = ["ff", "fi", "fl", "ffi", "ffl", "\u017ft", "st"];
	/** Family name from the font, or the supplied name when the font has no family name. **/
	public final family:String;

	/** Style name from the font, such as `Regular` or `Bold Italic`, when available. **/
	public final style:Null<String>;

	/** Number of font units that correspond to the requested text size in pixels. **/
	public var unitsPerEm(get, never):Int;

	/** Recommended distance above the baseline, in font units. **/
	public var ascent(get, never):Int;

	/** Signed distance below the baseline, in font units. Normally negative. **/
	public var descent(get, never):Int;

	/** Additional recommended space between lines, in font units. **/
	public var lineGap(get, never):Int;

	/** Number of glyph entries, including entries without a character mapping. **/
	public var glyphCount(get, never):Int;

	final data:FontData;
	final glyphs = new IntMap<Glyph>();
	var characters:Null<Array<String>>;
	var representations:Null<IntMap<Array<String>>>;

	function new(data:FontData, name:String) {
		this.data = data;
		final declaredFamily = data.name(16, 1);
		family = declaredFamily == null ? name : declaredFamily;
		style = data.name(17, 2);
	}

	/**
		Loads one font face from TTF, OTF, WOFF, or WOFF2 bytes.

		The format is detected from the bytes. TrueType and CFF version 1
		outlines are supported. The font retains its own copy of the data.

		@param bytes The complete font file
		@param name A name for error messages and a fallback when the file has no family name
		@return The decoded font face
		@throws FontLoadingError If the file is invalid or uses an unsupported outline format
	**/
	public static function fromBytes(bytes:Bytes, name:String = "Font"):Font {
		try {
			final source = new FontTable(bytes.sub(0, bytes.length), 0, bytes.length);
			final data = switch source.u32(0) {
				case 0x00010000, 0x74727565: Ttf.read(source, name);
				case 0x4f54544f: Otf.read(source, name);
				case 0x774f4646: Woff.read(source, name);
				case 0x774f4632: Woff2.read(source, name);
				default: throw new FontLoadingError(name, "Unknown font format.");
			};
			return new Font(data, name);
		} catch (error:FontLoadingError) {
			throw error;
		} catch (error:Dynamic) {
			throw new FontLoadingError(name, Std.string(error));
		}
	}

	/**
		Returns the Unicode characters with a glyph mapping in this font.

		@return An independent array ordered by Unicode code point. A
		ligature sequence is available through `getGlyph()` and does not
		appear in this single-character list.
	**/
	public function getCharacters():Array<String> {
		if (characters == null) characters = [for (code in data.codePoints()) FontData.character(code)];
		return characters.copy();
	}

	/**
		Looks up a character or a ligature supported by this face.

		Multi-character lookup checks standard font substitutions and encoded
		Latin ligature characters. It does not perform contextual shaping.

		@param text A single Unicode character or a ligature sequence such as `fi`
		@return The mapped glyph, or `null` if this font has no exact mapping
	**/
	public function getGlyph(text:String):Null<Glyph> {
		final codes = new StringIteratorUnicode(text);
		if (!codes.hasNext()) return null;
		final code = codes.next();
		if (!codes.hasNext()) {
			final id = data.glyph(code);
			return id == 0 ? null : getGlyphById(id);
		}
		final rules = data.ligatures.get(data.glyph(code));
		if (rules != null) {
			final following = [for (code in codes) data.glyph(code)];
			for (rule in rules) {
				if (following.length != rule.following.length) continue;
				var matches = true;
				for (i in 0...following.length)
					if (following[i] == 0 || following[i] != rule.following[i]) {
						matches = false;
						break;
					}
				if (matches) return getGlyphById(rule.replacement);
			}
		}
		final index = latinLigatures.indexOf(text);
		return index == -1 ? null : getGlyph(FontData.character(0xfb00 + index));
	}

	/**
		Retrieves a glyph by its index in the font file.

		@param id A glyph index between zero and `glyphCount - 1`
		@return The glyph, or `null` if the index is outside the font.
		Index zero normally holds the missing-character glyph.
	**/
	public function getGlyphById(id:Int):Null<Glyph> {
		if (id < 0 || id >= glyphCount) return null;
		var glyph = glyphs.get(id);
		if (glyph == null) {
			glyph = new Glyph(this, id);
			glyphs.set(id, glyph);
		}
		return glyph;
	}

	/**
		Renders text in this font into a new transparent image.

		The image includes line advances and any glyphs that extend beyond
		them. Newlines start a new line. An empty string returns an empty
		image when padding is zero. This font supplies the face, so the
		browser family, weight, and italic settings do not apply.

		@param text The text to render
		@param options Optional size, color, direction, ligatures, and line spacing
		@param padding Transparent pixels to add on each side
		@return The rendered image
		@throws TextDrawingError If the rendering options or resulting dimensions are invalid
	**/
	public function toImage(text:String, ?options:TextOptions, padding:Int = 0):Image {
		return TextDrawing.textImage(this, text, options == null ? {} : options, padding);
	}

	function glyphRepresentations(id:Int):Array<String> {
		indexRepresentations();
		final values = representations.get(id);
		return values == null ? [] : values.copy();
	}

	function indexRepresentations():Void {
		if (representations != null) return;
		final byGlyph = new IntMap<Array<String>>();
		for (code in data.codePoints()) {
			final id = data.glyph(code);
			var values = byGlyph.get(id);
			if (values == null) {
				values = [];
				byGlyph.set(id, values);
			}
			values.push(FontData.character(code));
		}
		// Only directly encoded characters can contribute to a ligature sequence.
		final direct = new IntMap<String>();
		for (id => values in byGlyph) direct.set(id, values[0]);
		for (first => rules in data.ligatures) {
			final prefix = direct.get(first);
			if (prefix == null) continue;
			for (rule in rules) {
				var text = prefix;
				for (id in rule.following) {
					final character = direct.get(id);
					if (character == null) {
						text = "";
						break;
					}
					text += character;
				}
				if (text.length == 0) continue;
				var values = byGlyph.get(rule.replacement);
				if (values == null) {
					values = [];
					byGlyph.set(rule.replacement, values);
				}
				if (!values.contains(text)) values.unshift(text);
			}
		}
		for (i in 0...latinLigatures.length) {
			final values = byGlyph.get(data.glyph(0xfb00 + i));
			final text = latinLigatures[i];
			if (values != null && !values.contains(text)) values.unshift(text);
		}
		representations = byGlyph;
	}

	inline function get_unitsPerEm():Int return data.unitsPerEm;
	inline function get_ascent():Int return data.ascent;
	inline function get_descent():Int return data.descent;
	inline function get_lineGap():Int return data.lineGap;
	inline function get_glyphCount():Int return data.glyphCount;
}

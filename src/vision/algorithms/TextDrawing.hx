package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Point2D;
import vision.ds.Rectangle;
import vision.ds.Font;
import vision.ds.Glyph;
import vision.native.ImageBackend;
import vision.exceptions.TextDrawingError;
import vision.formats._internal.fonts.FontData;
import vision.formats._internal.fonts.TextShaper;
import vision.formats._internal.fonts.FontData.FontPoint;
import vision.ds.specifics.TextOptions;

/** Lays out and rasterizes decoded font outlines. **/
@:noCompletion
class TextDrawing {
	// Rasterization quality settings and OpenType weight-class limits.
	static inline var SCANLINES_PER_PIXEL = 4;
	static inline var MIN_CURVE_STEPS = 2;
	static inline var MAX_CURVE_STEPS = 64;
	static inline var DEFAULT_LINE_HEIGHT_SCALE = 1.25;
	static inline var MIN_FONT_WEIGHT = 1;
	static inline var MAX_FONT_WEIGHT = 1000;
	static inline var MAX_CHANNEL_VALUE = 255;

	public static function validateOptions(options:TextOptions):Void {
		if (!Math.isFinite(options.size) || options.size <= 0 || !Math.isFinite(options.lineHeight)
			|| options.lineHeight < 0 || options.weight < MIN_FONT_WEIGHT || options.weight > MAX_FONT_WEIGHT)
			throw new TextDrawingError("Text size, line height, or weight is invalid.");
	}

	public static function draw(image:Image, x:Int, y:Int, text:String, font:Font, options:TextOptions):Void {
		final scale = options.size / font.unitsPerEm;
		layout(text, font.data, options, (id, left, baseline) -> {
			rasterize(image, font.data.outline(id), x + left, y + baseline, scale, options.color);
		});
	}

	public static function textImage(font:Font, text:String, options:TextOptions, padding:Int):Image {
		validateOptions(options);
		final bounds = new OutlineBounds();
		bounds.include(0, 0);
		if (text.length != 0) {
			final scale = options.size / font.unitsPerEm;
			final height = Math.max(options.size, (font.ascent - font.descent) * scale);
			layout(text, font.data, options, (id, x, baseline) -> {
				bounds.includeOutline(font.data.outline(id), x, baseline, scale);
			}, (left, right, top) -> {
				bounds.include(left, top);
				bounds.include(right, top + height);
			});
		}
		final result = bounds.image(padding);
		if (text.length != 0) draw(result, padding - Math.floor(bounds.left), padding - Math.floor(bounds.top), text, font, options);
		return result;
	}

	public static function glyphBounds(glyph:Glyph, size:Float):Rectangle {
		final scale = glyphScale(glyph, size);
		return outlineBounds(glyph.font.data.outline(glyph.id), scale).rectangle();
	}

	public static function glyphImage(glyph:Glyph, size:Float, color:Color, padding:Int):Image {
		final scale = glyphScale(glyph, size);
		final outline = glyph.font.data.outline(glyph.id);
		final bounds = outlineBounds(outline, scale);
		final result = bounds.image(padding);
		rasterize(result, outline, padding - Math.floor(bounds.left), padding - Math.floor(bounds.top), scale, color);
		return result;
	}

	static function glyphScale(glyph:Glyph, size:Float):Float {
		if (!Math.isFinite(size) || size <= 0) throw new TextDrawingError("Glyph size must be finite and positive.");
		return size / glyph.font.unitsPerEm;
	}

	static function outlineBounds(outline:Array<Array<FontPoint>>, scale:Float):OutlineBounds {
		final bounds = new OutlineBounds();
		bounds.includeOutline(outline, 0, 0, scale);
		if (outline.length == 0) bounds.include(0, 0);
		return bounds;
	}

	static function layout(text:String, font:FontData, options:TextOptions, place:(Int, Float, Float)->Void,
		?lineBounds:(Float, Float, Float)->Void):Void {
		final scale = options.size / font.unitsPerEm;
		final lineHeight = options.lineHeight == 0 ? options.size * DEFAULT_LINE_HEIGHT_SCALE : options.lineHeight;
		final lines = ~/\r\n?|\n/g.split(text);
		for (i in 0...lines.length) {
			final shaped = TextShaper.shapeGlyphs(lines[i], font, options.rightToLeft, options.ligatures);
			final glyphs = font.arabicPositioning != null && Lambda.exists(shaped, glyph -> glyph.arabic)
				? font.arabicPositioning.position(shaped, font)
				: [for (glyph in shaped) {id: glyph.id, advance: font.advance(glyph.id), x: 0, y: 0}];
			var pen = 0.0;
			if (options.rightToLeft)
				for (j in 0...glyphs.length) {
					pen -= glyphs[j].advance * scale;
					if (j > 0) pen -= font.pairAdjustment(glyphs[j - 1].id, glyphs[j].id) * scale;
				}
			final left = pen;
			final top = i * lineHeight;
			final baseline = top + font.ascent * scale;
			for (j in 0...glyphs.length) {
				final glyph = glyphs[j];
				if (j > 0) pen += font.pairAdjustment(glyphs[j - 1].id, glyph.id) * scale;
				place(glyph.id, pen + glyph.x * scale, baseline - glyph.y * scale);
				pen += glyph.advance * scale;
			}
			if (lineBounds != null) lineBounds(left, pen, top);
		}
	}

	static function flatten(points:Array<FontPoint>, x:Float, baseline:Float, scale:Float):Array<Point2D> {
		final last = points[points.length - 1];
		final first = points[0];
		final start = first.onCurve ? first : last.onCurve ? last : midpoint(last, first);
		var previous = start;
		final result = [new Point2D(x + start.x * scale, baseline - start.y * scale)];
		var i = first.onCurve ? 1 : 0;
		while (i < points.length) {
			final point = points[i++];
			if (point.onCurve) {
				result.push(new Point2D(x + point.x * scale, baseline - point.y * scale));
				previous = point;
			} else {
				final next = i == points.length ? start : points[i];
				final end = next.onCurve ? next : midpoint(point, next);
				if (i < points.length && next.onCurve) i++;
				final bend = Math.abs(previous.x - 2 * point.x + end.x) + Math.abs(previous.y - 2 * point.y + end.y);
				final steps = Std.int(Math.min(MAX_CURVE_STEPS, Math.max(MIN_CURVE_STEPS, Math.ceil(Math.sqrt(bend * scale)))));
				for (j in 1...steps + 1) {
					final t = j / steps;
					final u = 1 - t;
					final px = u * u * previous.x + 2 * u * t * point.x + t * t * end.x;
					final py = u * u * previous.y + 2 * u * t * point.y + t * t * end.y;
					result.push(new Point2D(x + px * scale, baseline - py * scale));
				}
				previous = end;
			}
		}
		return result;
	}

	static inline function midpoint(a:FontPoint, b:FontPoint):FontPoint {
		return {x: (a.x + b.x) * 0.5, y: (a.y + b.y) * 0.5, onCurve: true};
	}

	static function rasterize(image:Image, contours:Array<Array<FontPoint>>, x:Float, baseline:Float, scale:Float, ink:Color):Void {
		if (contours.length == 0 || ink.alpha == 0) return;
		final paths = [for (contour in contours) flatten(contour, x, baseline, scale)];
		var left = Math.POSITIVE_INFINITY, top = Math.POSITIVE_INFINITY;
		var right = Math.NEGATIVE_INFINITY, bottom = Math.NEGATIVE_INFINITY;
		for (path in paths)
			for (point in path) {
				left = Math.min(left, point.x);
				right = Math.max(right, point.x);
				top = Math.min(top, point.y);
				bottom = Math.max(bottom, point.y);
			}
		if (left >= image.width || right <= 0 || top >= image.height || bottom <= 0) return;
		final minX = Math.floor(Math.max(0, left));
		final maxX = Math.ceil(Math.min(image.width, right));
		final minY = Math.floor(Math.max(0, top));
		final maxY = Math.ceil(Math.min(image.height, bottom));
		final coverage = [for (_ in minX...maxX) 0.0];
		for (py in minY...maxY) {
			for (i in 0...coverage.length) coverage[i] = 0;
			for (sample in 0...SCANLINES_PER_PIXEL) {
				final line = py + (sample + 0.5) / SCANLINES_PER_PIXEL;
				final crossings:Array<{x:Float, direction:Int}> = [];
				for (path in paths) {
					var a = path[path.length - 1];
					for (b in path) {
						if ((a.y <= line && b.y > line) || (b.y <= line && a.y > line))
							crossings.push({x: a.x + (line - a.y) * (b.x - a.x) / (b.y - a.y), direction: b.y > a.y ? 1 : -1});
						a = b;
					}
				}
				crossings.sort((a, b) -> a.x < b.x ? -1 : a.x > b.x ? 1 : 0);
				var winding = 0;
				var start = 0.0;
				for (crossing in crossings) {
					if (winding == 0) start = crossing.x;
					winding += crossing.direction;
					if (winding != 0) continue;
					final lo = Math.max(minX, start);
					final hi = Math.min(maxX, crossing.x);
					if (hi <= lo) continue;
					for (px in Math.floor(lo)...Math.ceil(hi))
						coverage[px - minX] += Math.min(px + 1, hi) - Math.max(px, lo);
				}
			}
			for (i in 0...coverage.length) {
				if (coverage[i] <= 0) continue;
				final px = i + minX;
				final alpha = Math.min(1, coverage[i] / SCANLINES_PER_PIXEL) * ink.alphaFloat;
				final background = image.getPixel(px, py);
				final remainder = background.alphaFloat * (1 - alpha);
				final opacity = alpha + remainder;
				image.setPixel(px, py, Color.fromRGBA(Math.round((ink.red * alpha + background.red * remainder) / opacity),
					Math.round((ink.green * alpha + background.green * remainder) / opacity),
					Math.round((ink.blue * alpha + background.blue * remainder) / opacity), Math.round(opacity * MAX_CHANNEL_VALUE)));
			}
		}
	}
}

private class OutlineBounds {
	// Limit either coordinate to half the signed Int range so extents fit in Int.
	static inline var MAX_COORDINATE = MAX_INT >> 1;
	static inline var MAX_INT = 0x7fffffff;
	static inline var RGBA_BYTES_PER_PIXEL = 4;
	static inline var MAX_PACKED_IMAGE_WIDTH = 0xffff;

	public var left(default, null) = Math.POSITIVE_INFINITY;
	public var top(default, null) = Math.POSITIVE_INFINITY;
	var right = Math.NEGATIVE_INFINITY;
	var bottom = Math.NEGATIVE_INFINITY;

	public function new() {}

	public function include(x:Float, y:Float):Void {
		left = Math.min(left, x);
		top = Math.min(top, y);
		right = Math.max(right, x);
		bottom = Math.max(bottom, y);
	}

	public function includeOutline(contours:Array<Array<FontPoint>>, x:Float, baseline:Float, scale:Float):Void {
		for (contour in contours)
			for (point in contour) include(x + point.x * scale, baseline - point.y * scale);
	}

	public function rectangle():Rectangle {
		if (!Math.isFinite(left) || !Math.isFinite(right) || !Math.isFinite(top) || !Math.isFinite(bottom)
			|| left < -MAX_COORDINATE || top < -MAX_COORDINATE || right > MAX_COORDINATE || bottom > MAX_COORDINATE)
			throw new TextDrawingError("Rendered text bounds are too large.");
		final x = Math.floor(left);
		final y = Math.floor(top);
		return {x: x, y: y, width: Math.ceil(right) - x, height: Math.ceil(bottom) - y};
	}

	public function image(padding:Int):Image {
		if (padding < 0) throw new TextDrawingError("Text padding cannot be negative.");
		final bounds = rectangle();
		final width = bounds.width + 2.0 * padding;
		final height = bounds.height + 2.0 * padding;
		if (!Math.isFinite(width) || !Math.isFinite(height) || width > MAX_INT || height > MAX_INT
			|| Math.max(width, 1) * height * RGBA_BYTES_PER_PIXEL > MAX_INT - ImageBackend.PIXEL_OFFSET
			#if !vision_higher_width_cap || width > MAX_PACKED_IMAGE_WIDTH #end)
			throw new TextDrawingError("Rendered text image is too large.");
		return new Image(Std.int(height > 0 ? Math.max(width, 1) : width), Std.int(height));
	}
}

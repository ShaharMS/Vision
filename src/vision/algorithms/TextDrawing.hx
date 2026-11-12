package vision.algorithms;

import haxe.iterators.StringIteratorUnicode;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Point2D;
import vision.ds.TextFont;
import vision.ds.TextFont.FontPoint;
import vision.ds.specifics.TextOptions;

private typedef TextRun = {
	final codes:Array<Int>;
	final level:Int;
}

/** Portable rasterization of TrueType outlines. **/
@:noCompletion
class TextDrawing {
	static inline var SCANLINES = 4;

	// Isolated, final, initial, and medial Unicode presentation forms.
	static final arabicForms = [
		0x0621 => [0xfe80, 0, 0, 0],
		0x0622 => [0xfe81, 0xfe82, 0, 0],
		0x0623 => [0xfe83, 0xfe84, 0, 0],
		0x0624 => [0xfe85, 0xfe86, 0, 0],
		0x0625 => [0xfe87, 0xfe88, 0, 0],
		0x0626 => [0xfe89, 0xfe8a, 0xfe8b, 0xfe8c],
		0x0627 => [0xfe8d, 0xfe8e, 0, 0],
		0x0628 => [0xfe8f, 0xfe90, 0xfe91, 0xfe92],
		0x0629 => [0xfe93, 0xfe94, 0, 0],
		0x062a => [0xfe95, 0xfe96, 0xfe97, 0xfe98],
		0x062b => [0xfe99, 0xfe9a, 0xfe9b, 0xfe9c],
		0x062c => [0xfe9d, 0xfe9e, 0xfe9f, 0xfea0],
		0x062d => [0xfea1, 0xfea2, 0xfea3, 0xfea4],
		0x062e => [0xfea5, 0xfea6, 0xfea7, 0xfea8],
		0x062f => [0xfea9, 0xfeaa, 0, 0],
		0x0630 => [0xfeab, 0xfeac, 0, 0],
		0x0631 => [0xfead, 0xfeae, 0, 0],
		0x0632 => [0xfeaf, 0xfeb0, 0, 0],
		0x0633 => [0xfeb1, 0xfeb2, 0xfeb3, 0xfeb4],
		0x0634 => [0xfeb5, 0xfeb6, 0xfeb7, 0xfeb8],
		0x0635 => [0xfeb9, 0xfeba, 0xfebb, 0xfebc],
		0x0636 => [0xfebd, 0xfebe, 0xfebf, 0xfec0],
		0x0637 => [0xfec1, 0xfec2, 0xfec3, 0xfec4],
		0x0638 => [0xfec5, 0xfec6, 0xfec7, 0xfec8],
		0x0639 => [0xfec9, 0xfeca, 0xfecb, 0xfecc],
		0x063a => [0xfecd, 0xfece, 0xfecf, 0xfed0],
		0x0641 => [0xfed1, 0xfed2, 0xfed3, 0xfed4],
		0x0642 => [0xfed5, 0xfed6, 0xfed7, 0xfed8],
		0x0643 => [0xfed9, 0xfeda, 0xfedb, 0xfedc],
		0x0644 => [0xfedd, 0xfede, 0xfedf, 0xfee0],
		0x0645 => [0xfee1, 0xfee2, 0xfee3, 0xfee4],
		0x0646 => [0xfee5, 0xfee6, 0xfee7, 0xfee8],
		0x0647 => [0xfee9, 0xfeea, 0xfeeb, 0xfeec],
		0x0648 => [0xfeed, 0xfeee, 0, 0],
		0x0649 => [0xfeef, 0xfef0, 0xfbe8, 0xfbe9],
		0x064a => [0xfef1, 0xfef2, 0xfef3, 0xfef4],
	];

	public static function draw(image:Image, x:Int, y:Int, text:String, font:TextFont, options:TextOptions):Void {
		final scale = options.size / font.unitsPerEm;
		final lineHeight = options.lineHeight == 0 ? options.size * 1.25 : options.lineHeight;
		final lines = ~/\r\n?|\n/g.split(text);
		for (i in 0...lines.length) {
			final glyphs = shape(lines[i], font, options.rightToLeft, options.ligatures);
			var pen:Float = x;
			if (options.rightToLeft)
				for (j in 0...glyphs.length) {
					pen -= font.advance(glyphs[j]) * scale;
					if (j > 0) pen -= font.pairAdjustment(glyphs[j - 1], glyphs[j]) * scale;
				}
			final baseline = y + i * lineHeight + font.ascent * scale;
			for (j in 0...glyphs.length) {
				final id = glyphs[j];
				if (j > 0) pen += font.pairAdjustment(glyphs[j - 1], id) * scale;
				rasterize(image, font.outline(id), pen, baseline, scale, options.color);
				pen += font.advance(id) * scale;
			}
		}
	}

	static function shape(line:String, font:TextFont, rightToLeft:Bool, useLigatures:Bool):Array<Int> {
		final codes = [for (code in new StringIteratorUnicode(line)) code];
		final directions = [for (code in codes) direction(code)];
		final base = rightToLeft ? 1 : 0;
		var strong = base;
		final context = [for (dir in directions) {
			if (dir == 0 || dir == 1) strong = dir;
			dir == 2 ? strong : dir;
		}];
		var previous = base;
		var i = 0;
		while (i < context.length) {
			if (context[i] != -1) {
				previous = context[i++];
				continue;
			}
			final start = i;
			while (i < context.length && context[i] == -1) i++;
			final next = i < context.length ? context[i] : base;
			for (j in start...i) context[j] = previous == next ? previous : base;
		}

		final runs:Array<TextRun> = [];
		var run:TextRun = null;
		for (i in 0...codes.length) {
			final level = directions[i] == 2 && context[i] == 1 ? 2 : context[i] == 1 ? 1 : rightToLeft ? 2 : 0;
			if (run == null || run.level != level) {
				run = {codes: [], level: level};
				runs.push(run);
			}
			run.codes.push(codes[i]);
		}
		var start = 0;
		while (start < runs.length) {
			if (runs[start].level == 0) {
				start++;
				continue;
			}
			var end = start + 1;
			while (end < runs.length && runs[end].level > 0) end++;
			var left = start, right = end - 1;
			while (left < right) {
				final first = runs[left];
				runs[left++] = runs[right];
				runs[right--] = first;
			}
			start = end;
		}

		final result:Array<Int> = [];
		for (part in runs) {
			final rtl = part.level == 1;
			final mapped = rtl ? arabicGlyphs(part.codes, font) : [for (code in part.codes) mapGlyph(code, font)];
			final glyphs = useLigatures ? substitute(mapped, font) : mapped;
			if (rtl) glyphs.reverse();
			for (id in glyphs) if (id != -1) result.push(id);
		}
		return result;
	}

	static function direction(code:Int):Int {
		if ((code >= 0x30 && code <= 0x39) || (code >= 0x0660 && code <= 0x0669) || (code >= 0x06f0 && code <= 0x06f9))
			return 2;
		if ((code >= 0x05d0 && code <= 0x05ea) || (code >= 0x0620 && code <= 0x06ff) || (code >= 0xfb1d && code <= 0xfefc))
			return 1;
		if ((code >= 0x41 && code <= 0x5a) || (code >= 0x61 && code <= 0x7a) || (code >= 0xc0 && code < 0x0590))
			return 0;
		return -1;
	}

	static inline function mapGlyph(code:Int, font:TextFont):Int {
		return code == 0x200c || code == 0x200d ? -1 : font.glyph(code);
	}

	static function arabicGlyphs(codes:Array<Int>, font:TextFont):Array<Int> {
		final result = [];
		var i = 0;
		while (i < codes.length) {
			final code = codes[i];
			final forms = arabicForms.get(code);
			var shaped = 0;
			if (forms != null) {
				final previous = joiningNeighbor(codes, i, -1);
				final next = joiningNeighbor(codes, i, 1);
				final joinsPrevious = forms[1] != 0 && previous != null && previous[2] != 0;
				final joinsNext = forms[2] != 0 && next != null && next[1] != 0;
				if (code == 0x0644 && i + 1 < codes.length) {
					final pair = switch codes[i + 1] {
						case 0x0622: 0xfef5;
						case 0x0623: 0xfef7;
						case 0x0625: 0xfef9;
						case 0x0627: 0xfefb;
						default: 0;
					};
					if (pair != 0) {
						shaped = font.glyph(pair + (joinsPrevious ? 1 : 0));
						if (shaped != 0) i++;
					}
				}
				if (shaped == 0) {
					final form = forms[(joinsPrevious ? 1 : 0) + (joinsNext ? 2 : 0)];
					if (form != 0) shaped = font.glyph(form);
				}
			}
			result.push(shaped == 0 ? mapGlyph(code, font) : shaped);
			i++;
		}
		return result;
	}

	static function joiningNeighbor(codes:Array<Int>, index:Int, step:Int):Null<Array<Int>> {
		var i = index + step;
		while (i >= 0 && i < codes.length) {
			final code = codes[i];
			if (!(code >= 0x064b && code <= 0x065f) && code != 0x0670)
				return arabicForms.get(code);
			i += step;
		}
		return null;
	}

	static function substitute(glyphs:Array<Int>, font:TextFont):Array<Int> {
		final result = [];
		var i = 0;
		while (i < glyphs.length) {
			var id = glyphs[i++];
			final rules = font.ligatures.get(id);
			if (rules != null)
				for (rule in rules) {
					if (i + rule.following.length > glyphs.length) continue;
					var matches = true;
					for (j in 0...rule.following.length)
						if (glyphs[i + j] != rule.following[j]) {
							matches = false;
							break;
						}
					if (!matches) continue;
					id = rule.replacement;
					i += rule.following.length;
					break;
				}
			result.push(id);
		}
		return result;
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
				final steps = Std.int(Math.min(64, Math.max(2, Math.ceil(Math.sqrt(bend * scale)))));
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
			for (sample in 0...SCANLINES) {
				final line = py + (sample + 0.5) / SCANLINES;
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
				final alpha = Math.min(1, coverage[i] / SCANLINES) * ink.alphaFloat;
				final background = image.getPixel(px, py);
				final remainder = background.alphaFloat * (1 - alpha);
				final opacity = alpha + remainder;
				image.setPixel(px, py, Color.fromRGBA(Math.round((ink.red * alpha + background.red * remainder) / opacity),
					Math.round((ink.green * alpha + background.green * remainder) / opacity),
					Math.round((ink.blue * alpha + background.blue * remainder) / opacity), Math.round(opacity * 255)));
			}
		}
	}
}

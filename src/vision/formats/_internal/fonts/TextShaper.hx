package vision.formats._internal.fonts;

import haxe.iterators.StringIteratorUnicode;
import haxe.ds.IntMap;
import vision.formats._internal.fonts.FontData.FontLigature;

typedef ShapedGlyph = {
	final id:Int;
	final script:String;
	final rtl:Bool;
	final component:Int;
}

private typedef TextRun = {
	final codes:Array<Int>;
	final level:Int;
	final script:String;
}

/**
	Resolves glyphs and visual run order for the portable renderer. Arabic
	joining falls back to Unicode presentation forms supported by the font.
**/
@:noCompletion
class TextShaper {
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

	public static function shape(line:String, font:FontData, rightToLeft:Bool, useLigatures:Bool):Array<Int> {
		return [for (glyph in shapeGlyphs(line, font, rightToLeft, useLigatures)) glyph.id];
	}

	public static function shapeGlyphs(line:String, font:FontData, rightToLeft:Bool, useLigatures:Bool):Array<ShapedGlyph> {
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
		var previousScript = "";
		for (i in 0...codes.length) {
			final level = directions[i] == 2 && context[i] == 1 ? 2 : context[i] == 1 ? 1 : rightToLeft ? 2 : 0;
			var script = scriptFor(codes[i]);
			if (script == "") script = previousScript;
			if (script == "") {
				for (j in i + 1...codes.length) {
					script = scriptFor(codes[j]);
					if (script != "") break;
				}
			}
			if (run == null || run.level != level || run.script != script) {
				run = {codes: [], level: level, script: script};
				runs.push(run);
			}
			run.codes.push(codes[i]);
			previousScript = script;
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

		final result:Array<ShapedGlyph> = [];
		for (part in runs) {
			final rtl = part.level == 1;
			final glyphs = switch part.script {
				case "arab", "syrc": joiningGlyphs(part.codes, font, useLigatures, part.script);
				default: defaultGlyphs(part, font, useLigatures, rtl);
			};
			if (rtl) glyphs.reverse();
			for (glyph in glyphs) result.push(glyph);
		}
		return result;
	}

	public static function positionGlyphs(glyphs:Array<ShapedGlyph>, font:FontData):Array<OpenTypePositioning.GlyphPlacement> {
		final result = [];
		var start = 0;
		while (start < glyphs.length) {
			final first = glyphs[start];
			var end = start + 1;
			while (end < glyphs.length && glyphs[end].script == first.script && glyphs[end].rtl == first.rtl) end++;
			final run = glyphs.slice(start, end);
			final engine = font.positioningFor(first.script);
			final placements = engine == null ? [for (glyph in run) {id: glyph.id, advance: font.advance(glyph.id), x: 0, y: 0}]
				: engine.position(run, font);
			for (glyph in placements) result.push(glyph);
			start = end;
		}
		return result;
	}

	static function scriptFor(code:Int):String {
		if (isArabic(code)) return "arab";
		if ((code >= 0x0700 && code <= 0x074f) || (code >= 0x0860 && code <= 0x086f)) return "syrc";
		if ((code >= 0x0590 && code <= 0x05ff) || (code >= 0xfb1d && code <= 0xfb4f)) return "hebr";
		if ((code >= 0x0900 && code <= 0x097f) || (code >= 0xa8e0 && code <= 0xa8ff)) return "dev2";
		if ((code >= 0x1100 && code <= 0x11ff) || (code >= 0xac00 && code <= 0xd7ff)) return "hang";
		if (code >= 0x3040 && code <= 0x30ff) return "kana";
		if ((code >= 0x3400 && code <= 0x9fff) || (code >= 0x20000 && code <= 0x323af)) return "hani";
		if ((code >= 0x41 && code <= 0x5a) || (code >= 0x61 && code <= 0x7a) || (code >= 0xc0 && code < 0x0590)) return "latn";
		return "";
	}

	static function defaultGlyphs(run:TextRun, font:FontData, useLigatures:Bool, rtl:Bool):Array<ShapedGlyph> {
		final codes = run.script == "hang" ? ScriptComposition.hangul(run.codes, font) : run.codes;
		if (run.script == "hebr") ArabicJoining.reorderHebrewMarks(codes);
		final glyphs = [for (code in codes) mapGlyph(code, font)];
		final engine = font.substitutionsFor(run.script);
		if (engine != null) {
			engine.apply("ccmp", glyphs);
			if (run.script == "dev2") Devanagari.shape(codes, glyphs, engine);
			engine.apply("rlig", glyphs);
			if (useLigatures) engine.apply("liga", glyphs);
		}
		final mapped = run.script == "latn" && useLigatures && engine == null ? substitute(glyphs, font.ligatures) : glyphs;
		return [for (id in mapped) if (id >= 0) {id: id, script: run.script, rtl: rtl, component: -1}];
	}

	static inline function isArabic(code:Int):Bool {
		return (code >= 0x0600 && code <= 0x06ff) || (code >= 0x0750 && code <= 0x077f)
			|| (code >= 0x0870 && code <= 0x08ff) || (code >= 0xfb50 && code <= 0xfdff)
			|| (code >= 0xfe70 && code <= 0xfefc);
	}

	static function direction(code:Int):Int {
		if ((code >= 0x30 && code <= 0x39) || (code >= 0x0660 && code <= 0x0669) || (code >= 0x06f0 && code <= 0x06f9))
			return 2;
		final script = scriptFor(code);
		if (script == "arab" || script == "hebr" || script == "syrc") return 1;
		if (script != "") return 0;
		return -1;
	}

	static inline function mapGlyph(code:Int, font:FontData):Int {
		return code == 0x200c || code == 0x200d ? -1 : font.glyph(code);
	}

	static function joiningGlyphs(codes:Array<Int>, font:FontData, useLigatures:Bool, script:String):Array<ShapedGlyph> {
		if (script == "arab") ArabicJoining.reorderMarks(codes);
		final substitutions = font.substitutionsFor(script);
		// Join controls affect joining and block GSUB matches, but draw no glyph.
		final glyphs = [for (code in codes) mapGlyph(code, font) < 0 ? -2 : font.glyph(code)];
		final joining = [for (code in codes) ArabicJoining.type(code)];
		final previousJoins = [];
		final nextJoins = [];
		final forms = [];
		for (i in 0...codes.length) {
			final type = joining[i];
			final previous = ArabicJoining.joinsPrevious(type) && ArabicJoining.joinsNext(joiningNeighbor(joining, i, -1));
			final next = ArabicJoining.joinsNext(type) && ArabicJoining.joinsPrevious(joiningNeighbor(joining, i, 1));
			previousJoins.push(previous);
			nextJoins.push(next);
			forms.push(previous ? (next ? "medi" : "fina") : (next ? "init" : "isol"));
		}

		final substituted = [for (_ in codes) false];
		final components = [for (_ in codes) -1];
		if (substitutions != null) {
			substitutions.apply("ccmp", glyphs);
			for (feature in ["isol", "fina", "medi", "init"])
				substitutions.apply(feature, glyphs, forms, substituted);
			substitutions.apply("rlig", glyphs, null, null, components);
		}
		for (i in 0...codes.length) {
			if (glyphs[i] < 0) continue;
			final code = codes[i];
			if (code == 0x0644 && i + 1 < codes.length && glyphs[i] == font.glyph(code)
				&& glyphs[i + 1] == font.glyph(codes[i + 1])) {
				final pair = lamAlef(font, codes[i + 1], previousJoins[i]);
				if (pair != 0) {
					glyphs[i] = pair;
					glyphs[i + 1] = -1;
					continue;
				}
			}
			final presentation = arabicForms.get(code);
			if (presentation != null && !substituted[i] && glyphs[i] == font.glyph(code)) {
				final form = presentation[(previousJoins[i] ? 1 : 0) + (nextJoins[i] ? 2 : 0)];
				final fallback = form == 0 ? 0 : font.glyph(form);
				if (fallback != 0) glyphs[i] = fallback;
			}
		}
		if (substitutions != null) {
			substitutions.applyContext(glyphs);
			if (useLigatures) substitutions.apply("liga", glyphs, null, null, components);
		}
		return [for (i in 0...glyphs.length) if (glyphs[i] >= 0) {id: glyphs[i], script: script, rtl: true, component: components[i]}];
	}

	static function lamAlef(font:FontData, alef:Int, joinsPrevious:Bool):Int {
		final pair = switch alef {
			case 0x0622: 0xfef5;
			case 0x0623: 0xfef7;
			case 0x0625: 0xfef9;
			case 0x0627: 0xfefb;
			default: return 0;
		};
		return font.glyph(pair + (joinsPrevious ? 1 : 0));
	}

	static function joiningNeighbor(types:Array<Int>, index:Int, step:Int):Int {
		var i = index + step;
		while (i >= 0 && i < types.length) {
			if (!ArabicJoining.isTransparent(types[i])) return types[i];
			i += step;
		}
		return 0;
	}

	static function matchingLigature(glyphs:Array<Int>, index:Int, lookup:IntMap<Array<FontLigature>>):Null<FontLigature> {
		final rules = lookup.get(glyphs[index]);
		if (rules == null) return null;
		for (rule in rules) {
			if (index + rule.following.length >= glyphs.length) continue;
			var matches = true;
			for (j in 0...rule.following.length) {
				if (glyphs[index + 1 + j] != rule.following[j]) {
					matches = false;
					break;
				}
			}
			if (matches) return rule;
		}
		return null;
	}

	static function substitute(glyphs:Array<Int>, lookup:IntMap<Array<FontLigature>>):Array<Int> {
		final result = [];
		var i = 0;
		while (i < glyphs.length) {
			final rule = matchingLigature(glyphs, i, lookup);
			if (rule == null) {
				result.push(glyphs[i++]);
			} else {
				result.push(rule.replacement);
				i += 1 + rule.following.length;
			}
		}
		return result;
	}
}

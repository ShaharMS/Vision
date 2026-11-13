package vision.formats._internal.fonts;

import haxe.ds.IntMap;
import vision.formats._internal.fonts.FontData.FontLigature;

/** Applies supported OpenType GSUB features in logical order. **/
@:noCompletion
class OpenTypeSubstitutions {
	final layout:OpenTypeLookups;
	final font:FontData;
	final ligatures = new IntMap<IntMap<Array<FontLigature>>>();
	static inline var MAX_CONTEXT_DEPTH = 8;

	public function new(gsub:FontTable, gdef:Null<FontTable>, script:String, font:FontData) {
		layout = new OpenTypeLookups(gsub, gdef, script);
		this.font = font;
	}

	public function apply(tag:String, glyphs:Array<Int>, ?forms:Array<String>, ?substituted:Array<Bool>, ?components:Array<Int>):Void {
		applyLookups(layout.feature(tag), glyphs, tag, forms, substituted, components);
	}

	public function applyContext(glyphs:Array<Int>):Void {
		final required = layout.feature("rclt");
		final lookups = required.concat(layout.feature("calt").filter(id -> !required.contains(id)));
		lookups.sort((a, b) -> a - b);
		applyLookups(lookups, glyphs, "");
	}

	function applyLookups(lookups:Array<Int>, glyphs:Array<Int>, tag:String, ?forms:Array<String>, ?substituted:Array<Bool>, ?components:Array<Int>):Void {
		for (id in lookups) {
			var i = 0;
			while (i < glyphs.length) {
				if (forms == null || forms[i] == tag) {
					if (applyAt(id, glyphs, i, 0, components) && substituted != null) substituted[i] = true;
				}
				i++;
			}
		}
	}

	function applyAt(id:Int, glyphs:Array<Int>, index:Int, depth:Int, components:Null<Array<Int>>):Bool {
		if (depth >= MAX_CONTEXT_DEPTH) return false;
		final table = layout.table;
		final lookup = layout.lookup(id);
		if (lookup == 0) return false;
		final flags = table.u16(lookup + 2);
		if (glyphs[index] < 0 || (flags & 0xfff0) != 0 || layout.ignored(glyphs[index], flags)) return false;
		function next(from:Int, step:Int, flags:Int):Int {
			var i = from + step;
			while (i >= 0 && i < glyphs.length) {
				if (!layout.ignored(glyphs[i], flags)) return i;
				i += step;
			}
			return -1;
		}
		for (i in 0...table.u16(lookup + 4)) {
			var sub = lookup + table.u16(lookup + 6 + i * 2);
			var type = table.u16(lookup);
			if (type == 7 && table.u16(sub) == 1) {
				type = table.u16(sub + 2);
				sub += table.u32(sub + 4);
			}
			switch type {
				case 1:
					final covered = layout.coverage(sub + table.u16(sub + 2), glyphs[index]);
					if (covered < 0) continue;
					final replacement = switch table.u16(sub) {
						case 1: (glyphs[index] + table.i16(sub + 4)) & 0xffff;
						case 2: covered < table.u16(sub + 4) ? table.u16(sub + 6 + covered * 2) : -1;
						default: -1;
					};
					if (replacement < 0 || replacement >= font.glyphCount) continue;
					glyphs[index] = replacement;
					return true;
				case 4:
					var rules = ligatures.get(sub);
					if (rules == null) {
						rules = new IntMap();
						font.readLigatureSet(table, sub, rules);
						ligatures.set(sub, rules);
					}
					final candidates = rules.get(glyphs[index]);
					if (candidates == null) continue;
					for (rule in candidates) {
						final matched = [];
						var position = index;
						for (expected in rule.following) {
							position = next(position, 1, flags);
							if (position < 0 || glyphs[position] != expected) break;
							matched.push(position);
						}
						if (matched.length != rule.following.length) continue;
						glyphs[index] = rule.replacement;
						// Keep logical indices stable for later contextual rules and fallback.
						var previous = index;
						for (part in 0...matched.length) {
							final position = matched[part];
							if (components != null)
								for (mark in previous + 1...position) components[mark] = part;
							glyphs[position] = -1;
							previous = position;
						}
						if (components != null) {
							var mark = previous + 1;
							while (mark < glyphs.length && layout.glyphClass(glyphs[mark]) == 3)
								components[mark++] = matched.length;
						}
						return true;
					}
				case 6:
					if (table.u16(sub) != 3) continue;
					final match = layout.context(sub, glyphs, index, flags, next);
					if (match == null) continue;
					for (j in 0...table.u16(match.records)) {
						final record = match.records + 2 + j * 4;
						final position = table.u16(record);
						if (position < match.inputs.length && glyphs[match.inputs[position]] >= 0)
							applyAt(table.u16(record + 2), glyphs, match.inputs[position], depth + 1, components);
					}
					return true;
				default:
			}
		}
		return false;
	}
}

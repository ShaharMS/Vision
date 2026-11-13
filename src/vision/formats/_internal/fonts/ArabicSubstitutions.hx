package vision.formats._internal.fonts;

import haxe.ds.IntMap;
import vision.formats._internal.fonts.FontData.FontLigature;

/** Supported GSUB lookups from the Arabic script's default language system. **/
@:noCompletion
class ArabicSubstitutions {
	final forms = new Map<String, Array<IntMap<Int>>>();
	public final requiredLigatures:Array<IntMap<Array<FontLigature>>> = [];

	public function new(gsub:FontTable, font:FontData) {
		final scriptList = gsub.u16(4);
		final featureList = gsub.u16(6);
		final lookupList = gsub.u16(8);
		var arabicScript = 0;
		var defaultScript = 0;
		for (i in 0...gsub.u16(scriptList)) {
			final record = scriptList + 2 + i * 6;
			switch gsub.tag(record) {
				case "arab": arabicScript = scriptList + gsub.u16(record + 4);
				case "DFLT": defaultScript = scriptList + gsub.u16(record + 4);
				default:
			}
		}
		final script = arabicScript != 0 ? arabicScript : defaultScript;
		if (script == 0) return;
		final defaultLanguage = gsub.u16(script);
		if (defaultLanguage == 0) return;

		final language = script + defaultLanguage;
		final requiredFeature = gsub.u16(language + 2);
		final featureIndices = [for (i in 0...gsub.u16(language + 4)) gsub.u16(language + 6 + i * 2)];
		if (requiredFeature != 0xffff) featureIndices.push(requiredFeature);
		final indicesByTag = new Map<String, Array<Int>>();
		for (index in featureIndices) {
			if (index >= gsub.u16(featureList)) continue;
			final record = featureList + 2 + index * 6;
			final tag = gsub.tag(record);
			if (tag != "isol" && tag != "init" && tag != "medi" && tag != "fina" && tag != "rlig") continue;
			var indices = indicesByTag.get(tag);
			if (indices == null) {
				indices = [];
				indicesByTag.set(tag, indices);
			}
			final feature = featureList + gsub.u16(record + 4);
			for (i in 0...gsub.u16(feature + 2)) {
				final lookupIndex = gsub.u16(feature + 4 + i * 2);
				if (lookupIndex < gsub.u16(lookupList) && !indices.contains(lookupIndex)) indices.push(lookupIndex);
			}
		}
		for (tag => indices in indicesByTag) {
			indices.sort((a, b) -> a - b);
			final formLookups = [];
			for (index in indices) {
				final lookup = lookupList + gsub.u16(lookupList + 2 + index * 2);
				final lookupType = gsub.u16(lookup);
				// Filtering flags require GDEF classes. Skip lookups that depend on them.
				if ((gsub.u16(lookup + 2) & 0xfffe) != 0) continue;
				final singles = new IntMap<Int>();
				final ligatures = new IntMap<Array<FontLigature>>();
				for (i in 0...gsub.u16(lookup + 4)) {
					var sub = lookup + gsub.u16(lookup + 6 + i * 2);
					var type = lookupType;
					if (type == 7 && gsub.u16(sub) == 1) {
						type = gsub.u16(sub + 2);
						sub += gsub.u32(sub + 4);
					}
					if (tag == "rlig" && type == 4) font.readLigatureSet(gsub, sub, ligatures);
					else if (tag != "rlig" && type == 1) readSingleSubstitutions(gsub, sub, font, singles);
				}
				if (ligatures.keys().hasNext()) requiredLigatures.push(ligatures);
				if (singles.keys().hasNext()) formLookups.push(singles);
			}
			forms.set(tag, formLookups);
		}
	}

	static function readSingleSubstitutions(gsub:FontTable, sub:Int, font:FontData, result:IntMap<Int>):Void {
		final format = gsub.u16(sub);
		if (format != 1 && format != 2) return;
		final coverage = font.coverageGlyphs(gsub, sub + gsub.u16(sub + 2));
		final count = format == 1 ? coverage.length : gsub.u16(sub + 4);
		final delta = format == 1 ? gsub.i16(sub + 4) : 0;
		for (i in 0...Std.int(Math.min(coverage.length, count))) {
			final source = coverage[i];
			final replacement = format == 1 ? (source + delta) & 0xffff : gsub.u16(sub + 6 + i * 2);
			if (source < font.glyphCount && replacement < font.glyphCount && !result.exists(source))
				result.set(source, replacement);
		}
	}

	/** Returns null when the font has no applicable supported substitution. **/
	public function form(tag:String, glyph:Int):Null<Int> {
		final lookups = forms.get(tag);
		if (lookups == null) return null;
		var matched = false;
		for (lookup in lookups) {
			final replacement = lookup.get(glyph);
			if (replacement != null) {
				glyph = replacement;
				matched = true;
			}
		}
		return matched ? glyph : null;
	}
}

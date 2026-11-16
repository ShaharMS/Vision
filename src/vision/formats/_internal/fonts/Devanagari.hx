package vision.formats._internal.fonts;

/** Horizontal shaping for common Devanagari consonant clusters and matras. **/
@:noCompletion
class Devanagari {
	static inline var VIRAMA = 0x094d;
	static inline var SHORT_I = 0x093f;

	public static function shape(codes:Array<Int>, glyphs:Array<Int>, engine:OpenTypeSubstitutions):Void {
		for (feature in ["nukt", "akhn", "rkrf", "blwf"])
			engine.apply(feature, glyphs);

		final halfForms = [for (i in 0...codes.length) i + 2 < codes.length && consonant(codes[i])
			&& codes[i + 1] == VIRAMA && consonant(codes[i + 2]) ? "half" : ""];
		engine.apply("half", glyphs, halfForms);
		engine.apply("cjct", glyphs);

		for (i in 1...codes.length) {
			if (codes[i] != SHORT_I || !consonant(codes[i - 1])) continue;
			var start = i - 1;
			while (start >= 2 && codes[start - 1] == VIRAMA && consonant(codes[start - 2])) start -= 2;
			final matra = glyphs[i];
			var j = i;
			while (j > start) {
				glyphs[j] = glyphs[j - 1];
				j--;
			}
			glyphs[start] = matra;
		}
		for (feature in ["pres", "abvs", "blws", "psts", "haln", "calt"])
			engine.apply(feature, glyphs);
	}

	static inline function consonant(code:Int):Bool return (code >= 0x0915 && code <= 0x0939) || (code >= 0x0958 && code <= 0x095f);
}

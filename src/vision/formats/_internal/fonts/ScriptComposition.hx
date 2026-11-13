package vision.formats._internal.fonts;

/** Unicode Hangul composition for fonts that supply the composed syllable. **/
@:noCompletion
class ScriptComposition {
	static inline var LEADING_JAMO = 0x1100;
	static inline var VOWEL_JAMO = 0x1161;
	static inline var TRAILING_JAMO_BASE = 0x11a7;
	static inline var FIRST_SYLLABLE = 0xac00;
	static inline var LEADING_COUNT = 19;
	static inline var VOWEL_COUNT = 21;
	static inline var TRAILING_COUNT = 28;
	static inline var SYLLABLE_COUNT = LEADING_COUNT * VOWEL_COUNT * TRAILING_COUNT;

	public static function hangul(codes:Array<Int>, font:FontData):Array<Int> {
		final result = [];
		var i = 0;
		while (i < codes.length) {
			final original = codes[i++];
			var syllable = original;
			var end = i;
			final leading = original - LEADING_JAMO;
			if (leading >= 0 && leading < LEADING_COUNT && end < codes.length) {
				final vowel = codes[end] - VOWEL_JAMO;
				if (vowel >= 0 && vowel < VOWEL_COUNT) {
					syllable = FIRST_SYLLABLE + (leading * VOWEL_COUNT + vowel) * TRAILING_COUNT;
					end++;
				}
			}
			final index = syllable - FIRST_SYLLABLE;
			if (index >= 0 && index < SYLLABLE_COUNT && index % TRAILING_COUNT == 0 && end < codes.length) {
				final trailing = codes[end] - TRAILING_JAMO_BASE;
				if (trailing > 0 && trailing < TRAILING_COUNT) {
					syllable += trailing;
					end++;
				}
			}
			if (end > i && font.glyph(syllable) != 0) {
				result.push(syllable);
				i = end;
			} else result.push(original);
		}
		return result;
	}
}

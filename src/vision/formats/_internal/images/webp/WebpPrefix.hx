package vision.formats._internal.images.webp;

import vision.exceptions.ImageLoadingFailed;

/** Canonical VP8L prefix codes. Single-symbol trees consume no bits. **/
@:noCompletion
class WebpPrefix {
	static final order = [17, 18, 0, 1, 2, 3, 4, 5, 16, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
	static final repeatBits = [2, 3, 7];
	static final repeatBase = [3, 3, 11];
	final first:Array<Int> = [];
	final limit:Array<Int> = [];
	final start:Array<Int> = [];
	final symbols:Array<Int> = [];

	public function new(lengths:Array<Int>) {
		final counts = [for (_ in 0...16) 0];
		for (length in lengths) counts[length]++;
		final used = lengths.length - counts[0];
		if (used == 0) throw invalid();
		if (used == 1) {
			for (i in 0...lengths.length) if (lengths[i] != 0) symbols.push(i);
			return;
		}
		var code = 0;
		for (length in 1...16) {
			first.push(code);
			start.push(symbols.length);
			code += counts[length];
			limit.push(code);
			if (code > (1 << length)) throw invalid();
			for (i in 0...lengths.length)
				if (lengths[i] == length) symbols.push(i);
			code <<= 1;
		}
		if (code != 65536) throw invalid();
	}

	public function symbol(bits:WebpBits):Int {
		if (symbols.length == 1) return symbols[0];
		var code = 0;
		for (i in 0...15) {
			code = (code << 1) | bits.read(1);
			if (code >= first[i] && code < limit[i]) return symbols[start[i] + code - first[i]];
		}
		throw invalid();
	}

	public static function read(bits:WebpBits, alphabet:Int):WebpPrefix {
		final lengths = [for (_ in 0...alphabet) 0];
		if (bits.read(1) == 1) {
			final two = bits.read(1) == 1;
			final first = bits.read(bits.read(1) == 0 ? 1 : 8);
			if (first >= alphabet) throw invalid();
			lengths[first] = 1;
			if (!two) return new WebpPrefix(lengths);
			final second = bits.read(8);
			if (second >= alphabet || second == first) throw invalid();
			lengths[second] = 1;
			final tree = new WebpPrefix(lengths);
			tree.symbols[0] = first;
			tree.symbols[1] = second;
			return tree;
		}
		final count = bits.read(4) + 4;
		final codes = [for (_ in 0...19) 0];
		for (i in 0...count) codes[order[i]] = bits.read(3);
		final tree = new WebpPrefix(codes);
		var remaining = bits.read(1) == 0 ? alphabet : 2 + bits.read(2 + 2 * bits.read(3));
		if (remaining > alphabet) throw invalid();
		var previous = 8;
		var index = 0;
		while (index < alphabet && remaining > 0) {
			remaining--;
			final length = tree.symbol(bits);
			if (length < 16) {
				lengths[index++] = length;
				if (length != 0) previous = length;
			} else {
				final count = repeatBase[length - 16] + bits.read(repeatBits[length - 16]);
				if (count > alphabet - index) throw invalid();
				for (_ in 0...count) lengths[index++] = length == 16 ? previous : 0;
			}
		}
		return new WebpPrefix(lengths);
	}

	static inline function invalid():ImageLoadingFailed return new ImageLoadingFailed(WEBP, "Invalid lossless WebP prefix tree.");
}

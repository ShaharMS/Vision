package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/**
	Reads adaptive entropy-coded symbols from one AV1 tile.

	The decoder uses the 15-bit cumulative distributions and finite-tile
	padding defined by AV1 sections 8.2.2 through 8.2.6.
**/
@:noCompletion
class Av1SymbolDecoder {
	static inline var PROBABILITY_TOP = 32768;
	static inline var MIN_PROBABILITY = 4;

	final bytes:Bytes;
	final offset:Int;
	final tileBits:Int;
	final updateCdf:Bool;
	var position = 0;
	var remaining:Int;
	var range = PROBABILITY_TOP;
	var value:Int;
	var finished = false;

	/**
		Initializes the entropy decoder for a byte-aligned tile.

		@param bytes The bytes containing the tile
		@param offset The first tile byte
		@param length The tile length in bytes
		@param updateCdf Whether to adapt the caller's probability tables
	**/
	public function new(bytes:Bytes, offset:Int, length:Int, updateCdf:Bool = true) {
		if (offset < 0 || length <= 0 || length > 0x0fffffff || offset > bytes.length - length)
			throw new Av1BitstreamError("Invalid tile byte range.");
		this.bytes = bytes;
		this.offset = offset;
		this.updateCdf = updateCdf;
		tileBits = length * 8;
		final initial = tileBits < 15 ? tileBits : 15;
		value = (PROBABILITY_TOP - 1) ^ (readBits(initial) << (15 - initial));
		remaining = tileBits - 15;
	}

	/**
		Decodes one symbol and optionally updates its cumulative distribution.

		@param cdf Increasing cumulative probabilities for 2 to 16 symbols,
		ending in 32768, followed by an adaptation count from zero to 32
		@return The zero-based symbol index
	**/
	public function readSymbol(cdf:Array<Int>):Int {
		checkOpen();
		final count = cdf.length - 1;
		if (count < 2 || count > 16 || cdf[count - 1] != PROBABILITY_TOP || cdf[count] < 0 || cdf[count] > 32)
			throw new Av1BitstreamError("Invalid symbol distribution.");
		var previous = 0;
		for (i in 0...count) {
			if (cdf[i] < previous || cdf[i] > PROBABILITY_TOP)
				throw new Av1BitstreamError("Non-monotonic symbol distribution.");
			previous = cdf[i];
		}

		var symbol = 0;
		var upper = range;
		var lower = boundary(cdf[0], count - 1);
		while (value < lower) {
			upper = lower;
			symbol++;
			lower = boundary(cdf[symbol], count - symbol - 1);
		}
		normalize(upper, lower);
		if (updateCdf) adapt(cdf, count, symbol);
		return symbol;
	}

	/** Reads a literal of up to 31 bits using equal-probability binary symbols. **/
	public function readLiteral(count:Int):Int {
		checkOpen();
		if (count < 0 || count > 31) throw new Av1BitstreamError("Invalid literal length.");
		var result = 0;
		for (_ in 0...count) {
			final split = boundary(PROBABILITY_TOP >> 1, 1);
			if (value >= split) {
				normalize(range, split);
				result <<= 1;
			} else {
				normalize(split, 0);
				result = (result << 1) | 1;
			}
		}
		return result;
	}

	/** Checks the tile's terminating one bit and the following zero padding. **/
	public function finish():Void {
		checkOpen();
		final buffered = remaining + 15;
		final trailing = position - (buffered < 15 ? buffered : 15);
		if (trailing < 0 || trailing >= tileBits || bitAt(trailing) != 1)
			throw new Av1BitstreamError("Missing tile trailing bit.");
		for (i in trailing + 1...tileBits)
			if (bitAt(i) != 0) throw new Av1BitstreamError("Nonzero tile padding.");
		finished = true;
	}

	inline function boundary(cumulative:Int, symbolsAfter:Int):Int {
		return (((range >> 8) * ((PROBABILITY_TOP - cumulative) >> 6)) >> 1) + MIN_PROBABILITY * symbolsAfter;
	}

	function normalize(upper:Int, lower:Int):Void {
		range = upper - lower;
		value -= lower;
		var shift = 0;
		while (range < PROBABILITY_TOP) {
			range <<= 1;
			shift++;
		}
		final available = remaining < 0 ? 0 : remaining;
		final count = shift < available ? shift : available;
		final data = readBits(count) << (shift - count);
		value = data ^ (((value + 1) << shift) - 1);
		remaining -= shift;
		if (remaining < -14) throw new Av1BitstreamError("Tile entropy data ended early.");
	}

	static function adapt(cdf:Array<Int>, count:Int, symbol:Int):Void {
		final observations = cdf[count];
		final rate = (count < 4 ? 4 : 5) + (observations > 15 ? 1 : 0) + (observations > 31 ? 1 : 0);
		for (i in 0...count - 1) {
			if (i < symbol) cdf[i] -= cdf[i] >> rate;
			else cdf[i] += (PROBABILITY_TOP - cdf[i]) >> rate;
		}
		if (observations < 32) cdf[count] = observations + 1;
	}

	inline function bitAt(index:Int):Int return (bytes.get(offset + (index >> 3)) >>> (7 - (index & 7))) & 1;

	function readBits(count:Int):Int {
		var result = 0;
		for (_ in 0...count) result = (result << 1) | bitAt(position++);
		return result;
	}

	inline function checkOpen():Void {
		if (finished) throw new Av1BitstreamError("Tile entropy decoder has finished.");
	}
}

package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** Writes adaptive arithmetic-coded symbols for one AV1 tile. **/
@:noCompletion
class Av1SymbolEncoder {
	static inline final TOP = 32768;
	final updateCdf:Bool;
	final bytesWithCarry:Array<Int> = [];
	var low = 0;
	var range = TOP;
	var pendingBits = -9;
	var finished = false;

	/** Starts a tile, optionally disabling adaptation of the caller's CDFs. **/
	public function new(updateCdf:Bool = true) this.updateCdf = updateCdf;

	/**
		Writes a symbol using increasing Q15 probabilities ending in 32768,
		followed by the adaptation count.
	**/
	public function writeSymbol(symbol:Int, cdf:Array<Int>):Void {
		checkOpen();
		final count = Av1SymbolDecoder.validateCdf(cdf);
		if (symbol < 0 || symbol >= count) throw new Av1BitstreamError("Symbol is outside its distribution.");
		final upper = symbol == 0 ? range : Av1SymbolDecoder.boundary(range, cdf[symbol - 1], count - symbol);
		final lower = Av1SymbolDecoder.boundary(range, cdf[symbol], count - symbol - 1);
		narrow(upper, lower);
		if (updateCdf) Av1SymbolDecoder.adapt(cdf, count, symbol);
	}

	/** Writes up to 31 equiprobable bits, most significant first. **/
	public function writeLiteral(value:Int, count:Int):Void {
		checkOpen();
		if (count < 0 || count > 31 || value < 0 || (value >>> count) != 0)
			throw new Av1BitstreamError("Value does not fit the AV1 literal length.");
		var bit = count;
		while (bit > 0) {
			final split = Av1SymbolDecoder.boundary(range, TOP >> 1, 1);
			if (((value >>> --bit) & 1) == 0) narrow(range, split);
			else narrow(split, 0);
		}
	}

	/** Writes the terminating one bit and byte padding, then resolves carries. **/
	public function finish():Bytes {
		checkOpen();
		finished = true;
		// Choose the endpoint with the required trailing one inside the interval.
		var endpoint = ((low + 16383) & ~16383) | 16384;
		var shift = pendingBits + 16;
		var bits = pendingBits + 10;
		while (bits > 0) {
			bytesWithCarry.push(endpoint >>> shift);
			endpoint &= (1 << shift) - 1;
			shift -= 8;
			bits -= 8;
		}
		final output = Bytes.alloc(bytesWithCarry.length);
		var index = bytesWithCarry.length;
		var carry = 0;
		while (index > 0) {
			final value = bytesWithCarry[--index] + carry;
			output.set(index, value & 255);
			carry = value >>> 8;
		}
		return output;
	}

	function narrow(upper:Int, lower:Int):Void {
		low += range - upper;
		range = upper - lower;
		var shift = 0;
		while (range < TOP) {
			range <<= 1;
			shift++;
		}
		while (pendingBits + shift >= 0) {
			final cut = pendingBits + 16;
			bytesWithCarry.push(low >>> cut);
			low &= (1 << cut) - 1;
			pendingBits -= 8;
		}
		low <<= shift;
		pendingBits += shift;
	}

	inline function checkOpen():Void {
		if (finished) throw new Av1BitstreamError("Tile entropy encoder has finished.");
	}
}

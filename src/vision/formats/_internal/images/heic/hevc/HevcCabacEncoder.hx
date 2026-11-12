package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;

/** Binary arithmetic encoding for a byte-aligned HEVC CABAC substream. **/
@:noCompletion
class HevcCabacEncoder {
	final output = new BytesBuffer();
	var low = 0;
	var range = 510;
	var freeBits = 23;
	var pendingByte = -1;
	var pendingOnes = 0;
	var terminated = false;
	var finished = false;

	public function new() {}

	/** Encodes a context-coded bit and updates the supplied probability state. **/
	public function writeBin(value:Int, context:HevcCabacContext):Void {
		checkBit(value);
		final state = context.state;
		final leastRange = HevcCabacDecoder.lps[state * 4 + ((range >>> 6) & 3)];
		range -= leastRange;
		if (value != context.mostProbable) {
			low += range;
			range = leastRange;
			if (state == 0) context.mostProbable ^= 1;
			context.state = HevcCabacDecoder.nextLps[state];
		} else {
			context.state = HevcCabacDecoder.nextMps[state];
		}
		normalize();
	}

	/** Encodes an equiprobable bit without changing a context. **/
	public function writeBypass(value:Int):Void {
		checkBit(value);
		low = (low << 1) + (value == 0 ? 0 : range);
		freeBits--;
		if (freeBits < 12) drain();
	}

	/** Encodes a termination decision. A true value closes the arithmetic interval. **/
	public function writeTermination(value:Bool):Void {
		checkBit(0);
		range -= 2;
		if (value) {
			low += range;
			range = 2;
			terminated = true;
		}
		normalize();
	}

	/** Flushes a terminated interval, appending a stop bit and byte alignment. **/
	public function finish():Bytes {
		if (!terminated || finished) throw new HevcBitstreamError("CABAC substream is not ready to flush.");
		finished = true;
		final carryShift = 32 - freeBits;
		final carry = low >>> carryShift;
		if (pendingByte >= 0) output.addByte((pendingByte + carry) & 255);
		for (_ in 0...pendingOnes) output.addByte(carry == 0 ? 255 : 0);
		low &= (1 << carryShift) - 1;
		final tailBits = 24 - freeBits;
		final paddedBits = (tailBits + 8) & ~7;
		final tail = (((low >>> 8) << 1) | 1) << (paddedBits - tailBits - 1);
		var shift = paddedBits - 8;
		while (shift >= 0) {
			output.addByte((tail >>> shift) & 255);
			shift -= 8;
		}
		return output.getBytes();
	}

	function normalize():Void {
		while (range < 256) {
			range <<= 1;
			low <<= 1;
			freeBits--;
		}
		if (freeBits < 12) drain();
	}

	function drain():Void {
		final lead = low >>> (24 - freeBits);
		freeBits += 8;
		low &= (1 << (32 - freeBits)) - 1;
		if (lead == 255) {
			pendingOnes++;
			return;
		}
		final carry = lead >>> 8;
		if (pendingByte >= 0) output.addByte((pendingByte + carry) & 255);
		for (_ in 0...pendingOnes) output.addByte(carry == 0 ? 255 : 0);
		pendingByte = lead & 255;
		pendingOnes = 0;
	}

	inline function checkBit(value:Int):Void {
		if (terminated || (value != 0 && value != 1)) throw new HevcBitstreamError("Invalid CABAC write.");
	}
}

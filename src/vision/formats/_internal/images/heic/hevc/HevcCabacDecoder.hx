package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;

/** Adaptive binary arithmetic context for one HEVC syntax element. **/
@:allow(vision.formats._internal.images.heic.hevc.HevcCabacDecoder)
@:allow(vision.formats._internal.images.heic.hevc.HevcCabacEncoder)
@:noCompletion
class HevcCabacContext {
	var state:Int;
	var mostProbable:Int;

	/** Initializes a context from the slice QP and the syntax element's init value. **/
	public function new(qp:Int, initValue:Int) {
		if (initValue < 0 || initValue > 255) throw new HevcBitstreamError("Invalid CABAC initialization value.");
		final clippedQp = qp < 0 ? 0 : qp > 51 ? 51 : qp;
		final slope = (initValue >>> 4) * 5 - 45;
		final intercept = ((initValue & 15) << 3) - 16;
		final value = ((slope * clippedQp) >> 4) + intercept;
		final clipped = value < 1 ? 1 : value > 126 ? 126 : value;
		mostProbable = clipped >= 64 ? 1 : 0;
		state = mostProbable == 1 ? clipped - 64 : 63 - clipped;
	}
}

/** Binary arithmetic decoding for one byte-aligned HEVC CABAC substream. **/
@:noCompletion
@:allow(vision.formats._internal.images.heic.hevc.HevcCabacEncoder)
class HevcCabacDecoder {
	// H.265 arithmetic decoding probability and transition tables.
	static final lps = [
		128, 176, 208, 240, 128, 167, 197, 227, 128, 158, 187, 216, 123, 150, 178, 205,
		116, 142, 169, 195, 111, 135, 160, 185, 105, 128, 152, 175, 100, 122, 144, 166,
		95, 116, 137, 158, 90, 110, 130, 150, 85, 104, 123, 142, 81, 99, 117, 135,
		77, 94, 111, 128, 73, 89, 105, 122, 69, 85, 100, 116, 66, 80, 95, 110,
		62, 76, 90, 104, 59, 72, 86, 99, 56, 69, 81, 94, 53, 65, 77, 89,
		51, 62, 73, 85, 48, 59, 69, 80, 46, 56, 66, 76, 43, 53, 63, 72,
		41, 50, 59, 69, 39, 48, 56, 65, 37, 45, 54, 62, 35, 43, 51, 59,
		33, 41, 48, 56, 32, 39, 46, 53, 30, 37, 43, 50, 29, 35, 41, 48,
		27, 33, 39, 45, 26, 31, 37, 43, 24, 30, 35, 41, 23, 28, 33, 39,
		22, 27, 32, 37, 21, 26, 30, 35, 20, 24, 29, 33, 19, 23, 27, 31,
		18, 22, 26, 30, 17, 21, 25, 28, 16, 20, 23, 27, 15, 19, 22, 25,
		14, 18, 21, 24, 14, 17, 20, 23, 13, 16, 19, 22, 12, 15, 18, 21,
		12, 14, 17, 20, 11, 14, 16, 19, 11, 13, 15, 18, 10, 12, 15, 17,
		10, 12, 14, 16, 9, 11, 13, 15, 9, 11, 12, 14, 8, 10, 12, 14,
		8, 9, 11, 13, 7, 9, 11, 12, 7, 9, 10, 12, 7, 8, 10, 11,
		6, 8, 9, 11, 6, 7, 9, 10, 6, 7, 8, 9, 2, 2, 2, 2,
	];
	static final nextMps = [
		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16,
		17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
		33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
		49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 62, 63,
	];
	static final nextLps = [
		0, 0, 1, 2, 2, 4, 4, 5, 6, 7, 8, 9, 9, 11, 11, 12,
		13, 13, 15, 15, 16, 16, 18, 18, 19, 19, 21, 21, 22, 22, 23, 24,
		24, 25, 26, 26, 27, 27, 28, 29, 29, 30, 30, 30, 31, 32, 32, 33,
		33, 33, 34, 34, 35, 35, 35, 36, 36, 36, 37, 37, 37, 38, 38, 63,
	];

	final bytes:Bytes;
	final start:Int;
	final bitCount:Int;
	var position = 0;
	var range = 510;
	var value = 0;
	var terminated = false;

	/**
		Starts arithmetic decoding at the first CABAC byte in an RBSP.
		Emulation-prevention bytes must have been removed by the NAL reader.

		@param bytes The RBSP bytes
		@param offset Byte-aligned start of the CABAC substream
		@param length Number of bytes available in this substream
	**/
	public function new(bytes:Bytes, offset:Int, length:Int) {
		if (offset < 0 || length < 2 || length > 0x0fffffff || offset > bytes.length - length)
			throw new HevcBitstreamError("Invalid CABAC byte range.");
		this.bytes = bytes;
		start = offset;
		bitCount = length * 8;
		for (_ in 0...9) value = (value << 1) | bit();
		if (value >= range) throw new HevcBitstreamError("Invalid initial CABAC offset.");
	}

	/** Decodes a context-coded bit and updates the supplied probability state. **/
	public function readBin(context:HevcCabacContext):Int {
		checkOpen();
		final state = context.state;
		final leastRange = lps[state * 4 + ((range >>> 6) & 3)];
		range -= leastRange;
		var result = context.mostProbable;
		if (value >= range) {
			value -= range;
			range = leastRange;
			result ^= 1;
			if (state == 0) context.mostProbable ^= 1;
			context.state = nextLps[state];
		} else {
			context.state = nextMps[state];
		}
		normalize();
		return result;
	}

	/** Decodes an equiprobable bypass bit without changing a context. **/
	public function readBypass():Int {
		checkOpen();
		value = (value << 1) | bit();
		if (value < range) return 0;
		value -= range;
		return 1;
	}

	/** Decodes a termination bit. True closes this arithmetic substream. **/
	public function readTermination():Bool {
		checkOpen();
		range -= 2;
		if (value >= range) {
			terminated = true;
			return true;
		}
		normalize();
		return false;
	}

	/** Returns the byte offset of raw PCM samples after a PCM termination bin. **/
	public function alignForPcm():Int {
		if (!terminated) throw new HevcBitstreamError("PCM samples require a terminated CABAC interval.");
		while ((position & 7) != 0) {
			if (bit() != 0) throw new HevcBitstreamError("Invalid PCM alignment bit.");
		}
		return start + (position >>> 3);
	}

	function normalize():Void {
		while (range < 256) {
			range <<= 1;
			value = (value << 1) | bit();
		}
	}

	inline function bit():Int {
		if (position >= bitCount) throw new HevcBitstreamError("Truncated CABAC substream.");
		final index = position++;
		return (bytes.get(start + (index >>> 3)) >>> (7 - (index & 7))) & 1;
	}

	inline function checkOpen():Void {
		if (terminated) throw new HevcBitstreamError("CABAC substream has terminated.");
	}
}

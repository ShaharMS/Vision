package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;

/** Reads the picture layout fields at the start of a sequence parameter set. **/
@:noCompletion
class HevcSequenceGeometry {
	public final videoParameterSetId:Int;
	public final sequenceParameterSetId:Int;
	public final chromaFormat:Int;
	public final separateColorPlanes:Bool;
	public final codedWidth:Int;
	public final codedHeight:Int;
	public final cropLeft:Int;
	public final cropRight:Int;
	public final cropTop:Int;
	public final cropBottom:Int;
	public final width:Int;
	public final height:Int;
	public final lumaDepth:Int;
	public final chromaDepth:Int;

	/** Reads the geometry from an unescaped SPS payload following its NAL header. **/
	public function new(rbsp:Bytes) {
		final bits = new SequenceGeometryBits(rbsp);
		videoParameterSetId = bits.read(4);
		final subLayers = bits.read(3);
		if (subLayers == 7) throw new HevcBitstreamError("Invalid HEVC temporal sublayer count.");
		bits.read(1);
		skipProfileTierLevel(bits, subLayers);
		sequenceParameterSetId = bits.unsignedGolomb(15);
		chromaFormat = bits.unsignedGolomb(3);
		separateColorPlanes = chromaFormat == 3 && bits.read(1) != 0;
		codedWidth = bits.unsignedGolomb(0x3fffffff);
		codedHeight = bits.unsignedGolomb(0x3fffffff);
		if (bits.read(1) != 0) {
			final horizontalUnit = chromaFormat == 1 || chromaFormat == 2 ? 2 : 1;
			final verticalUnit = chromaFormat == 1 ? 2 : 1;
			cropLeft = bits.unsignedGolomb(Std.int(codedWidth / horizontalUnit)) * horizontalUnit;
			cropRight = bits.unsignedGolomb(Std.int((codedWidth - cropLeft) / horizontalUnit)) * horizontalUnit;
			cropTop = bits.unsignedGolomb(Std.int(codedHeight / verticalUnit)) * verticalUnit;
			cropBottom = bits.unsignedGolomb(Std.int((codedHeight - cropTop) / verticalUnit)) * verticalUnit;
		} else {
			cropLeft = cropRight = cropTop = cropBottom = 0;
		}
		width = codedWidth - cropLeft - cropRight;
		height = codedHeight - cropTop - cropBottom;
		if (width <= 0 || height <= 0) throw new HevcBitstreamError("Invalid HEVC picture dimensions or conformance window.");
		lumaDepth = bits.unsignedGolomb(8) + 8;
		chromaDepth = bits.unsignedGolomb(8) + 8;
	}

	static function skipProfileTierLevel(bits:SequenceGeometryBits, subLayers:Int):Void {
		bits.skip(96);
		final profiles = [];
		final levels = [];
		for (_ in 0...subLayers) {
			profiles.push(bits.read(1) != 0);
			levels.push(bits.read(1) != 0);
		}
		if (subLayers > 0) bits.skip((8 - subLayers) * 2);
		for (i in 0...subLayers) {
			if (profiles[i]) bits.skip(88);
			if (levels[i]) bits.skip(8);
		}
	}
}

private class SequenceGeometryBits {
	final bytes:Bytes;
	var offset = 0;
	var shift = 7;

	public function new(bytes:Bytes) this.bytes = bytes;

	public function read(count:Int):Int {
		var value = 0;
		for (_ in 0...count) {
			if (offset >= bytes.length) throw new HevcBitstreamError("Truncated HEVC sequence parameter set.");
			value = (value << 1) | ((bytes.get(offset) >>> shift) & 1);
			if (shift == 0) {
				offset++;
				shift = 7;
			} else shift--;
		}
		return value;
	}

	public function skip(count:Int):Void {
		for (_ in 0...count) read(1);
	}

	public function unsignedGolomb(maximum:Int):Int {
		var zeroes = 0;
		while (read(1) == 0) {
			zeroes++;
			if (zeroes > 30 || (1 << zeroes) - 1 > maximum)
				throw new HevcBitstreamError("HEVC sequence parameter exceeds its allowed range.");
		}
		final value = (1 << zeroes) - 1 + read(zeroes);
		if (value > maximum) throw new HevcBitstreamError("HEVC sequence parameter exceeds its allowed range.");
		return value;
	}
}

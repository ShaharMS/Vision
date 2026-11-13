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
	public final pictureOrderCountBits:Int;
	public final minCodingBlockLog2:Int;
	public final ctbLog2:Int;
	public final minTransformBlockLog2:Int;
	public final maxTransformBlockLog2:Int;
	public final interTransformDepth:Int;
	public final intraTransformDepth:Int;
	public final scalingListsEnabled:Bool;
	public final customScalingLists:Bool;
	public final asymmetricMotionPartitions:Bool;
	public final sampleAdaptiveOffset:Bool;
	public final pcm:Null<HevcPcmParameters>;
	public final strongIntraSmoothing:Bool;
	public final fullRange:Bool;
	public final matrixCoefficients:Int;

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
		pictureOrderCountBits = bits.unsignedGolomb(12) + 4;
		final firstLayer = bits.read(1) != 0 ? 0 : subLayers;
		for (_ in firstLayer...subLayers + 1) {
			final buffering = bits.unsignedGolomb(15);
			bits.unsignedGolomb(buffering);
			bits.skipUnsignedGolomb();
		}
		minCodingBlockLog2 = bits.unsignedGolomb(3) + 3;
		ctbLog2 = minCodingBlockLog2 + bits.unsignedGolomb(6 - minCodingBlockLog2);
		minTransformBlockLog2 = bits.unsignedGolomb(minCodingBlockLog2 - 3) + 2;
		maxTransformBlockLog2 = minTransformBlockLog2 + bits.unsignedGolomb(Std.int(Math.min(ctbLog2, 5)) - minTransformBlockLog2);
		interTransformDepth = bits.unsignedGolomb(ctbLog2 - minTransformBlockLog2);
		intraTransformDepth = bits.unsignedGolomb(ctbLog2 - minTransformBlockLog2);
		scalingListsEnabled = bits.read(1) != 0;
		customScalingLists = scalingListsEnabled && bits.read(1) != 0;
		if (customScalingLists) skipScalingLists(bits);
		asymmetricMotionPartitions = bits.read(1) != 0;
		sampleAdaptiveOffset = bits.read(1) != 0;
		pcm = bits.read(1) != 0 ? readPcm(bits) : null;
		strongIntraSmoothing = readSmoothing(bits);
		var range = false;
		var matrix = 2;
		if (bits.read(1) != 0) {
			if (bits.read(1) != 0 && bits.read(8) == 255) bits.skip(32);
			if (bits.read(1) != 0) bits.skip(1);
			if (bits.read(1) != 0) {
				bits.skip(3);
				range = bits.read(1) != 0;
				if (bits.read(1) != 0) {
					bits.skip(16);
					matrix = bits.read(8);
				}
			}
		}
		fullRange = range;
		matrixCoefficients = matrix;
	}

	function readSmoothing(bits:SequenceGeometryBits):Bool {
		final counts = [];
		final sets = bits.unsignedGolomb(64);
		for (i in 0...sets) {
			var count = 0;
			if (i > 0 && bits.read(1) != 0) {
				bits.read(1);
				bits.skipUnsignedGolomb();
				for (_ in 0...counts[i - 1] + 1) {
					if (bits.read(1) != 0 || bits.read(1) != 0) count++;
				}
			} else {
				count = bits.unsignedGolomb(64) + bits.unsignedGolomb(64);
				for (_ in 0...count) {
					bits.skipUnsignedGolomb();
					bits.read(1);
				}
			}
			if (count > 64) throw new HevcBitstreamError("Invalid HEVC reference picture count.");
			counts.push(count);
		}
		if (bits.read(1) != 0) {
			final longTerm = bits.unsignedGolomb(32);
			for (_ in 0...longTerm) bits.skip(pictureOrderCountBits + 1);
		}
		bits.read(1); // Temporal motion vector prediction.
		return bits.read(1) != 0;
	}

	function readPcm(bits:SequenceGeometryBits):HevcPcmParameters {
		final pcmLumaDepth = bits.read(4) + 1;
		final pcmChromaDepth = bits.read(4) + 1;
		if (pcmLumaDepth > lumaDepth || (chromaFormat != 0 && !separateColorPlanes && pcmChromaDepth > chromaDepth))
			throw new HevcBitstreamError("Invalid HEVC PCM sample depth.");
		final pcmMaxLog2 = Std.int(Math.min(ctbLog2, 5));
		final minLog2 = bits.unsignedGolomb(pcmMaxLog2 - 3) + 3;
		if (minLog2 < Math.min(minCodingBlockLog2, 5))
			throw new HevcBitstreamError("Invalid HEVC PCM block size.");
		return {
			lumaDepth: pcmLumaDepth,
			chromaDepth: pcmChromaDepth,
			minBlockLog2: minLog2,
			maxBlockLog2: minLog2 + bits.unsignedGolomb(pcmMaxLog2 - minLog2),
			loopFilterDisabled: bits.read(1) != 0
		};
	}

	static function skipScalingLists(bits:SequenceGeometryBits):Void {
		for (sizeId in 0...4) {
			final matrixCount = sizeId == 3 ? 2 : 6;
			for (matrix in 0...matrixCount) {
				if (bits.read(1) == 0) {
					bits.unsignedGolomb(matrix);
				} else {
					if (sizeId > 1) bits.unsignedGolomb(493);
					for (_ in 0...(sizeId == 0 ? 16 : 64)) bits.unsignedGolomb(256);
				}
			}
		}
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

/** Raw sample layout for HEVC coding units that use PCM. **/
typedef HevcPcmParameters = {
	final lumaDepth:Int;
	final chromaDepth:Int;
	final minBlockLog2:Int;
	final maxBlockLog2:Int;
	final loopFilterDisabled:Bool;
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

	public function skipUnsignedGolomb():Void {
		var zeroes = 0;
		while (read(1) == 0) {
			if (++zeroes > 31) throw new HevcBitstreamError("HEVC sequence parameter exceeds 32 bits.");
		}
		skip(zeroes);
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

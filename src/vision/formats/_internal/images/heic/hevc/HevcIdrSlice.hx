package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;

/** Header and entropy substream boundaries of an independent HEVC IDR intra slice. **/
@:noCompletion
class HevcIdrSlice {
	public final qp:Int;
	public final saoLuma:Bool;
	public final saoChroma:Bool;
	public final cbQpOffset:Int;
	public final crQpOffset:Int;
	public final deblockDisabled:Bool;
	public final betaOffset:Int;
	public final tcOffset:Int;
	public final substreamOffsets:Array<Int>;

	/**
		Reads an IDR slice header after removing emulation prevention.
		Entry point lengths are in escaped byte units as transmitted.
	**/
	public function new(rbsp:Bytes, sequence:HevcSequenceGeometry, picture:HevcPictureParameters, ?escaped:Bytes) {
		final bits = new HevcRawBits(rbsp);
		if (!bits.flag()) throw new HevcBitstreamError("Expected the first HEVC slice in the picture.");
		bits.flag(); // No output of prior pictures.
		if (bits.ue(63) != picture.id || picture.sequenceId != sequence.sequenceParameterSetId)
			throw new HevcBitstreamError("The HEVC slice references a different parameter set.");
		bits.read(picture.extraSliceBits);
		if (bits.ue(2) != 2) throw new HevcBitstreamError("Expected an intra HEVC slice.");
		if (picture.outputFlag && !bits.flag()) throw new HevcBitstreamError("The HEVC picture is marked for discard.");
		if (sequence.separateColorPlanes) throw new HevcBitstreamError("Separate HEVC color planes are unsupported.");
		saoLuma = sequence.sampleAdaptiveOffset && bits.flag();
		saoChroma = sequence.sampleAdaptiveOffset && sequence.chromaFormat != 0 && bits.flag();
		qp = picture.initialQp + bits.se(87);
		if (qp < -6 * (sequence.lumaDepth - 8) || qp > 51) throw new HevcBitstreamError("Invalid HEVC intra slice QP.");
		cbQpOffset = picture.cbQpOffset + (picture.sliceChromaOffsets ? bits.se(12) : 0);
		crQpOffset = picture.crQpOffset + (picture.sliceChromaOffsets ? bits.se(12) : 0);
		final overridesDeblock = picture.deblockOverride && bits.flag();
		deblockDisabled = overridesDeblock ? bits.flag() : picture.deblockDisabled;
		betaOffset = overridesDeblock && !deblockDisabled ? bits.se(6) * 2 : picture.betaOffset;
		tcOffset = overridesDeblock && !deblockDisabled ? bits.se(6) * 2 : picture.tcOffset;
		if (picture.filterAcrossSlices && (saoLuma || saoChroma || !deblockDisabled)) bits.flag();
		final sizes = [];
		if (picture.tiles || picture.wavefront) {
			final count = bits.ue(65535);
			if (count > 0) {
				final width = bits.ue(30) + 1;
				for (_ in 0...count) {
					final size = bits.read(width);
					if (size >= rbsp.length) throw new HevcBitstreamError("HEVC entry point exceeds the slice size.");
					sizes.push(size + 1);
				}
			}
		}
		if (picture.sliceHeaderExtension) {
			final length = bits.ue(4096);
			for (_ in 0...length) bits.read(8);
		}
		final start = bits.align();
		if (start >= rbsp.length) throw new HevcBitstreamError("HEVC slice is missing its CABAC payload.");
		substreamOffsets = [start];
		if (sizes.length > 0) {
			if (escaped == null) throw new HevcBitstreamError("HEVC entry points require the escaped slice payload.");
			var raw = 0;
			var zeroes = 0;
			var index = 0;
			var boundary = -1;
			for (i in 0...escaped.length) {
				if (raw == start && index == 0) boundary = i + sizes[index++];
				if (i == boundary) {
					substreamOffsets.push(raw);
					boundary = index < sizes.length ? i + sizes[index++] : -1;
				}
				final value = escaped.get(i);
				if (zeroes == 2 && value == 3) {
					zeroes = 0;
					continue;
				}
				raw++;
				zeroes = value == 0 ? zeroes + 1 : 0;
			}
			if (substreamOffsets.length != sizes.length + 1)
				throw new HevcBitstreamError("Truncated HEVC entropy entry points.");
		}
	}
}

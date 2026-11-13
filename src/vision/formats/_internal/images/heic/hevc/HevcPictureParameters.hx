package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;

/** Picture parameter set for single-layer HEVC intra pictures. **/
@:noCompletion
class HevcPictureParameters {
	public final id:Int;
	public final sequenceId:Int;
	public final dependentSlices:Bool;
	public final outputFlag:Bool;
	public final extraSliceBits:Int;
	public final signDataHiding:Bool;
	public final initialQp:Int;
	public final constrainedIntra:Bool;
	public final transformSkip:Bool;
	public final transquantBypass:Bool;
	public final qpDeltaDepth:Null<Int>;
	public final cbQpOffset:Int;
	public final crQpOffset:Int;
	public final sliceChromaOffsets:Bool;
	public final tiles:Bool;
	public final wavefront:Bool;
	public final filterAcrossSlices:Bool;
	public final deblockOverride:Bool;
	public final deblockDisabled:Bool;
	public final betaOffset:Int;
	public final tcOffset:Int;
	public final sliceHeaderExtension:Bool;

	/** Reads an unescaped PPS payload after the NAL header. **/
	public function new(rbsp:Bytes) {
		final bits = new HevcRawBits(rbsp);
		id = bits.ue(63);
		sequenceId = bits.ue(15);
		dependentSlices = bits.flag();
		outputFlag = bits.flag();
		extraSliceBits = bits.read(3);
		signDataHiding = bits.flag();
		bits.flag(); // CABAC initialization override for inter slices.
		bits.ue(14);
		bits.ue(14);
		initialQp = 26 + bits.se(74);
		constrainedIntra = bits.flag();
		transformSkip = bits.flag();
		qpDeltaDepth = bits.flag() ? bits.ue(3) : null;
		cbQpOffset = bits.se(12);
		crQpOffset = bits.se(12);
		sliceChromaOffsets = bits.flag();
		bits.read(2); // Weighted prediction.
		transquantBypass = bits.flag();
		tiles = bits.flag();
		wavefront = bits.flag();
		if (tiles) {
			final columns = bits.ue(19);
			final rows = bits.ue(21);
			if (!bits.flag()) {
				for (_ in 0...columns) bits.ue(65535);
				for (_ in 0...rows) bits.ue(65535);
			}
			bits.flag(); // Filtering across tile boundaries.
		}
		filterAcrossSlices = bits.flag();
		final deblockControl = bits.flag();
		deblockOverride = deblockControl && bits.flag();
		deblockDisabled = deblockControl && bits.flag();
		betaOffset = deblockControl && !deblockDisabled ? bits.se(6) * 2 : 0;
		tcOffset = deblockControl && !deblockDisabled ? bits.se(6) * 2 : 0;
		if (bits.flag()) throw new HevcBitstreamError("Custom HEVC picture scaling lists are unsupported.");
		bits.flag(); // Reference list modification.
		bits.ue(4); // Parallel merge level.
		sliceHeaderExtension = bits.flag();
		if (bits.flag()) throw new HevcBitstreamError("HEVC picture parameter extensions are unsupported.");
		bits.align();
	}
}

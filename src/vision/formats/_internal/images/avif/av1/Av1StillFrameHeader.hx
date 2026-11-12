package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** The coding parameters of a key frame in a reduced still-picture sequence. **/
@:noCompletion
class Av1StillFrameHeader {
	public final width:Int;
	public final height:Int;
	public final upscaledWidth:Int;
	public final renderWidth:Int;
	public final renderHeight:Int;
	public final updateCdf:Bool;
	public final screenContent:Bool;
	public final intraBlockCopy:Bool;
	public final tiles:Av1TileLayout;
	public final baseQuantizer:Int;
	public final quantizerDeltas:Array<Int>;
	public final quantizerMatrices:Null<Array<Int>>;
	public final segments:Null<Array<Array<Null<Int>>>>;
	public final deltaQuantizerShift:Null<Int>;
	public final deltaFilterShift:Null<Int>;
	public final multiDeltaFilter:Bool;
	public final lossless:Bool;
	public final loopFilterLevels:Array<Int>;
	public final loopFilterSharpness:Int;
	public final loopFilterDeltas:Null<Array<Int>>;
	public final cdefDamping:Int;
	public final cdefStrengths:Array<Array<Int>>;
	public final restorationTypes:Array<Int>;
	public final restorationUnitSize:Int;
	public final chromaRestorationUnitSize:Int;
	public final selectableTransform:Bool;
	public final reducedTransformSet:Bool;
	public final tileGroupOffset:Int;

	/**
		Reads a frame header. For a combined Frame OBU, tileGroupOffset is the
		first byte of the embedded tile group. A standalone header ends in trailing bits.
	**/
	public function new(sequence:Av1SequenceHeader, bytes:Bytes, offset:Int, length:Int, combined:Bool) {
		if (!sequence.reducedStillPictureHeader) throw new Av1BitstreamError("Expected a reduced AV1 still-picture sequence.");
		final bits = new Av1RawBits(bytes, offset, length);
		updateCdf = !bits.flag();
		screenContent = bits.flag();
		if (screenContent) bits.flag(); // Integer motion is inferred for an intra frame.
		upscaledWidth = sequence.maxWidth;
		final denominator = sequence.superResolution && bits.flag() ? bits.read(3) + 9 : 8;
		width = Std.int((upscaledWidth * 8 + (denominator >> 1)) / denominator);
		height = sequence.maxHeight;
		final explicitRenderSize = bits.flag();
		renderWidth = explicitRenderSize ? bits.read(16) + 1 : upscaledWidth;
		renderHeight = explicitRenderSize ? bits.read(16) + 1 : height;
		intraBlockCopy = screenContent && denominator == 8 && bits.flag();
		tiles = new Av1TileLayout(bits, width, height, sequence.superblockSize);

		baseQuantizer = bits.read(8);
		final yDc = delta(bits);
		final separateChroma = !sequence.monochrome && sequence.separateUvDeltaQ && bits.flag();
		final uDc = sequence.monochrome ? 0 : delta(bits);
		final uAc = sequence.monochrome ? 0 : delta(bits);
		final vDc = separateChroma ? delta(bits) : uDc;
		final vAc = separateChroma ? delta(bits) : uAc;
		quantizerDeltas = [yDc, uDc, uAc, vDc, vAc];
		if (bits.flag()) {
			final y = bits.read(4);
			final u = bits.read(4);
			quantizerMatrices = [y, u, sequence.separateUvDeltaQ ? bits.read(4) : u];
		} else quantizerMatrices = null;
		segments = bits.flag() ? readSegments(bits) : null;
		deltaQuantizerShift = baseQuantizer > 0 && bits.flag() ? bits.read(2) : null;
		deltaFilterShift = deltaQuantizerShift != null && !intraBlockCopy && bits.flag() ? bits.read(2) : null;
		multiDeltaFilter = deltaFilterShift != null && bits.flag();
		lossless = isLossless(baseQuantizer, segments, quantizerDeltas);

		loopFilterLevels = [0, 0, 0, 0];
		if (!lossless && !intraBlockCopy) {
			loopFilterLevels[0] = bits.read(6);
			loopFilterLevels[1] = bits.read(6);
			if (!sequence.monochrome && (loopFilterLevels[0] != 0 || loopFilterLevels[1] != 0)) {
				loopFilterLevels[2] = bits.read(6);
				loopFilterLevels[3] = bits.read(6);
			}
			loopFilterSharpness = bits.read(3);
			loopFilterDeltas = bits.flag() ? readLoopFilterDeltas(bits) : null;
		} else {
			loopFilterSharpness = 0;
			loopFilterDeltas = null;
		}
		cdefStrengths = [];
		if (sequence.cdef && !lossless && !intraBlockCopy) {
			cdefDamping = bits.read(2) + 3;
			final count = 1 << bits.read(2);
			for (_ in 0...count) {
				final y = readCdefStrength(bits);
				final uv = sequence.monochrome ? [0, 0] : readCdefStrength(bits);
				cdefStrengths.push(y.concat(uv));
			}
		} else cdefDamping = 0;

		restorationTypes = [0, 0, 0];
		if (sequence.restoration && (!lossless || width != upscaledWidth) && !intraBlockCopy) {
			final remap = [0, 3, 1, 2];
			for (plane in 0...(sequence.monochrome ? 1 : 3)) restorationTypes[plane] = remap[bits.read(2)];
		}
		if (restorationTypes[0] != 0 || restorationTypes[1] != 0 || restorationTypes[2] != 0) {
			var shift = bits.read(1);
			if (sequence.superblockSize == 128) shift++;
			else if (shift != 0) shift += bits.read(1);
			restorationUnitSize = 64 << shift;
			final chromaShift = sequence.subsamplingX && sequence.subsamplingY
				&& (restorationTypes[1] != 0 || restorationTypes[2] != 0) ? bits.read(1) : 0;
			chromaRestorationUnitSize = restorationUnitSize >> chromaShift;
		} else {
			restorationUnitSize = 0;
			chromaRestorationUnitSize = 0;
		}
		selectableTransform = !lossless && bits.flag();
		reducedTransformSet = bits.flag();
		if (sequence.filmGrain && bits.flag()) throw new Av1BitstreamError("AV1 film grain parameters are unsupported.");
		if (combined) tileGroupOffset = bits.align();
		else {
			bits.readTrailingBits();
			tileGroupOffset = offset + length;
		}
	}

	static inline function delta(bits:Av1RawBits):Int return bits.flag() ? bits.signed(7) : 0;

	static function readSegments(bits:Av1RawBits):Array<Array<Null<Int>>> {
		final widths = [8, 6, 6, 6, 6, 3, 0, 0];
		final segments:Array<Array<Null<Int>>> = [];
		for (_ in 0...8) {
			final features:Array<Null<Int>> = [];
			for (feature in 0...widths.length) {
				if (!bits.flag()) features.push(null);
				else if (feature >= 5) features.push(bits.read(widths[feature]));
				else {
					final limit = (1 << widths[feature]) - 1;
					final value = bits.signed(widths[feature] + 1);
					features.push(value < -limit ? -limit : value);
				}
			}
			segments.push(features);
		}
		return segments;
	}

	static function isLossless(base:Int, segments:Null<Array<Array<Null<Int>>>>, deltas:Array<Int>):Bool {
		for (delta in deltas) if (delta != 0) return false;
		if (segments == null) return base == 0;
		for (segment in segments) if (base + (segment[0] == null ? 0 : segment[0]) > 0) return false;
		return true;
	}

	static function readLoopFilterDeltas(bits:Av1RawBits):Array<Int> {
		final deltas = [1, 0, 0, 0, -1, 0, -1, -1, 0, 0];
		if (bits.flag()) for (i in 0...deltas.length) if (bits.flag()) deltas[i] = bits.signed(7);
		return deltas;
	}

	static function readCdefStrength(bits:Av1RawBits):Array<Int> {
		final primary = bits.read(4);
		final secondary = bits.read(2);
		return [primary, secondary == 3 ? 4 : secondary];
	}
}

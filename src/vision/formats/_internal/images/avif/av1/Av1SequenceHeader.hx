package vision.formats._internal.images.avif.av1;

import haxe.io.Bytes;
import vision.exceptions.Av1BitstreamError;

/** Sequence-level color sampling and coding parameters for an AV1 stream. **/
@:noCompletion
class Av1SequenceHeader {
	public final profile:Int;
	public final stillPicture:Bool;
	public final reducedStillPictureHeader:Bool;
	public final widthBits:Int;
	public final heightBits:Int;
	public final maxWidth:Int;
	public final maxHeight:Int;
	public final superblockSize:Int;
	public final filterIntra:Bool;
	public final intraEdgeFilter:Bool;
	public final superResolution:Bool;
	public final cdef:Bool;
	public final restoration:Bool;
	public final bitDepth:Int;
	public final monochrome:Bool;
	public final colorPrimaries:Int;
	public final transferCharacteristics:Int;
	public final matrixCoefficients:Int;
	public final fullRange:Bool;
	public final subsamplingX:Bool;
	public final subsamplingY:Bool;
	public final chromaSamplePosition:Int;
	public final separateUvDeltaQ:Bool;
	public final filmGrain:Bool;

	/**
		Reads the payload of a Sequence Header OBU, including its trailing bits.
		@param bytes The bytes containing the OBU
		@param offset Offset of the payload after the OBU header
		@param length Byte length of the payload
	**/
	public function new(bytes:Bytes, offset:Int, length:Int) {
		final bits = new SequenceBits(bytes, offset, length);
		profile = bits.read(3);
		stillPicture = bits.flag();
		reducedStillPictureHeader = bits.flag();
		if (profile > 2 || (reducedStillPictureHeader && !stillPicture))
			throw new Av1BitstreamError("Invalid AV1 sequence profile or still picture flags.");

		if (reducedStillPictureHeader) bits.read(5);
		else skipOperatingPoints(bits);
		widthBits = bits.read(4) + 1;
		heightBits = bits.read(4) + 1;
		maxWidth = bits.read(widthBits) + 1;
		maxHeight = bits.read(heightBits) + 1;
		if (!reducedStillPictureHeader && bits.flag()) bits.read(7);

		superblockSize = bits.flag() ? 128 : 64;
		filterIntra = bits.flag();
		intraEdgeFilter = bits.flag();
		if (!reducedStillPictureHeader) skipInterTools(bits);
		superResolution = bits.flag();
		cdef = bits.flag();
		restoration = bits.flag();

		final highBitDepth = bits.flag();
		bitDepth = highBitDepth ? (profile == 2 && bits.flag() ? 12 : 10) : 8;
		monochrome = profile != 1 && bits.flag();
		final hasColorDescription = bits.flag();
		colorPrimaries = hasColorDescription ? bits.read(8) : 2;
		transferCharacteristics = hasColorDescription ? bits.read(8) : 2;
		matrixCoefficients = hasColorDescription ? bits.read(8) : 2;

		final rgb = !monochrome && colorPrimaries == 1 && transferCharacteristics == 13 && matrixCoefficients == 0;
		fullRange = rgb || bits.flag();
		if (monochrome) {
			subsamplingX = true;
			subsamplingY = true;
		} else if (rgb || profile == 1) {
			subsamplingX = false;
			subsamplingY = false;
		} else if (profile == 0) {
			subsamplingX = true;
			subsamplingY = true;
		} else {
			subsamplingX = bitDepth < 12 || bits.flag();
			subsamplingY = bitDepth == 12 && subsamplingX && bits.flag();
		}
		chromaSamplePosition = !monochrome && subsamplingX && subsamplingY ? bits.read(2) : 0;
		separateUvDeltaQ = !monochrome && bits.flag();
		filmGrain = bits.flag();
		bits.readTrailingBits();
	}

	static function skipOperatingPoints(bits:SequenceBits):Void {
		var bufferDelayBits = 0;
		if (bits.flag()) {
			bits.read(32);
			bits.read(32);
			if (bits.flag()) bits.skipUvlc();
			if (bits.flag()) {
				bufferDelayBits = bits.read(5) + 1;
				bits.read(32);
				bits.read(10);
			}
		}
		final displayDelayPresent = bits.flag();
		final count = bits.read(5) + 1;
		for (_ in 0...count) {
			bits.read(12);
			if (bits.read(5) > 7) bits.read(1);
			if (bufferDelayBits != 0 && bits.flag()) {
				bits.read(bufferDelayBits);
				bits.read(bufferDelayBits);
				bits.read(1);
			}
			if (displayDelayPresent && bits.flag()) bits.read(4);
		}
	}

	static function skipInterTools(bits:SequenceBits):Void {
		bits.read(4);
		final orderHint = bits.flag();
		if (orderHint) bits.read(2);
		final screenContentTools = bits.flag() || bits.flag();
		if (screenContentTools && !bits.flag()) bits.read(1);
		if (orderHint) bits.read(3);
	}
}

private class SequenceBits {
	final bytes:Bytes;
	final end:Int;
	var position:Int;
	var bit:Int = 7;

	public function new(bytes:Bytes, offset:Int, length:Int) {
		if (offset < 0 || length < 0 || offset > bytes.length - length)
			throw new Av1BitstreamError("Invalid AV1 sequence header range.");
		this.bytes = bytes;
		position = offset;
		end = offset + length;
	}

	public inline function flag():Bool return read(1) != 0;

	public function read(count:Int):Int {
		var value = 0;
		for (_ in 0...count) {
			if (position == end) throw new Av1BitstreamError("Truncated AV1 sequence header.");
			value = (value << 1) | ((bytes.get(position) >>> bit) & 1);
			if (bit == 0) {
				position++;
				bit = 7;
			} else bit--;
		}
		return value;
	}

	public function skipUvlc():Void {
		var zeroes = 0;
		while (!flag()) {
			if (zeroes < 32) zeroes++;
		}
		if (zeroes < 32) read(zeroes);
	}

	public function readTrailingBits():Void {
		if (!flag()) throw new Av1BitstreamError("Missing AV1 sequence header trailing bit.");
		while (position < end) {
			if (flag()) throw new Av1BitstreamError("Nonzero AV1 sequence header padding.");
		}
	}
}

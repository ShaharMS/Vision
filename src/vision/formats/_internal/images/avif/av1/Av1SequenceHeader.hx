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
		final bits = new Av1RawBits(bytes, offset, length);
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

	static function skipOperatingPoints(bits:Av1RawBits):Void {
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

	static function skipInterTools(bits:Av1RawBits):Void {
		bits.read(4);
		final orderHint = bits.flag();
		if (orderHint) bits.read(2);
		final screenContentTools = bits.flag() || bits.flag();
		if (screenContentTools && !bits.flag()) bits.read(1);
		if (orderHint) bits.read(3);
	}
}

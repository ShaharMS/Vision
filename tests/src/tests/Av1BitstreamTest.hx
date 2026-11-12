package tests;

import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1ObuReader;
import vision.formats._internal.images.avif.av1.Av1SymbolDecoder;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class Av1BitstreamTest extends utest.Test {
	@:visionTestId("vision.formats._internal.images.avif.av1.Av1SymbolDecoder.readSymbol#adaptive")
	function test_readSymbol__adaptsThreeSymbolDistribution():Void {
		final bytes = Bytes.ofHex("008c");
		final cdf = [9000, 23000, 32768, 0];
		final decoder = new Av1SymbolDecoder(bytes, 0, bytes.length);
		for (expected in [0, 0, 0, 0, 0, 0, 1, 2]) Assert.equals(expected, decoder.readSymbol(cdf));
		Assert.equals(14615, cdf[0]);
		Assert.equals(24889, cdf[1]);
		Assert.equals(32768, cdf[2]);
		Assert.equals(8, cdf[3]);
		decoder.finish();
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1SymbolDecoder.readLiteral#tilePadding")
	function test_readLiteral__readsBooleanSymbolsAndChecksPadding():Void {
		final bytes = Bytes.ofHex("ffb4ff");
		final decoder = new Av1SymbolDecoder(bytes, 1, 1);
		Assert.equals(22, decoder.readLiteral(5));
		decoder.finish();
		ExceptionAssertions.throwsType(() -> decoder.readLiteral(1), Av1BitstreamError);

		final invalid = new Av1SymbolDecoder(Bytes.ofHex("b5"), 0, 1);
		invalid.readLiteral(5);
		ExceptionAssertions.throwsType(() -> invalid.finish(), Av1BitstreamError);
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1ObuReader.next#payloadRanges")
	function test_next__findsBoundedPayloads():Void {
		final bytes = Bytes.ofHex("12000e4802aabb");
		final reader = new Av1ObuReader(bytes, 0, bytes.length);
		Assert.equals(2, reader.next().type);
		final unit = reader.next();
		Assert.equals(1, unit.type);
		Assert.equals(2, unit.temporalId);
		Assert.equals(1, unit.spatialId);
		Assert.equals(5, unit.offset);
		Assert.equals(2, unit.length);
		Assert.isNull(reader.next());
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1ObuReader.next#truncated")
	function test_next__rejectsTruncatedPayload():Void {
		final bytes = Bytes.ofHex("0a02aa");
		final reader = new Av1ObuReader(bytes, 0, bytes.length);
		ExceptionAssertions.throwsType(() -> reader.next(), Av1BitstreamError);
	}
}

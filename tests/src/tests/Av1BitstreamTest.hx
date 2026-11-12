package tests;

import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1ObuReader;
import vision.formats._internal.images.avif.av1.Av1LosslessTransform;
import vision.formats._internal.images.avif.av1.Av1SequenceHeader;
import vision.formats._internal.images.avif.av1.Av1StillFrameHeader;
import vision.formats._internal.images.avif.av1.Av1SymbolDecoder;
import vision.formats._internal.images.avif.av1.Av1SymbolEncoder;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class Av1BitstreamTest extends utest.Test {
	@:visionTestId("vision.formats._internal.images.avif.av1.Av1StillFrameHeader.new#tiledStill")
	function test_new__readsFrameHeaderAndTileRanges():Void {
		// Headers extracted from libheif's examples/example.avif.
		final sequenceBytes = Bytes.ofHex("1fe671f850b204040d28");
		final sequence = new Av1SequenceHeader(sequenceBytes, 0, sequenceBytes.length);
		final frameBytes = Bytes.ofHex("67605be3b03ebd1b2071c71c10411558");
		final frame = new Av1StillFrameHeader(sequence, frameBytes, 0, frameBytes.length, false);
		Assert.equals(111, frame.baseQuantizer);
		Assert.equals("14,1,-11,-24,-39", frame.quantizerDeltas.join(","));
		Assert.equals("7,7,7,7", frame.loopFilterLevels.join(","));
		Assert.equals("1,0,1,0", frame.cdefStrengths[0].join(","));
		Assert.equals(64, frame.restorationUnitSize);
		Assert.equals(32, frame.chromaRestorationUnitSize);
		Assert.equals("0,64,128,192,200", frame.tiles.columnStarts.join(","));
		Assert.equals("0,48,96,134", frame.tiles.rowStarts.join(","));
		Assert.equals(2, frame.tiles.sizeBytes);

		// Explicit group with tiles 3 and 4, crossing a tile-row boundary.
		final group = Bytes.ofHex("9a000100aabbcc");
		final tiles = frame.tiles.readGroup(group, 0, group.length);
		Assert.equals(2, tiles.length);
		Assert.equals(4, tiles[0].offset);
		Assert.equals(2, tiles[0].length);
		Assert.equals(192, tiles[0].columnStart);
		Assert.equals(48, tiles[1].rowStart);
		ExceptionAssertions.throwsType(() -> frame.tiles.readGroup(group, 0, group.length - 1), Av1BitstreamError);
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1SymbolEncoder.finish#adaptive")
	function test_finish__writesKnownAdaptiveStream():Void {
		final encoder = new Av1SymbolEncoder();
		final cdf = [9000, 23000, 32768, 0];
		for (symbol in [0, 0, 0, 0, 0, 0, 1, 2]) encoder.writeSymbol(symbol, cdf);
		Assert.equals("008c", encoder.finish().toHex());
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1SymbolEncoder.finish#mixed")
	function test_finish__roundTripsLiteralAndSymbolStreams():Void {
		final encoder = new Av1SymbolEncoder(false);
		final cdf = [1, 2500, 32767, 32768, 0];
		for (i in 0...512) {
			encoder.writeLiteral(i, 9);
			encoder.writeSymbol(i & 3, cdf);
		}
		final bytes = encoder.finish();
		final decoder = new Av1SymbolDecoder(bytes, 0, bytes.length, false);
		for (i in 0...512) {
			Assert.equals(i, decoder.readLiteral(9));
			Assert.equals(i & 3, decoder.readSymbol(cdf));
		}
		decoder.finish();
		Assert.equals(0, cdf[4]);
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1SequenceHeader.new#stillPicture")
	function test_new__readsStillPictureParameters():Void {
		// Sequence Header OBU from libheif's examples/example.avif.
		final bytes = Bytes.ofHex("1fe671f850b204040d28");
		final header = new Av1SequenceHeader(bytes, 0, bytes.length);
		Assert.equals(800, header.maxWidth);
		Assert.equals(533, header.maxHeight);
		Assert.equals(8, header.bitDepth);
		Assert.equals(0, header.profile);
		Assert.isTrue(header.stillPicture);
		Assert.isTrue(header.reducedStillPictureHeader);
		Assert.isTrue(header.subsamplingX);
		Assert.isTrue(header.subsamplingY);
		Assert.isFalse(header.monochrome);
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1SequenceHeader.new#truncated")
	function test_new__rejectsTruncatedSequenceHeader():Void {
		final bytes = Bytes.ofHex("1fe671f850b204040d");
		ExceptionAssertions.throwsType(() -> new Av1SequenceHeader(bytes, 0, bytes.length), Av1BitstreamError);
	}

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
	@:visionTestId("vision.formats._internal.images.avif.av1.Av1LosslessTransform.forward#reference")
	function test_forward__matchesLosslessLiftingVector():Void {
		final residual = [12, -3, 9, 7, -4, 5, -6, 2, 8, -10, 3, 1, -2, 6, -8, 4];
		final coefficients = [24, 0, 32, 0, 20, -4, -8, 0, 28, 0, 0, -8, 32, -28, 24, 72];
		Assert.equals(coefficients.join(","), Av1LosslessTransform.forward(residual, 8).join(","));
		Assert.equals(residual.join(","), Av1LosslessTransform.inverse(coefficients, 8).join(","));
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1LosslessTransform.reconstruct#sampleRange")
	function test_reconstruct__addsResidualAndClips():Void {
		final prediction = [for (i in 0...16) i % 2 == 0 ? 0 : 4095];
		final residual = [for (i in 0...16) i % 2 == 0 ? -4095 : 4095];
		final coefficients = Av1LosslessTransform.forward(residual, 12);
		Assert.equals(residual.join(","), Av1LosslessTransform.inverse(coefficients, 12).join(","));
		Assert.equals(prediction.join(","), Av1LosslessTransform.reconstruct(prediction, coefficients, 12).join(","));
	}
}

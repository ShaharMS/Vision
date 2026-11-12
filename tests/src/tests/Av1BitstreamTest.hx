package tests;

import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.Av1BitstreamError;
import vision.formats._internal.images.avif.av1.Av1ObuReader;
import vision.formats._internal.images.avif.av1.Av1LosslessTransform;
import vision.formats._internal.images.avif.av1.Av1SequenceHeader;
import vision.formats._internal.images.avif.av1.Av1StillFrameHeader;
import vision.formats._internal.images.avif.av1.Av1PartitionTree;
import vision.formats._internal.images.avif.av1.Av1PartitionTree.Av1Partition;
import vision.formats._internal.images.avif.av1.Av1Palette;
import vision.formats._internal.images.avif.av1.Av1Dequantization;
import vision.formats._internal.images.avif.av1.Av1InverseTransform;
import vision.formats._internal.images.avif.av1.Av1Coefficients;
import vision.formats._internal.images.avif.av1.Av1IntraPrediction;
import vision.formats._internal.images.avif.av1.Av1IntraPrediction.Av1IntraEdges;
import vision.formats._internal.images.avif.av1.Av1SymbolDecoder;
import vision.formats._internal.images.avif.av1.Av1SymbolEncoder;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class Av1BitstreamTest extends utest.Test {
	@:visionTestId("vision.formats._internal.images.avif.av1.Av1IntraPrediction.predict#directional")
	function test_predict__projectsReconstructedEdgesAndUpsamples():Void {
		final edges:Av1IntraEdges = {above: [10, 20, 30, 40, 50, 60, 70, 80], left: [90, 100, 110, 120], corner: 5};
		final diagonal = Av1IntraPrediction.predict(4, 4, 8, Diagonal45, edges);
		Assert.equals("20,30,40,50", diagonal.slice(0, 4).join(","));
		Assert.equals("50,60,70,80", diagonal.slice(12).join(","));
		final crossing = Av1IntraPrediction.predict(4, 4, 8, Diagonal135, edges);
		Assert.equals("5,10,20,30", crossing.slice(0, 4).join(","));
		Assert.equals("90,5,10,20", crossing.slice(4, 8).join(","));
		final slope:Av1IntraEdges = {above: [0, 64, 128, 192], left: [0, 0, 0, 0], corner: 0};
		Assert.equals(3, Av1IntraPrediction.predict(4, 4, 8, Vertical, slope, -1, true)[0]);
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1IntraPrediction.predict#flatAndChroma")
	function test_predict__preservesFlatReferencesAndAppliesSignedChroma():Void {
		final edges:Av1IntraEdges = {above: [for (_ in 0...8) 713], left: [for (_ in 0...8) 713], corner: 713};
		for (mode in 0...13) {
			for (angle in -3...4) {
				final values = Av1IntraPrediction.predict(8, 8, 10, mode, edges, angle, true, true);
				Assert.isTrue(values.indexOf(713) == 0 && values.filter(value -> value != 713).length == 0);
			}
		}
		for (filter in 0...5) {
			final values = Av1IntraPrediction.predict(8, 8, 10, Dc, edges, 0, false, false, filter);
			Assert.isTrue(values.filter(value -> value != 713).length == 0);
		}
		Assert.equals("145,128,111", Av1IntraPrediction.chromaFromLuma([128, 128, 128], [0, 136, 272], -8, 8).join(","));
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1Coefficients.read#signedSparseBlock")
	function test_read__decodesSparseCoefficientsAndGolombExtension():Void {
		final writer = new Av1SymbolEncoder();
		writer.writeSymbol(0, [31849, 32768, 0]); // Nonzero 4x4 luma transform.
		writer.writeSymbol(2, [840, 1039, 1980, 4895, 32768, 0]); // EOB at index 2.
		writer.writeSymbol(0, [16961, 32768, 0]);
		writer.writeSymbol(0, [29600, 31446, 32768, 0]); // Level one at scan position 2.
		writer.writeSymbol(0, [18082, 29741, 31877, 32768, 0]);
		writer.writeSymbol(3, [4034, 8930, 12727, 32768, 0]);
		final extension = [12536, 19601, 23789, 32768, 0];
		for (_ in 0...4) writer.writeSymbol(3, extension);
		writer.writeSymbol(1, [16000, 32768, 0]); // Negative DC.
		writer.writeLiteral(3, 3); // Golomb-coded value three.
		writer.writeLiteral(0, 1);
		final bytes = writer.finish();
		final symbols = new Av1SymbolDecoder(bytes, 0, bytes.length);
		final block = new Av1Coefficients(symbols, 0).read(4, 4, 0, 0, 0, () -> TwoDimensional);
		Assert.equals(3, block.endOfBlock);
		Assert.equals(18, block.cumulativeLevel);
		Assert.equals(1, block.dcCategory);
		Assert.equals("-17,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0", block.values.join(","));
		symbols.finish();
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1Dequantization.dequantize#scaling")
	function test_dequantize__scalesClipsAndKeepsCoefficientSign():Void {
		final coefficients = [for (_ in 0...16) 0];
		coefficients[0] = -2;
		coefficients[1] = 3;
		coefficients[15] = -16384;
		final matrix = [for (_ in 0...16) 32];
		matrix[1] = 48;
		final result = Av1Dequantization.dequantize(coefficients, 4, 4, 8, 1, -1, 0, matrix);
		Assert.equals(-8, result[0]);
		Assert.equals(36, result[1]);
		Assert.equals(-32768, result[15]);
		final large = [for (_ in 0...32 * 32) 1];
		Assert.equals(1, Av1Dequantization.dequantize(large, 64, 64, 12, 0, 0, 0)[1023]);
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1InverseTransform.inverse#frequencyImpulse")
	function test_inverse__reconstructsDctFrequenciesAtAllSizes():Void {
		for (size in [4, 8, 16, 32, 64]) {
			final coded = size < 32 ? size : 32;
			final coefficients = [for (_ in 0...coded * coded) 0];
			final frequency = (size >> 2) - 1;
			coefficients[frequency * coded + 1] = 401;
			final result = Av1InverseTransform.inverse(coefficients, size, size, 8, Dct, Dct);
			final normalization = size == 4 ? 16 : size == 8 ? 32 : 64;
			var maxError = 0.0;
			for (y in 0...size) for (x in 0...size) {
				final vertical = frequency == 0 ? Math.sqrt(0.5) : Math.cos((y + 0.5) * frequency * Math.PI / size);
				final expected = Math.round(401 * Math.cos((x + 0.5) * Math.PI / size) * vertical / normalization);
				maxError = Math.max(maxError, Math.abs(expected - result[y * size + x]));
			}
			Assert.isTrue(maxError <= 1);
		}
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1InverseTransform.inverse#flipAdst")
	function test_inverse__flipsAdstOutputOnTheSelectedAxis():Void {
		for (size in [4, 8, 16]) {
			final coefficients = [for (i in 0...size * size) (i * 37 % 257) - 128];
			final normal = Av1InverseTransform.inverse(coefficients, size, size, 10, Adst, Adst);
			final flipped = Av1InverseTransform.inverse(coefficients, size, size, 10, FlipAdst, Adst);
			final expected = [];
			for (y in 0...size) for (x in 0...size) expected.push(normal[y * size + size - 1 - x]);
			Assert.equals(expected.join(","), flipped.join(","));
		}
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1Palette.readMap#colorMap")
	function test_readMap__recoversPaletteSamplesAndIndices():Void {
		final encoder = new Av1SymbolEncoder();
		final writer = new Av1Palette();
		final luma = [15, 17, 250, 253, 255];
		final cb = [11, 11, 239];
		final cr = [255, 61, 0];
		final yMap = Bytes.ofHex("040402020100010102020003");
		final uvMap = Bytes.ofHex("020100010200");
		Av1Palette.writeColors(encoder, luma, 8, [15, 18, 250], true);
		Av1Palette.writeColors(encoder, cb, 8, [50], false);
		Av1Palette.writeRedDifference(encoder, cr, 8);
		writer.writeMap(encoder, yMap, 4, 3, luma.length, true);
		writer.writeMap(encoder, uvMap, 3, 2, cb.length, false);
		final bytes = encoder.finish();
		final decoder = new Av1SymbolDecoder(bytes, 0, bytes.length);
		final reader = new Av1Palette();
		Assert.equals(luma.join(","), Av1Palette.readColors(decoder, luma.length, 8, [15, 18, 250], true).join(","));
		Assert.equals(cb.join(","), Av1Palette.readColors(decoder, cb.length, 8, [50], false).join(","));
		Assert.equals(cr.join(","), Av1Palette.readRedDifference(decoder, cr.length, 8).join(","));
		Assert.equals(yMap.toHex(), reader.readMap(decoder, 4, 3, luma.length, true).toHex());
		Assert.equals(uvMap.toHex(), reader.readMap(decoder, 3, 2, cb.length, false).toHex());
		decoder.finish();
	}

	@:visionTestId("vision.formats._internal.images.avif.av1.Av1PartitionTree.decode#clippedMixedTree")
	function test_decode__visitsPartitionLeavesInCodingOrder():Void {
		final encoder = new Av1SymbolEncoder();
		final writer = new Av1PartitionTree(0, 0, 20, 14, 64);
		final written = [];
		writer.encode(encoder, (x, y, size) -> {
			if (size > 4 || (size == 4 && y + 2 >= 14)) return Split;
			if (size == 4 && x == 0 && y == 0) return VerticalB;
			return None;
		}, (x, y, width, height) -> written.push('$x:$y:$width:$height'));
		final bytes = encoder.finish();
		final decoder = new Av1SymbolDecoder(bytes, 0, bytes.length);
		final reader = new Av1PartitionTree(0, 0, 20, 14, 64);
		final decoded = [];
		reader.decode(decoder, (x, y, width, height) -> decoded.push('$x:$y:$width:$height'));
		decoder.finish();
		Assert.equals(written.join(","), decoded.join(","));
		Assert.equals("0:0:2:4,2:0:2:2,2:2:2:2", decoded.slice(0, 3).join(","));
		Assert.equals("16:12:2:2,18:12:2:2", decoded.slice(-2).join(","));
	}

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

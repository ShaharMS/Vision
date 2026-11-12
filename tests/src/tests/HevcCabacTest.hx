package tests;

import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;
import vision.formats._internal.images.heic.hevc.HevcCabacEncoder;
import vision.formats._internal.images.heic.hevc.HevcConfiguration;
import vision.formats._internal.images.heic.hevc.HevcSequenceGeometry;
import vision.formats._internal.images.heic.hevc.HevcNalReader;
import vision.formats._internal.images.heic.hevc.HevcIntraPrediction;
import vision.formats._internal.images.heic.hevc.HevcTransform4;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HevcCabacTest extends utest.Test {
	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcCabacEncoder.finish#mixedBins")
	function test_finish__roundTripsMixedCabacBins():Void {
		final encoder = new HevcCabacEncoder();
		final contexts = [new HevcCabacContext(22, 154), new HevcCabacContext(37, 139)];
		final bins = [for (i in 0...2048) ((i * i + i * 17) >>> (i % 8)) & 1];
		for (i in 0...bins.length) {
			if (i % 5 == 0) encoder.writeTermination(false);
			if (i % 3 == 0) encoder.writeBypass(bins[i]);
			else encoder.writeBin(bins[i], contexts[i & 1]);
		}
		encoder.writeTermination(true);
		final bytes = encoder.finish();
		final decoder = new HevcCabacDecoder(bytes, 0, bytes.length);
		final decodedContexts = [new HevcCabacContext(22, 154), new HevcCabacContext(37, 139)];
		for (i in 0...bins.length) {
			if (i % 5 == 0) Assert.isFalse(decoder.readTermination());
			Assert.equals(bins[i], i % 3 == 0 ? decoder.readBypass() : decoder.readBin(decodedContexts[i & 1]));
		}
		Assert.isTrue(decoder.readTermination());
		ExceptionAssertions.throwsType(() -> encoder.finish(), HevcBitstreamError);
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcConfiguration.new#pictureGeometry")
	function test_new__readsConfigurationAndConformanceCrop():Void {
		// Decoder configuration from libheif's examples/example.heic.
		final bytes = Bytes.ofHex("01016000000090000000000078f000fcfdf8f800000f03200001001940010c01ffff016000000300900000030000030078998a02402100010030420101016000000300900000030000030078a0028080359f596662a49126bffc1ab01aac04000003000400000300642022000100074401c172b66240");
		final configuration = new HevcConfiguration(bytes);
		Assert.equals(4, configuration.lengthSize);
		Assert.equals("32,33,34", [for (unit in configuration.units) unit.type].join(","));
		final geometry = new HevcSequenceGeometry(configuration.units[1].rbsp);
		Assert.equals(1280, geometry.width);
		Assert.equals(856, geometry.codedHeight);
		Assert.equals(854, geometry.height);
		Assert.equals(2, geometry.cropBottom);
		Assert.equals(1, geometry.chromaFormat);
		Assert.equals(8, geometry.lumaDepth);
		Assert.equals(8, geometry.chromaDepth);
		Assert.equals(3, geometry.minCodingBlockLog2);
		Assert.equals(6, geometry.ctbLog2);
		Assert.equals(2, geometry.minTransformBlockLog2);
		Assert.equals(5, geometry.maxTransformBlockLog2);
		Assert.equals(1, geometry.interTransformDepth);
		Assert.equals(1, geometry.intraTransformDepth);
		Assert.isFalse(geometry.scalingListsEnabled);
		Assert.isTrue(geometry.sampleAdaptiveOffset);
		Assert.isNull(geometry.pcm);
		ExceptionAssertions.throwsType(() -> new HevcConfiguration(bytes.sub(0, bytes.length - 1)), HevcBitstreamError);
		ExceptionAssertions.throwsType(() -> new HevcSequenceGeometry(configuration.units[1].rbsp.sub(0, 16)), HevcBitstreamError);
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcCabacDecoder.readBin#mixedBins")
	function test_readBin__handlesContextBypassAndTermination():Void {
		final bytes = Bytes.ofHex("ff1378ff");
		final decoder = new HevcCabacDecoder(bytes, 1, 2);
		final context = new HevcCabacContext(0, 10);
		Assert.equals(1, decoder.readBin(context));
		Assert.equals(1, decoder.readBin(context));
		Assert.equals(0, decoder.readBypass());
		Assert.equals(1, decoder.readBin(context));
		Assert.equals(0, decoder.readBin(context));
		Assert.isTrue(decoder.readTermination());
		ExceptionAssertions.throwsType(() -> decoder.readBypass(), HevcBitstreamError);
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcCabacDecoder.new#invalidOffset")
	function test_new__rejectsInvalidInitialOffset():Void {
		ExceptionAssertions.throwsType(() -> new HevcCabacDecoder(Bytes.ofHex("ffff"), 0, 2), HevcBitstreamError);
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcCabacDecoder.readBypass#truncated")
	function test_readBypass__rejectsTruncatedInput():Void {
		final decoder = new HevcCabacDecoder(Bytes.ofHex("0000"), 0, 2);
		for (_ in 0...7) Assert.equals(0, decoder.readBypass());
		ExceptionAssertions.throwsType(() -> decoder.readBypass(), HevcBitstreamError);
	}
	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcNalReader.next#rbsp")
	function test_next__removesEmulationPreventionBytes():Void {
		final bytes = Bytes.ofHex("0000000626010000030180");
		final reader = new HevcNalReader(bytes, 0, bytes.length - 1, 4);
		final nal = reader.next();
		Assert.equals(19, nal.type);
		Assert.equals(0, nal.temporalId);
		Assert.equals("000001", nal.rbsp.toHex());
		Assert.isNull(reader.next());
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcNalReader.next#invalidEscape")
	function test_next__rejectsInvalidEscape():Void {
		final bytes = Bytes.ofHex("06260100000304");
		final reader = new HevcNalReader(bytes, 0, bytes.length, 1);
		ExceptionAssertions.throwsType(() -> reader.next(), HevcBitstreamError);
	}
	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcIntraPrediction.predict#diagonal")
	function test_predict__projectsAcrossBothReferenceEdges():Void {
		final top = [10, 20, 30, 40, 50, 60, 70, 80];
		final left = [90, 100, 110, 120, 130, 140, 150, 160];
		final diagonal = HevcIntraPrediction.predict(4, 18, top, left, 85, 8);
		Assert.equals("85,10,20,30,90,85,10,20,100,90,85,10,110,100,90,85", diagonal.join(","));
		final positive = HevcIntraPrediction.predict(4, 34, top, left, 85, 8);
		Assert.equals("20,30,40,50,30,40,50,60,40,50,60,70,50,60,70,80", positive.join(","));
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcIntraPrediction.predict#flat")
	function test_predict__keepsFlatReferencesFlatInEveryMode():Void {
		final references = [for (_ in 0...8) 731];
		for (mode in 0...35)
			for (sample in HevcIntraPrediction.predict(4, mode, references, references, 731, 10, true))
				Assert.equals(731, sample);
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcTransform4.inverse#dst")
	function test_inverse__matchesIntegerSineTransformVector():Void {
		final coefficients = [128, 20, -12, 6, -11, 33, 7, -2, 5, 0, -9, 16, 3, -8, 5, -7];
		final residual = HevcTransform4.inverse(coefficients, 8, true);
		Assert.equals("1,1,1,0,1,1,1,0,1,1,1,1,0,1,2,2", residual.join(","));
		final prediction = [for (_ in 0...16) 254];
		final reconstructed = HevcIntraPrediction.reconstruct(4, prediction, residual, 8);
		Assert.equals(255, reconstructed[15]);
		Assert.equals(254, reconstructed[3]);
	}

	@:visionTestId("vision.formats._internal.images.heic.hevc.HevcTransform4.forward#constant")
	function test_forward__encodesConstantResidualAsDc():Void {
		final residual = [for (_ in 0...16) 1];
		final coefficients = HevcTransform4.forward(residual, 8, false);
		Assert.equals("128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0", coefficients.join(","));
		Assert.equals(residual.join(","), HevcTransform4.inverse(coefficients, 8, false).join(","));
	}
}

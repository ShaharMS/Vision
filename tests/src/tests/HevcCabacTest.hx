package tests;

import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;
import vision.formats._internal.images.heic.hevc.HevcNalReader;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HevcCabacTest extends utest.Test {
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
}

package tests;

import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.ds.Image;
import vision.exceptions.HeifContainerError;
import vision.formats.to.ToBytes;
import vision.formats.from.FromBytes;
import vision.formats._internal.images.heic.hevc.HevcConfiguration;
import vision.formats._internal.images.heic.hevc.HevcNalReader;
import vision.formats._internal.images.avif.av1.Av1ObuReader;
import vision.formats._internal.images.avif.av1.Av1SequenceHeader;
import vision.formats._internal.images.avif.av1.Av1StillFrameHeader;
import vision.formats._internal.images.heif.HeifContainer;
import vision.formats._internal.images.heif.HeifContainer.HeifCodedImage;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HeifContainerTest extends utest.Test {
	@:visionTestId("vision.formats.to.ToBytes.avif#palettePicture")
	function test_avif__writesAnRgbPaletteStillPicture():Void {
		final image = new Image(17, 15, 0xff45b378);
		image.setPixel(16, 14, 0xff838383);
		final bytes = new ToBytes().avif(image);
		final item = HeifContainer.readPrimary(bytes);
		Assert.equals("av01", item.type);
		Assert.equals(17, item.width);
		Assert.equals(15, item.height);
		final reader = new Av1ObuReader(item.data, 0, item.data.length);
		final sequenceUnit = reader.next();
		Assert.equals(1, sequenceUnit.type);
		final sequence = new Av1SequenceHeader(item.data, sequenceUnit.offset, sequenceUnit.length);
		Assert.equals(0, sequence.matrixCoefficients);
		Assert.isFalse(sequence.subsamplingX);
		Assert.isFalse(sequence.subsamplingY);
		final frameUnit = reader.next();
		Assert.equals(6, frameUnit.type);
		final frame = new Av1StillFrameHeader(sequence, item.data, frameUnit.offset, frameUnit.length, true);
		Assert.isTrue(frame.screenContent);
		Assert.isTrue(frame.lossless);
		Assert.isTrue(frame.tileGroupOffset < frameUnit.offset + frameUnit.length);
		Assert.isNull(reader.next());
		final decoded = new FromBytes().avif(bytes);
		Assert.equals(17, decoded.width);
		Assert.equals(15, decoded.height);
		Assert.equals(image.getPixel(0, 0), decoded.getPixel(0, 0));
		Assert.equals(image.getPixel(16, 14), decoded.getPixel(16, 14));
	}

	@:visionTestId("vision.formats.to.ToBytes.heic#oddDimensions")
	function test_heic__writesCodedPictureAndCleanAperture():Void {
		final image = new Image(17, 15);
		image.setPixel(16, 14, 0xff838383);
		final bytes = new ToBytes().heic(image);
		final item = HeifContainer.readPrimary(bytes);
		Assert.equals("hvc1", item.type);
		Assert.equals(18, item.width);
		Assert.equals(16, item.height);
		Assert.equals("clap", item.properties[4].type);
		Assert.equals("00000011000000010000000f00000001ffffffff00000002ffffffff00000002", item.properties[4].payload.toHex());
		final configuration = new HevcConfiguration(item.properties[0].payload);
		Assert.equals(3, configuration.units.length);
		final reader = new HevcNalReader(item.data, 0, item.data.length, configuration.lengthSize);
		Assert.equals(19, reader.next().type);
		Assert.isNull(reader.next());
		final decoded = new FromBytes().heic(bytes);
		Assert.equals(17, decoded.width);
		Assert.equals(15, decoded.height);
		Assert.equals(131, decoded.getPixel(16, 14).red);
		Assert.equals(0, decoded.getPixel(15, 14).red);
		Assert.equals(255, decoded.getPixel(0, 0).alpha);
	}

	@:visionTestId("vision.formats._internal.images.heif.HeifContainer#roundTrip")
	function test_primary__preservesCodedDataAndProperties():Void {
		for (type in ["av01", "hvc1"]) {
			final item = fixture(type);
			final bytes = HeifContainer.writePrimary(item);
			final decoded = HeifContainer.readPrimary(bytes);
			Assert.equals(type, decoded.type);
			Assert.equals(32, decoded.width);
			Assert.equals(24, decoded.height);
			Assert.equals(0, item.data.compare(decoded.data));
			Assert.equals(2, decoded.properties.length);
			Assert.isTrue(decoded.properties[0].essential);
			Assert.equals(item.properties[0].type, decoded.properties[0].type);
			Assert.equals(0, item.properties[0].payload.compare(decoded.properties[0].payload));
		}
	}

	@:visionTestId("vision.formats._internal.images.heif.HeifContainer.readPrimary#truncated")
	function test_readPrimary__rejectsTruncatedMediaData():Void {
		final bytes = HeifContainer.writePrimary(fixture("av01"));
		ExceptionAssertions.throwsType(() -> HeifContainer.readPrimary(bytes.sub(0, bytes.length - 1)), HeifContainerError);
	}

	@:visionTestId("vision.formats._internal.images.heif.HeifContainer.writePrimary#invalidDimensions")
	function test_writePrimary__rejectsMismatchedSpatialExtents():Void {
		final item = fixture("av01");
		ExceptionAssertions.throwsType(() -> HeifContainer.writePrimary({
			type: item.type, width: 24, height: item.height, data: item.data, properties: item.properties
		}), HeifContainerError);
	}

	static function fixture(type:String):HeifCodedImage {
		return {
			type: type, width: 32, height: 24, data: Bytes.ofHex("01020304"),
			properties: [
				{type: type == "av01" ? "av1C" : "hvcC", essential: true, payload: Bytes.ofHex("81000000")},
				{type: "ispe", essential: false, payload: Bytes.ofHex("000000000000002000000018")}
			]
		};
	}
}

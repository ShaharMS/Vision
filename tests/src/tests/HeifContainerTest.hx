package tests;

import haxe.io.Bytes;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.HeifContainerError;
import vision.formats._internal.images.heif.HeifContainer;
import vision.formats._internal.images.heif.HeifContainer.HeifCodedImage;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HeifContainerTest extends utest.Test {
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

package tests;

import tests.support.FormatAssertions;
import utest.Assert;
import vision.formats.ImageIO;
import vision.formats.to.To;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class ToTest extends utest.Test {
	@:visionTestId("vision.formats.to.To.bytes#stableAccessor")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_bytes__stableAccessorAndDelegation() {
		var subject = new To();
		var bytes = subject.bytes.webp(FormatAssertions.fixtureImage());

		Assert.isTrue(subject.bytes == subject.bytes);
		FormatAssertions.bytesStartWith(bytes, [0x52, 0x49, 0x46, 0x46]);
		FormatAssertions.imagesEqual(FormatAssertions.fixtureImage(), ImageIO.from.bytes.webp(bytes));
	}

	@:visionTestId("vision.formats.to.To.framework#stableAccessor")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_framework__stableAccessorPerInstance() {
		var first = new To();
		var second = new To();

		Assert.notNull(first.framework);
		Assert.isTrue(first.framework == first.framework);
		Assert.isTrue(first.framework != second.framework);
	}
}

package tests;

import tests.support.FormatAssertions;
import utest.Assert;
import vision.formats.ImageIO;
import vision.formats.from.From;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class FromTest extends utest.Test {
	@:visionTestId("vision.formats.from.From.bytes#stableAccessor")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_bytes__stableAccessorAndDelegation() {
		var subject = new From();
		var expected = FormatAssertions.fixtureImage();
		var actual = subject.bytes.png(ImageIO.to.bytes.png(expected));

		Assert.isTrue(subject.bytes == subject.bytes);
		FormatAssertions.imagesEqual(expected, actual);
	}

	@:visionTestId("vision.formats.from.From.framework#stableAccessor")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_framework__stableAccessorPerInstance() {
		var first = new From();
		var second = new From();

		Assert.notNull(first.framework);
		Assert.isTrue(first.framework == first.framework);
		Assert.isTrue(first.framework != second.framework);
	}
}

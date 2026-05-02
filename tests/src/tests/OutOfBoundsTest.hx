package tests;

import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.ds.Image;
import vision.ds.Point2D;
import vision.exceptions.OutOfBounds;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class OutOfBoundsTest extends utest.Test {
	@:visionTestId("vision.exceptions.OutOfBounds.new#message")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__reportsPositionAndImageSize() {
		var image = new Image(4, 3);
		var error = ExceptionAssertions.capture(() -> throw new OutOfBounds(image, new Point2D(5, 1)));
		var message = ExceptionAssertions.messageOf(error);

		Assert.isTrue(Std.isOfType(error, OutOfBounds));
		Assert.isTrue(message.indexOf("Pixel Coordinates Out Of Bounds: pixel") == 0);
		Assert.isTrue(message.indexOf("5") != -1);
		Assert.isTrue(message.indexOf("size: 4x3") != -1);
	}
}
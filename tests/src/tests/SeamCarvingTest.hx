package tests;

import utest.Assert;
import vision.Vision;
import vision.algorithms.SeamCarving;
import vision.ds.Color;
import vision.ds.Image;
import tests.support.ExceptionAssertions;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class SeamCarvingTest extends utest.Test {
	@:visionTestId("vision.Vision.carve#dimensions-source-and-alpha")
	function test_carve__dimensionsSourceAndAlpha() {
		var image = fixture(6, 5, 17);
		var before = image.clone();
		var result = Vision.carve(image, 3, 2);
		Assert.equals(3, result.width);
		Assert.equals(2, result.height);
		assertImage(before, image);
		for (y in 0...result.height) for (x in 0...result.width) {
			var found = false;
			for (sy in 0...image.height) for (sx in 0...image.width) {
				if (result.getPixel(x, y) == image.getPixel(sx, sy)) found = true;
			}
			Assert.isTrue(found);
		}
	}

	@:visionTestId("vision.Vision.carve#no-op-independent")
	function test_carve__noOpReturnsIndependentCopy() {
		var image = fixture(3, 2, 9);
		var copy = Vision.carve(image, 3, 2);
		assertImage(image, copy);
		copy.setPixel(0, 0, Color.WHITE);
		Assert.isTrue(image.getPixel(0, 0) != Color.WHITE);
	}

	@:visionTestId("vision.Vision.carve#invalid-sizes")
	function test_carve__rejectsInvalidSizesBeforeMutation() {
		var image = fixture(3, 2, 9);
		var before = image.clone();
		for (size in [[0, 1], [1, 0], [-1, 1], [4, 1], [1, 3]]) {
			ExceptionAssertions.throwsAny(() -> { Vision.carve(image, size[0], size[1]); });
			assertImage(before, image);
		}
	}

	@:visionTestId("vision.algorithms.SeamCarving.compute#ties-and-degenerate-axes")
	function test_compute__tiesAndSinglePixelAxes() {
		var image = new Image(4, 3);
		for (y in 0...3) for (x in 0...4) image.setPixel(x, y, cast (((x + y * 4 + 1) << 24) | 0x333333));
		var vertical = SeamCarving.compute(image, 3, 3);
		for (y in 0...3) for (x in 0...3) Assert.equals(image.getPixel(x + 1, y), vertical.getPixel(x, y));
		var horizontal = SeamCarving.compute(image, 4, 2);
		for (y in 0...2) for (x in 0...4) Assert.equals(image.getPixel(x, y + 1), horizontal.getPixel(x, y));
		Assert.equals(1, SeamCarving.compute(image, 1, 1).width);
		Assert.equals(1, SeamCarving.compute(new Image(1, 4), 1, 1).height);
		Assert.equals(1, SeamCarving.compute(new Image(4, 1), 1, 1).width);
	}

	@:visionTestId("vision.algorithms.SeamCarving.compute#horizontal-and-order")
	function test_compute__horizontalTransposeParityAndWidthFirstOrder() {
		var image = fixture(6, 5, 31);
		assertImage(transpose(SeamCarving.compute(transpose(image), 3, 6)), SeamCarving.compute(image, 6, 3));
		var widthFirst = SeamCarving.compute(image, 4, 5);
		assertImage(SeamCarving.compute(widthFirst, 4, 3), SeamCarving.compute(image, 4, 3));
		// Batch removal must recalculate energy, matching successive one-seam calls.
		var repeated = SeamCarving.compute(SeamCarving.compute(image, 5, 5), 4, 5);
		assertImage(widthFirst, repeated);
	}

	@:visionTestId("vision.algorithms.SeamCarving.compute#exhaustive-minimum-path")
	function test_compute__matchesExhaustiveMinimumEnergy() {
		for (seed in 1...13) {
			var image = fixture(4, 5, seed);
			var result = SeamCarving.compute(image, 3, 5);
			var removed = new Array<Int>();
			var actualCost = 0.;
			for (y in 0...5) {
				var missing = -1;
				var next = 0;
				for (x in 0...4) {
					if (next < 3 && image.getPixel(x, y) == result.getPixel(next, y)) next++;
					else missing = x;
				}
				Assert.equals(3, next);
				removed.push(missing);
				if (y > 0) Assert.isTrue(Math.abs(missing - removed[y - 1]) <= 1);
				actualCost += energy(image, missing, y);
			}
			var minimum = Math.POSITIVE_INFINITY;
			function enumerate(row:Int, previous:Int, cost:Float) {
				if (row == 5) { if (cost < minimum) minimum = cost; return; }
				for (x in 0...4) if (row == 0 || Math.abs(x - previous) <= 1) enumerate(row + 1, x, cost + energy(image, x, row));
			}
			enumerate(0, 0, 0);
			Assert.floatEquals(minimum, actualCost);
		}
	}

	static function energy(image:Image, x:Int, y:Int):Float {
		var left = image.getPixel(x == 0 ? 0 : x - 1, y);
		var right = image.getPixel(x == image.width - 1 ? x : x + 1, y);
		var top = image.getPixel(x, y == 0 ? 0 : y - 1);
		var bottom = image.getPixel(x, y == image.height - 1 ? y : y + 1);
		return Math.abs(left.red - right.red) + Math.abs(left.green - right.green) + Math.abs(left.blue - right.blue)
			+ Math.abs(top.red - bottom.red) + Math.abs(top.green - bottom.green) + Math.abs(top.blue - bottom.blue);
	}

	static function fixture(width:Int, height:Int, seed:Int):Image {
		var image = new Image(width, height);
		for (y in 0...height) for (x in 0...width) {
			var rgb = ((x * 71 + y * 29 + seed * 13) % 256) << 16 | ((x * 19 + y * 83 + seed * 37) % 256) << 8 | ((x * 43 + y * 11 + seed * 59) % 256);
			image.setPixel(x, y, cast (((1 + x + y * width) << 24) | rgb));
		}
		return image;
	}

	static function transpose(image:Image):Image {
		var output = new Image(image.height, image.width);
		for (y in 0...image.height) for (x in 0...image.width) output.setPixel(y, x, image.getPixel(x, y));
		return output;
	}

	static function assertImage(expected:Image, actual:Image) {
		Assert.equals(expected.width, actual.width);
		Assert.equals(expected.height, actual.height);
		for (y in 0...expected.height) for (x in 0...expected.width) Assert.equals(expected.getPixel(x, y), actual.getPixel(x, y));
	}
}

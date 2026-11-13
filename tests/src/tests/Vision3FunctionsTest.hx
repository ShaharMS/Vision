package tests;

import utest.Assert;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.MultiPolygon;
import vision.ds.Polygon;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class Vision3FunctionsTest extends utest.Test {
	@:visionTestId("vision.Vision.dither#paletteAndAlpha")
	function test_dither__paletteAndAlpha() {
		final source = new Image(8, 8, Color.fromRGBA(128, 128, 128, 70));
		for (technique in [vision.ds.specifics.DitheringAlgorithm.FloydSteinberg, vision.ds.specifics.DitheringAlgorithm.Bayer]) {
			final result = Vision.dither(source, null, technique);
			var whites = 0;
			for (pixel in result) {
				Assert.equals(70, pixel.color.alpha);
				Assert.isTrue(pixel.color.red == 0 || pixel.color.red == 255);
				if (pixel.color.red == 255) whites++;
			}
			Assert.isTrue(whites > 16 && whites < 48);
		}
		Assert.equals(128, source.getPixel(0, 0).red);
	}

	@:visionTestId("vision.Vision.gaussianNoise#seedAndAlpha")
	function test_gaussianNoise__seedAndAlpha() {
		final source = new Image(4, 4, Color.fromRGBA(100, 100, 100, 90));
		final first = Vision.gaussianNoise(source, 20, 0, true, 123);
		final second = Vision.gaussianNoise(source, 20, 0, true, 123);
		var changed = false;
		for (y in 0...source.height)
			for (x in 0...source.width) {
				final color = first.getPixel(x, y);
				Assert.equals((second.getPixel(x, y) : Int), (color : Int));
				Assert.equals(color.red, color.green);
				Assert.equals(color.green, color.blue);
				Assert.equals(90, color.alpha);
				if (color.red != 100) changed = true;
			}
		Assert.isTrue(changed);
		Assert.equals(255, Vision.gaussianNoise(source, 0, 200).getPixel(0, 0).red);
	}

	@:visionTestId("vision.Vision.nonLocalMeansDenoise#edgeAndImpulse")
	function test_nonLocalMeansDenoise__edgeAndImpulse() {
		final source = new Image(8, 5, Color.BLACK);
		source.fillRect(0, 0, 4, 5, Color.fromRGBA(100, 100, 100, 90));
		source.setPixel(1, 2, Color.fromRGBA(140, 140, 140, 70));
		final output = Vision.nonLocalMeansDenoise(source, 30, 1, 2);
		Assert.isTrue(output.getPixel(1, 2).red < 125);
		Assert.isTrue(output.getPixel(3, 2).red >= 98);
		Assert.isTrue(output.getPixel(4, 2).red <= 2);
		Assert.equals(70, output.getPixel(1, 2).alpha);
		Assert.equals(140, source.getPixel(1, 2).red);
	}

	@:visionTestId("vision.Vision.find#techniquesAndOrdering")
	function test_find__techniquesAndOrdering() {
		final image = new Image(6, 2, Color.WHITE);
		final template = new Image(2, 1, Color.BLACK);
		template.setPixel(1, 0, Color.fromRGBA(100, 100, 100));
		image.stamp(4, 0, template);
		image.stamp(1, 1, template);
		final exact = Vision.find(image, template);
		Assert.equals(2, exact.length);
		Assert.equals(4, exact[0].bounds.x);
		Assert.equals(0, exact[0].bounds.y);
		Assert.equals(1, exact[1].bounds.x);
		Assert.equals(1.0, exact[1].score);

		image.setPixel(4, 0, Color.fromRGBA(20, 20, 20));
		image.setPixel(5, 0, Color.fromRGBA(120, 120, 120));
		final nearest = Vision.find(image, template, ColorDifference, 0.9, 1);
		Assert.equals(1, nearest.length);
		Assert.equals(1, nearest[0].bounds.x);
		final correlated = Vision.find(image, template, NormalizedCorrelation, 0.99);
		Assert.isTrue(Lambda.exists(correlated, match -> match.bounds.x == 4 && match.bounds.y == 0));
		Assert.equals(0, Vision.find(template, image).length);
		Assert.equals(0, Vision.find(image, new Image(1, 1, Color.TRANSPARENT), NormalizedCorrelation, 0).length);
	}

	@:visionTestId("vision.ds.Polygon.contains#holes")
	@:visionTestId("vision.ds.MultiPolygon.copy#deep")
	@:visionTestId("vision.ds.Image.fillMultiPolygon#union")
	@:visionTestId("vision.ds.Image.drawMultiPolygon#clipping")
	function test_polygons__holesClippingAndEditing() {
		final polygon = new Polygon([{x: -2, y: 1}, {x: 8, y: 1}, {x: 8, y: 8}, {x: -2, y: 8}],
			[[{x: 2, y: 3}, {x: 5, y: 3}, {x: 5, y: 6}, {x: 2, y: 6}]]);
		final island = new Polygon([{x: 3, y: 4}, {x: 4, y: 4}, {x: 4, y: 5}, {x: 3, y: 5}]);
		final multi = new MultiPolygon([polygon, island]);
		Assert.equals(61.0, polygon.area);
		Assert.equals(62.0, multi.area);
		Assert.equals(46.0, polygon.perimeter);
		Assert.equals(-2, multi.bounds.x);
		Assert.isFalse(polygon.contains({x: 3.5, y: 4.5}));
		Assert.isTrue(multi.contains({x: 3.5, y: 4.5}));
		final copy = multi.copy();
		copy.polygons[0].points[0].x = -3;
		Assert.equals(-2, multi.bounds.x);
		Assert.equals(-3, copy.bounds.x);

		final image = new Image(8, 8, Color.BLACK);
		image.fillPolygon(polygon, Color.WHITE);
		Assert.equals((Color.WHITE : Int), (image.getPixel(0, 1) : Int));
		Assert.equals((Color.BLACK : Int), (image.getPixel(3, 4) : Int));
		image.fillMultiPolygon(multi, Color.WHITE);
		Assert.equals((Color.WHITE : Int), (image.getPixel(3, 4) : Int));
		Assert.equals((Color.BLACK : Int), (image.getPixel(4, 4) : Int));

		final outline = new Image(8, 8, Color.BLACK);
		outline.drawMultiPolygon(multi, Color.WHITE);
		Assert.equals((Color.BLACK : Int), (outline.getPixel(0, 2) : Int));
		Assert.equals((Color.WHITE : Int), (outline.getPixel(2, 3) : Int));
		Assert.equals((Color.WHITE : Int), (outline.getPixel(3, 4) : Int));
	}
}

package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ApproxAssertions;
import utest.Assert;
import vision.algorithms.Hough;
import vision.ds.Color;
import vision.ds.HoughLine2D;
import vision.ds.Image;
import vision.ds.Point2D;
import vision.ds.specifics.HoughLineOptions;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HoughStandardTest extends utest.Test {
	@:visionTestId("vision.algorithms.Hough.createAccumulator#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_createAccumulator__default() {
		var accumulator = Hough.createAccumulator(4, 3);
		Assert.equals(4, accumulator.width);
		Assert.equals(3, accumulator.height);
		Assert.equals(0.0, accumulator.get(0, 0));
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__default() {
		var result = Hough.detectLines(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#horizontal")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__horizontalLine() {
		var result = Hough.detectLines(AlgorithmFixtures.horizontalLineImage(), createOptions(5));
		var detected = findClippedLine(result, 5, 5, new Point2D(0, 2), new Point2D(4, 2));
		Assert.isTrue(detected != null);
		if (detected == null) return;
		ApproxAssertions.equalsFloat(5, detected.votes);
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#vertical")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__verticalLine() {
		var result = Hough.detectLines(AlgorithmFixtures.verticalLineImage(), createOptions(5));
		var detected = findClippedLine(result, 5, 5, new Point2D(2, 0), new Point2D(2, 4));
		Assert.isTrue(detected != null);
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#diagonal")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__diagonalLine() {
		var result = Hough.detectLines(AlgorithmFixtures.diagonalLineImage(), createOptions(5));
		var detected = findClippedLine(result, 5, 5, new Point2D(0, 0), new Point2D(4, 4));
		Assert.isTrue(detected != null);
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#negative-rho")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__negativeRho() {
		var result = Hough.detectLines(AlgorithmFixtures.diagonalLineImage(5, 5, -2), createOptions(3));
		var detected = findClippedLine(result, 5, 5, new Point2D(2, 0), new Point2D(4, 2), 0.2);
		Assert.isTrue(detected != null);
		if (detected == null) return;
		Assert.isTrue(detected.rho < 0);
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#weighted-votes")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__weightedVotesPreferStrongerLine() {
		var options = createOptions(1);
		options.useEdgeValueWeights = true;

		var result = Hough.detectLines(createWeightedParallelLineImage(), options);
		var stronger = findClippedLine(result, 7, 7, new Point2D(1, 0), new Point2D(1, 6));
		var weaker = findClippedLine(result, 7, 7, new Point2D(5, 0), new Point2D(5, 6));

		Assert.isTrue(stronger != null);
		Assert.isTrue(weaker != null);
		if (stronger == null || weaker == null) return;

		Assert.isTrue(stronger.votes > weaker.votes);
		ApproxAssertions.equalsFloat(7, stronger.votes, 0.001);
		ApproxAssertions.equalsFloat((7 * 64) / 255, weaker.votes, 0.001);
	}

	@:visionTestId("vision.algorithms.Hough.detectLines#theta-bounds")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__thetaBoundsRejectOutsideWindow() {
		var options = createOptions(5);
		options.thetaResolution = 0.01;
		options.minTheta = (Math.PI / 2) - 0.2;
		options.maxTheta = (Math.PI / 2) + 0.2;

		var result = Hough.detectLines(createOrthogonalCrossImage(), options);
		var horizontal = findClippedLine(result, 5, 5, new Point2D(0, 2), new Point2D(4, 2), 0.05);
		var vertical = findClippedLine(result, 5, 5, new Point2D(2, 0), new Point2D(2, 4), 0.05);

		Assert.isTrue(horizontal != null);
		Assert.isNull(vertical);
	}

	@:visionTestId("vision.algorithms.Hough.detectLinesFromPoints#parity")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLinesFromPoints__matchesImageAccumulatorPath() {
		var image = AlgorithmFixtures.diagonalLineImage();
		var options = createOptions(5);
		var imageResult = Hough.detectLines(image, options);
		var pointResult = Hough.detectLinesFromPoints(collectPoints(image), image.width, image.height, options);
		var expectedStart = new Point2D(0, 0);
		var expectedEnd = new Point2D(4, 4);
		var imageLine = findClippedLine(imageResult, image.width, image.height, expectedStart, expectedEnd);
		var pointLine = findClippedLine(pointResult, image.width, image.height, expectedStart, expectedEnd);

		Assert.isTrue(imageLine != null);
		Assert.isTrue(pointLine != null);
		if (imageLine == null || pointLine == null) return;

		ApproxAssertions.equalsFloat(imageLine.rho, pointLine.rho, 0.001);
		ApproxAssertions.equalsFloat(imageLine.theta, pointLine.theta, 0.001);
		ApproxAssertions.equalsFloat(imageLine.votes, pointLine.votes, 0.001);
	}

	@:visionTestId("vision.ds.HoughLine2D.toRay2D#horizontal")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toRay2D__horizontalLineDirection() {
		var ray = new HoughLine2D(2, Math.PI / 2).toRay2D();
		var nextPoint = ray.getPointAtX(ray.point.x + 5);

		ApproxAssertions.equalsFloat(2, ray.point.y);
		ApproxAssertions.equalsFloat(2, nextPoint.y);
	}

	@:visionTestId("vision.ds.HoughLine2D.toRay2D#vertical")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toRay2D__verticalLineDirection() {
		var ray = new HoughLine2D(3, 0).toRay2D();
		var nextPoint = ray.getPointAtY(ray.point.y + 5);

		ApproxAssertions.equalsFloat(3, ray.point.x);
		ApproxAssertions.equalsFloat(3, nextPoint.x, 0.001);
	}

	function createOptions(voteThreshold:Int):HoughLineOptions {
		var options = new HoughLineOptions();
		options.rhoResolution = 0.01;
		options.voteThreshold = voteThreshold;
		return options;
	}

	function createWeightedParallelLineImage():Image {
		var image = new Image(7, 7, Color.BLACK);
		for (y in 0...7) {
			image.setPixel(1, y, Color.WHITE);
			image.setPixel(5, y, Color.fromRGBA(64, 64, 64));
		}
		return image;
	}

	function createOrthogonalCrossImage():Image {
		var image = AlgorithmFixtures.horizontalLineImage();
		for (y in 0...image.height) {
			image.setPixel(2, y, Color.WHITE);
		}
		return image;
	}

	function collectPoints(image:Image):Array<Point2D> {
		var points:Array<Point2D> = [];
		image.forEachPixel((x, y, color) -> {
			if (color.red == 0 && color.green == 0 && color.blue == 0) {
				return;
			}
			points.push(new Point2D(x, y));
		});
		return points;
	}

	function findClippedLine(lines:Array<HoughLine2D>, width:Int, height:Int, start:Point2D, end:Point2D, tolerance:Float = 0.01):Null<HoughLine2D> {
		for (line in lines) {
			var clipped = line.toLine2D(width, height);
			if (clipped == null) {
				continue;
			}
			if (matchesEndpoints(clipped.start, clipped.end, start, end, tolerance)) {
				return line;
			}
		}
		return null;
	}

	function matchesEndpoints(actualStart:Point2D, actualEnd:Point2D, expectedStart:Point2D, expectedEnd:Point2D, tolerance:Float):Bool {
		return (matchesPoint(actualStart, expectedStart, tolerance) && matchesPoint(actualEnd, expectedEnd, tolerance))
			|| (matchesPoint(actualStart, expectedEnd, tolerance) && matchesPoint(actualEnd, expectedStart, tolerance));
	}

	function matchesPoint(actual:Point2D, expected:Point2D, tolerance:Float):Bool {
		return Math.abs(actual.x - expected.x) <= tolerance && Math.abs(actual.y - expected.y) <= tolerance;
	}
}
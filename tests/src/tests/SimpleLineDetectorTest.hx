package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ApproxAssertions;
import utest.Assert;
import vision.algorithms.SimpleLineDetector;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Int16Point2D;
import vision.ds.Line2D;
import vision.ds.Point2D;

@:access(vision.algorithms.SimpleLineDetector)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class SimpleLineDetectorTest extends utest.Test {
	function assertHorizontalLine(line:Line2D, expectedMinX:Float, expectedMaxX:Float, expectedY:Float):Void {
		var minX = Math.min(line.start.x, line.end.x);
		var maxX = Math.max(line.start.x, line.end.x);
		ApproxAssertions.equalsFloat(expectedMinX, minX);
		ApproxAssertions.equalsFloat(expectedMaxX, maxX);
		ApproxAssertions.equalsFloat(expectedY, line.start.y);
		ApproxAssertions.equalsFloat(expectedY, line.end.y);
	}

	function assertVerticalLine(line:Line2D, expectedX:Float, expectedMinY:Float, expectedMaxY:Float):Void {
		var minY = Math.min(line.start.y, line.end.y);
		var maxY = Math.max(line.start.y, line.end.y);
		ApproxAssertions.equalsFloat(expectedX, line.start.x);
		ApproxAssertions.equalsFloat(expectedX, line.end.x);
		ApproxAssertions.equalsFloat(expectedMinY, minY);
		ApproxAssertions.equalsFloat(expectedMaxY, maxY);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.image#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_image__default() {
		Assert.isTrue(SimpleLineDetector.image == null);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.new#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__default() {
		Assert.notNull(new SimpleLineDetector(new Image(1, 1, Color.BLACK)));
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.findLineFromPoint#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_findLineFromPoint__default() {
		var result = SimpleLineDetector.findLineFromPoint(AlgorithmFixtures.horizontalLineImage(), new Int16Point2D(0, 2), 1.0);
		Assert.notNull(result);
		assertHorizontalLine(result, 0, 4, 2);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.findLineFromPoint#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_findLineFromPoint__tiny() {
		var result = SimpleLineDetector.findLineFromPoint(AlgorithmFixtures.horizontalLineImage(), new Int16Point2D(0, 2), 10.0);
		Assert.isTrue(result == null);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.findLineFromPoint#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_findLineFromPoint__checkerboard() {
		var result = SimpleLineDetector.findLineFromPoint(AlgorithmFixtures.verticalLineImage(), new Int16Point2D(2, 0), 1.0, true);
		Assert.notNull(result);
		assertVerticalLine(result, 2, 0, 4);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.lineCoveragePercentage#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_lineCoveragePercentage__default() {
		var result = SimpleLineDetector.lineCoveragePercentage(AlgorithmFixtures.horizontalLineImage(), new Line2D(new Point2D(0, 2), new Point2D(4, 2)));
		ApproxAssertions.equalsFloat(100, result);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.lineCoveragePercentage#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_lineCoveragePercentage__tiny() {
		var result = SimpleLineDetector.lineCoveragePercentage(AlgorithmFixtures.horizontalLineImage(), null);
		ApproxAssertions.equalsFloat(0, result);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.lineCoveragePercentage#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_lineCoveragePercentage__checkerboard() {
		var image = AlgorithmFixtures.horizontalLineImage();
		image.setPixel(2, 2, Color.BLACK);
		var result = SimpleLineDetector.lineCoveragePercentage(image, new Line2D(new Point2D(0, 2), new Point2D(4, 2)));
		ApproxAssertions.equalsFloat(60, result);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.correctLines#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_correctLines__default() {
		var lines = [new Line2D(new Point2D(0, 1), new Point2D(2, 1)), new Line2D(new Point2D(2, 1), new Point2D(4, 1))];
		var result = SimpleLineDetector.correctLines(lines, 0.5, 1.0);
		Assert.equals(1, result.length);
		assertHorizontalLine(result[0], 0, 4, 1);
	}

	@:visionTestId("vision.algorithms.SimpleLineDetector.correctLines#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_correctLines__duplicates() {
		var lines = [new Line2D(new Point2D(4, 1), new Point2D(2, 1)), new Line2D(new Point2D(2, 1), new Point2D(0, 1))];
		var result = SimpleLineDetector.correctLines(lines, 0.5, 1.0);
		Assert.equals(1, result.length);
		assertHorizontalLine(result[0], 0, 4, 1);
	}
}

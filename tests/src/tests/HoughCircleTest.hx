package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ApproxAssertions;
import utest.Assert;
import vision.algorithms.Hough;
import vision.Vision;
import vision.ds.Circle2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Point2D;
import vision.ds.specifics.HoughCircleOptions;

@:visionMaturity("semantic")
@:visionLifecycle("active")
class HoughCircleTest extends utest.Test {
	@:visionTestId("vision.ds.Circle2D.copy#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_circle2D_copy__default() {
		var copy = new Circle2D(new Point2D(2, 3), 4, 5).copy();
		Assert.equals(2.0, copy.center.x);
		Assert.equals(3.0, copy.center.y);
		Assert.equals(4.0, copy.radius);
		Assert.equals(5.0, copy.votes);
	}

	@:visionTestId("vision.algorithms.Hough.detectCircles#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCircles__default() {
		var result = Hough.detectCircles(new Image(3, 3, Color.BLACK));
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.Vision.houghCircleDetection#centered")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_houghCircleDetection__centeredCircle() {
		var options = createOptions();
		options.minimumRadius = 4;
		options.maximumRadius = 6;
		var result = Vision.houghCircleDetection(AlgorithmFixtures.filledCircleImage(31, 31, 15, 15, 5), options);
		var detected = findCircle(result, new Point2D(15, 15), 5, 2.0);
		Assert.notNull(detected);
		if (detected == null) return;
		ApproxAssertions.equalsFloat(15, detected.center.x, 2.0);
		ApproxAssertions.equalsFloat(15, detected.center.y, 2.0);
		ApproxAssertions.equalsFloat(5, detected.radius, 2.0);
		Assert.isTrue(detected.votes >= options.centerThreshold);
	}

	@:visionTestId("vision.algorithms.Hough.detectCircles#minimum-distance")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCircles__minimumDistanceKeepsSeparatedCircles() {
		var image = AlgorithmFixtures.separatedCircleImage();
		var options = createOptions();
		options.minimumRadius = 4;
		options.maximumRadius = 6;
		options.minimumDistance = 12;
		var result = Hough.detectCircles(image, options);
		Assert.equals(2, result.length);
		Assert.notNull(findCircle(result, new Point2D(14, 16), 5));
		Assert.notNull(findCircle(result, new Point2D(32, 16), 5));

		options.minimumDistance = 24;
		var suppressed = Hough.detectCircles(AlgorithmFixtures.separatedCircleImage(), options);
		Assert.equals(1, suppressed.length);
	}

	@:visionTestId("vision.algorithms.Hough.detectCircles#radius-bounds")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCircles__rejectsOutsideRadiusBounds() {
		var options = createOptions();
		options.minimumRadius = 8;
		options.maximumRadius = 9;
		var result = Hough.detectCircles(AlgorithmFixtures.filledCircleImage(), options);
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.algorithms.Hough.detectCircles#large-radius")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCircles__detectsLargeRadiusAboveThirtySixPixels() {
		var options = createOptions();
		options.minimumRadius = 38;
		options.maximumRadius = 42;
		var result = Hough.detectCircles(AlgorithmFixtures.filledCircleImage(101, 101, 50, 50, 40), options);
		var detected = findCircle(result, new Point2D(50, 50), 40, 3.0);
		Assert.notNull(detected);
	}

	@:visionTestId("vision.algorithms.Hough.detectCircles#no-edge-image")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectCircles__returnsNoCirclesForNonEmptyImageWithoutEdges() {
		var options = createOptions();
		options.minimumRadius = 4;
		options.maximumRadius = 8;
		var result = Hough.detectCircles(new Image(31, 31, Color.fromRGBA(180, 180, 180)), options);
		Assert.equals(0, result.length);
	}

	function createOptions():HoughCircleOptions {
		var options = new HoughCircleOptions();
		options.cannyLowThreshold = 20;
		options.cannyHighThreshold = 40;
		options.centerThreshold = 6;
		return options;
	}

	function findCircle(circles:Array<Circle2D>, center:Point2D, radius:Float, tolerance:Float = 1.5):Circle2D {
		for (circle in circles) {
			if (Math.abs(circle.center.x - center.x) > tolerance || Math.abs(circle.center.y - center.y) > tolerance) {
				continue;
			}
			if (Math.abs(circle.radius - radius) <= tolerance) {
				return circle;
			}
		}
		return null;
	}
}
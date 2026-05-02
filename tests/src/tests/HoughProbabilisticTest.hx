package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ApproxAssertions;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.algorithms.Hough;
import vision.algorithms.HoughProbabilisticSegments;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.exceptions.VisionException;
import vision.ds.specifics.ProbabilisticHoughLineOptions;
import vision.Vision;

@:visionMaturity("semantic")
@:visionLifecycle("active")
@:access(vision.algorithms.HoughProbabilisticSegments)
class HoughProbabilisticTest extends utest.Test {
	@:visionTestId("vision.algorithms.Hough.detectLineSegments#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLineSegments__default() {
		var options = new ProbabilisticHoughLineOptions();
		options.voteThreshold = 1;
		var result = Hough.detectLineSegments(new Image(3, 3, Color.BLACK), options);
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.algorithms.Hough.detectLineSegments#gap-link")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLineSegments__linksSmallGap() {
		var options = createOptions(5, 5, 1, 4);
		var result = Hough.detectLineSegments(AlgorithmFixtures.gappedHorizontalLineImage(), options);
		Assert.equals(1, result.length);
		assertHorizontalLine(result[0], 0, 6, 2);
	}

	@:visionTestId("vision.algorithms.Hough.detectLineSegments#min-length")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLineSegments__rejectsShortLine() {
		var options = createOptions(2, 3, 0, 2);
		var result = Hough.detectLineSegments(AlgorithmFixtures.shortHorizontalSegmentImage(), options);
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.algorithms.HoughProbabilisticSegments.mergeSegments#adjacent-parallel")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("synthetic_geometry")
	function test_detectLineSegments__keepsAdjacentParallelSegmentsDistinct() {
		var options = createOptions(6, 6, 0, 6, 1);
		var result = HoughProbabilisticSegments.mergeSegments([
			createSegment(new Line2D(new Point2D(0, 2), new Point2D(6, 2)), 2, Math.PI / 2),
			createSegment(new Line2D(new Point2D(0, 3), new Point2D(6, 3)), 3, Math.PI / 2)
		], options);
		Assert.equals(2, result.length);
		assertHorizontalLine(findSegment(result, new Point2D(0, 2), new Point2D(6, 2)), 0, 6, 2);
		assertHorizontalLine(findSegment(result, new Point2D(0, 3), new Point2D(6, 3)), 0, 6, 3);
	}

	@:visionTestId("vision.algorithms.Hough.detectLineSegments#duplicate-suppression")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLineSegments__suppressesDenseGridDuplicates() {
		var options = createOptions(8, 6, 0, 6);
		var result = Hough.detectLineSegments(AlgorithmFixtures.orthogonalGridImage(), options);
		Assert.equals(6, result.length);
		assertHorizontalLine(findSegment(result, new Point2D(0, 1), new Point2D(8, 1)), 0, 8, 1);
		assertHorizontalLine(findSegment(result, new Point2D(0, 4), new Point2D(8, 4)), 0, 8, 4);
		assertHorizontalLine(findSegment(result, new Point2D(0, 7), new Point2D(8, 7)), 0, 8, 7);
		assertVerticalLine(findSegment(result, new Point2D(1, 0), new Point2D(1, 8)), 1, 0, 8);
		assertVerticalLine(findSegment(result, new Point2D(4, 0), new Point2D(4, 8)), 4, 0, 8);
		assertVerticalLine(findSegment(result, new Point2D(7, 0), new Point2D(7, 8)), 7, 0, 8);
	}

	@:visionTestId("vision.Vision.houghLineSegmentDetection#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_houghLineSegmentDetection__default() {
		var image = AlgorithmFixtures.gappedHorizontalLineImage();
		var result = Vision.houghLineSegmentDetection(image, 5, 5, 1, image);
		Assert.equals(1, result.length);
		assertHorizontalLine(result[0], 0, 6, 2);
	}

	@:visionTestId("vision.Vision.houghLineSegmentDetection#edge-image-size")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_houghLineSegmentDetection__rejectsMismatchedEdgeImageSize() {
		var image = AlgorithmFixtures.gappedHorizontalLineImage();
		var mismatchedEdges = new Image(image.width - 1, image.height, Color.BLACK);
		ExceptionAssertions.expectMessage(
			() -> Vision.houghLineSegmentDetection(image, 5, 5, 1, mismatchedEdges),
			VisionException,
			'Hough Line Segment Detection Error: Custom edgeImage must match the source image dimensions. Expected 7x5 but got 6x5.'
		);
	}

	function createOptions(candidateThreshold:Int, minLineLength:Float, maxLineGap:Float, voteThreshold:Int, rhoResolution:Float = 0.01):ProbabilisticHoughLineOptions {
		var options = new ProbabilisticHoughLineOptions();
		options.rhoResolution = rhoResolution;
		options.candidateThreshold = candidateThreshold;
		options.minLineLength = minLineLength;
		options.maxLineGap = maxLineGap;
		options.voteThreshold = voteThreshold;
		return options;
	}

	function findSegment(lines:Array<Line2D>, start:Point2D, end:Point2D, tolerance:Float = 0.01):Line2D {
		for (line in lines) {
			if (matchesEndpoints(line.start, line.end, start, end, tolerance)) {
				return line;
			}
		}
		return null;
	}

	function assertHorizontalLine(line:Line2D, startX:Float, endX:Float, y:Float):Void {
		Assert.notNull(line);
		if (line == null) return;
		ApproxAssertions.equalsFloat(startX, line.start.x);
		ApproxAssertions.equalsFloat(endX, line.end.x);
		ApproxAssertions.equalsFloat(y, line.start.y);
		ApproxAssertions.equalsFloat(y, line.end.y);
	}

	function assertVerticalLine(line:Line2D, x:Float, startY:Float, endY:Float):Void {
		Assert.notNull(line);
		if (line == null) return;
		ApproxAssertions.equalsFloat(x, line.start.x);
		ApproxAssertions.equalsFloat(x, line.end.x);
		ApproxAssertions.equalsFloat(startY, line.start.y);
		ApproxAssertions.equalsFloat(endY, line.end.y);
	}

	function matchesEndpoints(actualStart:Point2D, actualEnd:Point2D, expectedStart:Point2D, expectedEnd:Point2D, tolerance:Float):Bool {
		return (matchesPoint(actualStart, expectedStart, tolerance) && matchesPoint(actualEnd, expectedEnd, tolerance))
			|| (matchesPoint(actualStart, expectedEnd, tolerance) && matchesPoint(actualEnd, expectedStart, tolerance));
	}

	function createSegment(line:Line2D, candidateRho:Float, candidateTheta:Float, supportVotes:Float = 7, candidateVotes:Float = 7) {
		return {
			line: line,
			supportVotes: supportVotes,
			candidateVotes: candidateVotes,
			candidateRho: candidateRho,
			candidateTheta: candidateTheta
		};
	}

	function matchesPoint(actual:Point2D, expected:Point2D, tolerance:Float):Bool {
		return Math.abs(actual.x - expected.x) <= tolerance && Math.abs(actual.y - expected.y) <= tolerance;
	}
}
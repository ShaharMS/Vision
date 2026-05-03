package tests;

import tests.support.AlgorithmFixtures;
import tests.support.ImageAssertions;
import tests.support.ManualFixtures;
import utest.Assert;
import vision.algorithms.SimpleHough;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Point2D;
import vision.ds.Ray2D;
import vision.ds.specifics.HoughLineOptions;

@:access(vision.algorithms.SimpleHough)
@:visionMaturity("semantic")
@:visionLifecycle("active")
/**
	Compatibility suite for the legacy ray-returning `SimpleHough` shim.
	Standard theta/rho behavior lives in `HoughStandardTest`.
**/
class SimpleHoughTest extends utest.Test {
	@:visionTestId("vision.algorithms.SimpleHough.detectLines#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__default() {
		var result = SimpleHough.detectLines(new Image(3, 3, Color.BLACK), 1);
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.algorithms.SimpleHough.detectLines#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__tiny() {
		var result = SimpleHough.detectLines(AlgorithmFixtures.horizontalLineImage(), 5);
		Assert.isTrue(hasHorizontalRay(result, 2));
	}

	@:visionTestId("vision.algorithms.SimpleHough.detectLines#compatibility")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__usesStandardParameterLines() {
		var options = new HoughLineOptions();
		options.voteThreshold = 5;
		var parameterLines = SimpleHough.detectParameterLines(AlgorithmFixtures.horizontalLineImage(), options);
		var rays = SimpleHough.detectLines(AlgorithmFixtures.horizontalLineImage(), 5);
		Assert.isTrue(parameterLines.length > 0);
		Assert.equals(parameterLines.length, rays.length);
		Assert.isTrue(hasMatchingRay(rays, parameterLines[0].toRay2D()));
	}

	@:visionTestId("vision.algorithms.SimpleHough.detectLines#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_detectLines__checkerboard() {
		var result = SimpleHough.detectLines(ManualFixtures.tinyCheckerboardImage(), 9);
		Assert.equals(0, result.length);
	}

	@:visionTestId("vision.algorithms.SimpleHough.mapLines#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_mapLines__default() {
		var result = SimpleHough.mapLines(new Image(5, 5, Color.BLACK), [new Ray2D(new Point2D(0, 2), 0)]);
		for (x in 0...5) {
			ImageAssertions.pixelEquals(result, x, 2, Color.CYAN);
		}
		ImageAssertions.pixelEquals(result, 0, 0, Color.BLACK);
	}

	@:visionTestId("vision.algorithms.SimpleHough.mapLines#tiny")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_mapLines__tiny() {
		var result = SimpleHough.mapLines(new Image(1, 1, Color.BLACK), []);
		ImageAssertions.pixelEquals(result, 0, 0, Color.BLACK);
	}

	@:visionTestId("vision.algorithms.SimpleHough.mapLines#checkerboard")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_mapLines__checkerboard() {
		var result = SimpleHough.mapLines(new Image(5, 5, Color.BLACK), [new Ray2D(new Point2D(0, 0), 1)]);
		Assert.isTrue(AlgorithmFixtures.nonBlackPixelCount(result) > 0);
	}

	@:visionTestId("vision.algorithms.SimpleHough.mapLines#duplicates")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	@:visionRequires("image_fixture")
	function test_mapLines__duplicates() {
		var ray = new Ray2D(new Point2D(0, 2), 0);
		var result = SimpleHough.mapLines(new Image(5, 5, Color.BLACK), [ray, ray]);
		ImageAssertions.pixelEquals(result, 2, 2, Color.CYAN);
	}

	function hasHorizontalRay(rays:Array<Ray2D>, expectedY:Float, tolerance:Float = 0.01):Bool {
		for (ray in rays) {
			var nextPoint = ray.getPointAtX(ray.point.x + 5);
			if (Math.abs(ray.point.y - expectedY) <= tolerance && Math.abs(nextPoint.y - expectedY) <= tolerance) {
				return true;
			}
		}
		return false;
	}

	function hasMatchingRay(rays:Array<Ray2D>, expected:Ray2D, tolerance:Float = 0.01):Bool {
		for (ray in rays) {
			if (Math.abs(ray.point.x - expected.point.x) <= tolerance
				&& Math.abs(ray.point.y - expected.point.y) <= tolerance
				&& Math.abs(ray.radians - expected.radians) <= tolerance) {
				return true;
			}
		}
		return false;
	}
}

package tests;

import utest.Assert;
import vision.algorithms.Hough;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.specifics.ProbabilisticHoughLineOptions;

@:visionMaturity("semantic")
@:visionLifecycle("active")
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
}
package tests;

import tests.support.ManualFixtures;
import utest.Assert;
import vision.ds.ImageView;
import vision.ds.ImageViewShape;

@:access(vision.ds.ImageView)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class ImageViewTest extends utest.Test {
	function createView():ImageView {
		return ManualFixtures.rectangleView(2, 3, 4, 5, ImageViewShape.ELLIPSE);
	}

	@:visionTestId("vision.ds.ImageView.x#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_x__default() {
		Assert.equals(2, createView().x);
	}

	@:visionTestId("vision.ds.ImageView.y#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_y__default() {
		Assert.equals(3, createView().y);
	}

	@:visionTestId("vision.ds.ImageView.width#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_width__default() {
		Assert.equals(4, createView().width);
	}

	@:visionTestId("vision.ds.ImageView.height#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_height__default() {
		Assert.equals(5, createView().height);
	}

	@:visionTestId("vision.ds.ImageView.shape#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_shape__default() {
		Assert.equals(ImageViewShape.ELLIPSE, createView().shape);
	}

	@:visionTestId("vision.ds.ImageView.toString#default")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_toString__default() {
		var instance = createView();
		Assert.equals('{shape: ${instance.shape}, x: 2, y: 3, width: 4, height: 5}', instance.toString());
	}

}

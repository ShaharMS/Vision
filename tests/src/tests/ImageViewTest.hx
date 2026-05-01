package tests;

import utest.Assert;
import vision.ds.ImageView;

@:access(vision.ds.ImageView)
@:visionMaturity("smoke")
@:visionLifecycle("active")
class ImageViewTest extends utest.Test {

	@:visionTestId("vision.ds.ImageView.x#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_x__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10, shape: vision.ds.ImageViewShape.RECTANGLE} : vision.ds.ImageView);
		var result = instance.x;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ImageView.y#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_y__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10, shape: vision.ds.ImageViewShape.RECTANGLE} : vision.ds.ImageView);
		var result = instance.y;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ImageView.width#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_width__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10, shape: vision.ds.ImageViewShape.RECTANGLE} : vision.ds.ImageView);
		var result = instance.width;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ImageView.height#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_height__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10, shape: vision.ds.ImageViewShape.RECTANGLE} : vision.ds.ImageView);
		var result = instance.height;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ImageView.shape#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_shape__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10, shape: vision.ds.ImageViewShape.RECTANGLE} : vision.ds.ImageView);
		var result = instance.shape;
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.ImageView.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var instance = ({x: 0, y: 0, width: 10, height: 10, shape: vision.ds.ImageViewShape.RECTANGLE} : vision.ds.ImageView);
		var result = instance.toString();
		Assert.notNull(result);
	}

}

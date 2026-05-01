package tests;

import utest.Assert;
import vision.ds.Point3D;

@:access(vision.ds.Point3D)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class Point3DTest extends utest.Test {

	@:visionTestId("vision.ds.Point3D.x#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_x__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var ctor_z = 1.0;
		var instance = new vision.ds.Point3D(ctor_x, ctor_y, ctor_z);
		var result = instance.x;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point3D.y#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_y__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var ctor_z = 1.0;
		var instance = new vision.ds.Point3D(ctor_x, ctor_y, ctor_z);
		var result = instance.y;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point3D.z#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_z__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var ctor_z = 1.0;
		var instance = new vision.ds.Point3D(ctor_x, ctor_y, ctor_z);
		var result = instance.z;
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point3D.distanceTo#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_distanceTo__default() {
		var point = new vision.ds.Point3D(0.0, 0.0, 0.0);
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var ctor_z = 1.0;
		var instance = new vision.ds.Point3D(ctor_x, ctor_y, ctor_z);
		var result = instance.distanceTo(point);
		Assert.isFalse(Math.isNaN(result));
	}

	@:visionTestId("vision.ds.Point3D.copy#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_copy__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var ctor_z = 1.0;
		var instance = new vision.ds.Point3D(ctor_x, ctor_y, ctor_z);
		var result = instance.copy();
		Assert.notNull(result);
	}

	@:visionTestId("vision.ds.Point3D.toString#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_toString__default() {
		var ctor_x = 1.0;
		var ctor_y = 1.0;
		var ctor_z = 1.0;
		var instance = new vision.ds.Point3D(ctor_x, ctor_y, ctor_z);
		var result = instance.toString();
		Assert.notNull(result);
	}

}

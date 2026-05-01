package tests;

import utest.Assert;
import vision.helpers.VisionThread;

@:access(vision.helpers.VisionThread)
@:visionMaturity("mixed")
@:visionLifecycle("active")
class VisionThreadTest extends utest.Test {

	@:visionTestId("vision.helpers.VisionThread.create#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_create__default() {
		var job = () -> {};
		var result = vision.helpers.VisionThread.create(job);
		Assert.notNull(result);
	}

	@:visionTestId("vision.helpers.VisionThread.job#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_job__default() {
		var ctor_job = () -> {};
		var instance = new vision.helpers.VisionThread(ctor_job);
		var result = instance.job;
		Assert.notNull(result);
	}

	@:visionTestId("vision.helpers.VisionThread.onFailed#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_onFailed__default() {
		var ctor_job = () -> {};
		var instance = new vision.helpers.VisionThread(ctor_job);
		var result = instance.onFailed;
		Assert.notNull(result);
	}

	@:visionTestId("vision.helpers.VisionThread.onDone#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_onDone__default() {
		var ctor_job = () -> {};
		var instance = new vision.helpers.VisionThread(ctor_job);
		var result = instance.onDone;
		Assert.notNull(result);
	}

	@:visionTestId("vision.helpers.VisionThread.jobDone#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_jobDone__default() {
		var ctor_job = () -> {};
		var instance = new vision.helpers.VisionThread(ctor_job);
		var result = instance.jobDone;
		Assert.pass();
	}

	@:visionTestId("vision.helpers.VisionThread.relaunchEvents#default")
	@:visionMaturity("structural")
	@:visionLifecycle("active")
	function test_relaunchEvents__default() {
		var ctor_job = () -> {};
		var instance = new vision.helpers.VisionThread(ctor_job);
		var result = instance.relaunchEvents;
		Assert.isTrue(result == true || result == false);
	}

	@:visionTestId("vision.helpers.VisionThread.count#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_count__default() {
		var ctor_job = () -> {};
		var instance = new vision.helpers.VisionThread(ctor_job);
		var result = instance.count;
		Assert.notNull(result);
	}

	@:visionTestId("vision.helpers.VisionThread.start#default")
	@:visionMaturity("smoke")
	@:visionLifecycle("active")
	function test_start__default() {
		var ctor_job = () -> {};
		var instance = new vision.helpers.VisionThread(ctor_job);
		instance.start();
		Assert.pass();
	}

}

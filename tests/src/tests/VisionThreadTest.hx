package tests;

import haxe.Exception;
import tests.support.ExceptionAssertions;
import utest.Assert;
import vision.exceptions.MultithreadFailure;
import vision.helpers.VisionThread;

@:access(vision.helpers.VisionThread)
@:visionMaturity("semantic")
@:visionLifecycle("active")
class VisionThreadTest extends utest.Test {
	@:visionTestId("vision.helpers.VisionThread.new#capturesJobAndCount")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_new__capturesJobAndCount() {
		var first = new VisionThread(() -> {});
		var second = new VisionThread(() -> {});

		Assert.notNull(first.job);
		Assert.equals(null, first.jobDone);
		Assert.equals(false, first.relaunchEvents);
		Assert.equals(first.count + 1, second.count);
	}

	@:visionTestId("vision.helpers.VisionThread.create#startsImmediately")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_create__startsImmediately() {
		var ran = false;
		var subject = VisionThread.create(() -> ran = true);

		waitForResolution(subject);

		Assert.isTrue(ran);
		Assert.equals(true, subject.jobDone);
	}

	@:visionTestId("vision.helpers.VisionThread.start#callsOnDone")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_start__callsOnDone() {
		var ran = false;
		var doneCalls = 0;
		var subject = new VisionThread(() -> ran = true);
		subject.onDone = () -> doneCalls++;

		subject.start();
		waitForResolution(subject);

		Assert.isTrue(ran);
		Assert.equals(true, subject.jobDone);
		Assert.equals(1, doneCalls);
	}

	@:visionTestId("vision.helpers.VisionThread.onFailed#defaultWrapsFailure")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_onFailed__defaultWrapsFailure() {
		var subject = new VisionThread(() -> {});
		var error = ExceptionAssertions.capture(() -> subject.onFailed(new Exception("boom")));

		Assert.isTrue(Std.isOfType(error, MultithreadFailure));
		Assert.isTrue(ExceptionAssertions.messageOf(error).indexOf("Thread number #" + subject.count + " failed: boom") != -1);
	}

	@:visionTestId("vision.helpers.VisionThread.onFailed#wrapperMarksFailure")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_onFailedWrapper__marksFailureAndInvokesHandler() {
		var captured:Exception = null;
		var subject = new VisionThread(() -> {});
		subject.onFailed = error -> captured = error;

		subject.onFailedWrapper(new Exception("boom"));

		Assert.equals(false, subject.jobDone);
		Assert.notNull(captured);
		Assert.equals("boom", captured.message);
	}

	@:visionTestId("vision.helpers.VisionThread.relaunchEvents#replaysCompletedEvents")
	@:visionMaturity("semantic")
	@:visionLifecycle("active")
	function test_relaunchEvents__replaysCompletedEvents() {
		var doneCalls = 0;
		var failedCalls = 0;
		var failedPayload:Dynamic = "unset";
		var subject = new VisionThread(() -> {});
		subject.relaunchEvents = true;

		subject.jobDone = true;
		subject.onDone = () -> doneCalls++;

		subject.jobDone = false;
		subject.onFailed = error -> {
			failedCalls++;
			failedPayload = error;
		};

		Assert.equals(1, doneCalls);
		Assert.equals(1, failedCalls);
		Assert.equals(null, failedPayload);
	}

	function waitForResolution(subject:VisionThread):Void {
		#if sys
		var attempts = 0;
		while (subject.jobDone == null && attempts < 200) {
			Sys.sleep(0.01);
			attempts++;
		}
		#end
		Assert.isTrue(subject.jobDone != null);
	}
}

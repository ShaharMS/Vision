package vision.helpers;

import vision.exceptions.MultithreadFaliure;
import haxe.Exception;
#if js
import js.lib.Promise;
#else
import sys.thread.Thread;
#end

class VisionThread {
	static var COUNT:Int = 0;

	var underlying:#if js Promise<Void> #else Thread #end;

	/**
	 * The currently assigned job. should be a function with 0 parameters and no return type (`Void` `->` `Void`)
	 */
	public var job:Void -> Void;

	/**
	 * Dispatches when the job fails
	 */
	public var onFailed(default, set):Exception->Void;

	/**
	 * Dispatches when the job is done
	 */
	public var onDone(default, set):Void->Void;

	/**
	 * |Value|Status|
	 * |---|:---:|
	 * |`true`|After the job is done|
	 * |`false`|After the job has failed|
	 * |`null`|Before/During the job|
	 */
	public var jobDone(default, null):Null<Bool>;

	/**
	 * Makes `Done` and `Failed` events relaunch when set.
	 */
	public var relaunchEvents:Bool = false;

	/**
	 * The `ID` of the thread. useful for debugging when the thread fails.
	 */
	public final count:Int;

	public function new(job:Void->Void) {
		this.job = job;
		count = COUNT++;
		onFailed = (d:Exception) -> {
			throw new MultithreadFaliure(count, d);
		};
		onDone = () -> {};
	}

	public function start() {
		#if js
		underlying = new Promise((onDone, onFailedWrapper) -> {
			job();
			jobDone = true;
		});
		#else
		underlying = Thread.create(() -> {
			try {
				job();
				jobDone = true;
				onDone();
			} catch (e) {
				onFailedWrapper(e);
			}
		});
		#end
	}

	function onFailedWrapper(d) {
		jobDone = false;
		onFailed(d);
	}

	public static function create(job:Void->Void):VisionThread {
		var t = new VisionThread(job);
		t.start();
		return t;
	}

	function set_onFailed(value:Exception->Void):Exception->Void {
		if (relaunchEvents && jobDone != null)
			value(null);

		return onFailed = value;
	}

	function set_onDone(value:() -> Void):() -> Void {
		if (relaunchEvents && jobDone != null)
			value();

		return onDone = value;
	}
}

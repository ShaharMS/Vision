package vision.helpers;

import haxe.macro.Expr.Catch;
import vision.exceptions.MultithreadFaliure;
import haxe.Exception;
#if js
import format.png.Reader;
import js.lib.Promise;
#else
import sys.thread.Thread;
#end

class VisionThread {
	static var COUNT:Int = 0;

	var underlying:#if js Promise<Void> #else Thread #end;
	var job:Void -> Void;

	public var onFailed(default, set):Exception->Void;
	public var onDone(default, set):Void->Void;
	public var jobDone(default, null):Null<Bool>;

	/**
	 * Makes `Done` and `Failed` events relaunch when set.
	 */
	public var relaunchEvents:Bool = false;

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
				onDone();
				jobDone = true;
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

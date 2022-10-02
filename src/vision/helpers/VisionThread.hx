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

	public var onFailed(default, set):Exception->Void;
	public var onDone(default, set):Void->Void;
	public var jobDone(default, null):Null<Bool>;

	/**
	 * Makes `Done` and `Failed` events relaunch when set.
	 */
	public var relaunchEvents:Bool = false;

	public final count:Int;

	function new(job:Void->Void) {
		count = COUNT++;
		onFailed = (d:Exception) -> {
			throw new MultithreadFaliure(count, d);
		};
		onDone = () -> {
			trace("done");
		};
		#if js
		underlying = new Promise((onDone, onFailed) -> {
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
				onFailed(e);
				jobDone = false;
			}
		});
		#end
	}

	public static function create(job:Void->Void):VisionThread {
		return new VisionThread(job);
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

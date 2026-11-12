package vision.ds;

/**
	The result of waiting for a screen's next frame.

	A synchronous target may complete the result before `Screen.poll()`
	returns. On an asynchronous target, register a callback with `then()`.
**/
@:allow(vision.ds.Screen)
class ScreenPoll {
	/** True when the next frame can begin, false if the screen closed, or null while waiting. **/
	public var result(default, null):Null<Bool>;

	final callbacks:Array<Bool->Void> = [];

	function new() {}

	/**
		Runs a callback when the frame wait completes. If it has already completed,
		the callback runs immediately.

		@param callback Receives whether the screen is ready for its next frame
	**/
	public function then(callback:Bool->Void):Void {
		if (result == null) callbacks.push(callback);
		else callback(result);
	}

	function complete(ready:Bool):Void {
		result = ready;
		final pending = callbacks.copy();
		callbacks.resize(0);
		for (callback in pending) callback(ready);
	}
}

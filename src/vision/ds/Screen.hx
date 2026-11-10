package vision.ds;

import haxe.Timer;
import vision.Vision;
import vision.ds.specifics.ScreenOptions;
import vision.exceptions.VisionException;
#if js
import js.Browser;
import js.lib.Promise;
import js.Syntax;
import vision.formats.__internal.CanvasRenderer;
#elseif (vision_native && (cpp || hl))
import vision.formats.__internal.NativeImageRenderer;
#end

/** A drawing destination on a browser page or in a standalone desktop window. **/
class Screen {
	public final x:Int;
	public final y:Int;
	public final width:Int;
	public final height:Int;

	/** Runs once, immediately before the first nonempty image draw. **/
	public var onFirstDraw:Null<Void->Void>;

	/** Target frames per second when polling. Defaults to 60. **/
	public var frameRate(default, set):Int = 60;

	var drewImage = false;
	var disposed = false;

	/** Elapsed seconds between completed polls. The first poll reports zero. **/
	public var deltaTime(default, null):Float = 0;

	var lastPoll:Null<Float>;

	#if js
	final renderer:CanvasRenderer;
	var animationFrame:Null<Int>;
	var pendingPoll:Promise<Bool>;
	var resolvePoll:Bool->Void;
	#elseif (vision_native && (cpp || hl))
	final renderer:NativeImageRenderer;
	#end

	/** Opens a screen. Positions and dimensions use pixels. **/
	public function new(x:Int, y:Int, width:Int, height:Int, ?options:ScreenOptions) {
		if (width <= 0 || height <= 0) throw new VisionException("Screen dimensions must be positive", "Screen");
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		if (options == null) options = {};
		frameRate = options.frameRate;

		#if js
		if (Syntax.code("typeof document === 'undefined'")
			|| Browser.document.body == null) throw new VisionException("Screen requires a browser page with a document body", "Screen");
		final canvas = Browser.document.createCanvasElement();
		canvas.width = width;
		canvas.height = height;
		canvas.style.position = "absolute";
		canvas.style.left = x + "px";
		canvas.style.top = y + "px";
		canvas.style.width = width + "px";
		canvas.style.height = height + "px";
		canvas.hidden = !options.visible;
		renderer = new CanvasRenderer(canvas, options.preferGpu, true);
		renderer.clear(Color.BLACK);
		Browser.document.body.appendChild(canvas);
		#elseif (vision_native && (cpp || hl))
		renderer = new NativeImageRenderer(width, height, options.preferGpu, options.visible, x, y);
		renderer.present();
		#else
		throw new VisionException("Screen requires a browser or a desktop build with vision_native", "Screen");
		#end
	}

	/** Clears the screen to an opaque background color. **/
	public function clear(color:Color = Color.BLACK):Void {
		checkOpen();
		#if (js || (vision_native && (cpp || hl)))
		renderer.clear(color | 0xFF000000);
		present();
		#end
	}

	/** Draws an image at a position relative to the top-left corner of this screen. **/
	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		if (!beginDraw(image)) return;
		#if (js || (vision_native && (cpp || hl)))
		renderer.draw(image, x, y);
		present();
		#end
	}

	/** Draws an inverted preview and preserves the original image. **/
	public function drawInverted(image:Image, x:Int = 0, y:Int = 0):Void {
		if (!beginDraw(image)) return;
		#if js
		renderer.drawInverted(image, x, y);
		#elseif (vision_native && (cpp || hl))
		renderer.draw(Vision.invert(image.clone()), x, y);
		present();
		#end
	}

	/** Requests device storage for an image. Returns false if it will stay on the CPU. **/
	public function attach(image:Image):Bool {
		checkOpen();
		#if js
		return renderer.attach(image);
		#else
		return false;
		#end
	}

	/** Releases device storage owned by this screen and preserves the image pixels. **/
	public function detach(image:Image):Void {
		#if js
		if (!disposed) renderer.detach(image);
		#end
	}

	/** Processes desktop events and reports whether the screen is still open. **/
	public function processEvents():Bool {
		if (disposed) return false;
		#if (vision_native && (cpp || hl) && !js)
		if (!renderer.poll()) {
			dispose();
			return false;
		}
		#end
		return true;
	}

	/**
		Waits until the next frame can start, measured from the last completed poll.
		Desktop builds wait on the calling thread. Browser builds return a promise.
		A closed screen reports false. Drawing and window event handling are separate.
	**/
	#if js
	public function poll():Promise<Bool> {
		if (disposed) return Promise.resolve(false);
		if (pendingPoll != null) return pendingPoll;
		pendingPoll = new Promise<Bool>((resolve, _) -> {
			resolvePoll = resolve;
			function nextFrame(_:Float):Void {
				final now = Timer.stamp();
				// Allow small variations in browser refresh timing.
				if (remainingTime(now) > 0.001) {
					animationFrame = Browser.window.requestAnimationFrame(nextFrame);
					return;
				}
				completePoll(now);
				finishBrowserPoll(true);
			}
			animationFrame = Browser.window.requestAnimationFrame(nextFrame);
		});
		return pendingPoll;
	}
	#else
	public function poll():Bool {
		if (disposed) return false;
		#if sys
		final remaining = remainingTime(Timer.stamp());
		if (remaining > 0) Sys.sleep(remaining);
		#end
		completePoll(Timer.stamp());
		return true;
	}
	#end

	/** Removes the screen or closes its window, and releases its drawing resources. **/
	public function dispose():Void {
		if (disposed) return;
		#if js
		if (animationFrame != null) Browser.window.cancelAnimationFrame(animationFrame);
		finishBrowserPoll(false);
		renderer.dispose();
		renderer.canvas.remove();
		#elseif (vision_native && (cpp || hl))
		renderer.dispose();
		#end
		disposed = true;
	}

	inline function set_frameRate(value:Int):Int {
		if (value <= 0) throw new VisionException("Screen frame rate must be positive", "Screen");
		return frameRate = value;
	}

	inline function remainingTime(now:Float):Float {
		return lastPoll == null ? 0 : lastPoll + 1 / frameRate - now;
	}

	function completePoll(now:Float):Void {
		deltaTime = lastPoll == null ? 0 : Math.max(0, now - lastPoll);
		lastPoll = now;
	}

	#if js
	function finishBrowserPoll(open:Bool):Void {
		final resolve = resolvePoll;
		animationFrame = null;
		pendingPoll = null;
		resolvePoll = null;
		if (resolve != null) resolve(open);
	}
	#end

	function beginDraw(image:Image):Bool {
		checkOpen();
		if (image.width <= 0 || image.height <= 0) return false;
		if (!drewImage) {
			drewImage = true;
			final firstDraw = onFirstDraw;
			onFirstDraw = null;
			if (firstDraw != null) firstDraw();
		}
		return !disposed;
	}

	inline function present():Void {
		#if (vision_native && (cpp || hl) && !js)
		renderer.present();
		#end
	}

	inline function checkOpen():Void {
		if (disposed) throw new VisionException("The screen has been disposed", "Screen");
	}
}

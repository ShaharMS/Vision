package vision.ds;

import haxe.Timer;
import vision.Vision;
import vision.ds.specifics.ScreenOptions;
import vision.exceptions.VisionException;
#if js
import js.Browser;
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

	/** Target frames per second for requested frames. Defaults to 60. **/
	public var frameRate(default, set):Int = 60;

	var drewImage = false;
	var disposed = false;
	var pendingFrame:Null<Float->Void>;
	var lastFrame:Null<Float>;
	var nextFrame:Null<Float>;

	#if js
	final renderer:CanvasRenderer;
	var animationFrame:Null<Int>;
	#elseif (vision_native && (cpp || hl))
	final renderer:NativeImageRenderer;
	var frameTimer:Timer;
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
	public function poll():Bool {
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
		Schedules one callback on the calling thread's event loop. The callback
		receives elapsed seconds since the previous callback, or zero for the first
		frame. Request another frame from the callback to continue.
		Each screen accepts one pending request at a time.
		Call this on the thread that created the screen.
	**/
	public function requestAnimationFrame(callback:Float->Void):Void {
		checkOpen();
		if (pendingFrame != null) throw new VisionException("The screen already has a pending frame request", "Screen");
		pendingFrame = callback;
		scheduleFrame();
	}

	/** Cancels the pending request and resets the elapsed time for the next request. **/
	public function cancelAnimationFrame():Void {
		cancelScheduledFrame();
		pendingFrame = null;
		lastFrame = null;
		nextFrame = null;
	}

	/** Removes the screen or closes its window, and releases its drawing resources. **/
	public function dispose():Void {
		if (disposed) return;
		cancelAnimationFrame();
		#if js
		renderer.dispose();
		renderer.canvas.remove();
		#elseif (vision_native && (cpp || hl))
		renderer.dispose();
		#end
		disposed = true;
	}

	function set_frameRate(value:Int):Int {
		if (value <= 0) throw new VisionException("Screen frame rate must be positive", "Screen");
		if (frameRate == value) return value;
		frameRate = value;
		nextFrame = lastFrame == null ? null : lastFrame + 1 / value;
		if (pendingFrame != null) {
			cancelScheduledFrame();
			scheduleFrame();
		}
		return value;
	}

	function scheduleFrame():Void {
		#if js
		animationFrame = Browser.window.requestAnimationFrame(_ -> {
			animationFrame = null;
			// Refresh timestamps can vary slightly around the target deadline.
			dispatchFrame(0.001);
		});
		#elseif (vision_native && (cpp || hl))
		final remaining = nextFrame == null ? 0.0 : nextFrame - Timer.stamp();
		final delay = Math.ceil(Math.max(1, remaining * 1000));
		frameTimer = Timer.delay(() -> {
			frameTimer = null;
			dispatchFrame(0);
		}, delay);
		#end
	}

	function dispatchFrame(tolerance:Float):Void {
		if (pendingFrame == null || !poll()) return;
		final now = Timer.stamp();
		if (nextFrame != null && now + tolerance < nextFrame) {
			scheduleFrame();
			return;
		}

		final callback = pendingFrame;
		pendingFrame = null;
		final delta = lastFrame == null ? 0.0 : Math.max(0, now - lastFrame);
		lastFrame = now;

		final interval = 1 / frameRate;
		final deadline = nextFrame == null ? now : nextFrame;
		// Keep the cadence when slightly late and skip catch-up frames after a stall.
		final following = deadline + interval;
		nextFrame = following > now ? following : now + interval;
		callback(delta);
	}

	function cancelScheduledFrame():Void {
		#if js
		if (animationFrame != null) {
			Browser.window.cancelAnimationFrame(animationFrame);
			animationFrame = null;
		}
		#elseif (vision_native && (cpp || hl))
		if (frameTimer != null) {
			frameTimer.stop();
			frameTimer = null;
		}
		#end
	}

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

package vision.ds;

import vision.Vision;
import vision.ds.specifics.ScreenOptions;
import vision.exceptions.VisionException;
#if js
import js.Browser;
import js.Syntax;
import vision.formats.__internal.CanvasRenderer;
#elseif (vision_native && (cpp || hl))
import haxe.Timer;
import vision.formats.__internal.NativeImageRenderer;
#end

/** A drawing destination on a browser page or in a standalone desktop window. **/
class Screen {
	public final x:Int;
	public final y:Int;
	public final width:Int;
	public final height:Int;

	var running = false;
	var drawingFrame = false;
	var disposed = false;

	#if js
	final renderer:CanvasRenderer;
	var animationFrame:Null<Int>;
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
		presentIfReady();
		#end
	}

	/** Draws an image at a position relative to the top-left corner of this screen. **/
	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		checkOpen();
		#if (js || (vision_native && (cpp || hl)))
		renderer.draw(image, x, y);
		presentIfReady();
		#end
	}

	/** Draws an inverted preview and preserves the original image. **/
	public function drawInverted(image:Image, x:Int = 0, y:Int = 0):Void {
		checkOpen();
		#if js
		renderer.drawInverted(image, x, y);
		#else
		draw(Vision.invert(image.clone()), x, y);
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

	/**
		Draws frames until stop or dispose is called, or until the desktop window closes.
		On the browser it schedules frames and returns immediately. On desktop it runs
		the window loop on the calling thread and returns when that loop ends.
	**/
	public function start(drawFrame:Void->Void):Void {
		checkOpen();
		if (running || drawingFrame) return;
		running = true;

		#if js
		function nextFrame(_:Float):Void {
			animationFrame = null;
			if (!running) return;
			runFrame(drawFrame);
			if (running) animationFrame = Browser.window.requestAnimationFrame(nextFrame);
		}
		animationFrame = Browser.window.requestAnimationFrame(nextFrame);
		#elseif (vision_native && (cpp || hl))
		while (running) {
			if (!renderer.poll()) {
				dispose();
				return;
			}
			final started = Timer.stamp();
			runFrame(drawFrame);
			final remaining = 1 / 60 - (Timer.stamp() - started);
			if (running && remaining > 0) Sys.sleep(remaining);
		}
		stop();
		#end
	}

	/** Stops the render loop while keeping the screen open. **/
	public function stop():Void {
		running = false;
		#if js
		if (animationFrame != null) {
			Browser.window.cancelAnimationFrame(animationFrame);
			animationFrame = null;
		}
		#end
	}

	/** Removes the screen or closes its window, and releases its drawing resources. **/
	public function dispose():Void {
		if (disposed) return;
		stop();
		#if js
		renderer.dispose();
		renderer.canvas.remove();
		#elseif (vision_native && (cpp || hl))
		renderer.dispose();
		#end
		disposed = true;
	}

	function runFrame(drawFrame:Void->Void):Void {
		drawingFrame = true;
		try {
			drawFrame();
		} catch (error:Dynamic) {
			drawingFrame = false;
			stop();
			throw error;
		}
		drawingFrame = false;
		presentIfReady();
	}

	inline function presentIfReady():Void {
		#if (vision_native && (cpp || hl) && !js)
		if (!drawingFrame && !disposed && !renderer.present()) stop();
		#end
	}

	inline function checkOpen():Void {
		if (disposed) throw new VisionException("The screen has been disposed", "Screen");
	}
}

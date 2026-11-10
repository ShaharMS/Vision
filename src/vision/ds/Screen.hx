package vision.ds;

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

	var drewImage = false;
	var disposed = false;

	#if js
	final renderer:CanvasRenderer;
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

	/** Removes the screen or closes its window, and releases its drawing resources. **/
	public function dispose():Void {
		if (disposed) return;
		#if js
		renderer.dispose();
		renderer.canvas.remove();
		#elseif (vision_native && (cpp || hl))
		renderer.dispose();
		#end
		disposed = true;
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

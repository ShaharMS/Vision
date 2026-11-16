package vision.native.browser;

#if js
import js.html.CanvasElement;
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.CanvasRenderingError;

/** Draws Vision images in caller order using a dedicated browser canvas. **/
@:noCompletion
class CanvasRenderer {
	public final canvas:CanvasElement;
	public var usesWebGl(get, never):Bool;

	final renderer:CanvasScreenRenderer;
	var disposed = false;

	/** Prefer WebGL 2 where available. Pass false to request Canvas 2D directly. **/
	public function new(canvas:CanvasElement, preferWebGl:Bool = true, preserve:Bool = false) {
		this.canvas = canvas;
		final gl = preferWebGl ? canvas.getContextWebGL2({preserveDrawingBuffer: preserve}) : null;
		renderer = gl == null ? new Canvas2DScreen(canvas) : new WebGLScreen(canvas, gl);
	}

	inline function get_usesWebGl():Bool return renderer is WebGLScreen;

	public function attach(image:Image):Bool {
		checkOpen();
		return renderer.attach(image);
	}

	public function detach(image:Image):Void renderer.detach(image);

	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		checkOpen();
		renderer.draw(image, x, y);
	}

	public function drawInverted(image:Image, x:Int = 0, y:Int = 0):Void {
		checkOpen();
		renderer.drawInverted(image, x, y);
	}

	public function clear(color:Color = 0x00000000):Void {
		checkOpen();
		renderer.clear(color);
	}

	public function dispose():Void {
		if (disposed) return;
		renderer.dispose();
		disposed = true;
	}

	inline function checkOpen():Void {
		if (disposed) throw new CanvasRenderingError("The canvas renderer has been disposed");
	}
}

/** Canvas drawing shared by the browser Screen and callers that own their canvas. **/
@:noCompletion
interface CanvasScreenRenderer {
	function draw(image:Image, x:Int, y:Int):Void;
	function drawInverted(image:Image, x:Int, y:Int):Void;
	function clear(color:Color):Void;
	function attach(image:Image):Bool;
	function detach(image:Image):Void;
	function dispose():Void;
}
#end

package vision.ds;

import haxe.Timer;
import vision.ds.specifics.ScreenOptions;
import vision.exceptions.ScreenError;
import vision.native.ScreenBackend;

/**
	A persistent surface for drawing images.

	A screen presents its contents in a browser canvas or desktop window when
	that backend is available. Other targets use an in-memory surface. Use
	`capture()` to read the drawn pixels on any target.

	On Wayland the compositor chooses window placement. The `x` and `y`
	properties report the coordinates requested by the caller.
**/
class Screen {
	/** Horizontal position of the presentation surface, in pixels. **/
	public var x(get, set):Int;

	/** Vertical position of the presentation surface, in pixels. **/
	public var y(get, set):Int;

	/** Width of the drawing area in pixels. Resizing keeps pixels in the overlapping area. **/
	public var width(get, set):Int;

	/** Height of the drawing area in pixels. Resizing keeps pixels in the overlapping area. **/
	public var height(get, set):Int;

	/** Whether this screen has a browser or desktop presentation surface. **/
	public var hasDisplay(get, never):Bool;

	/** Runs once, immediately before the first draw with a nonempty image. **/
	public var onFirstDraw:Null<Void->Void>;

	/** Invoked once after closing the screen and releasing its resources. **/
	public var onClose:Null<Void->Void>;

	/** Invoked after the logical drawing dimensions change. **/
	public var onResize:Null<(Int, Int)->Void>;

	/** Target frames per second used by `poll()`. Must be positive. **/
	public var frameRate(default, set):Int = 60;

	/** Seconds between completed frame waits. The first completed wait reports zero. **/
	public var deltaTime(default, null):Float = 0;

	var screenX:Int;
	var screenY:Int;
	var screenWidth:Int;
	var screenHeight:Int;
	final backend:ScreenBackend;
	var drewImage = false;
	var disposed = false;
	var lastPoll:Null<Float>;

	/** Opens a new screen with a black background. **/
	public static function open(x:Int, y:Int, width:Int, height:Int, ?options:ScreenOptions):Screen {
		return new Screen(x, y, width, height, options);
	}

	/**
		Opens a screen with a black background.

		@param x Horizontal position in browser page or desktop coordinates
		@param y Vertical position in browser page or desktop coordinates
		@param width Drawing area width in pixels
		@param height Drawing area height in pixels
		@param options Optional frame rate and presentation settings
		@throws ScreenError If the dimensions or frame rate are invalid
	**/
	public function new(x:Int, y:Int, width:Int, height:Int, ?options:ScreenOptions) {
		ScreenBackend.validateSize(width, height);
		final resolved:ScreenOptions = options == null ? {} : options;
		frameRate = resolved.frameRate;
		backend = new ScreenBackend(x, y, width, height, resolved);
		screenX = x;
		screenY = y;
		screenWidth = width;
		screenHeight = height;
	}

	/**
		Moves and resizes the screen in one operation. Pixels in the overlapping area
		keep their coordinates. Newly exposed pixels start black.

		@param x New horizontal position
		@param y New vertical position
		@param width New drawing area width
		@param height New drawing area height
		@throws ScreenError If the screen is closed or the dimensions are invalid
	**/
	public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		checkOpen();
		ScreenBackend.validateSize(width, height);
		if (x == this.x && y == this.y && width == this.width && height == this.height) return;
		final resized = width != screenWidth || height != screenHeight;
		backend.setBounds(x, y, width, height);
		screenX = x;
		screenY = y;
		screenWidth = width;
		screenHeight = height;
		if (resized && onResize != null) onResize(width, height);
	}

	/** Restores and shows the window or browser canvas. Returns false for in-memory screens. **/
	public function show():Bool return setWindowMode(Show);

	/** Minimizes the window or hides the browser canvas. Returns false for in-memory screens. **/
	public function minimize():Bool return setWindowMode(Minimize);

	/** Shows and maximizes the window or fits the canvas to the browser viewport. **/
	public function maximize():Bool return setWindowMode(Maximize);

	/**
		Enters desktop fullscreen. Returns false for browser canvases and in-memory screens.
	**/
	public function fullscreen():Bool return setWindowMode(Fullscreen);

	function setWindowMode(mode:vision.native.ScreenBackend.ScreenWindowMode):Bool {
		checkOpen();
		return backend.setWindowMode(mode);
	}

	/**
		Fills the entire screen with an opaque color.

		@param color The background color
	**/
	public function clear(color:Color = Color.BLACK):Void {
		checkOpen();
		backend.clear(color | 0xff000000);
	}

	/**
		Composites the image's current pixels onto the screen using its alpha
		channel. Call draw again to show later edits.

		@param image The image to draw
		@param x Horizontal offset from the top-left of the drawing area
		@param y Vertical offset from the top-left of the drawing area
	**/
	public function draw(image:Image, x:Int = 0, y:Int = 0):Void {
		if (beginDraw(image)) backend.draw(image, x, y);
	}

	/**
		Draws a color-inverted preview and leaves the source image intact.

		@param image The image to preview
		@param x Horizontal offset from the top-left of the drawing area
		@param y Vertical offset from the top-left of the drawing area
	**/
	public function drawInverted(image:Image, x:Int = 0, y:Int = 0):Void {
		if (beginDraw(image)) backend.drawInverted(image, x, y);
	}

	/**
		Copies the pixels currently drawn to the screen.

		@return An independent image in screen coordinates
		@throws ScreenError If the screen has been disposed
	**/
	public function capture():Image {
		checkOpen();
		return backend.capture();
	}

	/**
		Processes pending presentation events.

		@return False if the screen has closed
	**/
	public function processEvents():Bool {
		if (disposed) return false;
		if (backend.processEvents()) return true;
		dispose();
		return false;
	}

	/**
		Processes window events and blocks until the next frame on system targets.
		Browser code calls this from its animation loop, since the browser owns frame pacing.

		@return True when the screen is open and ready to draw
	**/
	public function poll():Bool {
		if (!processEvents()) return false;
		#if (sys && !js)
		var delay = remainingTime();
		while (delay > 0) {
			Sys.sleep(delay);
			if (!processEvents()) return false;
			delay = remainingTime();
		}
		#end
		final now = Timer.stamp();
		deltaTime = lastPoll == null ? 0 : Math.max(0, now - lastPoll);
		lastPoll = now;
		return true;
	}

	/** Closes the presentation surface and releases its drawing resources. **/
	public function close():Void {
		if (disposed) return;
		disposed = true;
		backend.dispose();
		if (onClose != null) onClose();
	}

	/** Closes the screen. Equivalent to close(). **/
	public function dispose():Void close();

	inline function get_hasDisplay():Bool return !disposed && backend.hasWindow();
	inline function get_x():Int return screenX;
	inline function set_x(value:Int):Int { setBounds(value, y, width, height); return x; }
	inline function get_y():Int return screenY;
	inline function set_y(value:Int):Int { setBounds(x, value, width, height); return y; }
	inline function get_width():Int return screenWidth;
	inline function set_width(value:Int):Int { setBounds(x, y, value, height); return width; }
	inline function get_height():Int return screenHeight;
	inline function set_height(value:Int):Int { setBounds(x, y, width, value); return height; }

	inline function set_frameRate(value:Int):Int {
		if (value <= 0) throw new ScreenError("Screen frame rate must be positive");
		return frameRate = value;
	}

	inline function remainingTime():Float {
		return lastPoll == null ? 0 : lastPoll + 1 / frameRate - Timer.stamp();
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


	inline function checkOpen():Void {
		if (disposed) throw new ScreenError("The screen has been disposed");
	}
}

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
	var pendingPoll:Null<ScreenPoll>;

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
		backend.setBounds(x, y, width, height);
		screenX = x;
		screenY = y;
		screenWidth = width;
		screenHeight = height;
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
		Draws an image onto the current contents using its alpha channel.

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
		Requests device storage for an image on this screen.

		@param image The image to attach
		@return True if the backend can store the image on the device
	**/
	public function attach(image:Image):Bool {
		checkOpen();
		return backend.attach(image);
	}

	/**
		Releases this screen's device storage for an image and preserves its pixels.

		@param image The image to detach
	**/
	public function detach(image:Image):Void {
		if (!disposed) backend.detach(image);
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
		Waits until the next frame may start, measured from the last completed wait.

		Callers manage their own drawing loop. Several calls while a wait is
		pending share the same result. Use `ScreenPoll.then()` on any target.

		@return A frame result that completes with false if the screen closes
	**/
	public function poll():ScreenPoll {
		if (pendingPoll != null) return pendingPoll;
		final poll = new ScreenPoll();
		if (disposed) {
			poll.complete(false);
			return poll;
		}
		pendingPoll = poll;
		backend.waitForFrame(remainingTime, () -> {
			final now = Timer.stamp();
			deltaTime = lastPoll == null ? 0 : Math.max(0, now - lastPoll);
			lastPoll = now;
			pendingPoll = null;
			poll.complete(true);
		});
		return poll;
	}

	/** Closes the presentation surface and releases its drawing resources. **/
	public function dispose():Void {
		if (disposed) return;
		disposed = true;
		final poll = pendingPoll;
		pendingPoll = null;
		backend.dispose();
		if (poll != null) poll.complete(false);
	}

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

package vision.native.cpu;

import haxe.Timer;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Image;
import vision.native.ScreenBackend.ScreenDriver;

/** A persistent drawing surface that needs no system window or graphics context. **/
@:noCompletion
class CpuScreenBackend implements ScreenDriver {
	var frame:Image;
	var timer:Null<Timer>;

	public function new(width:Int, height:Int) {
		frame = new Image(width, height, Color.BLACK);
	}

	public function setBounds(x:Int, y:Int, width:Int, height:Int):Void {
		frame = resizedFrame(width, height);
	}

	function resizedFrame(width:Int, height:Int):Image {
		if (width == frame.width && height == frame.height) return frame;
		final result = new Image(width, height, Color.BLACK);
		final columns = Std.int(Math.min(width, frame.width));
		final rows = Std.int(Math.min(height, frame.height));
		for (y in 0...rows)
			for (x in 0...columns) result.setPixel(x, y, frame.getPixel(x, y));
		return result;
	}

	public function clear(color:Color):Void {
		frame.fillRect(0, 0, frame.width, frame.height, color);
	}

	public function draw(image:Image, x:Int, y:Int):Void {
		final left = Std.int(Math.max(0, -x));
		final top = Std.int(Math.max(0, -y));
		final right = Std.int(Math.min(image.width, frame.width - x));
		final bottom = Std.int(Math.min(image.height, frame.height - y));
		for (row in top...bottom)
			for (column in left...right)
				frame.paintPixel(x + column, y + row, image.getPixel(column, row));
	}

	public function drawInverted(image:Image, x:Int, y:Int):Void {
		draw(Vision.invert(image.clone()), x, y);
	}

	public function capture():Image return frame.clone();
	public function attach(image:Image):Bool return false;
	public function detach(image:Image):Void {}
	public function processEvents():Bool return true;
	public function hasWindow():Bool return false;

	public function waitForFrame(remaining:()->Float, complete:()->Void):Void {
		#if (sys && !js)
		var delay = remaining();
		while (delay > 0) {
			Sys.sleep(delay);
			delay = remaining();
		}
		complete();
		#else
		final delay = remaining();
		if (delay <= 0) {
			complete();
		} else {
			timer = Timer.delay(() -> {
				timer = null;
				waitForFrame(remaining, complete);
			}, Math.ceil(delay * 1000));
		}
		#end
	}

	public function dispose():Void {
		if (timer != null) timer.stop();
		timer = null;
		frame = null;
	}
}

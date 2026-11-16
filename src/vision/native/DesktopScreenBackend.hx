package vision.native;

#if (cpp && !cppia && (windows || mac || vision_vulkan))
import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.ScreenError;
import vision.native.portable.CpuScreenBackend;

/** Shares device compositing and the portable fallback across desktop windows. **/
@:noCompletion
class DesktopScreenBackend extends CpuScreenBackend {
	override public function clear(color:Color):Void {
		frame.accelerate().clear(color).commit(InPlace);
		presentFrame();
	}

	override public function draw(image:Image, x:Int, y:Int):Void {
		if (!DesktopImageStorage.composite(frame, image, x, y, false)) super.draw(image, x, y);
		presentFrame();
	}

	override public function drawInverted(image:Image, x:Int, y:Int):Void {
		if (!image.hasView() && DesktopImageStorage.composite(frame, image, x, y, true)) presentFrame();
		else super.drawInverted(image, x, y);
	}

	function presentFrame():Void {
		if (!present()) throw new ScreenError("Could not present the desktop frame");
	}

	public function present():Bool return false;

	override public function dispose():Void {
		if (frame != null) frame.backend().releaseDeviceStorage();
		super.dispose();
	}
}
#end

package vision.native.browser;

#if js
import vision.ds.Image;
import vision.ds.accelerate.ImageCommitMode;
import vision.native.ImageBackend.ImageOperation;
import vision.native.portable.CpuAccelerationBackend;

/**
	Commits synchronously. Batches consisting entirely of invert, simple grayscale,
	and threshold operations on a whole image use WebGL 2 when available.
	Any other operation, active image view, or unavailable device storage sends
	the entire batch through the CPU executor. CPU reads synchronize device edits.
**/
class WebGLAccelerationBackend extends CpuAccelerationBackend {
	/** Queues inversion. WebGL supports it in whole-image transform batches. **/
	override public function invert():WebGLAccelerationBackend {
		super.invert();
		return this;
	}

	/** Simple grayscale can run on WebGL. Weighted grayscale uses the CPU. **/
	override public function grayscale(simple:Bool = false):WebGLAccelerationBackend {
		super.grayscale(simple);
		return this;
	}

	/** Queues thresholding. WebGL supports it in whole-image transform batches. **/
	override public function threshold(level:Int):WebGLAccelerationBackend {
		super.threshold(level);
		return this;
	}

	override function execute(mode:ImageCommitMode):Image {
		if (source.hasView() || commands.length == 0) return super.execute(mode);
		for (command in commands) switch command {
			case Transform(operation, _) if (operation != Grayscale):
			default: return super.execute(mode);
		}
		final result = mode == InPlace ? source : source.clone();
		if (!WebGLImageBackend.prepare(result)) return super.execute(mode);
		for (command in commands) switch command {
			case Transform(operation, value): ImageBackend.apply(result, operation, value);
			default:
		}
		return result;
	}
}
#end

package vision.native.windows;

#if (windows && ((cpp && !cppia) || (hl && vision_hashlink_screen)))
import vision.ds.Image;
import vision.ds.accelerate.ImageCommitMode;
import vision.native.desktop.DesktopImageStorage;
import vision.native.portable.CpuAccelerationBackend;

/**
	Runs whole-image clear, in-bounds rectangle fills, channel transforms, nearest
	and bilinear resize, and convolution with up to 81 weights on D3D11.
	Pixel writes, lines, shape outlines, ellipses, crop, blit, other resize modes,
	larger filters, image views and exposed bytes use the CPU for the entire batch.
	An unavailable device also uses the CPU. Shader floating-point rounding may
	differ at quantization boundaries. A successful commit keeps pixels on the GPU.
**/
class D3D11AccelerationBackend extends CpuAccelerationBackend {
	override function execute(mode:ImageCommitMode):Image {
		final result = DesktopImageStorage.execute(source, commands, mode);
		return result == null ? super.execute(mode) : result;
	}
}
#end

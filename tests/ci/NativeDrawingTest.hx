import vision.Vision;
import vision.ds.Image;
import vision.ds.NativeImageRenderer;
import vision.formats.__internal.NativeImageIO;

class NativeDrawingTest {
	static function main() {
		final requireGpu = Sys.args().contains("--gpu");
		final renderer = new NativeImageRenderer(64, 48, requireGpu, false);
		try {
			if (!renderer.poll() || renderer.usesWebGpu != requireGpu) throw "The requested native renderer did not initialize";

			final image = new Image(7, 5, 0xFF2A456F);
			image.setPixel(1, 2, 0x80122639);
			final packed = image.underlying;
			final offset = packed.length - image.width * image.height * 4;
			final nativeCopy = image.clone().underlying;
			if (!NativeImageIO.transform(nativeCopy.getData(), nativeCopy.length, offset, 1, 0)) throw "Native transform did not accept the packed buffer";
			Vision.invert(image);
			if (packed.compare(nativeCopy) != 0 || image.getPixel(1, 2) != 0xFFEDD9C6) throw "Native inversion did not update the original image";
			Vision.grayscale(image, true);
			if (image.getPixel(1, 2) != 0xFFD9D9D9) throw "Native grayscale produced a different pixel";
			Vision.blackAndWhite(image, 217);
			if (image.getPixel(1, 2) != 0xFF000000) throw "Native threshold changed equality behavior";

			renderer.clear(0xFF102030);
			renderer.draw(image, -2, 3);
			image.setPixel(1, 2, 0x8032AB10);
			renderer.draw(image, 14, 7);
			if (!renderer.present() || renderer.usesWebGpu != requireGpu) throw "Native image presentation failed";
			renderer.dispose();
			Sys.println(requireGpu ? "WebGPU image presentation passed" : "GDI image presentation passed");
		} catch (error:Dynamic) {
			renderer.dispose();
			throw error;
		}
	}
}

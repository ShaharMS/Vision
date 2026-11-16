package vision.native.portable;

import vision.Vision;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.exceptions.VisionError;

/** Executes ordered batch commands using packed CPU pixels. **/
@:noCompletion
class CpuBatchExecutor {
	public static function execute(source:Image, commands:Array<ImageCommand>, mode:ImageCommitMode):Image {
		var result = source.clone();
		for (command in commands) switch command {
			case Clear(color):
				result.forEachPixelInView((x, y, _) -> result.setUnsafePixel(x, y, color));
			case SetPixel(x, y, color):
				result.setPixel(x, y, color);
			case DrawLine(line, color):
				result.drawLine2D(line, color);
			case DrawRectangle(bounds, color):
				result.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, color);
			case Ellipse(x, y, radiusX, radiusY, color, fill):
				if (fill) result.fillEllipse(x, y, radiusX, radiusY, color);
				else result.drawEllipse(x, y, radiusX, radiusY, color);
			case Crop(bounds):
				result = result.getImagePortion(bounds);
			case Blit(image, x, y):
				result.stamp(x, y, image);
			case FillRectangle(bounds, color):
				result.fillRect(bounds.x, bounds.y, bounds.width, bounds.height, color);
			case Resize(width, height, algorithm):
				result = result.resize(width, height, algorithm);
			case Convolve(kernel):
				result = Vision.convolve(result, kernel);
			case ConvolveAxis(weights, vertical):
				final rows = vertical ? [for (weight in weights) [weight]] : [weights];
				result = Vision.convolve(result, Matrix2D.fromRows(rows));
			case Transform(operation, value):
				CpuImage.apply(result, operation, value);
		}
		if (mode == NewImage) return result;
		if (result.width != source.width || result.height != source.height)
			throw new VisionError("An in-place batch must retain its original dimensions.", "Image batch");
		source.backend().writePixels().blit(0, result.backend().readPixels(), 0, result.backend().length);
		return source;
	}
}

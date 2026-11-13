package vision.native.cpu;

import vision.algorithms.Convolution;
import vision.ds.Image;
import vision.ds.Matrix2D;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.exceptions.VisionError;

/** Executes ordered batch commands using packed CPU pixels. **/
@:noCompletion
class CpuBatchExecutor {
	public static function execute(source:Image, commands:Array<ImageCommand>, mode:ImageCommitMode):Image {
		if (mode == NewImage && commands.length == 1) switch commands[0] {
			case Convolve(kernel): return Convolution.apply(source, kernel);
			case Resize(width, height, algorithm):
				var input = source;
				return input.resizePixels(width, height, algorithm);
			default:
		}
		if (mode == InPlace && commands.length == 1) switch commands[0] {
			case FillRectangle(bounds, color) if (bounds.width <= 0 || bounds.height <= 0
				|| (bounds.x >= 0 && bounds.y >= 0 && bounds.width <= source.width - bounds.x
					&& bounds.height <= source.height - bounds.y)):
				source.fillRectPixels(bounds.x, bounds.y, bounds.width, bounds.height, color);
				return source;
			case PolygonShape(polygon, color, fill):
				if (fill) vision.algorithms.PolygonDrawing.fill(source, polygon, color);
				else vision.algorithms.PolygonDrawing.draw(source, polygon, color);
				return source;
			case MultiPolygonShape(polygons, color, fill):
				for (polygon in polygons.polygons)
					if (fill) vision.algorithms.PolygonDrawing.fill(source, polygon, color);
					else vision.algorithms.PolygonDrawing.draw(source, polygon, color);
				return source;
			case Transform(operation, value):
				CpuImage.apply(source, operation, value);
				return source;
			default:
		}
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
			case PolygonShape(polygon, color, fill):
				if (fill) vision.algorithms.PolygonDrawing.fill(result, polygon, color);
				else vision.algorithms.PolygonDrawing.draw(result, polygon, color);
			case MultiPolygonShape(polygons, color, fill):
				for (polygon in polygons.polygons)
					if (fill) vision.algorithms.PolygonDrawing.fill(result, polygon, color);
					else vision.algorithms.PolygonDrawing.draw(result, polygon, color);
			case Crop(bounds):
				result = result.getImagePortion(bounds);
			case Blit(image, x, y):
				result.stamp(x, y, image);
			case FillRectangle(bounds, color):
				result.fillRectPixels(bounds.x, bounds.y, bounds.width, bounds.height, color);
			case Resize(width, height, algorithm):
				result = result.resizePixels(width, height, algorithm);
			case Convolve(kernel):
				result = Convolution.apply(result, kernel);
			case ConvolveAxis(weights, vertical):
				final rows = vertical ? [for (weight in weights) [weight]] : [weights];
				result = Convolution.apply(result, Matrix2D.fromRows(rows), true);
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

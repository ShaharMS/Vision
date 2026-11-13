package vision.native.browser;

import vision.algorithms.Convolution;
import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.IntPoint2D;
import vision.ds.Circle2D;
import vision.ds.Polygon;
import vision.ds.MultiPolygon;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;
import vision.ds.Matrix2D;
import vision.ds.Rectangle;
import vision.ds.accelerate.ImageBatch;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.exceptions.VisionError;
import vision.native.cpu.CpuBatchExecutor;

#if (js && !nodejs)
/**
	An ordered, single-use image batch.
	On a WebGL-attached image, a supported batch executes against textures in
	the renderer's context. Nearest and bilinear resize use texel fetches.
	Convolution uses up to 81 taps, clamped borders, and RGBA8 render targets.
	Consecutive rectangle fills use scissored clears on the current target.
	The committed result can be drawn by the same renderer without readback.

	Unattached images, active views, weighted grayscale, other sampling modes,
	and unsupported command sequences use the packed-pixel executor. A CPU
	fallback may synchronize the source texture. Export and pixel reads also
	synchronize GPU results. Floating-point filtering can differ from the
	CPU reference by a channel value near a quantization boundary.
	Mutable parameters are copied when recorded. The source is read at commit.
**/
class BrowserImageBatch implements ImageBatch<BrowserImageBatch> {
	final source:Image;
	final commands:Array<ImageCommand> = [];
	var closed = false;

	/** Opens a batch without changing the image. **/
	public function new(source:Image) {
		this.source = source;
	}

	/** Replaces every pixel inside the active view. This command uses the packed-pixel executor. **/
	public function clear(color:Color):BrowserImageBatch {
		return record(Clear(color));
	}

	/** Queues a checked replacement pixel write. This command uses the packed-pixel executor. **/
	public function setPixel(x:Int, y:Int, color:Color):BrowserImageBatch {
		return record(SetPixel(x, y, color));
	}

	/** Queues a line in image coordinates. This command uses the packed-pixel executor. **/
	public function drawLine(line:Line2D, color:Color):BrowserImageBatch {
		return record(DrawLine(new Line2D(line.start.copy(), line.end.copy()), color));
	}

	/** Queues the outline of an image-space rectangle. This command uses the packed-pixel executor. **/
	public function drawRect(bounds:Rectangle, color:Color):BrowserImageBatch {
		return record(DrawRectangle(copyBounds(bounds), color));
	}

	/** Queues an outlined circle. This command uses the packed-pixel executor. **/
	public function drawCircle(circle:Circle2D, color:Color):BrowserImageBatch {
		return record(Ellipse(Math.round(circle.center.x), Math.round(circle.center.y), Math.round(circle.radius), Math.round(circle.radius), color, false));
	}

	/** Queues a filled circle. This command uses the packed-pixel executor. **/
	public function fillCircle(circle:Circle2D, color:Color):BrowserImageBatch {
		return record(Ellipse(Math.round(circle.center.x), Math.round(circle.center.y), Math.round(circle.radius), Math.round(circle.radius), color, true));
	}

	/** Queues an outlined ellipse. This command uses the packed-pixel executor. **/
	public function drawEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):BrowserImageBatch {
		return record(Ellipse(Math.round(center.x), Math.round(center.y), Math.round(radiusX), Math.round(radiusY), color, false));
	}

	/** Queues a filled ellipse. This command uses the packed-pixel executor. **/
	public function fillEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):BrowserImageBatch {
		return record(Ellipse(Math.round(center.x), Math.round(center.y), Math.round(radiusX), Math.round(radiusY), color, true));
	}

	/** Queues the exterior and hole outlines. This command uses the packed-pixel executor. **/
	public function drawPolygon(polygon:Polygon, color:Color):BrowserImageBatch {
		return record(PolygonShape(polygon.copy(), color, false));
	}

	/** Queues an even-odd fill with pixel-center sampling. This command uses the packed-pixel executor. **/
	public function fillPolygon(polygon:Polygon, color:Color):BrowserImageBatch {
		return record(PolygonShape(polygon.copy(), color, true));
	}

	/** Queues the outlines of each member and its holes. This command uses the packed-pixel executor. **/
	public function drawMultiPolygon(polygons:MultiPolygon, color:Color):BrowserImageBatch {
		return record(MultiPolygonShape(polygons.copy(), color, false));
	}

	/** Queues a fill of the union of all members. This command uses the packed-pixel executor. **/
	public function fillMultiPolygon(polygons:MultiPolygon, color:Color):BrowserImageBatch {
		return record(MultiPolygonShape(polygons.copy(), color, true));
	}

	/** Queues extraction of an image-space rectangle. This command uses the packed-pixel executor. **/
	public function crop(bounds:Rectangle):BrowserImageBatch {
		return record(Crop(copyBounds(bounds)));
	}

	/** Queues a replacement copy of the source at the given coordinates. This command uses the packed-pixel executor. **/
	public function blit(source:Image, x:Int, y:Int):BrowserImageBatch {
		return record(Blit(source, x, y));
	}

	/** Queues an RGBA replacement fill using image coordinates and the active view. **/
	public function fillRect(bounds:Rectangle, color:Color):BrowserImageBatch {
		return record(FillRectangle({x: bounds.x, y: bounds.y, width: bounds.width, height: bounds.height}, color));
	}

	/** Queues resampling to the supplied dimensions using the selected interpolation. **/
	public function resize(width:Int, height:Int, algorithm:ImageResizeAlgorithm):BrowserImageBatch {
		if (width < 0 || height < 0) throw new VisionError("Resize dimensions must be nonnegative.", "Image batch");
		return record(Resize(width, height, algorithm));
	}

	/** Queues an odd-sized RGB kernel with clamped borders and preserved alpha. **/
	public function convolve(kernel:Matrix2D):BrowserImageBatch {
		Convolution.validate(kernel);
		return record(Convolve(kernel.clone()));
	}

	/** Queues a horizontal pass with clamped borders, truncated RGB, and opaque alpha. **/
	public function convolveHorizontal(weights:Array<Float>):BrowserImageBatch {
		return axis(weights, false);
	}

	/** Queues a vertical pass with clamped borders, truncated RGB, and opaque alpha. **/
	public function convolveVertical(weights:Array<Float>):BrowserImageBatch {
		return axis(weights, true);
	}

	/** Queues RGB inversion with opaque alpha. **/
	public function invert():BrowserImageBatch return record(Transform(Invert, 0));

	/** Queues grayscale conversion. Simple mode averages the RGB channels. **/
	public function grayscale(simple:Bool = false):BrowserImageBatch {
		return record(Transform(simple ? SimpleGrayscale : Grayscale, 0));
	}

	/** Queues a binary threshold against the largest RGB channel. **/
	public function threshold(level:Int):BrowserImageBatch return record(Transform(BlackAndWhite, level));

	/** Executes the batch once. In-place commit preserves the identity of the source. **/
	public function commit(mode:ImageCommitMode = NewImage):Image {
		checkOpen();
		closed = true;
		final result = source.backend().executeBatch(commands, mode);
		if (result != null) return result;
		return CpuBatchExecutor.execute(source, commands, mode);
	}

	/**
		Submits this batch on an initialized WebGPU device and returns its pixels asynchronously.

		Supported operations share one queue submission with intermediate buffers on
		the device. The result is downloaded once before the promise resolves.
		Unsupported commands and image views run the whole batch on packed pixels.
		@param device The WebGPU device to use.
		@param mode Whether to return a new image or replace the source pixels.
		@return A promise for the committed image.
	**/
	public function commitWebGpu(device:WebGpuBatchDevice, mode:ImageCommitMode = NewImage):js.lib.Promise<Image> {
		checkOpen();
		closed = true;
		return device.execute(source, commands, mode);
	}

	function axis(weights:Array<Float>, vertical:Bool):BrowserImageBatch {
		if (weights.length == 0 || weights.length % 2 == 0)
			throw new VisionError("Filter weights must have positive odd length.", "Image batch");
		for (weight in weights)
			if (#if !static weight == null || #end !Math.isFinite(weight))
				throw new VisionError("Filter weights must be finite.", "Image batch");
		return record(ConvolveAxis(weights.copy(), vertical));
	}

	static function copyBounds(bounds:Rectangle):Rectangle {
		return {x: bounds.x, y: bounds.y, width: bounds.width, height: bounds.height};
	}

	function record(command:ImageCommand):BrowserImageBatch {
		checkOpen();
		commands.push(command);
		return this;
	}

	function checkOpen():Void {
		if (closed) throw new VisionError("This image batch is already committed.", "Image batch");
	}
}
#end

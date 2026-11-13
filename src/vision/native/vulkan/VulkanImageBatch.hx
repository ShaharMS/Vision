package vision.native.vulkan;

#if (cpp && !cppia && vision_vulkan)

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

/**
	An ordered, single-use image batch.
	Supported commands submit Vulkan compute work on the hardware compute queue. Each pass waits for completion before the next pass.
	Nearest and bilinear resize, convolution up to 81 taps, rectangle fills,
	and channel transforms keep the result on the device. Unsupported commands,
	active views, and unavailable devices use the packed-pixel executor.
	Reading pixels copies the completed host-visible buffer into the image cache. Shader float rounding
	can differ from CPU filtering at quantization boundaries.
	Mutable parameters are copied when recorded. The source is read at commit.
**/
class VulkanImageBatch implements ImageBatch<VulkanImageBatch> {
	final source:Image;
	final commands:Array<ImageCommand> = [];
	var closed = false;

	/** Opens a batch without changing the image. **/
	public function new(source:Image) {
		this.source = source;
	}

	/**
		Queues replacement with a single ARGB color. A full-image clear runs
		as a compute pass. An active view is applied by the packed-pixel executor.
	**/
	public function clear(color:Color):VulkanImageBatch {
		return record(Clear(color));
	}

	/** Queues a checked replacement pixel write. Uses packed pixels on this backend. **/
	public function setPixel(x:Int, y:Int, color:Color):VulkanImageBatch {
		return record(SetPixel(x, y, color));
	}

	/** Queues a line in image coordinates. Uses packed pixels on this backend. **/
	public function drawLine(line:Line2D, color:Color):VulkanImageBatch {
		return record(DrawLine(new Line2D(line.start.copy(), line.end.copy()), color));
	}

	/** Queues the outline of an image-space rectangle. Uses packed pixels on this backend. **/
	public function drawRect(bounds:Rectangle, color:Color):VulkanImageBatch {
		return record(DrawRectangle(copyBounds(bounds), color));
	}

	/** Queues an outlined circle. Uses packed pixels on this backend. **/
	public function drawCircle(circle:Circle2D, color:Color):VulkanImageBatch {
		return record(Ellipse(Math.round(circle.center.x), Math.round(circle.center.y), Math.round(circle.radius), Math.round(circle.radius), color, false));
	}

	/** Queues a filled circle. Uses packed pixels on this backend. **/
	public function fillCircle(circle:Circle2D, color:Color):VulkanImageBatch {
		return record(Ellipse(Math.round(circle.center.x), Math.round(circle.center.y), Math.round(circle.radius), Math.round(circle.radius), color, true));
	}

	/** Queues an outlined ellipse. Uses packed pixels on this backend. **/
	public function drawEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):VulkanImageBatch {
		return record(Ellipse(Math.round(center.x), Math.round(center.y), Math.round(radiusX), Math.round(radiusY), color, false));
	}

	/** Queues a filled ellipse. Uses packed pixels on this backend. **/
	public function fillEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):VulkanImageBatch {
		return record(Ellipse(Math.round(center.x), Math.round(center.y), Math.round(radiusX), Math.round(radiusY), color, true));
	}

	/** Queues the exterior and hole outlines. Uses packed pixels on this backend. **/
	public function drawPolygon(polygon:Polygon, color:Color):VulkanImageBatch {
		return record(PolygonShape(polygon.copy(), color, false));
	}

	/** Queues an even-odd fill with pixel-center sampling. Uses packed pixels on this backend. **/
	public function fillPolygon(polygon:Polygon, color:Color):VulkanImageBatch {
		return record(PolygonShape(polygon.copy(), color, true));
	}

	/** Queues the outlines of each member and its holes. Uses packed pixels on this backend. **/
	public function drawMultiPolygon(polygons:MultiPolygon, color:Color):VulkanImageBatch {
		return record(MultiPolygonShape(polygons.copy(), color, false));
	}

	/** Queues a fill of the union of all members. Uses packed pixels on this backend. **/
	public function fillMultiPolygon(polygons:MultiPolygon, color:Color):VulkanImageBatch {
		return record(MultiPolygonShape(polygons.copy(), color, true));
	}

	/** Queues extraction of an image-space rectangle. Uses packed pixels on this backend. **/
	public function crop(bounds:Rectangle):VulkanImageBatch {
		return record(Crop(copyBounds(bounds)));
	}

	/** Queues a replacement copy of the source at the given coordinates. Uses packed pixels on this backend. **/
	public function blit(source:Image, x:Int, y:Int):VulkanImageBatch {
		return record(Blit(source, x, y));
	}

	/**
		Queues replacement of a rectangle in image coordinates.

		Vulkan writes to a fresh buffer and preserves pixels outside the rectangle.
		The packed-pixel path handles views and bounds that require checked writes.
		@param bounds Pixel bounds, copied when queued.
		@param color Replacement color, including alpha.
		@return This batch.
	**/
	public function fillRect(bounds:Rectangle, color:Color):VulkanImageBatch {
		return record(FillRectangle({x: bounds.x, y: bounds.y, width: bounds.width, height: bounds.height}, color));
	}

	/**
		Queues resampling to the supplied dimensions.

		Nearest and bilinear sampling use explicit Vulkan buffer reads. Bilinear
		uses Vision's existing coordinate map and truncates interpolated ARGB.
		Higher-order interpolation uses the packed-pixel implementation.
		@param width Output width in pixels.
		@param height Output height in pixels.
		@param algorithm Sampling algorithm.
		@return This batch.
	**/
	public function resize(width:Int, height:Int, algorithm:ImageResizeAlgorithm):VulkanImageBatch {
		if (width < 0 || height < 0) throw new VisionError("Resize dimensions must be nonnegative.", "Image batch");
		return record(Resize(width, height, algorithm));
	}

	/**
		Queues an RGB filter with clamped borders and preserved alpha.

		Vulkan uploads up to 81 weights as a parameter buffer and rounds the RGB
		result into an packed ARGB buffer. Larger kernels use packed pixels.
		@param kernel Finite coefficients with positive odd dimensions.
		@return This batch.
	**/
	public function convolve(kernel:Matrix2D):VulkanImageBatch {
		Convolution.validate(kernel);
		return record(Convolve(kernel.clone()));
	}

	/** Queues a horizontal pass with clamped borders, truncated RGB, and opaque alpha. **/
	public function convolveHorizontal(weights:Array<Float>):VulkanImageBatch {
		return axis(weights, false);
	}

	/** Queues a vertical pass with clamped borders, truncated RGB, and opaque alpha. **/
	public function convolveVertical(weights:Array<Float>):VulkanImageBatch {
		return axis(weights, true);
	}

	/** Queues RGB inversion with opaque alpha. **/
	public function invert():VulkanImageBatch return record(Transform(Invert, 0));

	/** Queues grayscale conversion. Simple mode averages the RGB channels. **/
	public function grayscale(simple:Bool = false):VulkanImageBatch {
		return record(Transform(simple ? SimpleGrayscale : Grayscale, 0));
	}

	/** Queues a binary threshold against the largest RGB channel. **/
	public function threshold(level:Int):VulkanImageBatch return record(Transform(BlackAndWhite, level));

	/**
		Submits the batch once, in command order.

		The GPU result stays resident until pixel access or export. An in-place
		commit preserves source identity and requires the original dimensions.
		@param mode Whether to return a new image or update the source.
		@return The committed image.
	**/
	public function commit(mode:ImageCommitMode = NewImage):Image {
		checkOpen();
		closed = true;

		final result = source.backend().executeBatch(commands, mode);
		return result == null ? CpuBatchExecutor.execute(source, commands, mode) : result;
	}

	function axis(weights:Array<Float>, vertical:Bool):VulkanImageBatch {
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

	function record(command:ImageCommand):VulkanImageBatch {
		checkOpen();
		commands.push(command);
		return this;
	}

	function checkOpen():Void {
		if (closed) throw new VisionError("This image batch is already committed.", "Image batch");
	}
}

#end

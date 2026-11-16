package vision.native.portable;

import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.Circle2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;
import vision.ds.Matrix2D;
import vision.ds.Rectangle;
import vision.ds.accelerate.AccelerationBackend;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.exceptions.VisionError;

/**
	An ordered, single-use image batch.
	Commands execute against packed CPU pixels when committed.
	Mutable parameters are copied when recorded. The source is read at commit.
**/
class CpuAccelerationBackend implements AccelerationBackend<CpuAccelerationBackend> {
	final source:Image;
	final commands:Array<ImageCommand> = [];
	var closed = false;

	/** Opens a batch without changing the image. **/
	public function new(source:Image) {
		this.source = source;
	}

	/** Replaces every pixel inside the active view. Executes with packed pixels when committed. **/
	public function clear(color:Color):CpuAccelerationBackend {
		return record(Clear(color));
	}

	/** Queues a checked replacement pixel write. Executes with packed pixels when committed. **/
	public function setPixel(x:Int, y:Int, color:Color):CpuAccelerationBackend {
		return record(SetPixel(x, y, color));
	}

	/** Queues a line in image coordinates. Executes with packed pixels when committed. **/
	public function drawLine(line:Line2D, color:Color):CpuAccelerationBackend {
		return record(DrawLine(new Line2D(line.start.copy(), line.end.copy()), color));
	}

	/** Queues the outline of an image-space rectangle. Executes with packed pixels when committed. **/
	public function drawRect(bounds:Rectangle, color:Color):CpuAccelerationBackend {
		return record(DrawRectangle(copyBounds(bounds), color));
	}

	/** Queues an outlined circle. Executes with packed pixels when committed. **/
	public function drawCircle(circle:Circle2D, color:Color):CpuAccelerationBackend {
		return record(Ellipse(Math.round(circle.center.x), Math.round(circle.center.y), Math.round(circle.radius), Math.round(circle.radius), color, false));
	}

	/** Queues a filled circle. Executes with packed pixels when committed. **/
	public function fillCircle(circle:Circle2D, color:Color):CpuAccelerationBackend {
		return record(Ellipse(Math.round(circle.center.x), Math.round(circle.center.y), Math.round(circle.radius), Math.round(circle.radius), color, true));
	}

	/** Queues an outlined ellipse. Executes with packed pixels when committed. **/
	public function drawEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):CpuAccelerationBackend {
		return record(Ellipse(Math.round(center.x), Math.round(center.y), Math.round(radiusX), Math.round(radiusY), color, false));
	}

	/** Queues a filled ellipse. Executes with packed pixels when committed. **/
	public function fillEllipse(center:Point2D, radiusX:Float, radiusY:Float, color:Color):CpuAccelerationBackend {
		return record(Ellipse(Math.round(center.x), Math.round(center.y), Math.round(radiusX), Math.round(radiusY), color, true));
	}

	/** Queues extraction of an image-space rectangle. Executes with packed pixels when committed. **/
	public function crop(bounds:Rectangle):CpuAccelerationBackend {
		return record(Crop(copyBounds(bounds)));
	}

	/** Queues a replacement copy of the source at the given coordinates. Executes with packed pixels when committed. **/
	public function blit(source:Image, x:Int, y:Int):CpuAccelerationBackend {
		return record(Blit(source, x, y));
	}

	/** Queues an RGBA replacement fill using image coordinates and the active view. **/
	public function fillRect(bounds:Rectangle, color:Color):CpuAccelerationBackend {
		return record(FillRectangle({x: bounds.x, y: bounds.y, width: bounds.width, height: bounds.height}, color));
	}

	/** Queues resampling to the supplied dimensions using the selected interpolation. **/
	public function resize(width:Int, height:Int, algorithm:ImageResizeAlgorithm):CpuAccelerationBackend {
		if (width < 0 || height < 0) throw new VisionError("Resize dimensions must be nonnegative.", "Image batch");
		return record(Resize(width, height, algorithm));
	}

	/** Queues an odd-sized RGB kernel with clamped borders and preserved alpha. **/
	public function convolve(kernel:Matrix2D):CpuAccelerationBackend {
		return record(Convolve(kernel.clone()));
	}

	/** Queues a horizontal pass with clamped borders, rounded RGB, and preserved alpha. **/
	public function convolveHorizontal(weights:Array<Float>):CpuAccelerationBackend {
		return axis(weights, false);
	}

	/** Queues a vertical pass with clamped borders, rounded RGB, and preserved alpha. **/
	public function convolveVertical(weights:Array<Float>):CpuAccelerationBackend {
		return axis(weights, true);
	}

	/** Queues RGB inversion with opaque alpha. **/
	public function invert():CpuAccelerationBackend return record(Transform(Invert, 0));

	/** Queues grayscale conversion. Simple mode averages the RGB channels. **/
	public function grayscale(simple:Bool = false):CpuAccelerationBackend {
		return record(Transform(simple ? SimpleGrayscale : Grayscale, 0));
	}

	/** Queues a binary threshold against the largest RGB channel. **/
	public function threshold(level:Int):CpuAccelerationBackend return record(Transform(BlackAndWhite, level));

	/** Executes the batch once. In-place commit preserves the identity of the source. **/
	public function commit(mode:ImageCommitMode = NewImage):Image {
		checkOpen();
		closed = true;

		return execute(mode);
	}

	function execute(mode:ImageCommitMode):Image return CpuBatchExecutor.execute(source, commands, mode);

	function axis(weights:Array<Float>, vertical:Bool):CpuAccelerationBackend {
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

	function record(command:ImageCommand):CpuAccelerationBackend {
		checkOpen();
		commands.push(command);
		return this;
	}

	function checkOpen():Void {
		if (closed) throw new VisionError("This image batch is already committed.", "Image batch");
	}
}

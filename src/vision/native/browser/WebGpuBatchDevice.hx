package vision.native.browser;

#if (js && !nodejs)
import haxe.io.Bytes;
import js.lib.Promise;
import js.lib.Uint8Array;
import js.lib.Int32Array;
import js.lib.Float32Array;
import js.Syntax;
import vision.ds.Image;
import vision.ds.accelerate.ImageCommand;
import vision.ds.accelerate.ImageCommitMode;
import vision.ds.accelerate.PixelStorage;
import vision.exceptions.WebGpuError;
import vision.native.cpu.CpuBatchExecutor;

/**
	An explicitly initialized WebGPU compute device for browser image batches.
	Commands share one submission. Readback is asynchronous and returns packed
	pixels after all passes complete. Dispose the device after outstanding batches finish.
**/
class WebGpuBatchDevice {
	static final SHADER = '
		struct Params {
			sourceWidth: i32, sourceHeight: i32, width: i32, height: i32,
			mode: i32, value: u32, kernelWidth: i32, kernelHeight: i32,
			x: i32, y: i32, w: i32, h: i32,
			stepX: f32, stepY: f32, weights: array<f32, 81>,
		}
		@group(0) @binding(0) var<storage, read> source: array<u32>;
		@group(0) @binding(1) var<storage, read_write> output: array<u32>;
		@group(0) @binding(2) var<storage, read> p: Params;

		fn unpack(c: u32) -> vec4f {
			return vec4f(f32((c >> 8u) & 255u), f32((c >> 16u) & 255u),
				f32(c >> 24u), f32(c & 255u));
		}
		fn pack(color: vec4f) -> u32 {
			let c = vec4u(clamp(color, vec4f(0), vec4f(255)));
			return c.a | (c.r << 8u) | (c.g << 16u) | (c.b << 24u);
		}
		fn pixel(q: vec2i) -> vec4f {
			let b = clamp(q, vec2i(0), vec2i(p.sourceWidth - 1, p.sourceHeight - 1));
			return unpack(source[b.y * p.sourceWidth + b.x]);
		}

		@compute @workgroup_size(16, 16)
		fn main(@builtin(global_invocation_id) id: vec3u) {
			let q = vec2i(id.xy);
			if (q.x >= p.width || q.y >= p.height) { return; }
			var c = pixel(q);
			switch p.mode {
				case 0: {
					let sample = vec2f(q) * vec2f(p.stepX, p.stepY);
					let a = vec2i(sample);
					let f = fract(sample);
					let top = mix(pixel(a), pixel(a + vec2i(1, 0)), f.x);
					let bottom = mix(pixel(a + vec2i(0, 1)), pixel(a + vec2i(1, 1)), f.x);
					c = floor(mix(top, bottom, f.y) + vec4f(0.00001));
				}
				case 1: { c = pixel(vec2i(vec2f(q) * vec2f(p.stepX, p.stepY))); }
				case 2, 3: {
					var sum = vec3f(0);
					var tap = 0;
					let rx = p.kernelWidth / 2;
					let ry = p.kernelHeight / 2;
					for (var y = -ry; y <= ry; y++) {
						for (var x = -rx; x <= rx; x++) {
							sum += pixel(q + vec2i(x, y)).rgb * p.weights[tap];
							tap++;
						}
					}
					if (p.mode == 2) { c = vec4f(floor(sum + vec3f(0.5)), c.a); }
					else { c = vec4f(floor(sum + vec3f(0.00001)), 255); }
				}
				case 4: { c = vec4f(vec3f(255) - c.rgb, 255); }
				case 5: { c = vec4f(vec3f(floor((c.r + c.g + c.b) / 3)), 255); }
				case 6: {
					c = vec4f(vec3f(select(0.0, 255.0, max(max(c.r, c.g), c.b) > f32(bitcast<i32>(p.value)))), 255);
				}
				case 7: {
					if (q.x >= p.x && q.y >= p.y && q.x < p.x + p.w && q.y < p.y + p.h) {
						c = unpack(p.value);
					}
				}
				case 8: { c = vec4f(vec3f(floor(dot(c.rgb, vec3f(0.2126, 0.7152, 0.0722)))), 255); }
				default: {}
			}
			output[q.y * p.width + q.x] = pack(c);
		}';

	final device:Dynamic;
	final pipeline:Dynamic;
	var disposed = false;
	var presentation:Dynamic;
	final canvasFormat:String;

	function new(device:Dynamic, pipeline:Dynamic, canvasFormat:String) {
		this.device = device;
		this.pipeline = pipeline;
		this.canvasFormat = canvasFormat;
	}

	/** Requests an adapter and compiles the compute pipeline. Returns null when unavailable. **/
	public static function create():Promise<Null<WebGpuBatchDevice>> {
		final gpu:Dynamic = Syntax.code("typeof navigator === 'undefined' ? null : navigator.gpu");
		if (gpu == null) return Promise.resolve(null);
		final adapterRequest:Promise<Dynamic> = gpu.requestAdapter();
		return adapterRequest.then(adapter -> {
			if (adapter == null) return Promise.resolve(null);
			final request:Promise<Dynamic> = adapter.requestDevice();
			return request.then(device -> {
				final shader = device.createShaderModule({code: SHADER});
				final compile:Promise<Dynamic> = device.createComputePipelineAsync({
					layout: "auto", compute: {module: shader, entryPoint: "main"}
				});
				return compile.then(pipeline -> new WebGpuBatchDevice(device, pipeline, gpu.getPreferredCanvasFormat()), _ -> {
					device.destroy();
					return null;
				});
			});
		}).catchError(_ -> null);
	}

	@:allow(vision.native.browser.BrowserImageBatch)
	function execute(source:Image, commands:Array<ImageCommand>, mode:ImageCommitMode):Promise<Image> {
		try {
			if (disposed) throw new WebGpuError("This WebGPU device is disposed.");
			final passes = plan(source, commands);
			if (passes == null) return Promise.resolve(CpuBatchExecutor.execute(source, commands, mode));
			final result = submit(source, passes);
			return download(result).then(bytes -> {
				final image = mode == InPlace ? source : new Image(result.width, result.height);
				if (image.width != result.width || image.height != result.height)
					throw new WebGpuError("An in-place batch must retain its original dimensions.");
				image.backend().writePixels().blit(PixelStorage.PIXEL_OFFSET, bytes, 0, bytes.length);
				return image;
			}).finally(() -> result.buffer.destroy());
		} catch (error:Dynamic) {
			return Promise.reject(error);
		}
	}

	/** Associates CPU-backed images with this device for subsequent synchronous commits. **/
	public function attach(image:Image):Bool {
		return !disposed && fits(image.width, image.height) && image.backend().attachWebGpu(this);
	}

	@:allow(vision.native.browser.BrowserImage)
	function commit(source:Image, commands:Array<ImageCommand>, mode:ImageCommitMode):Null<Image> {
		if (disposed) throw new WebGpuError("This WebGPU device is disposed.");
		final passes = plan(source, commands);
		if (passes == null) return null;
		final last = passes[passes.length - 1];
		if (mode == InPlace && (last.width != source.width || last.height != source.height))
			throw new WebGpuError("An in-place batch must retain its original dimensions.");
		final result = submit(source, passes);
		final image = mode == InPlace ? source : new Image(result.width, result.height);
		image.backend().adoptWebGpu(this, result);
		return image;
	}

	function plan(source:Image, commands:Array<ImageCommand>):Null<Array<WebGpuPass>> {
		var width = source.width;
		var height = source.height;
		if (commands.length == 0 || source.hasView() || !fits(width, height)) return null;
		final passes = [];
		for (command in commands) {
			final pass = describe(command, width, height);
			if (pass == null || !fits(pass.width, pass.height)) return null;
			passes.push(pass);
			width = pass.width;
			height = pass.height;
		}
		return passes;
	}

	@:allow(vision.native.browser.BrowserImage)
	function download(surface:WebGpuPixels):Promise<Bytes> {
		final size = surface.width * surface.height * 4;
		final staging = device.createBuffer({size: size, usage: 1 | 8});
		try {
			final encoder = device.createCommandEncoder();
			encoder.copyBufferToBuffer(surface.buffer, 0, staging, 0, size);
			device.queue.submit([encoder.finish()]);
			final mapping:Promise<Dynamic> = staging.mapAsync(1);
			return mapping.then(_ -> Bytes.ofData(new Uint8Array(staging.getMappedRange()).slice().buffer))
				.finally(() -> staging.destroy());
		} catch (error:Dynamic) {
			staging.destroy();
			return Promise.reject(error);
		}
	}

	function fits(width:Int, height:Int):Bool {
		final bytes = width * 4.0 * height;
		return width > 0 && height > 0 && width <= 65535 && bytes <= 0x7fffffff - PixelStorage.PIXEL_OFFSET
			&& bytes <= device.limits.maxStorageBufferBindingSize && bytes <= device.limits.maxBufferSize
			&& Math.ceil(width / 16) <= device.limits.maxComputeWorkgroupsPerDimension
			&& Math.ceil(height / 16) <= device.limits.maxComputeWorkgroupsPerDimension;
	}

	function describe(command:ImageCommand, width:Int, height:Int):Null<WebGpuPass> {
		final pass:WebGpuPass = {width: width, height: height, mode: 0};
		switch command {
			case Resize(w, h, algorithm) if (w > 0 && h > 0 && (algorithm == BilinearInterpolation || algorithm == NearestNeighbor)):
				final bilinear = algorithm == BilinearInterpolation;
				pass.width = w;
				pass.height = h;
				pass.mode = bilinear ? 0 : 1;
				pass.stepX = (width - (bilinear ? 1 : 0)) / w;
				pass.stepY = (height - (bilinear ? 1 : 0)) / h;
			case Convolve(kernel) if (kernel.width * kernel.height <= 81):
				pass.mode = 2;
				pass.kernelWidth = kernel.width;
				pass.kernelHeight = kernel.height;
				pass.weights = kernel.underlying.inner;
			case ConvolveAxis(weights, vertical) if (weights.length <= 81):
				pass.mode = 3;
				pass.kernelWidth = vertical ? 1 : weights.length;
				pass.kernelHeight = vertical ? weights.length : 1;
				pass.weights = weights;
			case Transform(operation, value):
				pass.mode = switch operation {
					case Invert: 4;
					case SimpleGrayscale: 5;
					case BlackAndWhite: 6;
					case Grayscale: 8;
				};
				pass.value = value;
			case Clear(color):
				pass.mode = 7;
				pass.value = packedColor(color);
				pass.bounds = {x: 0, y: 0, width: width, height: height};
			case FillRectangle(bounds, color) if (bounds.x >= 0 && bounds.y >= 0 && bounds.width >= 0 && bounds.height >= 0
				&& bounds.width <= width - bounds.x && bounds.height <= height - bounds.y):
				pass.mode = 7;
				pass.value = packedColor(color);
				pass.bounds = bounds;
			default: return null;
		}
		return pass;
	}

	static inline function packedColor(c:vision.ds.Color):Int {
		return c.alpha | (c.red << 8) | (c.green << 16) | (c.blue << 24);
	}

	function submit(source:Image, passes:Array<WebGpuPass>):WebGpuPixels {
		final buffers:Array<Dynamic> = [];
		function allocate(size:Int, usage:Int):Dynamic {
			final buffer = device.createBuffer({size: size, usage: usage});
			buffers.push(buffer);
			return buffer;
		}
		function release():Void {
			for (buffer in buffers) buffer.destroy();
		}
		try {
			var width = source.width;
			var height = source.height;
			final resident = source.backend().webGpuPixels(this);
			var input:Dynamic;
			if (resident != null) input = resident.buffer;
			else {
				input = allocate(width * height * 4, 128 | 8);
				final bytes = source.exportToBytes();
				device.queue.writeBuffer(input, 0, new Uint8Array(bytes.getData()));
			}
			final encoder = device.createCommandEncoder();
			for (operation in passes) {
				final output = allocate(operation.width * operation.height * 4, 128 | 4);
				final params = allocate(95 * 4, 128 | 8);
				final words = new Int32Array(95);
				final floats = new Float32Array(words.buffer);
				words[0] = width;
				words[1] = height;
				words[2] = operation.width;
				words[3] = operation.height;
				words[4] = operation.mode;
				words[5] = operation.value == null ? 0 : operation.value;
				words[6] = operation.kernelWidth == null ? 0 : operation.kernelWidth;
				words[7] = operation.kernelHeight == null ? 0 : operation.kernelHeight;
				if (operation.bounds != null) {
					words[8] = operation.bounds.x;
					words[9] = operation.bounds.y;
					words[10] = operation.bounds.width;
					words[11] = operation.bounds.height;
				}
				floats[12] = operation.stepX == null ? 0 : operation.stepX;
				floats[13] = operation.stepY == null ? 0 : operation.stepY;
				if (operation.weights != null)
					for (i in 0...operation.weights.length) floats[14 + i] = operation.weights[i];
				device.queue.writeBuffer(params, 0, words);
				final bindings = device.createBindGroup({
					layout: pipeline.getBindGroupLayout(0),
					entries: [
						{binding: 0, resource: {buffer: input}},
						{binding: 1, resource: {buffer: output}},
						{binding: 2, resource: {buffer: params}}
					]
				});
				final pass = encoder.beginComputePass();
				pass.setPipeline(pipeline);
				pass.setBindGroup(0, bindings);
				pass.dispatchWorkgroups(Math.ceil(operation.width / 16), Math.ceil(operation.height / 16));
				pass.end();
				input = output;
				width = operation.width;
				height = operation.height;
			}
			device.queue.submit([encoder.finish()]);
			buffers.remove(input);
			release();
			return {buffer: input, width: width, height: height};
		} catch (error:Dynamic) {
			release();
			throw new WebGpuError(Std.string(error));
		}
	}

	@:allow(vision.native.browser.WebGpuScreen)
	function configure(canvas:js.html.CanvasElement):Dynamic {
		final context:Dynamic = Syntax.code("{0}.getContext('webgpu')", canvas);
		if (disposed || context == null) throw new WebGpuError("WebGPU canvas is unavailable.");
		context.configure({device: device, format: canvasFormat, alphaMode: "opaque"});
		return context;
	}

	@:allow(vision.native.browser.WebGpuScreen)
	function draw(context:Dynamic, image:Image, x:Int, y:Int):Void {
		if (disposed) throw new WebGpuError("This WebGPU device is disposed.");
		if (!fits(image.width, image.height)) return;
		if (presentation == null) {
			final shader = device.createShaderModule({code: '
				struct Bounds { x: i32, y: i32, width: i32, height: i32 }
				@group(0) @binding(0) var<storage, read> pixels: array<u32>;
				@group(0) @binding(1) var<uniform> bounds: Bounds;
				@vertex fn vertex(@builtin(vertex_index) i: u32) -> @builtin(position) vec4f {
					return vec4f(f32((i << 1u) & 2u) * 2 - 1, 1 - f32(i & 2u) * 2, 0, 1);
				}
				@fragment fn fragment(@builtin(position) p: vec4f) -> @location(0) vec4f {
					let x = i32(p.x) - bounds.x;
					let y = i32(p.y) - bounds.y;
					if (x < 0 || y < 0 || x >= bounds.width || y >= bounds.height) { return vec4f(0,0,0,1); }
					let c = pixels[y * bounds.width + x];
					return vec4f(f32((c >> 8u) & 255u), f32((c >> 16u) & 255u), f32(c >> 24u), 255) / 255;
				}
			'});
			presentation = device.createRenderPipeline({
				layout: "auto", vertex: {module: shader, entryPoint: "vertex"},
				fragment: {module: shader, entryPoint: "fragment", targets: [{format: canvasFormat}]}
			});
		}
		final resident = image.backend().webGpuPixels(this);
		final size = image.width * image.height * 4;
		final source = resident == null ? device.createBuffer({size: size, usage: 128 | 8}) : resident.buffer;
		final params = device.createBuffer({size: 16, usage: 64 | 8});
		try {
			if (resident == null) device.queue.writeBuffer(source, 0, new Uint8Array(image.exportToBytes().getData()));
			final bounds = new Int32Array([x, y, image.width, image.height]);
			device.queue.writeBuffer(params, 0, bounds);
			final bindings = device.createBindGroup({layout: presentation.getBindGroupLayout(0), entries: [
				{binding: 0, resource: {buffer: source}}, {binding: 1, resource: {buffer: params}}
			]});
			final encoder = device.createCommandEncoder();
			final pass = encoder.beginRenderPass({colorAttachments: [{
				view: context.getCurrentTexture().createView(), clearValue: {r: 0, g: 0, b: 0, a: 1},
				loadOp: "clear", storeOp: "store"
			}]});
			pass.setPipeline(presentation);
			pass.setBindGroup(0, bindings);
			pass.draw(3);
			pass.end();
			device.queue.submit([encoder.finish()]);
		} catch (error:Dynamic) {
			if (resident == null) source.destroy();
			params.destroy();
			throw error;
		}
		if (resident == null) source.destroy();
		params.destroy();
	}

	/** Waits for the device queue to finish previously submitted work. **/
	public function synchronize():Promise<Dynamic> return device.queue.onSubmittedWorkDone();

	/** Collects validation errors during a sequence of submitted commands. **/
	public function beginValidation():Void device.pushErrorScope("validation");

	/** Resolves with the first WebGPU validation error, if any. **/
	public function endValidation():Promise<Dynamic> return device.popErrorScope();

	/** Releases the device. Subsequent commits reject. **/
	public function dispose():Void {
		if (disposed) return;
		disposed = true;
		device.destroy();
	}
}

@:noCompletion
typedef WebGpuPixels = {
	final buffer:Dynamic;
	final width:Int;
	final height:Int;
}

private typedef WebGpuPass = {
	var width:Int;
	var height:Int;
	var mode:Int;
	var ?value:Int;
	var ?stepX:Float;
	var ?stepY:Float;
	var ?kernelWidth:Int;
	var ?kernelHeight:Int;
	var ?weights:Array<Float>;
	var ?bounds:vision.ds.Rectangle;
}
#end

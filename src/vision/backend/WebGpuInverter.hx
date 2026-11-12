package vision.backend;

#if js
import haxe.io.Bytes;
import js.lib.ArrayBuffer;
import js.lib.Promise;
import js.lib.Uint8Array;
import js.Syntax;
import vision.Vision;
import vision.ds.Image;

/** Optional asynchronous browser implementation of inversion for whole images. **/
class WebGpuInverter {
	static final SHADER = '
		@group(0) @binding(0) var<storage, read_write> pixels: array<u32>;
		@compute @workgroup_size(64)
		fn invert(@builtin(global_invocation_id) id: vec3u, @builtin(num_workgroups) groups: vec3u) {
			let index = id.y * groups.x * 64u + id.x;
			if (index < arrayLength(&pixels)) {
				pixels[index] = (pixels[index] ^ 0xffffff00u) | 0xffu;
			}
		}';

	static inline final COPY_SRC = 4;
	static inline final COPY_DST = 8;
	static inline final MAP_READ = 1;
	static inline final STORAGE = 128;

	final device:GpuDevice;
	final pipeline:GpuPipeline;
	var disposed = false;

	function new(device:GpuDevice, pipeline:GpuPipeline) {
		this.device = device;
		this.pipeline = pipeline;
	}

	/** Returns null when a WebGPU device and shader pipeline are unavailable. **/
	public static function create():Promise<Null<WebGpuInverter>> {
		final gpu:Gpu = Syntax.code("typeof navigator === 'undefined' ? null : navigator.gpu");
		if (gpu == null)
			return Promise.resolve(null);
		return gpu.requestAdapter().then(adapter -> {
			if (adapter == null)
				return Promise.resolve(null);
			return adapter.requestDevice().then(device -> {
				final shader = device.createShaderModule({code: SHADER});
				return device.createComputePipelineAsync({
					layout: "auto",
					compute: {module: shader, entryPoint: "invert"}
				}).then(pipeline -> new WebGpuInverter(device, pipeline), _ -> {
					device.destroy();
					return null;
				});
			});
		}).catchError(_ -> null);
	}

	/** Inverts a copy. Views and jobs outside device limits use the portable implementation. **/
	public function invert(image:Image):Promise<Image> {
		final result = image.clone();
		final size = result.underlying.length - @:privateAccess Image.OFFSET;
		if (disposed || size == 0 || result.hasView() || size > device.limits.maxBufferSize ||
			size > device.limits.maxStorageBufferBindingSize)
			return Promise.resolve(Vision.invert(result));

		final groups = Math.ceil(size / (4 * 64));
		final columns = Std.int(Math.min(groups, device.limits.maxComputeWorkgroupsPerDimension));
		final rows = Math.ceil(groups / columns);
		if (rows > device.limits.maxComputeWorkgroupsPerDimension)
			return Promise.resolve(Vision.invert(result));

		final input = result.exportToBytes();
		var storage:GpuBuffer = null;
		var readback:GpuBuffer = null;
		function release():Void {
			if (storage != null) storage.destroy();
			if (readback != null) readback.destroy();
		}
		try {
			storage = device.createBuffer({size: size, usage: STORAGE | COPY_SRC | COPY_DST});
			readback = device.createBuffer({size: size, usage: MAP_READ | COPY_DST});
			final bindings = device.createBindGroup({
				layout: pipeline.getBindGroupLayout(0),
				entries: [{binding: 0, resource: {buffer: storage}}]
			});
			device.queue.writeBuffer(storage, 0, new Uint8Array(input.getData()));
			final commands = device.createCommandEncoder();
			final pass = commands.beginComputePass();
			pass.setPipeline(pipeline);
			pass.setBindGroup(0, bindings);
			pass.dispatchWorkgroups(columns, rows);
			pass.end();
			commands.copyBufferToBuffer(storage, 0, readback, 0, size);
			device.queue.submit([commands.finish()]);
			return readback.mapAsync(MAP_READ).then(_ -> {
				final bytes = Bytes.ofData(new Uint8Array(readback.getMappedRange()).slice().buffer);
				result.underlying.blit(@:privateAccess Image.OFFSET, bytes, 0, size);
				release();
				return result;
			}).catchError(error -> {
				release();
				return Promise.reject(error);
			});
		} catch (error:Dynamic) {
			release();
			return Promise.reject(error);
		}
	}

	/** Releases the WebGPU device created by this inverter. **/
	public function dispose():Void {
		if (!disposed) {
			disposed = true;
			device.destroy();
		}
	}
}

private extern class Gpu {
	function requestAdapter():Promise<Null<GpuAdapter>>;
}

private extern class GpuAdapter {
	function requestDevice():Promise<GpuDevice>;
}

private extern class GpuDevice {
	final queue:GpuQueue;
	final limits:{maxBufferSize:Float, maxStorageBufferBindingSize:Float, maxComputeWorkgroupsPerDimension:Int};
	function createShaderModule(descriptor:{code:String}):Dynamic;
	function createComputePipelineAsync(descriptor:Dynamic):Promise<GpuPipeline>;
	function createBuffer(descriptor:{size:Int, usage:Int}):GpuBuffer;
	function createBindGroup(descriptor:Dynamic):Dynamic;
	function createCommandEncoder():GpuCommands;
	function destroy():Void;
}

private extern class GpuPipeline {
	function getBindGroupLayout(index:Int):Dynamic;
}

private extern class GpuBuffer {
	function mapAsync(mode:Int):Promise<Dynamic>;
	function getMappedRange():ArrayBuffer;
	function destroy():Void;
}

private extern class GpuQueue {
	function writeBuffer(buffer:GpuBuffer, offset:Int, data:Uint8Array):Void;
	function submit(commands:Array<Dynamic>):Void;
}

private extern class GpuCommands {
	function beginComputePass():GpuComputePass;
	function copyBufferToBuffer(source:GpuBuffer, sourceOffset:Int, target:GpuBuffer, targetOffset:Int, size:Int):Void;
	function finish():Dynamic;
}

private extern class GpuComputePass {
	function setPipeline(pipeline:GpuPipeline):Void;
	function setBindGroup(index:Int, bindings:Dynamic):Void;
	function dispatchWorkgroups(x:Int, y:Int):Void;
	function end():Void;
}
#end

package vision.native.browser;

#if (js && !nodejs)
import js.html.webgl.Framebuffer;
import js.html.webgl.GL;
import js.html.webgl.Program;
import js.html.webgl.Shader;
import js.html.webgl.Texture;
import js.html.webgl.UniformLocation;
import js.html.webgl.WebGL2RenderingContext;
import js.lib.Uint8Array;
import js.lib.Float32Array;
import vision.ds.accelerate.ImageCommand;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.accelerate.PixelStorage;
import vision.ds.accelerate.ImageOperation;

import vision.exceptions.WebGlError;

@:noCompletion
class WebGlRenderer {
	static final VERTEX = '#version 300 es
		uniform vec4 rectangle;
		out vec2 uv;
		void main() {
			uv = vec2(float(gl_VertexID & 1), float(gl_VertexID >> 1));
			gl_Position = vec4(rectangle.xy + uv * rectangle.zw, 0.0, 1.0);
		}';
	static final FRAGMENT = '#version 300 es
		precision highp float;
		precision highp int;
		uniform sampler2D pixels;
		uniform int operation;
		uniform int threshold;
		uniform bool present;
		in vec2 uv;
		out vec4 color;
		void main() {
			vec4 rgba = texture(pixels, uv);
			if (operation == ${(ImageOperation.Invert : Int)})
				rgba = vec4(vec3(1.0) - rgba.rgb, 1.0);
			if (operation == ${(ImageOperation.SimpleGrayscale : Int)}) {
				uvec3 rgb = uvec3(round(rgba.rgb * 255.0));
				float gray = float((rgb.r + rgb.g + rgb.b) / 3u) / 255.0;
				rgba = vec4(vec3(gray), 1.0);
			}
			if (operation == ${(ImageOperation.BlackAndWhite : Int)}) {
				ivec3 rgb = ivec3(round(rgba.rgb * 255.0));
				float level = max(max(rgb.r, rgb.g), rgb.b) > threshold ? 1.0 : 0.0;
				rgba = vec4(vec3(level), 1.0);
			}
			color = present ? vec4(rgba.rgb * rgba.a, rgba.a) : rgba;
		}';

	static final FILTER_FRAGMENT = '#version 300 es
		precision highp float;
		precision highp int;
		uniform sampler2D pixels;
		uniform vec2 sampleStep;
		uniform int mode;
		uniform ivec2 kernelSize;
		uniform float weights[81];
		out vec4 color;

		vec4 pixelAt(ivec2 p) {
			return round(texelFetch(pixels, clamp(p, ivec2(0), textureSize(pixels, 0) - 1), 0) * 255.0);
		}

		void main() {
			ivec2 p = ivec2(gl_FragCoord.xy);
			if (mode == 0) {
				vec2 samplePoint = vec2(p) * sampleStep;
				ivec2 topLeft = ivec2(samplePoint);
				vec2 fraction = fract(samplePoint);
				vec4 top = mix(pixelAt(topLeft), pixelAt(topLeft + ivec2(1, 0)), fraction.x);
				vec4 bottom = mix(pixelAt(topLeft + ivec2(0, 1)), pixelAt(topLeft + ivec2(1, 1)), fraction.x);
				color = floor(mix(top, bottom, fraction.y) + 0.00001) / 255.0;
			} else if (mode == 1) {
				color = pixelAt(ivec2(vec2(p) * sampleStep)) / 255.0;
			} else {
				vec3 sum = vec3(0);
				ivec2 radius = kernelSize / 2;
				int index = 0;
				for (int y = -radius.y; y <= radius.y; ++y)
					for (int x = -radius.x; x <= radius.x; ++x)
						sum += pixelAt(p + ivec2(x, y)).rgb * weights[index++];
				color = mode == 2
					? vec4(floor(clamp(sum, 0.0, 255.0) + 0.5), pixelAt(p).a) / 255.0
					: vec4(floor(clamp(sum, 0.0, 255.0) + 0.00001), 255.0) / 255.0;
			}
		}';

	final gl:WebGL2RenderingContext;
	var filterProgram:Program;
	public var onImageAttached:(BrowserImage, WebGlSurface)->Void;
	final program:Program;
	final rectangle:UniformLocation;
	final operation:UniformLocation;
	final threshold:UniformLocation;
	final present:UniformLocation;
	final texture:Texture;
	final maxSize:Int;
	var width = 0;
	var height = 0;

	public function new(gl:WebGL2RenderingContext) {
		this.gl = gl;
		program = link(FRAGMENT);
		rectangle = gl.getUniformLocation(program, "rectangle");
		operation = gl.getUniformLocation(program, "operation");
		threshold = gl.getUniformLocation(program, "threshold");
		present = gl.getUniformLocation(program, "present");
		maxSize = gl.getParameter(GL.MAX_TEXTURE_SIZE);
		texture = createTexture();
		gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
	}

	function link(source:String):Program {
		final vertex = compile(GL.VERTEX_SHADER, VERTEX);
		final fragment = try {
			compile(GL.FRAGMENT_SHADER, source);
		} catch (error:Dynamic) {
			gl.deleteShader(vertex);
			if (Std.isOfType(error, WebGlError)) throw cast(error, WebGlError);
			throw new WebGlError(Std.string(error), "WebGL shader");
		};
		final program = gl.createProgram();
		gl.attachShader(program, vertex);
		gl.attachShader(program, fragment);
		gl.linkProgram(program);
		gl.deleteShader(vertex);
		gl.deleteShader(fragment);
		if (!gl.getProgramParameter(program, GL.LINK_STATUS)) {
			final message = gl.getProgramInfoLog(program);
			gl.deleteProgram(program);
			throw new WebGlError(message, "WebGL link");
		}
		return program;
	}

	@:allow(vision.native.browser.WebGlSurface)
	function renderFilter(source:Texture, width:Int, height:Int, mode:Int, stepX:Float, stepY:Float,
			kernelWidth:Int, kernelHeight:Int, weights:Array<Float>):Void {
		if (filterProgram == null) filterProgram = link(FILTER_FRAGMENT);
		gl.viewport(0, 0, width, height);
		gl.disable(GL.BLEND);
		gl.useProgram(filterProgram);
		gl.bindTexture(GL.TEXTURE_2D, source);
		gl.uniform4f(gl.getUniformLocation(filterProgram, "rectangle"), -1, -1, 2, 2);
		gl.uniform2f(gl.getUniformLocation(filterProgram, "sampleStep"), stepX, stepY);
		gl.uniform1i(gl.getUniformLocation(filterProgram, "mode"), mode);
		gl.uniform2i(gl.getUniformLocation(filterProgram, "kernelSize"), kernelWidth, kernelHeight);
		if (weights != null)
			gl.uniform1fv(gl.getUniformLocation(filterProgram, "weights[0]"), new Float32Array(weights));
		gl.drawArrays(GL.TRIANGLE_STRIP, 0, 4);
	}

	function compile(kind:Int, source:String):Shader {
		final shader = gl.createShader(kind);
		gl.shaderSource(shader, source);
		gl.compileShader(shader);
		if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
			final message = gl.getShaderInfoLog(shader);
			gl.deleteShader(shader);
			throw new WebGlError(message, "WebGL shader");
		}
		return shader;
	}

	public function draw(rgba:Uint8Array, width:Int, height:Int, changed:Bool, x:Int, y:Int, canvasWidth:Int, canvasHeight:Int, invert:Bool):Void {
		if (width > maxSize || height > maxSize) throw new WebGlError("Image exceeds the WebGL texture size limit", "WebGL draw");

		gl.bindTexture(GL.TEXTURE_2D, texture);
		if (width != this.width || height != this.height) {
			gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
			this.width = width;
			this.height = height;
		} else if (changed) {
			gl.texSubImage2D(GL.TEXTURE_2D, 0, 0, 0, width, height, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
		}
		presentTexture(texture, width, height, x, y, canvasWidth, canvasHeight, invert);
	}

	public function createSurface(width:Int, height:Int):WebGlSurface {
		if (gl.isContextLost() || width <= 0 || height <= 0 || width > maxSize || height > maxSize) return null;
		return new WebGlSurface(this, gl, width, height);
	}

	@:allow(vision.native.browser.WebGlSurface)
	function createTexture():Texture {
		final result = gl.createTexture();
		gl.bindTexture(GL.TEXTURE_2D, result);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
		return result;
	}

	public function presentTexture(source:Texture, width:Int, height:Int, x:Int, y:Int, canvasWidth:Int, canvasHeight:Int, invert:Bool):Void {
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		gl.viewport(0, 0, canvasWidth, canvasHeight);
		gl.enable(GL.BLEND);
		gl.useProgram(program);
		gl.uniform4f(rectangle, 2.0 * x / canvasWidth - 1, 1 - 2.0 * y / canvasHeight, 2.0 * width / canvasWidth, -2.0 * height / canvasHeight);
		render(source, invert ? (ImageOperation.Invert : Int) : 0, 0, true);
	}

	@:allow(vision.native.browser.WebGlSurface)
	function transformTexture(source:Texture, width:Int, height:Int, operation:ImageOperation, value:Int):Void {
		gl.viewport(0, 0, width, height);
		gl.disable(GL.BLEND);
		gl.useProgram(program);
		gl.uniform4f(rectangle, -1, -1, 2, 2);
		render(source, operation, value, false);
	}

	function render(source:Texture, filter:Int, value:Int, forDisplay:Bool):Void {
		gl.bindTexture(GL.TEXTURE_2D, source);
		gl.uniform1i(operation, filter);
		gl.uniform1i(threshold, value);
		gl.uniform1i(present, forDisplay ? 1 : 0);
		gl.drawArrays(GL.TRIANGLE_STRIP, 0, 4);
	}

	public function clear(color:Color):Void {
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		final alpha = color.alpha / 255;
		gl.clearColor(color.red * alpha / 255, color.green * alpha / 255, color.blue * alpha / 255, alpha);
		gl.clear(GL.COLOR_BUFFER_BIT);
	}

	public function dispose():Void {
		gl.deleteTexture(texture);
		gl.deleteProgram(program);
		if (filterProgram != null) gl.deleteProgram(filterProgram);
	}
}

@:noCompletion
class WebGlSurface {
	public final owner:WebGlRenderer;
	public var texture(default, null):Texture;
	public var onDispose:Void->Void;

	final gl:WebGL2RenderingContext;
	public final width:Int;
	public final height:Int;
	final pixels = new BrowserPixels();
	var output:Texture;
	var framebuffer:Framebuffer;

	public function new(owner:WebGlRenderer, gl:WebGL2RenderingContext, width:Int, height:Int) {
		this.owner = owner;
		this.gl = gl;
		this.width = width;
		this.height = height;
		texture = owner.createTexture();
	}

	public function isAvailable():Bool {
		return texture != null && !gl.isContextLost();
	}

	public function upload(packed:ByteArray):Bool {
		pixels.updatePacked(packed, width, height);
		gl.bindTexture(GL.TEXTURE_2D, texture);
		gl.texImage2D(GL.TEXTURE_2D, 0, WebGL2RenderingContext.RGBA8, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, pixels.rgba);
		return gl.getError() == GL.NO_ERROR;
	}

	function bindTarget(target:Texture):Bool {
		if (framebuffer == null) framebuffer = gl.createFramebuffer();
		if (framebuffer == null) return false;
		gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
		gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, target, 0);
		final complete = gl.checkFramebufferStatus(GL.FRAMEBUFFER) == GL.FRAMEBUFFER_COMPLETE;
		if (!complete) gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		return complete;
	}

	public function transform(operation:ImageOperation, value:Int):Bool {
		if (output == null) {
			output = owner.createTexture();
			if (output == null) return false;
			gl.texImage2D(GL.TEXTURE_2D, 0, WebGL2RenderingContext.RGBA8, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
		}
		if (!bindTarget(output)) return false;
		owner.transformTexture(texture, width, height, operation, value);
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		if (gl.getError() != GL.NO_ERROR) return false;
		final previous = texture;
		texture = output;
		output = previous;
		return true;
	}

	/** Allocates a render target and records one full-image filter pass. **/
	public function filter(width:Int, height:Int, mode:Int, stepX:Float, stepY:Float,
			kernelWidth:Int = 0, kernelHeight:Int = 0, ?weights:Array<Float>):WebGlSurface {
		final result = owner.createSurface(width, height);
		if (result == null) return null;
		var complete = false;
		try {
			gl.texImage2D(GL.TEXTURE_2D, 0, WebGL2RenderingContext.RGBA8, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
			if (result.bindTarget(result.texture)) {
				owner.renderFilter(texture, width, height, mode, stepX, stepY, kernelWidth, kernelHeight, weights);
				complete = gl.getError() == GL.NO_ERROR;
			}
		} catch (_:WebGlError) {}
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		if (complete) return result;
		result.dispose();
		return null;
	}

	/** Fills a rectangle on an isolated batch render target. **/
	public function fillRect(bounds:vision.ds.Rectangle, color:Color):Bool {
		if (!bindTarget(texture)) return false;
		gl.enable(GL.SCISSOR_TEST);
		gl.scissor(bounds.x, bounds.y, bounds.width, bounds.height);
		gl.clearColor(color.red / 255, color.green / 255, color.blue / 255, color.alpha / 255);
		gl.clear(GL.COLOR_BUFFER_BIT);
		gl.disable(GL.SCISSOR_TEST);
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		return gl.getError() == GL.NO_ERROR;
	}

	public function download(packed:ByteArray):Void {
		if (!isAvailable() || !bindTarget(texture)) throw new WebGlError("Image pixels are unavailable from WebGL", "Image readback");
		final rgba = new Uint8Array(width * height * 4);
		gl.readPixels(0, 0, width, height, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		if (gl.getError() != GL.NO_ERROR) throw new WebGlError("Could not read image pixels from WebGL", "Image readback");
		var index = 0;
		while (index < rgba.length) {
			final target = PixelStorage.PIXEL_OFFSET + index;
			packed[target] = rgba[index + 3];
			packed[target + 1] = rgba[index];
			packed[target + 2] = rgba[index + 1];
			packed[target + 3] = rgba[index + 2];
			index += 4;
		}
	}

	public function dispose():Void {
		gl.deleteTexture(texture);
		gl.deleteTexture(output);
		gl.deleteFramebuffer(framebuffer);
		texture = null;
		output = null;
		framebuffer = null;
		if (onDispose != null) {
			onDispose();
			onDispose = null;
		}
	}
}
#end

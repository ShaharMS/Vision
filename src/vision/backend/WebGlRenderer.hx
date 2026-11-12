package vision.backend;

#if js
import js.html.webgl.Framebuffer;
import js.html.webgl.GL;
import js.html.webgl.Program;
import js.html.webgl.Shader;
import js.html.webgl.Texture;
import js.html.webgl.UniformLocation;
import js.html.webgl.WebGL2RenderingContext;
import js.lib.Uint8Array;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.ImageStorage;
import vision.ds.ImageStorage.ImageOperation;
import vision.ds.ImageStorage.ImageSurface;
import vision.exceptions.VisionException;

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

	final gl:WebGL2RenderingContext;
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
		final vertex = compile(GL.VERTEX_SHADER, VERTEX);
		final fragment = try {
			compile(GL.FRAGMENT_SHADER, FRAGMENT);
		} catch (error:Dynamic) {
			gl.deleteShader(vertex);
			throw error;
		};
		program = gl.createProgram();
		gl.attachShader(program, vertex);
		gl.attachShader(program, fragment);
		gl.linkProgram(program);
		gl.deleteShader(vertex);
		gl.deleteShader(fragment);
		if (!gl.getProgramParameter(program, GL.LINK_STATUS)) {
			final message = gl.getProgramInfoLog(program);
			gl.deleteProgram(program);
			throw new VisionException(message, "WebGL link");
		}
		rectangle = gl.getUniformLocation(program, "rectangle");
		operation = gl.getUniformLocation(program, "operation");
		threshold = gl.getUniformLocation(program, "threshold");
		present = gl.getUniformLocation(program, "present");
		maxSize = gl.getParameter(GL.MAX_TEXTURE_SIZE);
		texture = createTexture();
		gl.blendFunc(GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
	}

	function compile(kind:Int, source:String):Shader {
		final shader = gl.createShader(kind);
		gl.shaderSource(shader, source);
		gl.compileShader(shader);
		if (!gl.getShaderParameter(shader, GL.COMPILE_STATUS)) {
			final message = gl.getShaderInfoLog(shader);
			gl.deleteShader(shader);
			throw new VisionException(message, "WebGL shader");
		}
		return shader;
	}

	public function draw(rgba:Uint8Array, width:Int, height:Int, changed:Bool, x:Int, y:Int, canvasWidth:Int, canvasHeight:Int, invert:Bool):Void {
		if (width > maxSize || height > maxSize) throw new VisionException("Image exceeds the WebGL texture size limit", "WebGL draw");

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

	@:allow(vision.backend.WebGlSurface)
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

	@:allow(vision.backend.WebGlSurface)
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
	}
}

@:noCompletion
class WebGlSurface implements ImageSurface {
	public final owner:WebGlRenderer;
	public var texture(default, null):Texture;
	public var onDispose:Void->Void;

	final gl:WebGL2RenderingContext;
	final width:Int;
	final height:Int;
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

	public function download(packed:ByteArray):Void {
		if (!isAvailable() || !bindTarget(texture)) throw new VisionException("Image pixels are unavailable from WebGL", "Image readback");
		final rgba = new Uint8Array(width * height * 4);
		gl.readPixels(0, 0, width, height, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		if (gl.getError() != GL.NO_ERROR) throw new VisionException("Could not read image pixels from WebGL", "Image readback");
		var index = 0;
		while (index < rgba.length) {
			final target = ImageStorage.PIXEL_OFFSET + index;
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

package vision.backend.browser;

#if js
import js.html.webgl.GL;
import js.html.webgl.Program;
import js.html.webgl.Shader;
import js.html.webgl.Texture;
import js.html.webgl.UniformLocation;
import js.html.webgl.WebGL2RenderingContext;
import js.lib.Uint8Array;
import vision.exceptions.VisionException;

@:noCompletion
class WebGlDraw {
	static final VERTEX = '#version 300 es
		uniform vec4 rectangle;
		out vec2 uv;
		void main() {
			uv = vec2(float(gl_VertexID & 1), float(gl_VertexID >> 1));
			gl_Position = vec4(rectangle.xy + uv * rectangle.zw, 0.0, 1.0);
		}';
	static final FRAGMENT = '#version 300 es
		precision highp float;
		uniform sampler2D pixels;
		uniform bool invert;
		in vec2 uv;
		out vec4 color;
		void main() {
			vec4 rgba = texture(pixels, uv);
			if (invert)
				rgba = vec4(vec3(1.0) - rgba.rgb, 1.0);
			color = vec4(rgba.rgb * rgba.a, rgba.a);
		}';

	final gl:WebGL2RenderingContext;
	final program:Program;
	final rectangle:UniformLocation;
	final invertColor:UniformLocation;
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
		invertColor = gl.getUniformLocation(program, "invert");
		maxSize = gl.getParameter(GL.MAX_TEXTURE_SIZE);
		texture = gl.createTexture();
		gl.bindTexture(GL.TEXTURE_2D, texture);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
		gl.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
		gl.enable(GL.BLEND);
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
		if (width > maxSize || height > maxSize)
			throw new VisionException("Image exceeds the WebGL texture size limit", "WebGL draw");
		gl.viewport(0, 0, canvasWidth, canvasHeight);
		gl.useProgram(program);
		gl.bindTexture(GL.TEXTURE_2D, texture);
		if (width != this.width || height != this.height) {
			gl.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
			this.width = width;
			this.height = height;
		} else if (changed) {
			gl.texSubImage2D(GL.TEXTURE_2D, 0, 0, 0, width, height, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
		}
		gl.uniform4f(rectangle, 2.0 * x / canvasWidth - 1, 1 - 2.0 * y / canvasHeight, 2.0 * width / canvasWidth, -2.0 * height / canvasHeight);
		gl.uniform1i(invertColor, invert ? 1 : 0);
		gl.drawArrays(GL.TRIANGLE_STRIP, 0, 4);
	}

	public function clear():Void {
		gl.clearColor(0, 0, 0, 0);
		gl.clear(GL.COLOR_BUFFER_BIT);
	}

	public function dispose():Void {
		gl.deleteTexture(texture);
		gl.deleteProgram(program);
	}
}
#end

package vision.backend;

#if (lime && lime_cffi && (cpp || hl))
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLTexture;
import lime.utils.Float32Array;
import vision.exceptions.VisionException;

@:noCompletion
class NativeTextureRenderer {
	final program:GLProgram;
	final vertices:GLBuffer;
	final texture:GLTexture;
	final position:Int;

	public function new() {
		final vertex = compile(GL.VERTEX_SHADER, "
			attribute vec2 position;
			varying vec2 uv;
			void main() {
				gl_Position = vec4(position, 0.0, 1.0);
				uv = vec2((position.x + 1.0) * 0.5, (1.0 - position.y) * 0.5);
			}");
		final fragment = compile(GL.FRAGMENT_SHADER, "
			#ifdef GL_ES
			precision mediump float;
			#endif
			uniform sampler2D pixels;
			varying vec2 uv;
			void main() {
				gl_FragColor = texture2D(pixels, uv);
			}");
		program = GL.createProgram();
		GL.attachShader(program, vertex);
		GL.attachShader(program, fragment);
		GL.linkProgram(program);
		GL.deleteShader(vertex);
		GL.deleteShader(fragment);
		if (GL.getProgramParameter(program, GL.LINK_STATUS) == 0) throw new VisionException(GL.getProgramInfoLog(program), "Desktop OpenGL link");

		position = GL.getAttribLocation(program, "position");
		vertices = GL.createBuffer();
		GL.bindBuffer(GL.ARRAY_BUFFER, vertices);
		final quad = new Float32Array([-1., -1., 1., -1., -1., 1., 1., 1.]);
		GL.bufferData(GL.ARRAY_BUFFER, quad.byteLength, quad, GL.STATIC_DRAW);
		texture = GL.createTexture();
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.NEAREST);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.NEAREST);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.CLAMP_TO_EDGE);
		GL.texParameteri(GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.CLAMP_TO_EDGE);
	}

	public function draw(frame:lime.graphics.Image, bounds:lime.math.Rectangle):Void {
		GL.viewport(0, 0, frame.width, frame.height);
		GL.useProgram(program);
		GL.activeTexture(GL.TEXTURE0);
		GL.bindTexture(GL.TEXTURE_2D, texture);
		GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, frame.width, frame.height, 0, GL.RGBA, GL.UNSIGNED_BYTE, frame.getPixels(bounds, RGBA32));
		GL.bindBuffer(GL.ARRAY_BUFFER, vertices);
		GL.enableVertexAttribArray(position);
		GL.vertexAttribPointer(position, 2, GL.FLOAT, false, 0, 0);
		GL.drawArrays(GL.TRIANGLE_STRIP, 0, 4);
		GL.disableVertexAttribArray(position);
	}

	static function compile(kind:Int, source:String):GLShader {
		final shader = GL.createShader(kind);
		GL.shaderSource(shader, source);
		GL.compileShader(shader);
		if (GL.getShaderParameter(shader, GL.COMPILE_STATUS) == 0) throw new VisionException(GL.getShaderInfoLog(shader), "Desktop OpenGL shader");
		return shader;
	}
}
#end

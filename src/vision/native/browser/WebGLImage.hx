package vision.native.browser;

#if js
import js.html.webgl.Framebuffer;
import js.html.webgl.GL;
import js.html.webgl.Texture;
import js.html.webgl.WebGL2RenderingContext;
import js.lib.Uint8Array;
import vision.ds.ByteArray;
import vision.exceptions.WebGlError;
import vision.native.ImageBackend;
import vision.native.ImageBackend.DeviceImageStorage;
import vision.native.ImageBackend.ImageOperation;

/** Device storage for one Image. Its textures belong to the creating WebGL renderer. **/
@:noCompletion
class WebGLImage implements DeviceImageStorage {
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
		if (!isAvailable() || !bindTarget(texture)) throw new WebGlError("Image pixels are unavailable from WebGL", "Image readback");
		final rgba = new Uint8Array(width * height * 4);
		gl.readPixels(0, 0, width, height, GL.RGBA, GL.UNSIGNED_BYTE, rgba);
		gl.bindFramebuffer(GL.FRAMEBUFFER, null);
		if (gl.getError() != GL.NO_ERROR) throw new WebGlError("Could not read image pixels from WebGL", "Image readback");
		var index = 0;
		while (index < rgba.length) {
			final target = ImageBackend.PIXEL_OFFSET + index;
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

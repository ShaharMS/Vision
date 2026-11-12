package vision.native.browser;

#if js
import js.lib.Uint8Array;
import vision.ds.ByteArray;
import vision.ds.Image;

@:noCompletion
@:access(vision.ds.Image)
class BrowserPixels {
	public var rgba:Uint8Array;

	var width = 0;
	var height = 0;

	public function new() {}

	public function update(image:Image, width:Int, height:Int):Bool {
		return updatePacked(image.storage().readPixels(), width, height);
	}

	public function updatePacked(argb:ByteArray, width:Int, height:Int):Bool {
		final length = width * height * 4;
		var changed = this.width != width || this.height != height;
		this.width = width;
		this.height = height;
		if (rgba == null || rgba.length != length) rgba = new Uint8Array(length);

		// Image.underlying exposes writable bytes. Compare the actual data on each draw.
		var index = 0;
		while (index < length) {
			final start = Image.OFFSET + index;
			final r = argb[start + 1];
			final g = argb[start + 2];
			final b = argb[start + 3];
			final a = argb[start];
			if (rgba[index] != r || rgba[index + 1] != g || rgba[index + 2] != b || rgba[index + 3] != a) {
				rgba[index] = r;
				rgba[index + 1] = g;
				rgba[index + 2] = b;
				rgba[index + 3] = a;
				changed = true;
			}
			index += 4;
		}
		return changed;
	}
}
#end

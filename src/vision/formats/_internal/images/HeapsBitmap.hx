package vision.formats._internal.images;

#if heaps
import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import h3d.mat.Texture;
import hxd.Pixels;
import vision.ds.Image;
import vision.ds.PixelFormat;

/** A Vision image presented as a regular Heaps bitmap. Call update after editing the image. **/
class HeapsBitmap extends Bitmap {
	var texture:Texture;

	/**
		Creates a framework bitmap from the current pixels of a Vision image.

		@param image The initial image to present
		@param parent The optional Heaps display object that owns the bitmap
	**/
	public function new(image:Image, ?parent:Object) {
		super(null, parent);
		update(image);
	}

	/**
		Uploads the current pixels and reuses the bitmap storage when the size matches.

		@param image The image to present. An empty image releases the current storage.
	**/
	public function update(image:Image):Void {
		if (image.width <= 0 || image.height <= 0) {
			dispose();
			return;
		}
		final pixels = new Pixels(image.width, image.height, image.exportToBytes(PixelFormat.RGBA), RGBA);
		if (texture != null && texture.width == pixels.width && texture.height == pixels.height) {
			texture.uploadPixels(pixels);
			return;
		}
		final replacement = Texture.fromPixels(pixels);
		dispose();
		texture = replacement;
		tile = Tile.fromTexture(texture);
	}

	/** Releases the texture associated with this bitmap. **/
	public function dispose():Void {
		tile = null;
		if (texture != null) {
			texture.dispose();
			texture = null;
		}
	}
}
#end

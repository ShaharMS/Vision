package vision.formats._internal.images;

#if openfl
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import vision.ds.Image;

/** A Vision image presented as a regular OpenFL bitmap. Call update after editing the image. **/
class OpenFlBitmap extends Bitmap {
	var ownedData:BitmapData;

	/**
		Creates a framework bitmap from the current pixels of a Vision image.

		@param image The initial image to present
	**/
	public function new(image:Image) {
		super();
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
		if (ownedData == null || ownedData.width != image.width || ownedData.height != image.height) {
			dispose();
			ownedData = new BitmapData(image.width, image.height, true, 0);
		}
		final bytes = ByteArray.fromBytes(image.exportToBytes());
		bytes.endian = Endian.BIG_ENDIAN;
		ownedData.setPixels(ownedData.rect, bytes);
		bitmapData = ownedData;
	}

	/** Releases the pixel storage associated with this bitmap. **/
	public function dispose():Void {
		if (ownedData != null) {
			if (bitmapData == ownedData)
				bitmapData = null;
			ownedData.dispose();
			ownedData = null;
		}
	}
}
#end

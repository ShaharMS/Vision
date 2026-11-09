package vision.formats.to;

#if openfl
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import vision.ds.Image;

/** A Vision image presented as a regular OpenFL bitmap. Call update after editing the image. **/
class OpenFlBitmap extends Bitmap {
	var ownedData:BitmapData;

	public function new(image:Image) {
		super();
		update(image);
	}

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

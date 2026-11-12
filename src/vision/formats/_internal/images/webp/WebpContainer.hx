package vision.formats._internal.images.webp;

import haxe.io.BytesOutput;
import vision.ds.ByteArray;
import vision.exceptions.ImageLoadingFailed;

/** RIFF framing shared by still and animated WebP images. **/
@:noCompletion
class WebpContainer {
	public static function read(bytes:ByteArray, visit:(String, Int, Int)->Void):Void {
		if (bytes.length < 12 || bytes.getString(0, 4) != "RIFF" || bytes.getString(8, 4) != "WEBP")
			throw invalid("Invalid WebP container.");
		final size = bytes.getInt32(4);
		if (size < 4 || size > bytes.length - 8) throw invalid("Invalid WebP container size.");
		chunks(bytes, 12, size + 8, visit);
	}

	public static function chunks(bytes:ByteArray, offset:Int, end:Int, visit:(String, Int, Int)->Void):Void {
		while (offset < end) {
			if (end - offset < 8) throw invalid("Truncated WebP chunk.");
			final tag = bytes.getString(offset, 4);
			final length = bytes.getInt32(offset + 4);
			offset += 8;
			if (length < 0 || length > end - offset || (length & 1) > end - offset - length)
				throw invalid("Invalid WebP chunk size.");
			visit(tag, offset, length);
			offset += length + (length & 1);
		}
	}

	public static function write(payload:ByteArray):ByteArray {
		final output = new BytesOutput();
		output.writeString("RIFF");
		output.writeInt32(4 + payload.length);
		output.writeString("WEBP");
		output.write(payload);
		return output.getBytes();
	}

	public static function chunk(output:BytesOutput, tag:String, payload:ByteArray):Void {
		output.writeString(tag);
		output.writeInt32(payload.length);
		output.write(payload);
		if ((payload.length & 1) != 0) output.writeByte(0);
	}

	public static inline function invalid(reason:String):ImageLoadingFailed return new ImageLoadingFailed(WEBP, reason);
}

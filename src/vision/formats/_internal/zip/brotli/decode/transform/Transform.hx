package vision.formats._internal.zip.brotli.decode.transform;

import haxe.io.Bytes;

class Transform {
	public final prefix:Bytes;
	public final transform:Int;
	public final suffix:Bytes;

	public function new(prefix:String, transform:Int, suffix:String) {
		this.prefix = Bytes.ofString(prefix);
		this.transform = transform;
		this.suffix = Bytes.ofString(suffix);
	}
}

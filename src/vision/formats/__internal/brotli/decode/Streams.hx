package vision.formats.__internal.brotli.decode;

import vision.formats.__internal.brotli.decode.streams.BrotliOutput;
import haxe.io.Bytes;

/**
 * The decoder's one output call. Input is read where it lies, by the bit
 * reader.
 */
class Streams
{
	/* Writes len bytes of buf to the output, or throws past its limit. */
	static public inline function BrotliWrite(out:BrotliOutput, buf:Bytes, buf_off:Int, len:Int):Int {
		out.write(buf, buf_off, len);
		return len;
	}
}

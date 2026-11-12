package vision.formats.__internal.brotli.decode.streams;

import haxe.io.Bytes;

/**
	Where the decoder's ring buffer is flushed: the decoded bytes, gathered in
	`Bytes` chunks up to a limit.

	A chunk costs one byte per byte, and a stream whose ring buffer never
	wrapped (anything smaller than its window) arrives as one write and is
	returned as it came.
**/
class BrotliOutput {
	/** Bytes this may hold, or 0 for no limit. **/
	public var limit(default, null):Int;

	/** Bytes written so far. **/
	public var total(default, null):Int = 0;

	var __chunks:Array<Bytes> = [];
	var __current:Bytes = null;
	var __used:Int = 0;

	public function new(limit:Int) {
		this.limit = limit > 0 ? limit : 0;
	}

	/**
		Appends `count` bytes of `buffer`, or throws if they would take the
		output past `limit`. The check is written as a difference because the
		sum of two lengths can wrap.
	**/
	public function write(buffer:Bytes, offset:Int, count:Int):Void {
		if (count <= 0) {
			return;
		}
		if (limit > 0 && count > limit - total) {
			throw exceeded(limit);
		}

		while (count > 0) {
			if (__current == null || __used == __current.length) {
				// The rest of this write at least (a ring buffer's worth
				// arrives in one), and otherwise a chunk growing with the
				// output from 4 KB to 1 MB, never past what the limit allows.
				var size:Int = total < 4096 ? 4096 : (total > 1 << 20 ? 1 << 20 : total);
				if (size < count) {
					size = count;
				}
				if (limit > 0 && size > limit - total) {
					size = limit - total;
				}
				__current = Bytes.alloc(size);
				__chunks.push(__current);
				__used = 0;
			}
			var room:Int = __current.length - __used;
			var n:Int = count < room ? count : room;
			__current.blit(__used, buffer, offset, n);
			__used += n;
			offset += n;
			count -= n;
			total += n;
		}
	}

	/** Everything written, as one `Bytes`. **/
	public function getBytes():Bytes {
		if (__chunks.length == 1 && __used == __current.length) {
			return __current;
		}
		var out:Bytes = Bytes.alloc(total);
		var at:Int = 0;
		for (chunk in __chunks) {
			var n:Int = total - at < chunk.length ? total - at : chunk.length;
			out.blit(at, chunk, 0, n);
			at += n;
		}
		return out;
	}

	/** What a decode that would pass `limit` throws. **/
	public static function exceeded(limit:Int):haxe.Exception {
		return new vision.exceptions.FontLoadingError("WOFF2", "Brotli stream exceeded " + limit + " bytes");
	}
}

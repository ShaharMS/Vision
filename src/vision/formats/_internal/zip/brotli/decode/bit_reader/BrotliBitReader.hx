package vision.formats._internal.zip.brotli.decode.bit_reader;

import haxe.io.Bytes;

/**
	Reads bits LSB first straight out of the input.

	The decoder is only ever handed a whole stream, so this reads it where it
	lies, not through an 8 KB ring and a callback as the C reference does:
	`val_` holds the four bytes before `pos_`, of which `bit_pos_` bits are
	spent. Bytes past the end read as zero, and `BrotliReadMoreInput` says
	when a read went past it.
**/
class BrotliBitReader {
	public var val_:UInt; /* pre-fetched bits */
	public var pos_:Int; /* index of the next byte to load into val_ */
	public var bit_pos_:UInt; /* bits of val_ already consumed */

	/** The stream, and the index one past its last byte. **/
	public var input_:Bytes;
	public var end_:Int;

	public function new() {}
}

package vision.formats.__internal.brotli.decode;

import vision.formats.__internal.brotli.decode.bit_reader.BrotliBitReader;
import haxe.io.Bytes;

/**
 * ...
 * @author ...
 */
class BitReader
{
//h
public static inline var BROTLI_MAX_NUM_BIT_READ =  25;

public static var kBitMask:Array<UInt> = [//[BROTLI_MAX_NUM_BIT_READ]
  0, 1, 3, 7, 15, 31, 63, 127, 255, 511, 1023, 2047, 4095, 8191, 16383, 32767,
  65535, 131071, 262143, 524287, 1048575, 2097151, 4194303, 8388607, 16777215
];
public static function BitMask(n:Int):UInt { return kBitMask[n]; }

/*
 * Loads one byte into the top of val_ for every eight bits consumed from the
 * bottom. A byte past the end of the stream loads as zero.
 */
public static function ShiftBytes32(br:BrotliBitReader) {
  while (br.bit_pos_ >= 8) {
    br.val_ >>>= 8;
    if (br.pos_ < br.end_) {
      br.val_ |= br.input_.get(br.pos_) << 24;
    }
    ++br.pos_;
    br.bit_pos_ -= 8;
  }
}

/*
 * Whether every bit consumed so far lay inside the stream.
 *
 * Asked before each step of the decode: a step that ran past the end is
 * refused at the next one, having read only zeros meanwhile.
 */
public static function BrotliReadMoreInput(br:BrotliBitReader):Bool {
  // Bytes from the first byte in val_ to the end of the stream.
  var left:Int = br.end_ - br.pos_ + 4;
  var consumed:Int = cast br.bit_pos_;
  return left > 4 || (left << 3) >= consumed;
}

/* The same question, asked before a step that reads up to `num` bytes. */
public static inline function BrotliReadInputAmount(br:BrotliBitReader, num:Int):Bool {
  return BrotliReadMoreInput(br);
}

/* Guarantees that there are at least 24 bits in the buffer. */
public static inline function BrotliFillBitWindow(br:BrotliBitReader) {
  ShiftBytes32(br);
}

public static function BrotliInitBitReader(br:BrotliBitReader, input:Bytes, start:Int, end:Int) {
  br.input_ = input;
  br.end_ = end;
  BrotliResetBitReader(br, start);
}

/* Points the reader at a byte of the stream, with val_ holding the four bytes there. */
public static function BrotliResetBitReader(br:BrotliBitReader, at:Int) {
  br.pos_ = at;
  br.val_ = 0;
  br.bit_pos_ = 32;
  ShiftBytes32(br);
}

/* Whether there is a stream to read at all. */
public static function BrotliWarmupBitReader(br:BrotliBitReader):Bool {
  return br.end_ > br.pos_ - 4;
}

//238
/* Reads the specified number of bits from Read Buffer. */
public static function BrotliReadBits(
    br:BrotliBitReader, n_bits:Int):UInt {
  var val:UInt;
  /*
   * The if statement gives 2-4% speed boost on Canterbury data set with
   * asm.js/firefox/x86-64.
   */
  if ((32 - (br.bit_pos_ : Int)) < n_bits) {
    BrotliFillBitWindow(br);
  }
  val = (br.val_ >> br.bit_pos_) & BitMask(n_bits);

  br.bit_pos_ += n_bits;
  return val;
}

	public function new()
	{

	}

}

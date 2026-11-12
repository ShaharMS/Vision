package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;

/** Encodes an independent HEVC Main-profile picture with PCM coding units. **/
@:noCompletion
class HevcPcmEncoder {
	static inline final BLOCK = 16;
	static inline final LEVEL = 153;

	/**
		Encodes a full-range, 8-bit 4:2:0 picture as VPS, SPS, PPS and IDR NAL units.
		@param width The even displayed width
		@param height The even displayed height
		@param luma Luma samples in raster order
		@param cb Blue-difference samples in raster order
		@param cr Red-difference samples in raster order
	**/
	public static function encode(width:Int, height:Int, luma:Bytes, cb:Bytes, cr:Bytes):Array<Bytes> {
		if (width <= 0 || height <= 0 || width > 8192 || height > 8192 || ((width | height) & 1) != 0
			|| width * height > 8912896 || luma.length != width * height || cb.length != luma.length >> 2 || cr.length != cb.length)
			throw new HevcBitstreamError("Invalid HEVC PCM picture or plane dimensions.");
		final codedWidth = (width + BLOCK - 1) & -BLOCK;
		final codedHeight = (height + BLOCK - 1) & -BLOCK;
		if (codedWidth * codedHeight > 8912896) throw new HevcBitstreamError("Padded HEVC picture exceeds its level.");
		return [
			nal(32, videoParameters()),
			nal(33, sequenceParameters(width, height, codedWidth, codedHeight)),
			nal(34, pictureParameters()),
			nal(19, picture(width, height, codedWidth, codedHeight, luma, cb, cr))
		];
	}

	static function profile(bits:PcmHeaderBits):Void {
		bits.write(33, 8); // Profile space 0, high tier, Main profile.
		bits.write(0x60000000, 32);
		bits.write(9, 4); // Progressive and frame-only.
		bits.write(0, 32);
		bits.write(0, 12);
		bits.write(LEVEL, 8);
	}

	static function videoParameters():Bytes {
		final bits = new PcmHeaderBits();
		bits.write(0, 4); // VPS ID.
		bits.write(3, 2); // Internal and available base layer.
		bits.write(0, 9); // One layer and one temporal sublayer.
		bits.write(1, 1); // Temporal nesting.
		bits.write(65535, 16);
		profile(bits);
		bits.write(0, 1); // Highest sublayer ordering only.
		for (_ in 0...3) bits.ue(0);
		bits.write(0, 6); // Maximum layer ID.
		bits.ue(0); // No extra layer sets.
		bits.write(0, 2); // No timing or extension.
		return bits.finish();
	}

	static function sequenceParameters(width:Int, height:Int, codedWidth:Int, codedHeight:Int):Bytes {
		final bits = new PcmHeaderBits();
		bits.write(1, 8); // VPS ID 0, one sublayer, temporal nesting.
		profile(bits);
		bits.ue(0); // SPS ID.
		bits.ue(1); // 4:2:0.
		bits.ue(codedWidth);
		bits.ue(codedHeight);
		final cropped = width != codedWidth || height != codedHeight;
		bits.write(cropped ? 1 : 0, 1);
		if (cropped) {
			bits.ue(0);
			bits.ue((codedWidth - width) >> 1);
			bits.ue(0);
			bits.ue((codedHeight - height) >> 1);
		}
		bits.ue(0); // Luma bit depth minus eight.
		bits.ue(0); // Chroma bit depth minus eight.
		bits.ue(0); // Four POC bits.
		bits.write(0, 1); // Highest sublayer ordering only.
		for (_ in 0...3) bits.ue(0);
		bits.ue(1); // 16x16 minimum coding block.
		bits.ue(0); // One coding block per CTB.
		bits.ue(0); // 4x4 minimum transform.
		bits.ue(2); // 16x16 maximum transform.
		bits.ue(0);
		bits.ue(0);
		bits.write(1, 4); // No scaling lists, AMP or SAO. Enable PCM.
		bits.write(0x77, 8);
		bits.ue(1);
		bits.ue(0);
		bits.write(1, 1); // Skip filters for PCM.
		bits.ue(0); // No short-term references.
		bits.write(1, 4); // No long-term refs, MVP or smoothing. Enable VUI.
		bits.write(1, 3); // No aspect ratio or overscan. Signal video format.
		bits.write(0x17, 5); // Unspecified video format, full range and colour description.
		bits.write(1, 8); // BT.709 primaries.
		bits.write(13, 8); // sRGB transfer.
		bits.write(1, 8); // BT.709 matrix.
		bits.write(0, 8); // Remaining VUI flags and SPS extension.
		return bits.finish();
	}

	static function pictureParameters():Bytes {
		final bits = new PcmHeaderBits();
		bits.ue(0); // PPS ID.
		bits.ue(0); // SPS ID.
		bits.write(0, 7); // No dependent slices, extra header bits or CABAC override.
		bits.ue(0);
		bits.ue(0);
		bits.ue(0); // Initial QP 26.
		bits.write(0, 3); // No constrained intra, transform skip or CU QP delta.
		bits.ue(0);
		bits.ue(0); // Chroma QP offsets.
		bits.write(0, 7); // No slice chroma offsets, weighted prediction, tiles, WPP or across-slice filter.
		bits.write(5, 3); // Deblocking control present and disabled.
		bits.write(0, 2); // No scaling list data or reference list modification.
		bits.ue(0); // Merge level.
		bits.write(0, 2); // No header or PPS extension.
		return bits.finish();
	}

	static function picture(width:Int, height:Int, codedWidth:Int, codedHeight:Int, luma:Bytes, cb:Bytes, cr:Bytes):Bytes {
		final bits = new PcmHeaderBits();
		bits.write(2, 2); // First slice, no prior pictures.
		bits.ue(0);
		bits.ue(2); // I slice.
		bits.ue(0); // QP delta.
		final output = new BytesBuffer();
		output.add(bits.finish());
		final partMode = new HevcCabacContext(26, 184);
		var cabac = new HevcCabacEncoder();
		for (by in 0...Std.int(codedHeight / BLOCK)) {
			for (bx in 0...Std.int(codedWidth / BLOCK)) {
				cabac.writeBin(1, partMode); // Intra 2Nx2N.
				cabac.writeTermination(true); // PCM flag.
				output.add(cabac.finish());
				writeBlock(output, luma, width, height, bx * BLOCK, by * BLOCK, BLOCK);
				writeBlock(output, cb, width >> 1, height >> 1, bx * (BLOCK >> 1), by * (BLOCK >> 1), BLOCK >> 1);
				writeBlock(output, cr, width >> 1, height >> 1, bx * (BLOCK >> 1), by * (BLOCK >> 1), BLOCK >> 1);
				cabac = new HevcCabacEncoder();
				final last = (bx + 1) * BLOCK == codedWidth && (by + 1) * BLOCK == codedHeight;
				cabac.writeTermination(last);
			}
		}
		output.add(cabac.finish());
		return output.getBytes();
	}

	static function writeBlock(output:BytesBuffer, plane:Bytes, width:Int, height:Int, x:Int, y:Int, size:Int):Void {
		for (row in y...y + size) {
			final start = (row < height ? row : height - 1) * width;
			for (column in x...x + size) output.addByte(plane.get(start + (column < width ? column : width - 1)));
		}
	}

	static function nal(type:Int, rbsp:Bytes):Bytes {
		final output = new BytesBuffer();
		output.addByte(type << 1);
		output.addByte(1);
		var zeroes = 0;
		for (i in 0...rbsp.length) {
			final value = rbsp.get(i);
			if (zeroes == 2 && value <= 3) {
				output.addByte(3);
				zeroes = 0;
			}
			output.addByte(value);
			zeroes = value == 0 ? zeroes + 1 : 0;
		}
		return output.getBytes();
	}
}

private class PcmHeaderBits {
	final output = new BytesBuffer();
	var pending = 0;
	var count = 0;

	public function new() {}

	public function write(value:Int, length:Int):Void {
		var bit = length;
		while (bit > 0) {
			pending = (pending << 1) | ((value >>> --bit) & 1);
			if (++count == 8) {
				output.addByte(pending);
				pending = 0;
				count = 0;
			}
		}
	}

	public function ue(value:Int):Void {
		final code = value + 1;
		var length = 0;
		var remaining = code;
		while ((remaining >>>= 1) != 0) length++;
		write(0, length);
		write(code, length + 1);
	}

	public function finish():Bytes {
		write(1, 1);
		if (count != 0) write(0, 8 - count);
		return output.getBytes();
	}
}

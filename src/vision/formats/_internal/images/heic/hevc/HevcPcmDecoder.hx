package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;

/** Reconstructs sample planes from a single intra slice containing PCM coding units. **/
@:noCompletion
class HevcPcmDecoder {
	/**
		Reads a single IDR slice with one PCM coding unit per coding tree block.
		Returns luma, Cb and Cr planes at their coded dimensions.
	**/
	public static function decode(sps:HevcSequenceGeometry, pps:Bytes, slice:Bytes):Array<Bytes> {
		final pcm = sps.pcm;
		if (pcm == null || sps.chromaFormat != 1 || sps.lumaDepth != 8 || sps.chromaDepth != 8
			|| pcm.lumaDepth != 8 || pcm.chromaDepth != 8 || sps.ctbLog2 != sps.minCodingBlockLog2
			|| sps.ctbLog2 < pcm.minBlockLog2 || sps.ctbLog2 > pcm.maxBlockLog2
			|| sps.sampleAdaptiveOffset || !pcm.loopFilterDisabled)
			throw new HevcBitstreamError("Unsupported HEVC PCM sequence parameters.");
		final size = 1 << sps.ctbLog2;
		final width = sps.codedWidth;
		final height = sps.codedHeight;
		if (((width | height) & (size - 1)) != 0 || width * 1.0 * height > 8912896)
			throw new HevcBitstreamError("Invalid HEVC PCM picture dimensions.");
		final picture = readPictureParameters(pps, sps.sequenceParameterSetId);
		final header = new HevcRawBits(slice);
		if (!header.flag()) throw new HevcBitstreamError("Expected the first slice of an HEVC picture.");
		header.flag(); // No output of prior pictures.
		if (header.ue(63) != picture.id || header.ue(2) != 2)
			throw new HevcBitstreamError("Expected an HEVC intra slice referencing the selected PPS.");
		if (picture.outputFlag && !header.flag()) throw new HevcBitstreamError("HEVC picture is marked for discard.");
		final qp = picture.qp + header.se(51);
		if (qp < 0 || qp > 51) throw new HevcBitstreamError("Invalid HEVC slice QP.");
		var position = header.align();
		final y = Bytes.alloc(width * height);
		final cb = Bytes.alloc(y.length >> 2);
		final cr = Bytes.alloc(cb.length);
		final partMode = new HevcCabacContext(qp, 184);
		var cabac = new HevcCabacDecoder(slice, position, slice.length - position);
		final columns = Std.int(width / size);
		final rows = Std.int(height / size);
		for (by in 0...rows) {
			for (bx in 0...columns) {
				if (cabac.readBin(partMode) != 1 || !cabac.readTermination())
					throw new HevcBitstreamError("Unsupported non-PCM HEVC coding unit.");
				position = cabac.alignForPcm();
				final chromaSize = size >> 1;
				position = copyBlock(slice, position, y, width, bx * size, by * size, size);
				position = copyBlock(slice, position, cb, width >> 1, bx * chromaSize, by * chromaSize, chromaSize);
				position = copyBlock(slice, position, cr, width >> 1, bx * chromaSize, by * chromaSize, chromaSize);
				cabac = new HevcCabacDecoder(slice, position, slice.length - position);
				if (cabac.readTermination() != (bx == columns - 1 && by == rows - 1))
					throw new HevcBitstreamError("Unexpected end of HEVC PCM slice.");
			}
		}
		return [y, cb, cr];
	}

	static function readPictureParameters(bytes:Bytes, sequenceId:Int):{id:Int, qp:Int, outputFlag:Bool} {
		final bits = new HevcRawBits(bytes);
		final id = bits.ue(63);
		if (bits.ue(15) != sequenceId || bits.flag())
			throw new HevcBitstreamError("Unsupported HEVC PCM picture parameter set.");
		final outputFlag = bits.flag();
		if (bits.read(3) != 0) throw new HevcBitstreamError("Unsupported HEVC PCM extra slice header bits.");
		bits.read(2); // Sign data hiding and CABAC initialization.
		bits.ue(14);
		bits.ue(14);
		final qp = bits.se(26) + 26;
		bits.read(2); // Constrained intra prediction and transform skip.
		if (bits.flag()) bits.ue(3);
		bits.se(12);
		bits.se(12);
		if (bits.read(7) != 0 || bits.read(3) != 5 || bits.read(2) != 0)
			throw new HevcBitstreamError("Unsupported HEVC PCM picture coding flags.");
		bits.ue(4); // Merge level.
		if (bits.read(2) != 0) throw new HevcBitstreamError("Unsupported HEVC PCM picture extensions.");
		bits.align();
		return {id: id, qp: qp, outputFlag: outputFlag};
	}

	static function copyBlock(source:Bytes, position:Int, plane:Bytes, stride:Int, x:Int, y:Int, size:Int):Int {
		if (position > source.length - size * size) throw new HevcBitstreamError("Truncated HEVC PCM samples.");
		for (row in 0...size) plane.blit((y + row) * stride + x, source, position + row * size, size);
		return position + size * size;
	}
}

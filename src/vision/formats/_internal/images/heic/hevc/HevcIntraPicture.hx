/*
 * SPDX-License-Identifier: LGPL-2.1-or-later
 * HEVC intra coding and transform tree syntax adapted from FFmpeg n4.4
 * libavcodec/hevcdec.c and hevc_cabac.c.
 * Copyright (C) 2012-2013 Guillaume Martres, Mickael Raulet,
 * Gildas Cocherel, and Wassim Hamidouche.
 * See COPYING.LGPLv2.1 in this directory.
 */
package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;

/** Reconstructs an 8-bit 4:2:0 IDR picture from its coding and transform trees. **/
@:noCompletion
class HevcIntraPicture {
	final sequence:HevcSequenceGeometry;
	final picture:HevcPictureParameters;
	final slice:HevcIdrSlice;
	final planes:Array<HevcIntraPlane>;
	final modes:HevcIntraModes;
	final sao:HevcSao;
	final depths:Bytes;
	final depthStride:Int;
	final ctb:Int;
	var cabac:HevcCabacDecoder;
	var contexts:IntraContexts;

	public static function decode(sequence:HevcSequenceGeometry, picture:HevcPictureParameters, slice:HevcIdrSlice, rbsp:Bytes):Array<Bytes> {
		if (sequence.chromaFormat != 1 || sequence.lumaDepth != 8 || sequence.chromaDepth != 8
			|| sequence.scalingListsEnabled || sequence.pcm != null || picture.tiles
			|| picture.qpDeltaDepth != null || picture.transquantBypass || !slice.deblockDisabled
			|| sequence.codedWidth * 1.0 * sequence.codedHeight > 8912896)
			throw new HevcBitstreamError("Unsupported HEVC intra picture configuration.");
		return new HevcIntraPicture(sequence, picture, slice).read(rbsp);
	}

	function new(sequence:HevcSequenceGeometry, picture:HevcPictureParameters, slice:HevcIdrSlice) {
		this.sequence = sequence;
		this.picture = picture;
		this.slice = slice;
		final width = sequence.codedWidth;
		final height = sequence.codedHeight;
		ctb = 1 << sequence.ctbLog2;
		planes = [new HevcIntraPlane(width, height), new HevcIntraPlane(width >> 1, height >> 1), new HevcIntraPlane(width >> 1, height >> 1)];
		modes = new HevcIntraModes(width, height, sequence.ctbLog2);
		sao = new HevcSao(width, height, ctb, slice.saoLuma, slice.saoChroma);
		depthStride = width >> sequence.minCodingBlockLog2;
		depths = Bytes.alloc(depthStride * (height >> sequence.minCodingBlockLog2));
		contexts = new IntraContexts(slice.qp);
	}

	function read(rbsp:Bytes):Array<Bytes> {
		final columns = Std.int((sequence.codedWidth + ctb - 1) / ctb);
		final rows = Std.int((sequence.codedHeight + ctb - 1) / ctb);
		final offsets = slice.substreamOffsets;
		if (offsets.length != (picture.wavefront ? rows : 1))
			throw new HevcBitstreamError("HEVC entropy entry points do not match the coding tree rows.");
		var next:IntraContexts = null;
		for (row in 0...rows) {
			if (row == 0 || picture.wavefront) {
				final index = picture.wavefront ? row : 0;
				final start = offsets[index];
				final end = index + 1 < offsets.length ? offsets[index + 1] : rbsp.length;
				cabac = new HevcCabacDecoder(rbsp, start, end - start);
				if (row > 0) contexts = next == null ? new IntraContexts(slice.qp) : next;
			}
			for (column in 0...columns) {
				sao.read(cabac, contexts.saoMerge, contexts.saoType, column, row);
				codingTree(column * ctb, row * ctb, sequence.ctbLog2, 0);
				if (picture.wavefront && column == 1 && row + 1 < rows) next = contexts.copy();
				if (cabac.readTermination() != (row == rows - 1 && column == columns - 1))
					throw new HevcBitstreamError("Unexpected HEVC intra slice termination.");
			}
			if (picture.wavefront && row + 1 < rows && !cabac.readTermination())
				throw new HevcBitstreamError("Missing HEVC wavefront substream termination.");
		}
		return [for (i in 0...planes.length) {
			final plane = planes[i];
			final sub = i == 0 ? 0 : 1;
			sao.apply(plane.samples, plane.width, plane.height, i, sub, sub);
		}];
	}

	function codingTree(x:Int, y:Int, log:Int, depth:Int):Void {
		final size = 1 << log;
		final cell = (y >> sequence.minCodingBlockLog2) * depthStride + (x >> sequence.minCodingBlockLog2);
		final available = x + size <= sequence.codedWidth && y + size <= sequence.codedHeight;
		final left = x != 0 && depths.get(cell - 1) > depth;
		final top = y != 0 && depths.get(cell - depthStride) > depth;
		final split = log > sequence.minCodingBlockLog2
			&& (!available || cabac.readBin(contexts.splitCoding[(left ? 1 : 0) + (top ? 1 : 0)]) != 0);
		if (split) {
			final half = size >> 1;
			for (row in 0...2) for (column in 0...2) {
				final px = x + column * half;
				final py = y + row * half;
				if (px < sequence.codedWidth && py < sequence.codedHeight) codingTree(px, py, log - 1, depth + 1);
			}
			return;
		}
		if (!available) throw new HevcBitstreamError("HEVC picture dimensions do not align to the minimum coding block.");
		final cells = size >> sequence.minCodingBlockLog2;
		for (row in 0...cells) depths.fill(cell + row * depthStride, cells, depth);
		final partitioned = log == sequence.minCodingBlockLog2 && cabac.readBin(contexts.partition) == 0;
		final luma = modes.readLuma(cabac, contexts.prediction, x, y, size, partitioned);
		final chroma = HevcIntraModes.readChroma(cabac, contexts.chromaMode, luma[0]);
		transformTree(x, y, log, 0, partitioned, luma, chroma, true, true, 0, 0);
	}

	function transformTree(x:Int, y:Int, log:Int, depth:Int, partitioned:Bool, luma:Array<Int>, chroma:Int,
		cb:Bool, cr:Bool, predictionUnit:Int, quadrant:Int):Void {
		final forced = log > sequence.maxTransformBlockLog2 || (partitioned && depth == 0);
		final canSplit = log > sequence.minTransformBlockLog2 && depth < sequence.intraTransformDepth + (partitioned ? 1 : 0);
		final split = forced || (canSplit && cabac.readBin(contexts.splitTransform[5 - log]) != 0);
		if (log > 2) {
			if (cb) cb = cabac.readBin(contexts.chromaCbf[depth]) != 0;
			if (cr) cr = cabac.readBin(contexts.chromaCbf[depth]) != 0;
		}
		if (split) {
			final half = 1 << (log - 1);
			for (i in 0...4)
				transformTree(x + (i & 1) * half, y + (i >> 1) * half, log - 1, depth + 1, partitioned,
					luma, chroma, cb, cr, partitioned && depth == 0 ? i : predictionUnit, i);
			return;
		}
		final hasLuma = cabac.readBin(contexts.lumaCbf[depth == 0 ? 1 : 0]) != 0;
		reconstruct(0, x, y, log, luma[predictionUnit], hasLuma, slice.qp);
		if (log > 2 || quadrant == 3) {
			final px = log == 2 ? (x - 4) >> 1 : x >> 1;
			final py = log == 2 ? (y - 4) >> 1 : y >> 1;
			final chromaLog = log == 2 ? 2 : log - 1;
			reconstruct(1, px, py, chromaLog, chroma, cb, HevcResidual.chromaQp(slice.qp, slice.cbQpOffset));
			reconstruct(2, px, py, chromaLog, chroma, cr, HevcResidual.chromaQp(slice.qp, slice.crQpOffset));
		}
	}

	function reconstruct(plane:Int, x:Int, y:Int, log:Int, mode:Int, hasResidual:Bool, qp:Int):Void {
		final size = 1 << log;
		final buffer = planes[plane];
		final references = buffer.references(x, y, size);
		if (plane == 0 && size > 4 && mode != 1) {
			final distance = Std.int(Math.min(Math.abs(mode - 10), Math.abs(mode - 26)));
			if (distance > (size == 8 ? 7 : size == 16 ? 1 : 0)) references.smooth(size, sequence.strongIntraSmoothing);
		}
		var pixels = HevcIntraPrediction.predict(size, mode, references.top, references.left, references.corner, 8, plane == 0);
		if (hasResidual) {
			final skip = picture.transformSkip && log == 2 && cabac.readBin(contexts.transformSkip[plane == 0 ? 0 : 1]) != 0;
			final levels = contexts.coefficients.read(cabac, log, plane != 0, mode, picture.signDataHiding);
			pixels = HevcIntraPrediction.reconstruct(size, pixels, HevcResidual.inverse(levels, size, qp, plane == 0, skip), 8);
		}
		buffer.put(x, y, size, pixels);
	}
}

private class HevcIntraPlane {
	public final width:Int;
	public final height:Int;
	public final samples:Bytes;
	final ready:Bytes;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		samples = Bytes.alloc(width * height);
		ready = Bytes.alloc((width >> 2) * (height >> 2));
	}

	public function references(x:Int, y:Int, size:Int):HevcReferences {
		final chain = [for (i in 0...2 * size) sample(x - 1, y + 2 * size - 1 - i)];
		chain.push(sample(x - 1, y - 1));
		for (i in 0...2 * size) chain.push(sample(x + i, y - 1));
		var fallback = 128;
		for (value in chain) if (value >= 0) {
			fallback = value;
			break;
		}
		for (i in 0...chain.length) {
			if (chain[i] < 0) chain[i] = fallback;
			else fallback = chain[i];
		}
		return new HevcReferences(chain, size);
	}

	function sample(x:Int, y:Int):Int {
		if (x < 0 || y < 0 || x >= width || y >= height || ready.get((y >> 2) * (width >> 2) + (x >> 2)) == 0) return -1;
		return samples.get(y * width + x);
	}

	public function put(x:Int, y:Int, size:Int, pixels:Array<Int>):Void {
		for (row in 0...size) for (column in 0...size)
			samples.set((y + row) * width + x + column, pixels[row * size + column]);
		for (row in 0...(size >> 2))
			ready.fill(((y >> 2) + row) * (width >> 2) + (x >> 2), size >> 2, 1);
	}
}

private class HevcReferences {
	public var top:Array<Int>;
	public var left:Array<Int>;
	public var corner:Int;

	public function new(chain:Array<Int>, size:Int) {
		final length = size * 2;
		corner = chain[length];
		top = chain.slice(length + 1);
		left = [for (i in 0...length) chain[length - i - 1]];
	}

	public function smooth(size:Int, strong:Bool):Void {
		final length = size * 2;
		final topEnd = top[length - 1];
		final leftEnd = left[length - 1];
		if (strong && size == 32 && Math.abs(corner + topEnd - 2 * top[31]) < 8
			&& Math.abs(corner + leftEnd - 2 * left[31]) < 8) {
			for (i in 0...length - 1) {
				top[i] = ((63 - i) * corner + (i + 1) * topEnd + 32) >> 6;
				left[i] = ((63 - i) * corner + (i + 1) * leftEnd + 32) >> 6;
			}
			return;
		}
		final filteredCorner = (left[0] + 2 * corner + top[0] + 2) >> 2;
		top = smoothLine(top, corner);
		left = smoothLine(left, corner);
		corner = filteredCorner;
	}

	static function smoothLine(line:Array<Int>, corner:Int):Array<Int> {
		return [for (i in 0...line.length) i == line.length - 1 ? line[i]
			: ((i == 0 ? corner : line[i - 1]) + 2 * line[i] + line[i + 1] + 2) >> 2];
	}
}

private class IntraContexts {
	public var saoMerge:HevcCabacContext;
	public var saoType:HevcCabacContext;
	public var splitCoding:Array<HevcCabacContext>;
	public var partition:HevcCabacContext;
	public var prediction:HevcCabacContext;
	public var chromaMode:HevcCabacContext;
	public var splitTransform:Array<HevcCabacContext>;
	public var lumaCbf:Array<HevcCabacContext>;
	public var chromaCbf:Array<HevcCabacContext>;
	public var transformSkip:Array<HevcCabacContext>;
	public var coefficients:HevcCoefficients;

	public function new(qp:Int) {
		saoMerge = new HevcCabacContext(qp, 153);
		saoType = new HevcCabacContext(qp, 200);
		splitCoding = init(qp, [139, 141, 157]);
		partition = new HevcCabacContext(qp, 184);
		prediction = new HevcCabacContext(qp, 184);
		chromaMode = new HevcCabacContext(qp, 63);
		splitTransform = init(qp, [153, 138, 138]);
		lumaCbf = init(qp, [111, 141]);
		chromaCbf = init(qp, [94, 138, 182, 154, 154]);
		transformSkip = init(qp, [139, 139]);
		coefficients = new HevcCoefficients(qp);
	}

	public function copy():IntraContexts {
		final result = new IntraContexts(0);
		result.saoMerge = saoMerge.copy();
		result.saoType = saoType.copy();
		result.splitCoding = copyBins(splitCoding);
		result.partition = partition.copy();
		result.prediction = prediction.copy();
		result.chromaMode = chromaMode.copy();
		result.splitTransform = copyBins(splitTransform);
		result.lumaCbf = copyBins(lumaCbf);
		result.chromaCbf = copyBins(chromaCbf);
		result.transformSkip = copyBins(transformSkip);
		result.coefficients = coefficients.copy();
		return result;
	}

	static function copyBins(values:Array<HevcCabacContext>):Array<HevcCabacContext>
		return [for (value in values) value.copy()];

	static function init(qp:Int, values:Array<Int>):Array<HevcCabacContext>
		return [for (value in values) new HevcCabacContext(qp, value)];
}

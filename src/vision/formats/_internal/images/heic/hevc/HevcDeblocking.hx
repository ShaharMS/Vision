/*
 * SPDX-License-Identifier: LGPL-2.1-or-later
 * Adapted from FFmpeg n4.4 libavcodec/hevc_filter.c and hevcdsp_template.c.
 * Copyright (C) 2012-2013 Guillaume Martres
 * Copyright (C) 2013 Seppo Tomperi and Wassim Hamidouche
 * See COPYING.LGPLv2.1 in this directory.
 */
package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;

/** Deblocks a single 8-bit HEVC intra slice before sample adaptive offset filtering. **/
@:noCompletion
class HevcDeblocking {
	static final beta = [
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 7, 8,
		9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36,
		38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64
	];
	static final tc = [
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
		1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4,
		5, 5, 6, 6, 7, 8, 9, 10, 11, 13, 14, 16, 18, 20, 22, 24
	];

	final width:Int;
	final height:Int;
	final stride:Int;
	final vertical:Bytes;
	final horizontal:Bytes;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;
		stride = width >> 2;
		vertical = Bytes.alloc(stride * (height >> 2));
		horizontal = Bytes.alloc(vertical.length);
	}

	/** Marks transform edges, which have boundary strength two in an intra picture. **/
	public function mark(x:Int, y:Int, size:Int):Void {
		final start = (y >> 2) * stride + (x >> 2);
		if (x > 0 && (x & 7) == 0)
			for (row in 0...(size >> 2)) vertical.set(start + row * stride, 1);
		if (y > 0 && (y & 7) == 0) horizontal.fill(start, size >> 2, 1);
	}

	/** Applies vertical and horizontal edges, with a QP on each side of the boundary. **/
	public function apply(planes:Array<Bytes>, quantizers:Bytes, minBlockLog:Int,
		picture:HevcPictureParameters, slice:HevcIdrSlice):Void {
		final qpStride = width >> minBlockLog;
		for (pass in 0...2) {
			final acrossX = pass == 0;
			final edges = acrossX ? vertical : horizontal;
			final step = acrossX ? 1 : width;
			final along = acrossX ? width : 1;
			var y = acrossX ? 0 : 8;
			while (y < height) {
				var x = acrossX ? 8 : 0;
				while (x < width) {
					if (edges.get((y >> 2) * stride + (x >> 2)) != 0) {
						final p = ((y - (acrossX ? 0 : 1)) >> minBlockLog) * qpStride + ((x - (acrossX ? 1 : 0)) >> minBlockLog);
						final q = (y >> minBlockLog) * qpStride + (x >> minBlockLog);
						final qp = (quantizers.get(p) + quantizers.get(q) + 1) >> 1;
						filterLuma(planes[0], y * width + x, step, along,
							beta[clip(qp + slice.betaOffset, 0, 51)], tc[clip(qp + 2 + slice.tcOffset, 0, 53)]);
					}
					x += acrossX ? 8 : 4;
				}
				y += acrossX ? 4 : 8;
			}
			final chromaWidth = width >> 1;
			y = acrossX ? 0 : 16;
			while (y < height) {
				var x = acrossX ? 16 : 0;
				while (x < width) {
					if (edges.get((y >> 2) * stride + (x >> 2)) != 0) {
						final p = ((y - (acrossX ? 0 : 1)) >> minBlockLog) * qpStride + ((x - (acrossX ? 1 : 0)) >> minBlockLog);
						final q = (y >> minBlockLog) * qpStride + (x >> minBlockLog);
						final qp = (quantizers.get(p) + quantizers.get(q) + 1) >> 1;
						for (plane in 1...3) {
							final offset = plane == 1 ? picture.cbQpOffset : picture.crQpOffset;
							final chromaQp = HevcResidual.chromaQp(qp, offset);
							filterChroma(planes[plane], (y >> 1) * chromaWidth + (x >> 1), acrossX ? 1 : chromaWidth,
								acrossX ? chromaWidth : 1, tc[clip(chromaQp + 2 + slice.tcOffset, 0, 53)]);
						}
					}
					x += acrossX ? 16 : 8;
				}
				y += acrossX ? 8 : 16;
			}
		}
	}

	static function filterLuma(samples:Bytes, start:Int, step:Int, along:Int, beta:Int, tc:Int):Void {
		if (beta == 0 || tc == 0) return;
		final first = neighbors(samples, start, step);
		final last = neighbors(samples, start + along * 3, step);
		final pFirst = curvature(first, 3, -1);
		final qFirst = curvature(first, 4, 1);
		final pLast = curvature(last, 3, -1);
		final qLast = curvature(last, 4, 1);
		final d0 = pFirst + qFirst;
		final d3 = pLast + qLast;
		if (d0 + d3 >= beta) return;
		final strong = strongEdge(first, d0, beta, tc) && strongEdge(last, d3, beta, tc);
		final sideLimit = (beta + (beta >> 1)) >> 3;
		final secondP = pFirst + pLast < sideLimit;
		final secondQ = qFirst + qLast < sideLimit;
		for (line in 0...4) {
			final index = start + line * along;
			final p = neighbors(samples, index, step);
			if (strong) {
				final limit = tc * 2;
				for (side in 0...2) {
					if (side != 0) p.reverse();
					final sign = side == 0 ? -1 : 1;
					final edge = side == 0 ? index - step : index;
					setNear(samples, edge, p[3], (p[1] + 2 * p[2] + 2 * p[3] + 2 * p[4] + p[5] + 4) >> 3, limit);
					setNear(samples, edge + sign * step, p[2], (p[1] + p[2] + p[3] + p[4] + 2) >> 2, limit);
					setNear(samples, edge + sign * step * 2, p[1], (2 * p[0] + 3 * p[1] + p[2] + p[3] + p[4] + 4) >> 3, limit);
				}
			} else {
				final raw = (9 * (p[4] - p[3]) - 3 * (p[5] - p[2]) + 8) >> 4;
				if (abs(raw) >= 10 * tc) continue;
				final delta = clip(raw, -tc, tc);
				final half = tc >> 1;
				samples.set(index - step, clip(p[3] + delta, 0, 255));
				samples.set(index, clip(p[4] - delta, 0, 255));
				if (secondP) setNear(samples, index - 2 * step, p[2], (((p[1] + p[3] + 1) >> 1) + p[2] + delta) >> 1, half);
				if (secondQ) setNear(samples, index + step, p[5], (((p[6] + p[4] + 1) >> 1) + p[5] - delta) >> 1, half);
			}
		}
	}

	static function filterChroma(samples:Bytes, start:Int, step:Int, along:Int, tc:Int):Void {
		if (tc == 0) return;
		for (line in 0...4) {
			final index = start + line * along;
			final p = samples.get(index - step);
			final q = samples.get(index);
			final delta = clip((4 * (q - p) + samples.get(index - 2 * step) - samples.get(index + step) + 4) >> 3, -tc, tc);
			samples.set(index - step, clip(p + delta, 0, 255));
			samples.set(index, clip(q - delta, 0, 255));
		}
	}

	static function neighbors(samples:Bytes, index:Int, step:Int):Array<Int>
		return [for (i in -4...4) samples.get(index + i * step)];

	static inline function curvature(samples:Array<Int>, start:Int, direction:Int):Int
		return abs(samples[start + 2 * direction] - 2 * samples[start + direction] + samples[start]);

	static inline function strongEdge(p:Array<Int>, d:Int, beta:Int, tc:Int):Bool
		return abs(p[0] - p[3]) + abs(p[7] - p[4]) < (beta >> 3)
			&& abs(p[3] - p[4]) < ((tc * 5 + 1) >> 1) && (d << 1) < (beta >> 2);

	static inline function setNear(samples:Bytes, index:Int, original:Int, desired:Int, limit:Int):Void
		samples.set(index, clip(original + clip(desired - original, -limit, limit), 0, 255));

	static inline function abs(value:Int):Int return value < 0 ? -value : value;
	static inline function clip(value:Int, min:Int, max:Int):Int return value < min ? min : value > max ? max : value;
}

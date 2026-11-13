/*
 * SPDX-License-Identifier: LGPL-2.1-or-later
 * Portions based on FFmpeg n4.4 libavcodec/hevcdec.c
 * Copyright (C) 2012-2013 Guillaume Martres, Mickael Raulet, Gildas Cocherel, and Wassim Hamidouche
 * Adapted to Haxe for Vision. See COPYING.LGPLv2.1 in this directory.
 * This code is distributed without any warranty.
 */

package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;

/** Tracks reconstructed intra modes and decodes prediction-unit mode syntax. **/
@:noCompletion
class HevcIntraModes {
	static final chromaModes = [0, 26, 10, 1];

	final modes:Bytes;
	final stride:Int;
	final ctbMask:Int;

	public function new(width:Int, height:Int, ctbLog2:Int) {
		stride = (width + 3) >> 2;
		modes = Bytes.alloc(stride * ((height + 3) >> 2));
		modes.fill(0, modes.length, 1);
		ctbMask = (1 << ctbLog2) - 1;
	}

	/** Decodes the luma prediction units in one coding unit, in raster order. **/
	public function readLuma(cabac:HevcCabacDecoder, context:HevcCabacContext, x:Int, y:Int, size:Int, split:Bool):Array<Int> {
		final units = split ? 2 : 1;
		final step = size >> (split ? 1 : 0);
		final predicted = [for (_ in 0...units * units) cabac.readBin(context) != 0];
		final result = [];
		for (row in 0...units) for (column in 0...units) {
			final px = x + column * step;
			final py = y + row * step;
			final cell = (py >> 2) * stride + (px >> 2);
			final left = px == 0 ? 1 : modes.get(cell - 1);
			final above = (py & ctbMask) == 0 ? 1 : modes.get(cell - stride);
			final candidates = likely(left, above);
			var mode:Int;
			if (predicted[row * units + column]) {
				final index = cabac.readBypass() == 0 ? 0 : 1 + cabac.readBypass();
				mode = candidates[index];
			} else {
				mode = 0;
				for (_ in 0...5) mode = (mode << 1) | cabac.readBypass();
				candidates.sort((a, b) -> a - b);
				for (candidate in candidates) if (mode >= candidate) mode++;
			}
			for (line in 0...(step >> 2)) modes.fill(cell + line * stride, step >> 2, mode);
			result.push(mode);
		}
		return result;
	}

	/** Decodes the chroma mode for a 4:2:0 intra coding unit. **/
	public static function readChroma(cabac:HevcCabacDecoder, context:HevcCabacContext, luma:Int):Int {
		if (cabac.readBin(context) == 0) return luma;
		final mode = chromaModes[(cabac.readBypass() << 1) | cabac.readBypass()];
		return mode == luma ? 34 : mode;
	}

	static function likely(left:Int, above:Int):Array<Int> {
		if (left == above) return left < 2 ? [0, 1, 26] : [left, 2 + ((left + 29) & 31), 2 + ((left - 1) & 31)];
		final third = left != 0 && above != 0 ? 0 : left != 1 && above != 1 ? 1 : 26;
		return [left, above, third];
	}
}

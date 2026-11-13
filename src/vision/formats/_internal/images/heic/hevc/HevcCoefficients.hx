/*
 * SPDX-License-Identifier: LGPL-2.1-or-later
 * Portions based on FFmpeg n4.4 libavcodec/hevc_cabac.c
 * Copyright (C) 2012-2013 Guillaume Martres; 2012-2013 Gildas Cocherel
 * Adapted to Haxe for Vision. See COPYING.LGPLv2.1 in this directory.
 * This code is distributed without any warranty.
 */

package vision.formats._internal.images.heic.hevc;

import vision.exceptions.HevcBitstreamError;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;

/** Adaptive coefficient syntax for HEVC Main intra transform blocks. **/
@:noCompletion
class HevcCoefficients {
	static final lastInit = [110,110,124,125,140,153,125,127,140,109,111,143,127,111,79,108,123,63];
	static final significanceInit = [
		111,111,125,110,110,94,124,108,124,107,125,141,179,153,125,107,125,141,179,153,125,107,
		125,141,179,153,125,140,139,182,182,152,136,152,136,153,136,139,111,136,139,111
	];
	static final greaterInit = [
		140,92,137,138,140,152,138,139,153,74,149,92,139,107,122,152,140,179,166,182,140,227,122,197
	];
	static final smallContexts = [0,1,4,5,2,3,4,5,6,6,8,8,7,7,8,8];
	var lastX:Array<HevcCabacContext>;
	var lastY:Array<HevcCabacContext>;
	var group:Array<HevcCabacContext>;
	var significance:Array<HevcCabacContext>;
	var greaterOne:Array<HevcCabacContext>;
	var greaterTwo:Array<HevcCabacContext>;

	/** Initializes coefficient probabilities using the slice QP. **/
	public function new(qp:Int) {
		lastX = init(qp, lastInit);
		lastY = init(qp, lastInit);
		group = init(qp, [91,171,134,141]);
		significance = init(qp, significanceInit);
		greaterOne = init(qp, greaterInit);
		greaterTwo = init(qp, [138,153,136,167,152,152]);
	}

	/** Captures the adaptive coefficient state for the following CTB row. **/
	public function copy():HevcCoefficients {
		final result = new HevcCoefficients(0);
		result.lastX = [for (value in lastX) value.copy()];
		result.lastY = [for (value in lastY) value.copy()];
		result.group = [for (value in group) value.copy()];
		result.significance = [for (value in significance) value.copy()];
		result.greaterOne = [for (value in greaterOne) value.copy()];
		result.greaterTwo = [for (value in greaterTwo) value.copy()];
		return result;
	}

	/** Reads signed coefficient levels in raster order for a nonempty transform block. **/
	public function read(cabac:HevcCabacDecoder, logSize:Int, chroma:Bool, intraMode:Int, signHiding:Bool):Array<Int> {
		if (logSize < 2 || logSize > 5) throw new HevcBitstreamError("Invalid HEVC coefficient block size.");
		final size = 1 << logSize;
		final grid = size >> 2;
		// Intra modes close to the vertical axis use a horizontal scan, and vice versa.
		final scan = logSize <= (chroma ? 2 : 3) && intraMode >= 6 && intraMode <= 14 ? 2
			: logSize <= (chroma ? 2 : 3) && intraMode >= 22 && intraMode <= 30 ? 1 : 0;
		final offset = chroma ? 15 : 3 * (logSize - 2) + ((logSize - 1) >> 2);
		final shift = chroma ? logSize - 2 : (logSize + 1) >> 2;
		final limit = 2 * logSize - 1;
		final prefixX = prefix(cabac, lastX, offset, shift, limit);
		final prefixY = prefix(cabac, lastY, offset, shift, limit);
		final codedX = coordinate(cabac, prefixX);
		final codedY = coordinate(cabac, prefixY);
		final x = scan == 2 ? codedY : codedX;
		final y = scan == 2 ? codedX : codedY;
		final groups = order(grid, scan);
		final positions = order(4, scan);
		final lastGroup = groups.indexOf((y >> 2) * grid + (x >> 2));
		final lastPosition = positions.indexOf((y & 3) * 4 + (x & 3));
		final present = [for (_ in 0...grid * grid) false];
		final levels = [for (_ in 0...size * size) 0];
		var previousGreater = 1;
		var g = lastGroup;
		while (g >= 0) {
			final entry = groups[g];
			final gx = entry % grid;
			final gy = Std.int(entry / grid);
			final right = gx + 1 < grid && present[entry + 1];
			final below = gy + 1 < grid && present[entry + grid];
			final interior = g != lastGroup && g != 0;
			present[entry] = !interior || cabac.readBin(group[(chroma ? 2 : 0) + (right || below ? 1 : 0)]) != 0;
			if (present[entry]) {
				final flags = g == lastGroup ? [lastPosition] : [];
				final base = (chroma ? 27 : 0) + (logSize == 2 ? 0 : chroma ? (logSize == 3 ? 9 : 12)
					: (entry != 0 ? 3 : 0) + (logSize == 3 ? (scan == 0 ? 9 : 15) : 21));
				var position = g == lastGroup ? lastPosition - 1 : 15;
				while (position > 0) {
					final raster = positions[position];
					final sx = raster & 3;
					final sy = raster >> 2;
					final ctx = logSize == 2 ? smallContexts[raster] : right
						? (below ? 2 : sy == 0 ? 2 : sy == 1 ? 1 : 0)
						: below ? (sx == 0 ? 2 : sx == 1 ? 1 : 0) : sx + sy == 0 ? 2 : sx + sy < 3 ? 1 : 0;
					if (cabac.readBin(significance[base + ctx]) != 0) flags.push(position);
					position--;
				}
				if (position == 0 && ((interior && flags.length == 0)
					|| cabac.readBin(significance[g == 0 ? (chroma ? 27 : 0) : base + 2]) != 0)) flags.push(0);
				if (flags.length != 0) {
					final contextSet = (!chroma && g > 0 ? 2 : 0) + (g != lastGroup && previousGreater == 0 ? 1 : 0);
					previousGreater = readLevels(cabac, levels, flags, positions, size, gx, gy, contextSet, chroma, signHiding);
				}
			}
			g--;
		}
		return levels;
	}

	function readLevels(cabac:HevcCabacDecoder, output:Array<Int>, flags:Array<Int>, positions:Array<Int>, size:Int,
		gx:Int, gy:Int, contextSet:Int, chroma:Bool, signHiding:Bool):Int {
		final count = flags.length;
		final amplitudes = [for (_ in flags) 1];
		var state = 1;
		var firstLarge = -1;
		for (i in 0...(count < 8 ? count : 8)) {
			if (cabac.readBin(greaterOne[(chroma ? 16 : 0) + contextSet * 4 + state]) != 0) {
				amplitudes[i]++;
				state = 0;
				if (firstLarge < 0) firstLarge = i;
			} else if (state > 0 && state < 3) state++;
		}
		if (firstLarge >= 0) amplitudes[firstLarge] += cabac.readBin(greaterTwo[(chroma ? 4 : 0) + contextSet]);
		final hidden = signHiding && flags[0] - flags[count - 1] >= 4;
		final signs = [for (_ in 0...(hidden ? count - 1 : count)) cabac.readBypass()];
		var sum = 0;
		var rice = 0;
		for (i in 0...count) {
			var level = amplitudes[i];
			if (i >= 8 || level == (i == firstLarge ? 3 : 2)) {
				level += remaining(cabac, rice);
				if (rice < 4 && level > (3 << rice)) rice++;
			}
			sum += level;
			final negative = hidden && i == count - 1 ? (sum & 1) != 0 : signs[i] != 0;
			if (level > (negative ? 32768 : 32767)) throw new HevcBitstreamError("HEVC coefficient level is out of range.");
			final raster = positions[flags[i]];
			output[(gy * 4 + (raster >> 2)) * size + gx * 4 + (raster & 3)] = negative ? -level : level;
		}
		return state;
	}

	static function order(side:Int, scan:Int):Array<Int> {
		final result = [];
		if (scan == 0) {
			for (diagonal in 0...2 * side - 1) {
				final first = diagonal < side ? 0 : diagonal - side + 1;
				final last = diagonal < side ? diagonal : side - 1;
				for (x in first...last + 1) result.push((diagonal - x) * side + x);
			}
		} else {
			for (y in 0...side) for (x in 0...side) result.push(scan == 1 ? y * side + x : x * side + y);
		}
		return result;
	}

	static function prefix(cabac:HevcCabacDecoder, contexts:Array<HevcCabacContext>, offset:Int, shift:Int, limit:Int):Int {
		var value = 0;
		while (value < limit && cabac.readBin(contexts[offset + (value >> shift)]) != 0) value++;
		return value;
	}

	static function coordinate(cabac:HevcCabacDecoder, prefix:Int):Int {
		if (prefix < 4) return prefix;
		final bits = (prefix >> 1) - 1;
		return ((2 + (prefix & 1)) << bits) + literal(cabac, bits);
	}

	static function remaining(cabac:HevcCabacDecoder, rice:Int):Int {
		var prefix = 0;
		while (cabac.readBypass() != 0) {
			if (++prefix > 18) throw new HevcBitstreamError("Invalid HEVC coefficient Rice prefix.");
		}
		if (prefix < 3) return (prefix << rice) + literal(cabac, rice);
		final extra = prefix - 3;
		return (((1 << extra) + 2) << rice) + literal(cabac, extra + rice);
	}

	static function literal(cabac:HevcCabacDecoder, bits:Int):Int {
		var value = 0;
		for (_ in 0...bits) value = (value << 1) | cabac.readBypass();
		return value;
	}

	static function init(qp:Int, values:Array<Int>):Array<HevcCabacContext>
		return [for (value in values) new HevcCabacContext(qp, value)];
}

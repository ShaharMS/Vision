/*
 * SPDX-License-Identifier: LGPL-2.1-or-later
 * Portions based on FFmpeg n4.4 libavcodec/hevc_cabac.c
 * Copyright (C) 2012-2013 Guillaume Martres; 2012-2013 Gildas Cocherel
 * Adapted to Haxe for Vision. See COPYING.LGPLv2.1 in this directory.
 * This code is distributed without any warranty.
 */

package vision.formats._internal.images.heic.hevc;

import haxe.io.Bytes;
import vision.formats._internal.images.heic.hevc.HevcCabacDecoder.HevcCabacContext;

/** Reads HEVC sample adaptive offsets and applies them to a deblocked 8-bit picture. **/
@:noCompletion
class HevcSao {
	static final directions = [[1, 0], [0, 1], [1, 1], [1, -1]];
	final columns:Int;
	final rows:Int;
	final size:Int;
	final units:Array<Array<SaoOffset>>;
	final luma:Bool;
	final chroma:Bool;

	public function new(width:Int, height:Int, size:Int, luma:Bool, chroma:Bool) {
		this.size = size;
		this.luma = luma;
		this.chroma = chroma;
		columns = Std.int((width + size - 1) / size);
		rows = Std.int((height + size - 1) / size);
		units = [for (_ in 0...columns * rows) null];
	}

	/** Reads the offsets before the coding tree of a CTB in raster order. **/
	public function read(cabac:HevcCabacDecoder, merge:HevcCabacContext, type:HevcCabacContext, column:Int, row:Int):Void {
		if (!luma && !chroma) return;
		final index = row * columns + column;
		if (column > 0 && cabac.readBin(merge) != 0) {
			units[index] = units[index - 1];
			return;
		}
		if (row > 0 && cabac.readBin(merge) != 0) {
			units[index] = units[index - columns];
			return;
		}
		final y = luma ? readOffset(cabac, readType(cabac, type)) : Off;
		final uvType = chroma ? readType(cabac, type) : 0;
		final cb = readOffset(cabac, uvType);
		final cr = switch cb {
			case Edge(axis, _): readOffset(cabac, uvType, axis);
			default: readOffset(cabac, uvType);
		};
		units[index] = [y, cb, cr];
	}

	/** Filters one plane using only the original deblocked samples as references. **/
	public function apply(source:Bytes, width:Int, height:Int, plane:Int, subX:Int, subY:Int):Bytes {
		if (plane == 0 ? !luma : !chroma) return source;
		final output = source.sub(0, source.length);
		final blockWidth = size >> subX;
		final blockHeight = size >> subY;
		for (row in 0...rows) for (column in 0...columns) {
			final unit = units[row * columns + column];
			if (unit == null) continue;
			final x = column * blockWidth;
			final y = row * blockHeight;
			final right = min(width, x + blockWidth);
			final bottom = min(height, y + blockHeight);
			switch unit[plane] {
				case Off:
				case Band(first, offsets):
					for (py in y...bottom) for (px in x...right) {
						final index = py * width + px;
						final value = source.get(index);
						final band = ((value >> 3) - first) & 31;
						if (band < 4) output.set(index, clip(value + offsets[band]));
					}
				case Edge(axis, offsets):
					final dx = directions[axis][0];
					final dy = directions[axis][1];
					final step = dy * width + dx;
					for (py in y...bottom) for (px in x...right) {
						if (px - dx < 0 || px + dx >= width || py - dy < 0 || py - dy >= height || py + dy < 0 || py + dy >= height)
							continue;
						final index = py * width + px;
						final value = source.get(index);
						final category = sign(value - source.get(index - step)) + sign(value - source.get(index + step));
						if (category != 0) output.set(index, clip(value + offsets[category < 0 ? category + 2 : category + 1]));
					}
			}
		}
		return output;
	}

	static inline function readType(cabac:HevcCabacDecoder, context:HevcCabacContext):Int
		return cabac.readBin(context) == 0 ? 0 : 1 + cabac.readBypass();

	static function readOffset(cabac:HevcCabacDecoder, type:Int, axis:Int = -1):SaoOffset {
		if (type == 0) return Off;
		final offsets = [];
		for (_ in 0...4) {
			var value = 0;
			while (value < 7 && cabac.readBypass() != 0) value++;
			offsets.push(value);
		}
		if (type == 1) {
			for (i in 0...4) if (offsets[i] != 0 && cabac.readBypass() != 0) offsets[i] = -offsets[i];
			var band = 0;
			for (_ in 0...5) band = (band << 1) | cabac.readBypass();
			return Band(band, offsets);
		}
		offsets[2] = -offsets[2];
		offsets[3] = -offsets[3];
		return Edge(axis < 0 ? (cabac.readBypass() << 1) | cabac.readBypass() : axis, offsets);
	}

	static inline function clip(value:Int):Int return value < 0 ? 0 : value > 255 ? 255 : value;
	static inline function sign(value:Int):Int return value < 0 ? -1 : value > 0 ? 1 : 0;
	static inline function min(a:Int, b:Int):Int return a < b ? a : b;
}

private enum SaoOffset {
	Off;
	Band(first:Int, offsets:Array<Int>);
	Edge(axis:Int, offsets:Array<Int>);
}

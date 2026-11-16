package vision.formats._internal.images.webp;

// Adapted from golang.org/x/image/vp8, copyright The Go Authors. See VP8-LICENSE.

import haxe.io.Bytes;
import vision.ds.ByteArray;
import vision.ds.Color;
import vision.ds.Image;

private typedef Vp8Block = {pred:Array<Int>, nzMask:Int, nzY16:Int};
private typedef Vp8Quant = {y1:Array<Int>, y2:Array<Int>, uv:Array<Int>};
private typedef Vp8Filter = {level:Int, ilevel:Int, hlevel:Int, inner:Bool};

/** Decodes the VP8 key frames used in WebP (RFC 6386). **/
@:noCompletion
class Vp8Decoder {
	static inline final uniformProb = 128;
	static inline final nSegment = 4;
	static inline final planeY1WithY2 = 0;
	static inline final planeY2 = 1;
	static inline final planeUV = 2;
	static inline final planeY1SansY2 = 3;
	static inline final bCoeffBase = 256;
	static inline final rCoeffBase = 320;
	static inline final whtCoeffBase = 384;
	static inline final ybrBX = 8;
	static inline final ybrBY = 18;
	static inline final ybrRX = 24;
	static inline final ybrRY = 18;
	static inline final predDC = 0;
	static inline final predTM = 1;
	static inline final predVE = 2;
	static inline final predHE = 3;
	static inline final predRD = 4;
	static inline final predVR = 5;
	static inline final predLD = 6;
	static inline final predVL = 7;
	static inline final predHD = 8;
	static inline final predHU = 9;

	public final width:Int;
	public final height:Int;
	final mbw:Int;
	final mbh:Int;
	final yStride:Int;
	final cStride:Int;
	final luma:ByteArray;
	final cb:ByteArray;
	final cr:ByteArray;
	final fp:Vp8Partition;
	final op:Array<Vp8Partition>;
	final nOP:Int;
	final quant:Array<Vp8Quant> = [];
	final tokenProb = [for (plane in Vp8Tables.defaultTokenProb)
		[for (band in plane) [for (context in band) context.copy()]]];
	final upMB:Array<Vp8Block>;
	var leftMB:Vp8Block;
	final predY4 = [for (_ in 0...4) [0, 0, 0, 0]];
	final coeff = [for (_ in 0...400) 0];
	// Luma occupies rows 1 through 16 at x=8. Chroma occupies rows 18
	// through 25 at x=8 and x=24. Adjacent cells hold predictor borders.
	final ybr = [for (_ in 0...26) [for (_ in 0...32) 0]];
	var segment = 0;
	var predY16 = 0;
	var predC8 = 0;
	var usePredY16 = false;
	var nzDCMask = 0;
	var nzACMask = 0;
	var useSkipProb = false;
	var skipProb = 0;
	final segmentHeader = {
		useSegment: false, updateMap: false, relativeDelta: true,
		quantizer: [0, 0, 0, 0], filterStrength: [0, 0, 0, 0], prob: [255, 255, 255]
	};
	final filterHeader = {
		simple: false, level: 0, sharpness: 0, useLFDelta: false, refLFDelta: [0, 0, 0, 0], modeLFDelta: [0, 0, 0, 0]
	};
	final filterParams:Array<Array<Vp8Filter>> = [for (_ in 0...4)
		[for (mode in 0...2) {level: 0, ilevel: 0, hlevel: 0, inner: mode != 0}]];
	final perMBFilterParams:Array<Vp8Filter> = [];

	public function new(input:ByteArray) {
		if (input.length < 11 || (input[0] & 1) != 0 || ((input[0] >> 1) & 7) > 3
			|| input[3] != 0x9d || input[4] != 1 || input[5] != 0x2a)
			throw WebpContainer.invalid("Invalid WebP VP8 key frame.");
		width = (input[6] | (input[7] << 8)) & 0x3fff;
		height = (input[8] | (input[9] << 8)) & 0x3fff;
		if (width == 0 || height == 0 || width * height > 32000000)
			throw WebpContainer.invalid("Invalid VP8 dimensions.");
		final partitionEnd = 10 + ((input[0] >> 5) | (input[1] << 3) | (input[2] << 11));
		if (partitionEnd > input.length) throw WebpContainer.invalid("Truncated VP8 header partition.");
		fp = new Vp8Partition(input, 10, partitionEnd);
		fp.readBit(uniformProb); // color space
		fp.readBit(uniformProb); // pixel clamping
		parseSegmentHeader();
		parseFilterHeader();
		nOP = 1 << fp.readUint(uniformProb, 2);
		op = [];
		var position = partitionEnd + (nOP - 1) * 3;
		if (position > input.length) throw WebpContainer.invalid("Truncated VP8 partition table.");
		for (i in 0...nOP) {
			final offset = partitionEnd + i * 3;
			final size = i == nOP - 1 ? input.length - position : input[offset] | (input[offset + 1] << 8) | (input[offset + 2] << 16);
			if (size > input.length - position) throw WebpContainer.invalid("Truncated VP8 coefficient partition.");
			op.push(new Vp8Partition(input, position, position + size));
			position += size;
		}
		for (_ in 0...4) quant.push({y1: [0, 0], y2: [0, 0], uv: [0, 0]});
		parseQuant();
		fp.readBit(uniformProb); // refresh entropy probabilities
		parseTokenProb();
		useSkipProb = fp.readBit(uniformProb);
		if (useSkipProb) skipProb = fp.readUint(uniformProb, 8);
		mbw = (width + 15) >> 4;
		mbh = (height + 15) >> 4;
		yStride = mbw * 16;
		cStride = mbw * 8;
		luma = Bytes.alloc(yStride * mbh * 16);
		cb = Bytes.alloc(cStride * mbh * 8);
		cr = Bytes.alloc(cStride * mbh * 8);
		upMB = [for (_ in 0...mbw) block()];
	}

	public function read(?alpha:ByteArray):Image {
		for (mby in 0...mbh) {
			leftMB = block();
			for (mbx in 0...mbw) {
				final skip = reconstruct(mbx, mby);
				final f = filterParams[segment][btou(!usePredY16)];
				perMBFilterParams.push({level: f.level, ilevel: f.ilevel, hlevel: f.hlevel, inner: f.inner || !skip});
			}
		}
		if (filterHeader.level != 0) {
			if (filterHeader.simple) simpleFilter(); else normalFilter();
		}
		final image = new Image(width, height);
		final lastColumn = (width - 1) >> 1;
		final lastRow = (height - 1) >> 1;
		for (y in 0...height) {
			final chromaY = y >> 1;
			final nearRow = chromaY * cStride;
			final farRow = clip(chromaY + ((y & 1) == 0 ? -1 : 1), 0, lastRow) * cStride;
			for (x in 0...width) {
				final nearX = x >> 1;
				final farX = clip(nearX + ((x & 1) == 0 ? -1 : 1), 0, lastColumn);
				final yValue = luma[y * yStride + x] - 16;
				final u = upsample(cb, nearRow, farRow, nearX, farX) - 128;
				final v = upsample(cr, nearRow, farRow, nearX, farX) - 128;
				final r = clip8((298 * yValue + 409 * v + 128) >> 8);
				final g = clip8((298 * yValue - 100 * u - 208 * v + 128) >> 8);
				final b = clip8((298 * yValue + 516 * u + 128) >> 8);
				image.setUnsafePixel(x, y, Color.fromRGBA(r, g, b, alpha == null ? 255 : alpha[y * width + x]));
			}
		}
		return image;
	}

	// Bilinear interpolation of centered 4:2:0 chroma samples.
	static inline function upsample(plane:ByteArray, nearRow:Int, farRow:Int, nearX:Int, farX:Int):Int {
		return (9 * plane[nearRow + nearX] + 3 * (plane[nearRow + farX] + plane[farRow + nearX]) + plane[farRow + farX] + 8) >> 4;
	}

	static inline function block():Vp8Block return {pred: [0, 0, 0, 0], nzMask: 0, nzY16: 0};
	static inline function btou(value:Bool):Int return value ? 1 : 0;
	static inline function pack(x:Array<Int>, shift:Int):Int return (x[0] | (x[1] << 1) | (x[2] << 2) | (x[3] << 3)) << shift;
	static inline function int16(value:Int):Int return ((value & 0xffff) ^ 0x8000) - 0x8000;
	static inline function clip(value:Int, min:Int, max:Int):Int return value < min ? min : value > max ? max : value;
	static inline function clip8(value:Int):Int return clip(value, 0, 255);
	static inline function clamp255(value:Int):Int return clip8(value);
	static inline function clamp127(value:Int):Int return clip(value, -128, 127);
	static inline function clamp15(value:Int):Int return clip(value, -16, 15);
	static inline function abs(value:Int):Int return value < 0 ? -value : value;
	static inline function checkTopLeftPred(mbx:Int, mby:Int, p:Int):Int {
		if (p != predDC) return p;
		return mbx == 0 ? (mby == 0 ? 12 : 11) : (mby == 0 ? 10 : 0);
	}

	function parseSegmentHeader():Void {
		segmentHeader.useSegment = fp.readBit(uniformProb);
		if (!segmentHeader.useSegment) {
			segmentHeader.updateMap = false;
			return;
		}
		segmentHeader.updateMap = fp.readBit(uniformProb);
		if (fp.readBit(uniformProb)) {
			segmentHeader.relativeDelta = !fp.readBit(uniformProb);
			for (i in 0...segmentHeader.quantizer.length) {
				segmentHeader.quantizer[i] = (fp.readOptionalInt(uniformProb, 7));
			}
			for (i in 0...segmentHeader.filterStrength.length) {
				segmentHeader.filterStrength[i] = (fp.readOptionalInt(uniformProb, 6));
			}
		}
		if (!segmentHeader.updateMap) {
			return;
		}
		for (i in 0...segmentHeader.prob.length) {
			if (fp.readBit(uniformProb)) {
				segmentHeader.prob[i] = (fp.readUint(uniformProb, 8));
			} else {
				segmentHeader.prob[i] = 0xff;
			}
		}
	}

	function parseFilterHeader():Void {
		filterHeader.simple = fp.readBit(uniformProb);
		filterHeader.level = (fp.readUint(uniformProb, 6));
		filterHeader.sharpness = (fp.readUint(uniformProb, 3));
		filterHeader.useLFDelta = fp.readBit(uniformProb);
		if (filterHeader.useLFDelta && fp.readBit(uniformProb)) {
			for (i in 0...filterHeader.refLFDelta.length) {
				filterHeader.refLFDelta[i] = (fp.readOptionalInt(uniformProb, 6));
			}
			for (i in 0...filterHeader.modeLFDelta.length) {
				filterHeader.modeLFDelta[i] = (fp.readOptionalInt(uniformProb, 6));
			}
		}
		if (filterHeader.level != 0) {
			computeFilterParams();
		}
	}

	function parseQuant():Void {
		var baseQ0 = fp.readUint(uniformProb, 7);
		var dqy1DC = fp.readOptionalInt(uniformProb, 4);
		final dqy1AC = 0;
		var dqy2DC = fp.readOptionalInt(uniformProb, 4);
		var dqy2AC = fp.readOptionalInt(uniformProb, 4);
		var dquvDC = fp.readOptionalInt(uniformProb, 4);
		var dquvAC = fp.readOptionalInt(uniformProb, 4);
		for (i in 0...nSegment) {
			var q = (baseQ0);
			if (segmentHeader.useSegment) {
				if (segmentHeader.relativeDelta) {
					q += (segmentHeader.quantizer[i]);
				} else {
					q = (segmentHeader.quantizer[i]);
				}
			}
			quant[i].y1[0] = Vp8Tables.dequantTableDC[clip(q+dqy1DC, 0, 127)];
			quant[i].y1[1] = Vp8Tables.dequantTableAC[clip(q+dqy1AC, 0, 127)];
			quant[i].y2[0] = Vp8Tables.dequantTableDC[clip(q+dqy2DC, 0, 127)] * 2;
			quant[i].y2[1] = Vp8Tables.dequantTableAC[clip(q+dqy2AC, 0, 127)] * 155;
			quant[i].y2[1] = Std.int(quant[i].y2[1] / 100);
			if (quant[i].y2[1] < 8) {
				quant[i].y2[1] = 8;
			}
			// The 117 is not a typo. The dequant_init function in the spec's Reference
			// Decoder Source Code (http://tools.ietf.org/html/rfc6386#section-9.6 Page 145)
			// says to clamp the LHS value at 132, which is equal to Vp8Tables.dequantTableDC[117].
			quant[i].uv[0] = Vp8Tables.dequantTableDC[clip(q+dquvDC, 0, 117)];
			quant[i].uv[1] = Vp8Tables.dequantTableAC[clip(q+dquvAC, 0, 127)];
		}
	}

	function parseTokenProb():Void {
		for (i in 0...tokenProb.length) {
			for (j in 0...tokenProb[i].length) {
				for (k in 0...tokenProb[i][j].length) {
					for (l in 0...tokenProb[i][j][k].length) {
						if (fp.readBit(Vp8Tables.tokenProbUpdateProb[i][j][k][l])) {
							tokenProb[i][j][k][l] = (fp.readUint(uniformProb, 8));
						}
					}
				}
			}
		}
	}

	function parsePredModeY16(mbx:Int):Void {
		var p = 0;
		if (!fp.readBit(156)) {
			if (!fp.readBit(163)) {
				p = predDC;
			} else {
				p = predVE;
			}
		} else if (!fp.readBit(128)) {
			p = predHE;
		} else {
			p = predTM;
		}
		for (i in 0...4) {
			upMB[mbx].pred[i] = p;
			leftMB.pred[i] = p;
		}
		predY16 = p;
	}

	function parsePredModeC8():Void {
		if (!fp.readBit(142)) {
			predC8 = predDC;
		} else if (!fp.readBit(114)) {
			predC8 = predVE;
		} else if (!fp.readBit(183)) {
			predC8 = predHE;
		} else {
			predC8 = predTM;
		}
	}

	function parsePredModeY4(mbx:Int):Void {
		for (j in 0...4) {
			var p = leftMB.pred[j];
			for (i in 0...4) {
				var prob = Vp8Tables.predProb[upMB[mbx].pred[i]][p];
				if (!fp.readBit(prob[0])) {
					p = predDC;
				} else if (!fp.readBit(prob[1])) {
					p = predTM;
				} else if (!fp.readBit(prob[2])) {
					p = predVE;
				} else if (!fp.readBit(prob[3])) {
					if (!fp.readBit(prob[4])) {
						p = predHE;
					} else if (!fp.readBit(prob[5])) {
						p = predRD;
					} else {
						p = predVR;
					}
				} else if (!fp.readBit(prob[6])) {
					p = predLD;
				} else if (!fp.readBit(prob[7])) {
					p = predVL;
				} else if (!fp.readBit(prob[8])) {
					p = predHD;
				} else {
					p = predHU;
				}
				predY4[j][i] = p;
				upMB[mbx].pred[i] = p;
			}
			leftMB.pred[j] = p;
		}
	}

	function prepareYBR(mbx:Int, mby:Int):Void {
		if (mbx == 0) {
			for (y in 0...17) {
				ybr[y][7] = 0x81;
			}
			for (y in 17...26) {
				ybr[y][7] = 0x81;
				ybr[y][23] = 0x81;
			}
		} else {
			for (y in 0...17) {
				ybr[y][7] = ybr[y][7+16];
			}
			for (y in 17...26) {
				ybr[y][7] = ybr[y][15];
				ybr[y][23] = ybr[y][31];
			}
		}
		if (mby == 0) {
			for (x in 7...28) {
				ybr[0][x] = 0x7f;
			}
			for (x in 7...16) {
				ybr[17][x] = 0x7f;
			}
			for (x in 23...32) {
				ybr[17][x] = 0x7f;
			}
		} else {
			for (i in 0...16) {
				ybr[0][8+i] = luma[(16*mby-1)*yStride+16*mbx+i];
			}
			for (i in 0...8) {
				ybr[17][8+i] = cb[(8*mby-1)*cStride+8*mbx+i];
			}
			for (i in 0...8) {
				ybr[17][24+i] = cr[(8*mby-1)*cStride+8*mbx+i];
			}
			if (mbx == mbw-1) {
				for (i in 16...20) {
					ybr[0][8+i] = luma[(16*mby-1)*yStride+16*mbx+15];
				}
			} else {
				for (i in 16...20) {
					ybr[0][8+i] = luma[(16*mby-1)*yStride+16*mbx+i];
				}
			}
		}
		for (step in 0...Std.int((16 - (4)) / 4)) {
			var y = 4 + step * 4;
			ybr[y][24] = ybr[0][24];
			ybr[y][25] = ybr[0][25];
			ybr[y][26] = ybr[0][26];
			ybr[y][27] = ybr[0][27];
		}
	}

	function parseResiduals4(r:Vp8Partition, plane:Int, context:Int, quant:Array<Int>, skipFirstCoeff:Bool, coeffBase:Int):Int {
		var prob = tokenProb[plane];
		var n = 0;
		if (skipFirstCoeff) {
			n = 1;
		}
		var p = prob[Vp8Tables.bands[n]][context];
		if (!r.readBit(p[0])) {
			return 0;
		}
		while (n != 16) {
			n++;
			if (!r.readBit(p[1])) {
				p = prob[Vp8Tables.bands[n]][0];
				continue;
			}
			var v = 0;
			if (!r.readBit(p[2])) {
				v = 1;
				p = prob[Vp8Tables.bands[n]][1];
			} else {
				if (!r.readBit(p[3])) {
					if (!r.readBit(p[4])) {
						v = 2;
					} else {
						v = 3 + r.readUint(p[5], 1);
					}
				} else if (!r.readBit(p[6])) {
					if (!r.readBit(p[7])) {
						// Category 1.
						v = 5 + r.readUint(159, 1);
					} else {
						// Category 2.
						v = 7 + 2*r.readUint(165, 1) + r.readUint(145, 1);
					}
				} else {
					// Categories 3, 4, 5 or 6.
					var b1 = r.readUint(p[8], 1);
					var b0 = r.readUint(p[9+b1], 1);
					var cat = 2*b1 + b0;
					var tab = Vp8Tables.cat3456[cat];
					v = 0;
					for (i in 0...tab.length) {
						if (tab[i] == 0) break;
						v *= 2;
						v += r.readUint(tab[i], 1);
					}
					v += 3 + (8 << cat);
				}
				p = prob[Vp8Tables.bands[n]][2];
			}
			var z = Vp8Tables.zigzag[n-1];
			var c = (v) * (quant[btou(z > 0)]);
			if (r.readBit(uniformProb)) {
				c = -c;
			}
			coeff[coeffBase+(z)] = int16(c);
			if (n == 16 || !r.readBit(p[0])) {
				return 1;
			}
		}
		return 1;
	}

	function parseResiduals(mbx:Int, mby:Int):Bool {
		var partition = op[mby&(nOP-1)];
		var plane = planeY1SansY2;
		var quant = quant[segment];

		// Parse the DC coefficient of each 4x4 luma region.
		if (usePredY16) {
			var nz = parseResiduals4(partition, planeY2, leftMB.nzY16+upMB[mbx].nzY16, quant.y2, false, whtCoeffBase);
			leftMB.nzY16 = nz;
			upMB[mbx].nzY16 = nz;
			inverseWHT16();
			plane = planeY1WithY2;
		}

		var nzDC = [0, 0, 0, 0];
		var nzAC = [0, 0, 0, 0];
		var dcMask = 0;
		var acMask = 0;
		var coeffBase = 0;

		// Parse the luma coefficients.
		var lnz = Vp8Tables.unpack[leftMB.nzMask & 0x0f].copy();
		var unz = Vp8Tables.unpack[upMB[mbx].nzMask & 0x0f].copy();
		for (y in 0...4) {
			var nz = lnz[y];
			for (x in 0...4) {
				nz = parseResiduals4(partition, plane, nz+unz[x], quant.y1, usePredY16, coeffBase);
				unz[x] = nz;
				nzAC[x] = nz;
				nzDC[x] = btou(coeff[coeffBase] != 0);
				coeffBase += 16;
			}
			lnz[y] = nz;
			dcMask |= pack(nzDC, y*4);
			acMask |= pack(nzAC, y*4);
		}
		var lnzMask = pack(lnz, 0);
		var unzMask = pack(unz, 0);

		// Parse the chroma coefficients.
		lnz = Vp8Tables.unpack[leftMB.nzMask >> 4].copy();
		unz = Vp8Tables.unpack[upMB[mbx].nzMask >> 4].copy();
		for (step in 0...Std.int((4 - (0)) / 2)) {
			var c = 0 + step * 2;
			for (y in 0...2) {
				var nz = lnz[y+c];
				for (x in 0...2) {
					nz = parseResiduals4(partition, planeUV, nz+unz[x+c], quant.uv, false, coeffBase);
					unz[x+c] = nz;
					nzAC[y*2+x] = nz;
					nzDC[y*2+x] = btou(coeff[coeffBase] != 0);
					coeffBase += 16;
				}
				lnz[y+c] = nz;
			}
			dcMask |= pack(nzDC, 16+c*2);
			acMask |= pack(nzAC, 16+c*2);
		}
		lnzMask |= pack(lnz, 4);
		unzMask |= pack(unz, 4);

		// Save decoder state.
		leftMB.nzMask = (lnzMask);
		upMB[mbx].nzMask = (unzMask);
		nzDCMask = dcMask;
		nzACMask = acMask;

		// Section 15.1 of the spec says that "Steps 2 and 4 [of the loop filter]
		// are skipped... [if] there is no DCT coefficient coded for the whole
		// macroblock."
		return nzDCMask == 0 && nzACMask == 0;
	}

	function reconstructMacroblock(mbx:Int, mby:Int):Void {
		if (usePredY16) {
			var p = checkTopLeftPred(mbx, mby, predY16);
			Vp8Prediction.predict16(p, ybr, 1, 8);
			for (j in 0...4) {
				for (i in 0...4) {
					var n = 4*j + i;
					var y = 4*j + 1;
					var x = 4*i + 8;
					var mask = (1) << (n);
					if ((nzACMask & mask) != 0) {
						inverseDCT4(y, x, 16*n);
					} else if ((nzDCMask & mask) != 0) {
						inverseDCT4DCOnly(y, x, 16*n);
					}
				}
			}
		} else {
			for (j in 0...4) {
				for (i in 0...4) {
					var n = 4*j + i;
					var y = 4*j + 1;
					var x = 4*i + 8;
					Vp8Prediction.predict4(predY4[j][i], ybr, y, x);
					var mask = (1) << (n);
					if ((nzACMask & mask) != 0) {
						inverseDCT4(y, x, 16*n);
					} else if ((nzDCMask & mask) != 0) {
						inverseDCT4DCOnly(y, x, 16*n);
					}
				}
			}
		}
		var p = checkTopLeftPred(mbx, mby, predC8);
		Vp8Prediction.predict8(p, ybr, ybrBY, ybrBX);
		if ((nzACMask & 0x0f0000) != 0) {
			inverseDCT8(ybrBY, ybrBX, bCoeffBase);
		} else if ((nzDCMask & 0x0f0000) != 0) {
			inverseDCT8DCOnly(ybrBY, ybrBX, bCoeffBase);
		}
		Vp8Prediction.predict8(p, ybr, ybrRY, ybrRX);
		if ((nzACMask & 0xf00000) != 0) {
			inverseDCT8(ybrRY, ybrRX, rCoeffBase);
		} else if ((nzDCMask & 0xf00000) != 0) {
			inverseDCT8DCOnly(ybrRY, ybrRX, rCoeffBase);
		}
	}

	function reconstruct(mbx:Int, mby:Int):Bool {
		if (segmentHeader.updateMap) {
			if (!fp.readBit(segmentHeader.prob[0])) {
				segment = (fp.readUint(segmentHeader.prob[1], 1));
			} else {
				segment = (fp.readUint(segmentHeader.prob[2], 1)) + 2;
			}
		}
		var skip = false;
		if (useSkipProb) {
			skip = fp.readBit(skipProb);
		}
		// Prepare the workspace.
		for (i in 0...coeff.length) {
			coeff[i] = 0;
		}
		prepareYBR(mbx, mby);
		// Parse the predictor modes.
		usePredY16 = fp.readBit(145);
		if (usePredY16) {
			parsePredModeY16(mbx);
		} else {
			parsePredModeY4(mbx);
		}
		parsePredModeC8();
		// Parse the residuals.
		if (!skip) {
			skip = parseResiduals(mbx, mby);
		} else {
			if (usePredY16) {
				leftMB.nzY16 = 0;
				upMB[mbx].nzY16 = 0;
			}
			leftMB.nzMask = 0;
			upMB[mbx].nzMask = 0;
			nzDCMask = 0;
			nzACMask = 0;
		}
		// Reconstruct the YCbCr data and copy it to the image.
		reconstructMacroblock(mbx, mby);
		for (y in 0...16) {
			final i = (mby * 16 + y) * yStride + mbx * 16;
			for (x in 0...16) luma[i + x] = ybr[y + 1][x + 8];
		}
		for (y in 0...8) {
			final i = (mby * 8 + y) * cStride + mbx * 8;
			for (x in 0...8) {
				cb[i + x] = ybr[y + ybrBY][x + ybrBX];
				cr[i + x] = ybr[y + ybrRY][x + ybrRX];
			}
		}
		return skip;
	}

	function inverseDCT4(y:Int, x:Int, coeffBase:Int):Void {
		final c1 = 85627;
		final c2 = 35468;
		var m = [for (_ in 0...4) [0, 0, 0, 0]];
		for (i in 0...4) {
			var a = (coeff[coeffBase+0]) + (coeff[coeffBase+8]);
			var b = (coeff[coeffBase+0]) - (coeff[coeffBase+8]);
			var c = ((coeff[coeffBase+4] * c2) >> 16) - ((coeff[coeffBase+12] * c1) >> 16);
			var d = ((coeff[coeffBase+4] * c1) >> 16) + ((coeff[coeffBase+12] * c2) >> 16);
			m[i][0] = a + d;
			m[i][1] = b + c;
			m[i][2] = b - c;
			m[i][3] = a - d;
			coeffBase++;
		}
		for (j in 0...4) {
			var dc = m[0][j] + 4;
			var a = dc + m[2][j];
			var b = dc - m[2][j];
			var c = ((m[1][j] * c2) >> 16) - ((m[3][j] * c1) >> 16);
			var d = ((m[1][j] * c1) >> 16) + ((m[3][j] * c2) >> 16);
			ybr[y+j][x+0] = clip8((ybr[y+j][x+0]) + ((a+d) >> 3));
			ybr[y+j][x+1] = clip8((ybr[y+j][x+1]) + ((b+c) >> 3));
			ybr[y+j][x+2] = clip8((ybr[y+j][x+2]) + ((b-c) >> 3));
			ybr[y+j][x+3] = clip8((ybr[y+j][x+3]) + ((a-d) >> 3));
		}
	}

	function inverseDCT4DCOnly(y:Int, x:Int, coeffBase:Int):Void {
		var dc = ((coeff[coeffBase+0]) + 4) >> 3;
		for (j in 0...4) {
			for (i in 0...4) {
				ybr[y+j][x+i] = clip8((ybr[y+j][x+i]) + dc);
			}
		}
	}

	function inverseDCT8(y:Int, x:Int, coeffBase:Int):Void {
		inverseDCT4(y+0, x+0, coeffBase+0*16);
		inverseDCT4(y+0, x+4, coeffBase+1*16);
		inverseDCT4(y+4, x+0, coeffBase+2*16);
		inverseDCT4(y+4, x+4, coeffBase+3*16);
	}

	function inverseDCT8DCOnly(y:Int, x:Int, coeffBase:Int):Void {
		inverseDCT4DCOnly(y+0, x+0, coeffBase+0*16);
		inverseDCT4DCOnly(y+0, x+4, coeffBase+1*16);
		inverseDCT4DCOnly(y+4, x+0, coeffBase+2*16);
		inverseDCT4DCOnly(y+4, x+4, coeffBase+3*16);
	}

	function inverseWHT16():Void {
		var m = [for (_ in 0...16) 0];
		for (i in 0...4) {
			var a0 = (coeff[384+0+i]) + (coeff[384+12+i]);
			var a1 = (coeff[384+4+i]) + (coeff[384+8+i]);
			var a2 = (coeff[384+4+i]) - (coeff[384+8+i]);
			var a3 = (coeff[384+0+i]) - (coeff[384+12+i]);
			m[0+i] = a0 + a1;
			m[8+i] = a0 - a1;
			m[4+i] = a3 + a2;
			m[12+i] = a3 - a2;
		}
		var out = 0;
		for (i in 0...4) {
			var dc = m[0+i*4] + 3;
			var a0 = dc + m[3+i*4];
			var a1 = m[1+i*4] + m[2+i*4];
			var a2 = m[1+i*4] - m[2+i*4];
			var a3 = dc - m[3+i*4];
			coeff[out+0] = int16((a0 + a1) >> 3);
			coeff[out+16] = int16((a3 + a2) >> 3);
			coeff[out+32] = int16((a0 - a1) >> 3);
			coeff[out+48] = int16((a3 - a2) >> 3);
			out += 64;
		}
	}

	static function filter2(pix:ByteArray, level:Int, index:Int, iStep:Int, jStep:Int):Void {
		for (step in 0...16) {
			final offset = index + step * iStep;
			var p1 = (pix[offset-2*jStep]);
			var p0 = (pix[offset-1*jStep]);
			var q0 = (pix[offset+0*jStep]);
			var q1 = (pix[offset+1*jStep]);
			if ((abs(p0-q0) << 1) + (abs(p1-q1) >> 1) > level) {
				continue;
			}
			var a = 3*(q0-p0) + clamp127(p1-q1);
			var a1 = clamp15((a + 4) >> 3);
			var a2 = clamp15((a + 3) >> 3);
			pix[offset-1*jStep] = clamp255(p0 + a2);
			pix[offset+0*jStep] = clamp255(q0 - a1);
		}
	}

	static function filter246(pix:ByteArray, n:Int, level:Int, ilevel:Int, hlevel:Int, index:Int, iStep:Int, jStep:Int, fourNotSix:Bool):Void {
		for (step in 0...n) {
			final offset = index + step * iStep;
			var p3 = (pix[offset-4*jStep]);
			var p2 = (pix[offset-3*jStep]);
			var p1 = (pix[offset-2*jStep]);
			var p0 = (pix[offset-1*jStep]);
			var q0 = (pix[offset+0*jStep]);
			var q1 = (pix[offset+1*jStep]);
			var q2 = (pix[offset+2*jStep]);
			var q3 = (pix[offset+3*jStep]);
			if ((abs(p0-q0) << 1) + (abs(p1-q1) >> 1) > level) {
				continue;
			}
			if (abs(p3-p2) > ilevel ||
				abs(p2-p1) > ilevel ||
				abs(p1-p0) > ilevel ||
				abs(q1-q0) > ilevel ||
				abs(q2-q1) > ilevel ||
				abs(q3-q2) > ilevel) {
				continue;
			}
			if (abs(p1-p0) > hlevel || abs(q1-q0) > hlevel) {
				// Filter 2 pixels.
				var a = 3*(q0-p0) + clamp127(p1-q1);
				var a1 = clamp15((a + 4) >> 3);
				var a2 = clamp15((a + 3) >> 3);
				pix[offset-1*jStep] = clamp255(p0 + a2);
				pix[offset+0*jStep] = clamp255(q0 - a1);
			} else if (fourNotSix) {
				// Filter 4 pixels.
				var a = 3 * (q0 - p0);
				var a1 = clamp15((a + 4) >> 3);
				var a2 = clamp15((a + 3) >> 3);
				var a3 = (a1 + 1) >> 1;
				pix[offset-2*jStep] = clamp255(p1 + a3);
				pix[offset-1*jStep] = clamp255(p0 + a2);
				pix[offset+0*jStep] = clamp255(q0 - a1);
				pix[offset+1*jStep] = clamp255(q1 - a3);
			} else {
				// Filter 6 pixels.
				var a = clamp127(3*(q0-p0) + clamp127(p1-q1));
				var a1 = (27*a + 63) >> 7;
				var a2 = (18*a + 63) >> 7;
				var a3 = (9*a + 63) >> 7;
				pix[offset-3*jStep] = clamp255(p2 + a3);
				pix[offset-2*jStep] = clamp255(p1 + a2);
				pix[offset-1*jStep] = clamp255(p0 + a1);
				pix[offset+0*jStep] = clamp255(q0 - a1);
				pix[offset+1*jStep] = clamp255(q1 - a2);
				pix[offset+2*jStep] = clamp255(q2 - a3);
			}
		}
	}

	function simpleFilter():Void {
		for (mby in 0...mbh) {
			for (mbx in 0...mbw) {
				var f = perMBFilterParams[mbw*mby+mbx];
				if (f.level == 0) {
					continue;
				}
				var l = (f.level);
				var yIndex = (mby*yStride + mbx) * 16;
				if (mbx > 0) {
					filter2(luma, l+4, yIndex, yStride, 1);
				}
				if (f.inner) {
					filter2(luma, l, yIndex+0x4, yStride, 1);
					filter2(luma, l, yIndex+0x8, yStride, 1);
					filter2(luma, l, yIndex+0xc, yStride, 1);
				}
				if (mby > 0) {
					filter2(luma, l+4, yIndex, 1, yStride);
				}
				if (f.inner) {
					filter2(luma, l, yIndex+yStride*0x4, 1, yStride);
					filter2(luma, l, yIndex+yStride*0x8, 1, yStride);
					filter2(luma, l, yIndex+yStride*0xc, 1, yStride);
				}
			}
		}
	}

	function normalFilter():Void {
		for (mby in 0...mbh) {
			for (mbx in 0...mbw) {
				var f = perMBFilterParams[mbw*mby+mbx];
				if (f.level == 0) {
					continue;
				}
				final l = f.level;
				final il = f.ilevel;
				final hl = f.hlevel;
				var yIndex = (mby*yStride + mbx) * 16;
				var cIndex = (mby*cStride + mbx) * 8;
				if (mbx > 0) {
					filter246(luma, 16, l+4, il, hl, yIndex, yStride, 1, false);
					filter246(cb, 8, l+4, il, hl, cIndex, cStride, 1, false);
					filter246(cr, 8, l+4, il, hl, cIndex, cStride, 1, false);
				}
				if (f.inner) {
					filter246(luma, 16, l, il, hl, yIndex+0x4, yStride, 1, true);
					filter246(luma, 16, l, il, hl, yIndex+0x8, yStride, 1, true);
					filter246(luma, 16, l, il, hl, yIndex+0xc, yStride, 1, true);
					filter246(cb, 8, l, il, hl, cIndex+0x4, cStride, 1, true);
					filter246(cr, 8, l, il, hl, cIndex+0x4, cStride, 1, true);
				}
				if (mby > 0) {
					filter246(luma, 16, l+4, il, hl, yIndex, 1, yStride, false);
					filter246(cb, 8, l+4, il, hl, cIndex, 1, cStride, false);
					filter246(cr, 8, l+4, il, hl, cIndex, 1, cStride, false);
				}
				if (f.inner) {
					filter246(luma, 16, l, il, hl, yIndex+yStride*0x4, 1, yStride, true);
					filter246(luma, 16, l, il, hl, yIndex+yStride*0x8, 1, yStride, true);
					filter246(luma, 16, l, il, hl, yIndex+yStride*0xc, 1, yStride, true);
					filter246(cb, 8, l, il, hl, cIndex+cStride*0x4, 1, cStride, true);
					filter246(cr, 8, l, il, hl, cIndex+cStride*0x4, 1, cStride, true);
				}
			}
		}
	}

	function computeFilterParams():Void {
		for (i in 0...filterParams.length) {
			var baseLevel = filterHeader.level;
			if (segmentHeader.useSegment) {
				baseLevel = segmentHeader.filterStrength[i];
				if (segmentHeader.relativeDelta) {
					baseLevel += filterHeader.level;
				}
			}

			for (j in 0...filterParams[i].length) {
				var p = filterParams[i][j];
				p.inner = j != 0;
				var level = baseLevel;
				if (filterHeader.useLFDelta) {
					// The libwebp C code has a "TODO: only CURRENT is handled for now."
					level += filterHeader.refLFDelta[0];
					if (j != 0) {
						level += filterHeader.modeLFDelta[0];
					}
				}
				if (level <= 0) {
					p.level = 0;
					continue;
				}
				if (level > 63) {
					level = 63;
				}
				var ilevel = level;
				if (filterHeader.sharpness > 0) {
					if (filterHeader.sharpness > 4) {
						ilevel >>= 2;
					} else {
						ilevel >>= 1;
					}
					final x = 9 - filterHeader.sharpness;
					if (ilevel > x) {
						ilevel = x;
					}
				}
				if (ilevel < 1) {
					ilevel = 1;
				}
				p.ilevel = (ilevel);
				p.level = (2*level + ilevel);
				p.hlevel = level < 15 ? 0 : level < 40 ? 1 : 2;
			}
		}
	}
}

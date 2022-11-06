package vision.algorithms;

import vision.ds.haar.Feature;
import vision.ds.ByteArray;
import haxe.io.Float32Array;
import haxe.io.UInt8Array;
import vision.ds.haar.IntegralImage;
import vision.ds.Image;
import vision.tools.MathTools.*;

@:access(vision.ds.Image)
class Haar {
	static function computeIntegralImage(image:Image):IntegralImage {
		var im:ByteArray,
			count = image.width * image.height,
			sum:Float,
			sum2:Float,
			i:Int,
			j:Int,
			k:Int,
			y:Int,
			g:Int,
			gray = new UInt8Array(count), // Viola-Jones
			integral = new Float32Array(count),
			squares = new Float32Array(count), // Lienhart et al. extension using tilted features
			tilted = new Float32Array(count);

		im.blit(0, image.underlying, Image.OFFSET, image.underlying.length - Image.OFFSET);
		// first row
		j = 0;
		i = 0;
		sum = sum2 = 0;
		while (j < image.width) {
			// use fixed-point gray-scale transform, close to openCV transform
			// https://github.com/mtschirs/js-objectdetect/issues/3
			// 0,29901123046875  0,58697509765625  0,114013671875 with round-off
			g = ((4899 * im[i] + 9617 * im[i + 1] + 1868 * im[i + 2]) + 8192) >>> 14;

			g &= 255;
			sum += g;
			sum2 += (g * g);

			gray[j] = g;
			integral[j] = sum;
			squares[j] = sum2;
			tilted[j] = g;

			j++;
			i += 4;
		}

		// other rows
		k = 0;
		y = 1;
		j = image.width;
		i = (image.width << 2);
		sum = sum2 = 0;
		while (i < im.length) {
			// use fixed-point gray-scale transform, close to openCV transform
			// https://github.com/mtschirs/js-objectdetect/issues/3
			// 0,29901123046875  0,58697509765625  0,114013671875 with round-off
			g = ((4899 * im[i] + 9617 * im[i + 1] + 1868 * im[i + 2]) + 8192) >>> 14;

			g &= 255;
			sum += g;
			sum2 += (g * g);

			gray[j] = g;
			integral[j] = integral[j - image.width] + sum;
			squares[j] = squares[j - image.width] + sum2;
			tilted[j] = tilted[j + 1 - image.width] + (g + gray[j - image.width]) + ((y > 1) ? tilted[j - image.width - image.width] : 0)
				+ ((k > 0) ? tilted[j - 1 - image.width] : 0);

			k++;
			j++;
			i += 4;
			if (k >= image.width) {
				k = 0;
				y++;
				sum = sum2 = 0;
			}
		}

		return {
			gray: gray,
			integral: integral,
			tilted: tilted,
			squares: squares
		};
	}

	// compute Canny edges on gray-scale image to speed up detection if possible
	static function computeIntegralCanny(gray:UInt8Array, w:Int, h:Float) {
		var i:Int,
			j:Int,
			k:Int,
			sum:Float,
			grad_x:Float,
			grad_y:Float,
			ind0,
			ind1,
			ind2,
			ind_1,
			ind_2,
			count = gray.length,
			lowPass = new UInt8Array(count),
			canny = new Float32Array(count);

		// first, second rows, last, second-to-last rows
		i = 0;
		while (i < w) {
			lowPass[i] = 0;
			lowPass[i + w] = 0;
			lowPass[i + count - w] = 0;
			lowPass[i + count - w - w] = 0;

			canny[i] = 0;
			canny[i + count - w] = 0;
			i++;
		}
		// first, second columns, last, second-to-last columns
		j = 0;
		k = 0;
		while (j < h) {
			lowPass[0 + k] = 0;
			lowPass[1 + k] = 0;
			lowPass[w - 1 + k] = 0;
			lowPass[w - 2 + k] = 0;

			canny[0 + k] = 0;
			canny[w - 1 + k] = 0;

			j++;
			k += w;
		}
		// gauss lowPass
		i = 1;
		while (++i < w - 2) {
			sum = 0;
			j = 2;
			k = (w << 1);
			while (j < h - 2) {
				ind0 = i + k;
				ind1 = ind0 + w;
				ind2 = ind1 + w;
				ind_1 = ind0 - w;
				ind_2 = ind_1 - w;

				// use as simple fixed-point arithmetic as possible (only addition/subtraction and binary shifts)
				// http://stackoverflow.com/questions/11703599/unsigned-32-bit-integers-in-javascript
				// http://stackoverflow.com/questions/6232939/is-there-a-way-to-correctly-multiply-two-32-bit-integers-in-javascript/6422061#6422061
				// http://stackoverflow.com/questions/6798111/bitwise-operations-on-32-bit-unsigned-ints
				// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Bitwise_Operators#%3E%3E%3E_%28Zero-fill_right_shift%29
				sum = (0 + (gray[ind_2 - 2] << 1) + (gray[ind_1 - 2] << 2) + (gray[ind0 - 2] << 2) + (gray[ind0 - 2]) + (gray[ind1 - 2] << 2)
					+ (gray[ind2 - 2] << 1) + (gray[ind_2 - 1] << 2) + (gray[ind_1 - 1] << 3) + (gray[ind_1 - 1]) + (gray[ind0 - 1] << 4)
					- (gray[ind0 - 1] << 2) + (gray[ind1 - 1] << 3) + (gray[ind1 - 1]) + (gray[ind2 - 1] << 2) + (gray[ind_2] << 2) + (gray[ind_2])
					+ (gray[ind_1] << 4) - (gray[ind_1] << 2) + (gray[ind0] << 4) - (gray[ind0]) + (gray[ind1] << 4) - (gray[ind1] << 2) + (gray[ind2] << 2)
					+ (gray[ind2]) + (gray[ind_2 + 1] << 2) + (gray[ind_1 + 1] << 3) + (gray[ind_1 + 1]) + (gray[ind0 + 1] << 4) - (gray[ind0 + 1] << 2)
					+ (gray[ind1 + 1] << 3) + (gray[ind1 + 1]) + (gray[ind2 + 1] << 2) + (gray[ind_2 + 2] << 1) + (gray[ind_1 + 2] << 2)
					+ (gray[ind0 + 2] << 2) + (gray[ind0 + 2]) + (gray[ind1 + 2] << 2) + (gray[ind2 + 2] << 1));

				/*
					Original Code
					grad[ind0] = sum/159 = sum*0.0062893081761006;
				 */

				// sum of coefficients = 159, factor = 1/159 = 0,0062893081761006
				// 2^14 = 16384, 16384/2 = 8192
				// 2^14/159 = 103,0440251572322304 =~ 103 +/- 2^13
				lowPass[ind0] = (((Std.int(103 * sum + 8192) & 0xFFFFFFFF) >>> 14) & 0xFF) >>> 0;
				j++;
				k += w;
			}
		}

		// sobel gradient
		for (i in 1...w - 1) {
			j = 1;
			k = w;
			while (j < h - 1) {
				// compute coords using simple add/subtract arithmetic (faster)
				ind0 = k + i;
				ind1 = ind0 + w;
				ind_1 = ind0 - w;

				grad_x = ((0 - lowPass[ind_1 - 1] + lowPass[ind_1 + 1] - lowPass[ind0 - 1] - lowPass[ind0 - 1] + lowPass[ind0 + 1] + lowPass[ind0 + 1]
					- lowPass[ind1 - 1] + lowPass[ind1 + 1])) // &0xFFFFFFFF
				;
				grad_y = ((0 + lowPass[ind_1 - 1] + lowPass[ind_1] + lowPass[ind_1] + lowPass[ind_1 + 1] - lowPass[ind1 - 1] - lowPass[ind1] - lowPass[ind1]
					- lowPass[ind1 + 1])) // &0xFFFFFFFF
				;

				// sum += (Abs(grad_x) + Abs(grad_y))&0xFFFFFFFF;
				canny[ind0] = (Math.abs(grad_x) + Math.abs(grad_y)); // &0xFFFFFFFF;

				j++;
				k += w;
			}
		}

		// integral canny
		// first row
		i = 0;
		sum = 0;
		while (i < w) {
			sum += canny[i];
			canny[i] = sum; // &0xFFFFFFFF;
			i++;
		}
		// other rows
		i = w;
		k = 0;
		sum = 0;
		while (i < count) {
			sum += canny[i];
			canny[i] = (canny[i - w] + sum); // &0xFFFFFFFF;
			i++;
			k++;
			if (k >= w) {
				k = 0;
				sum = 0;
			}
		}

		return canny;
	}

	// merge the detected features if needed
	static function groupRectangles(rects:Array<Feature>, min_neighbors, epsilon) {
		var rlen = rects.length,
			ref = [],
			feats:Array<Feature> = [],
			nb_classes = 0,
			neighbors,
			r:Array<Feature>,
			found = false,
			i,
			j,
			n,
			t,
			ri;

		// original code
		// find number of neighbor classes
		for (i in 0...rlen)
			ref[i] = 0;
		for (i in 0...rlen) {
			found = false;
			for (j in 0...i) {
				if (rects[j].equals(rects[i], epsilon)) {
					found = true;
					ref[i] = ref[j];
				}
			}

			if (!found) {
				ref[i] = nb_classes;
				nb_classes++;
			}
		}

		// merge neighbor classes
		neighbors = [];
		r = [];
		for (i in 0...nb_classes) {
			neighbors[i] = 0;
			r[i] = {};
		}

		for (i in 0...rlen) {
			ri = ref[i];
			neighbors[ri]++;
			r[ri].add(rects[i]);
		}
		var fri:Feature;
		for (i in 0...nb_classes) {
			n = neighbors[i];
			if (n >= min_neighbors) {
				t = 1 / (n + n);
				fri = {
					x: t * (r[i].x * 2 + n),
					y: t * (r[i].y * 2 + n),
					width: t * (r[i].width * 2 + n),
					height: t * (r[i].height * 2 + n)
				};

				feats.push(fri);
			}
		}

		// filter inside rectangles
		rlen = feats.length;
		for (i in 0...rlen) {
			for (j in i + 1...rlen) {
				if (!feats[i].isInside && feats[i].inside(feats[j])) {
					feats[i].isInside = true;
				} else if (!feats[j].isInside && feats[j].inside(feats[i])) {
					feats[j].isInside = true;
				}
			}
		}
		i = rlen;
		while (--i >= 0) {
			if (feats[i].isInside) {
				feats.splice(i, 1);
			}
		}

		return feats;
	}

	// area used as compare func for sorting
	static function byArea(a:Feature, b:Feature):Int {
		return Std.int(b.area - a.area);
	}

	// serial index used as compare func for sorting
	static function byOrder(a:Feature, b:Feature):Int {
		return a.index - b.index;
	}

	// used for parallel "reduce" computation
	static function mergeSteps(d:Array<Array<Feature>>) {
		// concat and sort according to serial ordering
		if (d[1].length != 0) {
			var temp = d[0].concat(d[1]);
			temp.sort(byOrder);
			d[0] = temp;
		}
		return d[0];
	}

	// used for parallel, asynchronous and/or synchronous computation
	static function detectSingleStep(self:Dynamic):Array<Feature> {
		var Sqrt:Float->Float = Math.sqrt,
			ret:Array<Feature> = [],
			haar:Dynamic = self.haardata,
			haar_stages = haar.stages,
			scaledSelection = self.scaledSelection,
			w = self.width,
			h = self.height,
			selw = scaledSelection.width,
			selh = scaledSelection.height,
			imArea = w * h,
			imArea1 = imArea - 1,
			sizex = haar.size1,
			sizey = haar.size2,
			xstep,
			ystep,
			xsize,
			ysize,
			startx = scaledSelection.x,
			starty = scaledSelection.y,
			startty,
			x,
			y,
			ty,
			tyw,
			tys,
			sl = haar_stages.length,
			p0,
			p1,
			p2,
			p3,
			xl,
			yl,
			s,
			t,
			bx1,
			bx2,
			by1,
			by2,
			swh,
			inv_area,
			total_x,
			total_x2,
			vnorm,
			edges_density,
			pass,
			cL = self.cannyLow,
			cH = self.cannyHigh,

			stage,
			threshold,
			trees,
			tl,
			canny = self.canny,
			integral = self.integral,
			squares = self.squares,
			tilted = self.tilted,
			t,
			cur_node_ind,
			where,
			features,
			feature,
			rects,
			nb_rects,
			thresholdf,
			rect_sum,
			kr,
			r,
			x1,
			y1,
			x2,
			y2,
			x3,
			y3,
			x4,
			y4,
			rw,
			rh,
			yw,
			yh,
			sum,
			scale = self.scale,
			increment = self.increment,
			index = self.i != null ? self.i : 0,
			doCanny = self.doCannyPruning;

		bx1 = 0;
		bx2 = w - 1;
		by1 = 0;
		by2 = imArea - w;

		xsize = cropDecimal(scale * sizex);
		xstep = cropDecimal(xsize * increment);
		ysize = cropDecimal(scale * sizey);
		ystep = cropDecimal(ysize * increment);
		// ysize = xsize; ystep = xstep;
		tyw = ysize * w;
		tys = ystep * w;
		startty = starty * tys;
		xl = selw - xsize;
		yl = selh - ysize;
		swh = xsize * ysize;
		inv_area = 1.0 / swh;

		y = starty;
		ty = startty;
		while (y < yl) {
			x = startx;
			while (x < xl) {
				p0 = x - 1 + ty - w;
				p1 = p0 + xsize;
				p2 = p0 + tyw;
				p3 = p2 + xsize;

				// clamp
				p0 = (p0 < 0) ? 0 : (p0 > imArea1) ? imArea1 : p0;
				p1 = (p1 < 0) ? 0 : (p1 > imArea1) ? imArea1 : p1;
				p2 = (p2 < 0) ? 0 : (p2 > imArea1) ? imArea1 : p2;
				p3 = (p3 < 0) ? 0 : (p3 > imArea1) ? imArea1 : p3;

				if (doCanny) {
					// avoid overflow
					edges_density = inv_area * (canny[p3] - canny[p2] - canny[p1] + canny[p0]);
					if (edges_density < cL || edges_density > cH) continue;
				}

				// pre-compute some values for speed

				// avoid overflow
				total_x = inv_area * (integral[p3] - integral[p2] - integral[p1] + integral[p0]);
				// avoid overflow
				total_x2 = inv_area * (squares[p3] - squares[p2] - squares[p1] + squares[p0]);

				vnorm = total_x2 - total_x * total_x;
				vnorm = (vnorm > 1) ? Sqrt(vnorm) : /*vnorm*/ 1;

				pass = true;
				for (s in 0...sl) {
					// Viola-Jones HAAR-Stage evaluator
					stage = haar_stages[s];
					threshold = stage.thres;
					trees = stage.trees;
					tl = trees.length;
					sum = 0;

					for (t in 0...tl) {
						//
						// inline the tree and leaf evaluators to avoid function calls per-loop (faster)
						//

						// Viola-Jones HAAR-Tree evaluator
						features = trees[t].feats;
						cur_node_ind = 0;
						while (true) {
							feature = features[cur_node_ind];

							// Viola-Jones HAAR-Leaf evaluator
							rects = feature.rects;
							nb_rects = rects.length;
							thresholdf = feature.thres;
							rect_sum = 0;

							if (feature.tilt) {
								// tilted rectangle feature, Lienhart et al. extension
								for (kr in 0...nb_rects) {
									r = rects[kr];

									// this produces better/larger features, possible rounding effects??
									x1 = x + cropDecimal(scale * r[0]);
									y1 = (y - 1 + cropDecimal(scale * r[1])) * w;
									x2 = x + cropDecimal(scale * (r[0] + r[2]));
									y2 = (y - 1 + cropDecimal(scale * (r[1] + r[2]))) * w;
									x3 = x + cropDecimal(scale * (r[0] - r[3]));
									y3 = (y - 1 + cropDecimal(scale * (r[1] + r[3]))) * w;
									x4 = x + cropDecimal(scale * (r[0] + r[2] - r[3]));
									y4 = (y - 1 + cropDecimal(scale * (r[1] + r[2] + r[3]))) * w;

									// clamp
									x1 = (x1 < bx1) ? bx1 : (x1 > bx2) ? bx2 : x1;
									x2 = (x2 < bx1) ? bx1 : (x2 > bx2) ? bx2 : x2;
									x3 = (x3 < bx1) ? bx1 : (x3 > bx2) ? bx2 : x3;
									x4 = (x4 < bx1) ? bx1 : (x4 > bx2) ? bx2 : x4;
									y1 = (y1 < by1) ? by1 : (y1 > by2) ? by2 : y1;
									y2 = (y2 < by1) ? by1 : (y2 > by2) ? by2 : y2;
									y3 = (y3 < by1) ? by1 : (y3 > by2) ? by2 : y3;
									y4 = (y4 < by1) ? by1 : (y4 > by2) ? by2 : y4;

									// RSAT(x-h+w, y+w+h-1) + RSAT(x, y-1) - RSAT(x-h, y+h-1) - RSAT(x+w, y+w-1)
									//        x4     y4            x1  y1          x3   y3            x2   y2
									rect_sum += r[4] * (tilted[x4 + y4] - tilted[x3 + y3] - tilted[x2 + y2] + tilted[x1 + y1]);
								}
							} else {
								// orthogonal rectangle feature, Viola-Jones original
								for (kr in 0...nb_rects) {
									r = rects[kr];

									// this produces better/larger features, possible rounding effects??
									x1 = x - 1 + cropDecimal(scale * r[0]);
									x2 = x - 1 + cropDecimal(scale * (r[0] + r[2]));
									y1 = (w) * (y - 1 + cropDecimal(scale * r[1]));
									y2 = (w) * (y - 1 + cropDecimal(scale * (r[1] + r[3])));

									// clamp
									x1 = (x1 < bx1) ? bx1 : (x1 > bx2) ? bx2 : x1;
									x2 = (x2 < bx1) ? bx1 : (x2 > bx2) ? bx2 : x2;
									y1 = (y1 < by1) ? by1 : (y1 > by2) ? by2 : y1;
									y2 = (y2 < by1) ? by1 : (y2 > by2) ? by2 : y2;

									// SAT(x-1, y-1) + SAT(x+w-1, y+h-1) - SAT(x-1, y+h-1) - SAT(x+w-1, y-1)
									//      x1   y1         x2      y2          x1   y1            x2    y1
									rect_sum += r[4] * (integral[x2 + y2] - integral[x1 + y2] - integral[x2 + y1] + integral[x1 + y1]);
								}
							}

							where = (rect_sum * inv_area < thresholdf * vnorm) ? 0 : 1;
							// END Viola-Jones HAAR-Leaf evaluator

							if (where != 0) {
								if (feature.has_r) {
									sum += feature.r_val;
									break;
								} else {
									cur_node_ind = feature.r_node;
								}
							} else {
								if (feature.has_l) {
									sum += feature.l_val;
									break;
								} else {
									cur_node_ind = feature.l_node;
								}
							}
						}
						// END Viola-Jones HAAR-Tree evaluator
					}
					pass = (sum > threshold) ? true : false;
					// END Viola-Jones HAAR-Stage evaluator

					if (!pass) break;
				}

				if (pass) {
					ret.push({
						index: index,
						x: x,
						y: y,
						width: xsize,
						height: ysize
					});
				}

				x += xstep;
			}

			y += ystep;
			ty += tys;
		}

		// return any features found in this step
		return ret;
	}

	// called when detection ends, calls user-defined callback if any
	static function detectEnd(self:Dynamic, rects:Array<Feature>, withOnComplete:Bool) {
		var i, n, ratio;
		for (i in 0...rects.length) rects[i] = rects[i].clone();
		self.objects = groupRectangles(rects, self.min_neighbors, self.epsilon);
		ratio = 1.0 / self.Ratio;
		for(i in 0...self.objects.length) self.objects[i].scale(ratio).round().computeArea();
		// sort according to size
		// (a deterministic way to present results under different cases)
		self.objects.sort(byArea);
		self.Ready = true;
		if (withOnComplete && self.onComplete) self.onComplete.call(self);
	}
}

package vision.algorithms;

import vision.ds.haar.Feature;
import vision.ds.ByteArray;
import haxe.io.Float32Array;
import haxe.io.UInt8Array;
import vision.ds.haar.IntegralImage;
import vision.ds.Image;

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
		for (i in 0...rlen) ref[i] = 0;
		for (i in 0...rlen)
		{
			found = false;
			for (j in 0...i)
			{
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
		for (i in 0...nb_classes)
		{
			neighbors[i] = 0;
			r[i] = {};
		}

		for (i in 0...rlen)
		{
			ri = ref[i];
			neighbors[ri]++;
			r[ri].add(rects[i]);
		}
        var fri:Feature;
		for (i in 0...nb_classes)
		{
			n = neighbors[i];
			if (n >= min_neighbors) {
				t = 1 / (n + n);
				fri = {x: t * (r[i].x * 2 + n), y: t * (r[i].y * 2 + n), width: t * (r[i].width * 2 + n), height: t * (r[i].height * 2 + n)};

				feats.push(fri);
			}
		}

		// filter inside rectangles
		rlen = feats.length;
		for (i in 0...rlen)
		{
			for (j in i + 1...rlen)
			{
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
	static function byArea(a:Feature, b:Feature):Int { return Std.int(b.area - a.area); }

	// serial index used as compare func for sorting
	static function byOrder(a:Feature, b:Feature):Int { return a.index-b.index; }

	
	// used for parallel "reduce" computation
	static function mergeSteps(d:Array<Array<Feature>>)
	{
		// concat and sort according to serial ordering
		if (d[1].length != 0){
			var temp = d[0].concat(d[1]);
			temp.sort(byOrder);
			d[0] = temp;
		}
		return d[0];
	}
}

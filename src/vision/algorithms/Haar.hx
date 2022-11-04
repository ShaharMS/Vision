package vision.algorithms;

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
			// 0,29901123046875  0,58697509765625  0,114013671875 with roundoff
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
			// 0,29901123046875  0,58697509765625  0,114013671875 with roundoff
			g = ((4899 * im[i] + 9617 * im[i + 1] + 1868 * im[i + 2]) + 8192) >>> 14;

			g &= 255;
			sum += g;
			sum2 += (g * g);

			gray[j] = g;
			integral[j] = integral[j - image.width] + sum;
			squares[j] = squares[j - image.width] + sum2;
			tilted[j] = tilted[j + 1 - image.width] + (g + gray[j - image.width]) + ((y > 1) ? tilted[j - image.width - image.width] : 0) + ((k > 0) ? tilted[j - 1 - image.width] : 0);

			k++;
			j++;
			i += 4;
			if (k >= image.width) {
				k = 0;
				y++;
				sum = sum2 = 0;
			}
		}

		return {gray: gray, integral: integral, tilted: tilted, squares: squares};
	}
}

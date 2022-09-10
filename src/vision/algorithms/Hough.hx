package vision.algorithms;

import vision.tools.MathTools;
import haxe.ds.BalancedTree;
import vision.ds.hough.HoughAccumulator;
import haxe.Timer;
import vision.ds.hough.HoughSpace;
import vision.ds.Matrix;
import vision.ds.Point2D;
import vision.ds.Color;
import haxe.ds.Vector;
import vision.ds.Ray2D;
import vision.ds.LineSegment2D;
import vision.ds.Image;

/**
	A Hough Transform implementation by [ShaharMS](https://www.github.com/ShaharMS).

	## What is The Hough Transform?

	The Hough transform is a computer vision technique, commonly used to identify lines within an image.

	The only knowledge you need prior to understanding the algorithm is that lines can be represented 
	by either:
	 - two points `(x1, y1)` `(x2, y2)`, using the equation `y - y1 = m(x - x1)`
	 - two values, called `theta` and `rho`:
		- The first (theta) is the angle of the line
		- The second (rho) is the shortest distance from that line to the origin.

	## How does it work?

	The algorithm basically works like this:

	1. Create a large matrix where one axis of the matrix corresponds to theta and one to rho. This matrix is called the accumulator and is said to represent the "Hough space" of the image. Initialize this matrix by each entry being 0.
	1. Create a grayscale image
	1. Find the edges in that image (for example using the canny algorithm)
	1. For each point in those edges:
	1. Calculate many lines defined by theta and rho radiating out from that point. Each theta should have the same angle of difference to each other and each rho is calculated based on the coordinate of the point and the theta. For each of these lines, add a 1 to the corresponding entry in the accumulator matrix.
	1. When you have a filled in accumulator, find a number of local maxima within that accumulator. Each local maxima corresponds to a line in the image, so if you want to find 10 lines you should pick out the 10 local maxima that have the largest values in the accumulator matrix.
	1. Transform the local maxima in the accumulator back to lines using their corresponding theta and rho values.
	1. To visualize the result, overlay these lines on your original image.

**/
class Hough {
	/**
		Uses the Hough Transform to generate an accumulator based on the
		image provided.

		@param image The image to be transformed.

		@return A `HoughSpace` object, containing the accumulator and an image representation of the accumulator.
	**/
	public static function toHoughSpace(image:Image):HoughSpace {
		var rhoMax = Math.sqrt(image.width * image.width + image.height * image.height);
		var accum:HoughAccumulator = new HoughAccumulator(Std.int(rhoMax));
		var houghSpace = new Image(361, Std.int(rhoMax), Color.WHITE);
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				if (Math.abs(image.getPixel(x, y).red) == 255) {
					var rho:Float;
					var theta = 0.;
					var thetaIndex = 0;
					while (thetaIndex < 180) {
						rho = x * Math.cos(theta) + y * Math.sin(theta);
						accum.incrementCell(Std.int(rho), thetaIndex);
						houghSpace.paintPixel(thetaIndex, Std.int(rho), Color.fromRGBAFloat(0, 0, 0, 0.01));
						theta += Math.PI / 360;
						thetaIndex++;
					}
				}
			}
		}
		return {accumulator: accum, image: houghSpace};
	}

	/**
		Returns a `HoughSpace` object, containing
		the accumulator, an image representation of the accumulator,
		and all the local maximums found in the accumulator.

		@param image The image to be transformed.
		@param threshold The minimum value of an accumulator's cell to be considered a local maximum (or, a line). Defaults to 30.
		@param numLocalMaxima A cap on the number of local maximums to return. When unset, all local maximums are returned. unless you have a good reason, you should'nt set this parameter.
		@param maximaCheckLoop For performance reasons, the algorithm will only check the local maximums in the accumulator once every `maximaCheckLoop` iterations. **How does this work?** - a value of 10 will check for a maximum every 10 pixels. Setting this might be useful when working with very large images. By default, this parameter is set to `(image.width + image.height) / 10`.

		@return A `HoughSpace` object, containing the accumulator, an image representation of the accumulator, and all the local maximums found in the accumulator.
	**/
	public static function toHoughSpaceWithRays(image:Image, threshold:Int = 30, ?numLocalMaxima:Int = null, ?maximaCheckLoop:Int = null):HoughSpace {
		
		var rhoMax = Math.sqrt(image.width * image.width + image.height * image.height);
		var accum:HoughAccumulator = new HoughAccumulator(Std.int(rhoMax));
		var houghSpace = new Image(361, Std.int(rhoMax), Color.WHITE);

		var maximas:Array<Point2D> = [];
		var rays:Array<Ray2D> = [];

		function checkMaxima() {
			var max = 0;
			var bestRho = 0.;
			var bestTheta = 0;
			for (i in 0...360) {
				if (accum[i] == null) continue;
				for (j in 0...accum[i].length) {
					if (accum[i][j] > max) {
						max = accum[i][j];
						bestRho = j;
						bestTheta = i;
					}
				}
			}

			if (max > threshold) {
				// now to backproject into drawing space
				bestRho *= 2;
				bestRho -= rhoMax; /// accumulator has rhoMax added

				var localMax:Point2D = {x: bestTheta, y: bestRho};

				//deep equality check 
				for (maxima in maximas) {
					if (maxima.x == localMax.x && maxima.y == localMax.y) {
						return;
					}
				}

				maximas.push(localMax);

				var x1 = bestRho / Math.cos(bestTheta * Math.PI / 180);
				var y1 = bestRho / Math.sin(bestTheta * Math.PI / 180);
				var m = Math.tan(bestTheta * Math.PI / 180);

				rays.push(new Ray2D({x: x1, y: y1}, m));
			}
		}
		
		var loop = 0;
		maximaCheckLoop = maximaCheckLoop != null ? maximaCheckLoop : Std.int((image.width + image.height) / 20);

		for (x in 0...image.width) {
			for (y in 0...image.height) {
				if (Math.abs(image.getPixel(x, y).red) == 255) {
					var rho:Float;
					var theta = 0.;
					var thetaIndex = 0;
					while (thetaIndex < 180) {
						rho = x * Math.cos(theta) + y * Math.sin(theta);
						accum.incrementCell(Std.int(rho), thetaIndex);
						houghSpace.paintPixel(thetaIndex, Std.int(rho), Color.fromRGBAFloat(0, 0, 0, 0.01));
						theta += Math.PI / 360;
						thetaIndex++;
					}
				}
				loop++;
				if (loop >= maximaCheckLoop && Math.abs(image.getPixel(x, y).red) == 255) {
					loop = 0;
					checkMaxima();
					loop = 0;
					if (numLocalMaxima != null) {
						if (maximas.length >= numLocalMaxima) {
							var space = new HoughSpace(accum, houghSpace);
							space.rays = rays;
							space.maximums = maximas;
							return space;
						}
					}
				}
			}
		}

		var space = new HoughSpace(accum, houghSpace);
		space.rays = rays;
		space.maximums = maximas;
		return space;
	}
}
	
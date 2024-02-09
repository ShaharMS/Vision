package vision.algorithms;

import vision.ds.Heatmap;
import vision.ds.Matrix2D;
import vision.tools.ImageTools;
import vision.ds.gaussian.GaussianKernelSize;
import vision.ds.IntPoint2D;
import vision.ds.Point2D;
import vision.ds.Image;
import vision.ds.specifics.EdgeFilterType;

using vision.tools.MathTools;

class Harris {
	


	public static function generateHarrisCorners(image:Image, initialEdgeFilterType:EdgeFilterType, k:Float, delta:Float, windowSize:Int, sigma:Float):{responses:Heatmap, corners:Heatmap} {
		var corners = new Image(image.width, image.height);

		var edgeImage = applyFilter(image.clone(), initialEdgeFilterType);
		var responses = new Heatmap(image.width, image.height);
		var avg = Std.int((windowSize - 1) / 2);

		edgeImage.forEachPixelInView((x, y, color) -> {
			/* The matrix of the Harris response function is basically a sum of other matrices calculated for each cell 
			 in the window, multiplied by a gaussian function for the specific cell's position in the image.
			 The `windowSize`^2 matrices were going to calculate are of the form:
			
						┌        	 ┐
			  g(x, y) *	│ IₓIₓ, IₓIᵧ │
						│ IₓIᵧ, IᵧIᵧ │
						└        	 ┘
			  - g(x, y): the gaussian function at a specific coordinate
			  - I: the edge image,
			  - Iₓ: the image's color change rate at a specific coordinate + some small value, x axis
			  - Iᵧ: the image's color change rate at a specific coordinate + some small value, y axis

			*/
			var matrices:Array<Matrix2D> = [];
			for (wx in -avg...avg + 1) {
				for (wy in -avg...avg + 1) {
					var matrix:Matrix2D = 
						[
							[getValueOfImageDerivativeAt(image, x, y, delta, true).pow(2), getValueOfImageDerivativeAt(image, x, y, delta, true) * getValueOfImageDerivativeAt(image, x + wx, y + wy, delta, false)],
							[getValueOfImageDerivativeAt(image, x, y, delta, true) * getValueOfImageDerivativeAt(image, x + wx, y + wy, delta, false), getValueOfImageDerivativeAt(image, x + wx, y + wy, delta, false).pow(2)]
						];
					matrix.multiplyWithScalar(averageUsingGaussianDistribution(image, x, y, windowSize, sigma));
					matrices.push(matrix);
				}
			}
			var M = matrices.shift();
			for (matrix in matrices) {
				M += matrix;
			}
			
			responses.set(x, y, harrisResponseFunction(M, k));

			
		});

		var maximums = responses.getLocalMaximums();
		var cornerHeatmap = new Heatmap(image.width, image.height);
		for (point in maximums) {
			cornerHeatmap.set(point.x, point.y, 255);
		}

		return {responses: responses, corners: cornerHeatmap };
	}

	public static function harrisResponseFunction(matrix:Matrix2D, k:Float) {
		return matrix.getDeterminant() - k * matrix.getTrace().pow(2);
	}

	public static function applyFilter(image:Image, type:EdgeFilterType) {
		return switch type {
			case SOBEL: Vision.sobelEdgeDiffOperator(image);
			case PERWITT: Vision.perwittEdgeDiffOperator(image);
			case ROBERT: Vision.robertEdgeDiffOperator(image);
		}
	}

	/**
		An integral part of the harris response function is the image's color change rate at a specific coordinate + some small value (in our case, `delta`).
		The rate of color change is the same thing as the slope of a function, hence the name of this function. The two match up well, since we only
		need the rate of change in either the `x` or `y` direction.

		
		@param image A gray scale image
		@param coordinate The coordinate of the pixel
		@param delta The small value to add to the coordinate. This can be optimized for more/less aggressive corner detection.
		@param xDirection Whether to use the x direction or the y direction, since we need both slopes represented (on the `x` and `y` axis)
	**/
	public static function getValueOfImageDerivativeAt(image:Image, x:Float, y:Float, delta:Float = 0.1, xDirection:Bool = true) {
		var rise1 = image.getFloatingPixel(x, y);
		var rise2 = xDirection ? image.getFloatingPixel(x + delta, y) : image.getFloatingPixel(x, y + delta);
		var run1 = xDirection ? x : y;
		var run2 = run1 + delta;

		return (rise2.red - rise1.red) / (run2 - run1); // both `rise` variables are grayscale colors, all color channels are the same
	}

	public static function averageUsingGaussianDistribution(image:Image, x:Int, y:Int , kernelSize:GaussianKernelSize = X3, sigma:Float = 1) {
		var kernel = Gauss.create2DKernelOfSize(kernelSize, sigma);
		var window = ImageTools.getNeighborsOfPixel(image, x, y, 3);
		var sum = 0.;
		for (kx in 0...kernelSize) {
			for (ky in 0...kernelSize) {
				sum += kernel.get(kx, ky) * window.get(kx, ky).red; // Again, grayscale colors
			}
		}
		return sum;
		
	}
}
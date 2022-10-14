package vision.algorithms;

import vision.ds.gaussian.GaussianKernalSize;
import vision.ds.Color;
import vision.tools.ImageTools;
import vision.ds.Image;

class Laplacian {
    
    public static function convolveWithLaplacianOperator(image:Image, positive:Bool) {
		var edgeColors:Image = new Image(image.width, image.height);

		for (i in 0...image.width) {
			for (j in 0...image.height) {
				// get the red value of the grayed pixel
				// we can "trust" .red since the value should be similar across the channels
                var sign = positive ? 1 : -1;
				final pos01 = ImageTools.grayscalePixel(image.getSafePixel(i - 1, j)).red * sign;
				final pos10 = ImageTools.grayscalePixel(image.getSafePixel(i, j - 1)).red * sign;
				final pos11 = ImageTools.grayscalePixel(image.getSafePixel(i, j)).red * -4 * sign;
				final pos12 = ImageTools.grayscalePixel(image.getSafePixel(i, j + 1)).red * sign;
				final pos21 = ImageTools.grayscalePixel(image.getSafePixel(i + 1, j)).red * sign;
                final gray = Std.int((pos01 + pos10 + pos11 + pos12 + pos21) / 5);
				edgeColors.setPixel(i, j, Color.fromRGBA(gray, gray, gray));
			}
		}

		return edgeColors;
	}

    public static function laplacianOfGaussian(image:Image, kernalSize:GaussianKernalSize, sigma:Float, threshold:Float, positive:Bool) {
        var returned = new Image(image.width, image.height);
        var blurred = Vision.gaussianBlur(image.clone(), sigma, kernalSize);
        var imageToProcess:Image;
        imageToProcess = convolveWithLaplacianOperator(blurred, positive);
        imageToProcess.forEachPixel((x, y, color) -> {
            if (color.red > threshold) {
                returned.setPixel(x, y, 0xFFFFFFFF);
            }
        });
        return returned;
    }

}
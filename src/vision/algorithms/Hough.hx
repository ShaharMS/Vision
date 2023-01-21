package vision.algorithms;

import vision.ds.Point2D;
import vision.ds.Ray2D;
import vision.ds.Array2D;
import vision.ds.Line2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools.*;

using vision.tools.MathTools;

class Hough {

	static var maxRho:Int;

	public static function generateHoughSpace(image:Image):Image {
		maxRho = 2 * ceil(sqrt(image.width * image.width + image.height * image.height)); 
		final maxThetaIndex = 360; // calculating using radians is impossible, since array indices are integers.
		var accumulator = new Image(maxThetaIndex + 1, maxRho);
		#if (!java && !jvm)
		var calcLine = new Ray2D({x: 0, y: 0}, null, 0);
		image.forEachPixel((x, y, color) -> {
			if (color.red != 255) return;
			calcLine.point.x = x;
			calcLine.point.y = y;
			for (deg in 0...maxThetaIndex) {
				calcLine.degrees = deg;
				final rho = x * Math.cos(deg.degreesToRadians()) + y * Math.sin(deg.degreesToRadians());
				var rhoIndex = rho + ceil(maxRho / 2);
				if (rhoIndex < 0) trace(rhoIndex) else
				accumulator.setFloatingPixel(deg, rhoIndex, accumulator.getFloatingPixel(deg, rhoIndex) + 100);
			}
		});
		#end
		return accumulator;
	}

	public static function extractLocalMaximas(space:Image):Image {
		for (x in 0...space.width) {
			for (y in 0...space.height) {
				final value = space.getPixel(x, y);
				final neighbors = [
					space.getSafePixel(x - 1, y - 1),
					space.getSafePixel(x + 0, y - 1),
					space.getSafePixel(x + 1, y - 1),
					space.getSafePixel(x - 1, 0),
					space.getSafePixel(x + 1, 0),
					space.getSafePixel(x - 1, y + 1),
					space.getSafePixel(x + 0, y + 1),
					space.getSafePixel(x + 1, y + 1)
				];
				for (i in 0...neighbors.length) {
					if (neighbors[i] > value) {
						space.setPixel(x, y, 0);
					}
				}
			}
		}
		space.forEachPixel((x, y, color) -> if (color != 0) trace(color.toInt()));
		return space;
	}

	public static function threshold(space:Image, value:Int) {
		space.forEachPixel((x, y, color) -> {
			if (color > value) space.setPixel(x, y, 0xFFFFFFFF) else space.setPixel(x, y, 0);
		});
		return space;
	}

	public static function mapLines(image:Image, space:Image):Image {
		space.forEachPixel((x, y, color) -> {
			if (color == 0xFFFFFFFF) {
				var radians = x.degreesToRadians();
				y -= ceil(maxRho / 2); // project rho values back into their original range
				var locX = y * cos(radians), locY = y * sin(radians);
				var ray = new Ray2D({x: locX, y: locY}, null, x != 0 ? x + 90 : 0);
				image.drawRay2D(ray, Color.CYAN);
			}
		});

		return image;
	}
}

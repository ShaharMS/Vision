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
	public static function generateHoughSpace(image:Image):Image {
		final maxRho = 2 * floor(distanceBetweenPoints({x: 0, y: 0}, {x: image.width, y: image.height}));
		final maxThetaIndex = 360; // calculating using radians is impossible, since array indices are integers.
		var accumulator = new Image(maxThetaIndex + 1, maxRho);

		var calcLine = new Ray2D({x: 0, y: 0}, null, 0);
		image.forEachPixel((x, y, color) -> {
			if (color.red != 255) return;
			calcLine.point.x = x;
			calcLine.point.y = y;
			for (deg in 0...maxThetaIndex) {
				calcLine.degrees = deg;
				final rho = abs(distanceFromPointToRay2D({x: 0, y: 0}, calcLine));
				var thetaIndex = new Point2D(0, 0).degreesFromPointToPoint2D(getClosestPointOnRay2D({x: 0, y: 0}, calcLine));
				if (thetaIndex < 0) thetaIndex = 360 + thetaIndex;
				accumulator.setFloatingPixel(thetaIndex, rho, accumulator.getFloatingPixel(thetaIndex, rho) + 100);
			}
		});

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
				var locX = y * cos(radians), locY = y * sin(radians);
				var ray = new Ray2D({x: locX, y: locY}, null, x != 0 ? x + 90 : 0);
				image.drawRay2D(ray, Color.CYAN);
			}
		});

		return image;
	}
}

class HoughTransform {
	// Create the accumulator array
	var accumulator:Array<Array<Int>>;

	public function new(numRho:Int) {
        var numTheta = 360;
		// Initialize the accumulator array
		accumulator = new Array<Array<Int>>();
		for (i in 0...numTheta) {
			accumulator[i] = new Array<Int>();
			for (j in 0...numRho) {
				accumulator[i][j] = 0;
			}
		}
	}

	public function detectLines(edges:Array<Array<Int>>, minVotes:Int):Array<Ray2D> {
		// Initialize the array to store the detected lines
		var lines:Array<Ray2D> = [];

		// Loop through all the edge points
		for (y in 0...edges.length) {
			for (x in 0...edges[y].length) {
				// Check if the current point is an edge
				if (edges[y][x] > 0) {
					// Loop through all the possible theta values
					for (theta in 0...accumulator.length) {
						// Calculate the corresponding rho value
						var rho = x * Math.cos(theta) + y * Math.sin(theta);
						// Convert rho to the corresponding index in the accumulator array
						var rhoIndex = Math.round(rho + accumulator[0].length / 2);
						// Increment the accumulator value at the corresponding indices
						accumulator[theta][rhoIndex]++;
					}
				}
			}
		}

		// Loop through the accumulator array to find the lines with enough votes
		for (theta in 0...accumulator.length) {
			for (rho in 0...accumulator[theta].length) {
				if (accumulator[theta][rho] >= minVotes) {
					// Convert the indices back to rho and theta values
					var rhoVal = rho - accumulator[0].length / 2;
					var thetaVal = theta;
					// Convert rho and theta to x and y
					var x = rhoVal * Math.cos(thetaVal);
					var y = rhoVal * Math.sin(thetaVal);
					// Convert theta to an angle in degrees
					var angle = thetaVal * 180 / Math.PI;
					// Add the detected line to the array
					lines.push(new Ray2D({x: x, y: y}, null, angle));
				}
			}
		}

		// Return the detected lines
		return lines;
	}
}

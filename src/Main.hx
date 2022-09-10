package;

import vision.ds.Queue;
import vision.ds.LineSegment2D;
import vision.tools.MathTools;
import haxe.Timer;
import vision.algorithms.Gaussian;
import vision.Vision;
import vision.ds.Color;
import vision.ds.Rectangle;
import vision.ds.Point2D;
import vision.ds.Ray2D;
import haxe.display.Display.Package;
#if js
import js.html.Document;
import js.Browser;
#end
import vision.algorithms.Hough;
import vision.ds.Image;
using vision.Vision;

class Main {
	static function main() {
		var start:Float, end:Float;

		var image = new Image(250, 250, 0x000000);
		image.drawLine(12, 53, 54, 15, 0xbd0202);
		image.drawLine(56, 248, 181, 95, 0x000355);
		image.drawLine(110, 15, 121, 131, 0x31f300);
		image.drawLine(248, 53, 15, 231, 0xffffff);
		image.drawRect(34, 12, 33, 53, 0xf0ff46);
		image.fillRect(12, 53, 33, 53, 0xffffff);
		image.drawCircle(100, 100, 50, 0x3c896e);
		image.drawCircle(100, 100, 30, 0xff00d4);
		image.drawCircle(200, 200, 40, Color.YELLOW);
		image.fillColor(new Point2D(200, 200), Color.YELLOW);
		image.drawCircle(180, 190, 5, Color.BROWN);
		image.fillColor(new Point2D(180, 190), Color.BROWN);
		image.drawCircle(220, 190, 5, Color.BROWN);
		image.fillColor(new Point2D(220, 190), Color.BROWN);
		image.drawCircle(200, 225, 8, Color.BROWN);
		image.fillColor(new Point2D(200, 225), Color.BROWN);
		image.drawQuadraticBezier(new LineSegment2D({x: 100, y: 100}, {x: 200, y: 100}), {x: 200, y: 200}, 0x1900ff);
		image.drawCubicBezier(new LineSegment2D({x: 10, y: 10}, {x: 50, y: 100}), {x: 150, y: 200}, {x: 200, y: 75}, 0xff0000);
		image.drawRay2D(new Ray2D({x: 0, y: 0}, 1), 0x00ff00);
		image.drawEllipse(100, 100, 40, 21, 0x9fff9f);
		printImage(image);
		start = haxe.Timer.stamp();
		printImage(Vision.blackAndWhite(image.clone()));
		end = haxe.Timer.stamp();
		trace("Black and white took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(Vision.grayscale(image.clone()));
		end = haxe.Timer.stamp();
		trace("Grayscale took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(image.clone().sobelEdgeDetection());
		end = haxe.Timer.stamp();
		trace("Sobel edge detection took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		var hough = Hough.toHoughSpace(Vision.perwittEdgeDetection(image.clone()));
		printImage(hough.image);
		end = haxe.Timer.stamp();
		trace("Hough transform took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(Vision.perwittEdgeDetection(image.clone()));
		end = haxe.Timer.stamp();
		trace("Perwitt edge detection took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(Vision.nearestNeighborBlur(image.clone(), 1));
		end = haxe.Timer.stamp();
		trace("Nearest neighbor blur took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(image.clone().contrast());
		end = haxe.Timer.stamp();
		trace("Contrast took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(image.clone().gaussianBlur(2, 15));
		end = haxe.Timer.stamp();
		trace("Gaussian blur took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(image.clone());
		end = haxe.Timer.stamp();
		trace("Image Cloning took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printImage(image.clone().mirror());
		end = haxe.Timer.stamp();
		trace("Image Mirroring took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		var canny = Vision.cannyEdgeDetection(image.clone());
		printImage(canny);
		end = haxe.Timer.stamp();
		trace("Canny edge detection took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		var lines = Vision.simpleLineSegment2DDetection(image.clone(), 3, 30);
		var newI = image.clone();
		for (l in lines) {
			newI.drawLineSegment2D(l, 0x00FFD5);
		}
		printImage(newI);
		end = haxe.Timer.stamp();
		trace("Simple line detection took: " + MathTools.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		var lines = Vision.houghRay2DDetection(image.clone());
		for (l in lines) {
			image.drawRay2D(l, 0x00FFD5);
		}
		printImage(image);
		end = haxe.Timer.stamp();
		trace("Hough line detection took: " + MathTools.turnicate(end - start, 4) + " seconds");
	
		trace(new Ray2D({x: 0, y: 0}, 1).getPointAtX(8));
		trace(new Ray2D({x: 0, y: 0}, 1).slope);
		trace(new Ray2D({x: 0, y: 0}, 1).degrees);
		trace(new Ray2D({x: 0, y: 0}, 1).radians);
		trace(new Ray2D({x: 0, y: 0}, 1).getPointAtY(8));
		trace(new Ray2D({x: 0, y: 0}, 1).yIntercept);
		trace(new Ray2D({x: 0, y: 0}, 1).xIntercept);
		var queue = new Queue<Int>();
		queue.enqueue(0);
		queue.enqueue(1);
		queue.enqueue(2);
		queue.enqueue(3);
		trace(queue);
		trace(queue.dequeue());
		trace(queue.dequeue());
		trace(queue.dequeue());
		trace(queue);
	}

	public static function printImage(image:Image) {
		#if js
		var c = Browser.document.createCanvasElement();
		c.width = image.width;
		c.height = image.height;
		var ctx = c.getContext2d();
		var imageData = ctx.getImageData(0, 0, image.width, image.height);
		var data = imageData.data;
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var i = (y * image.width + x) * 4;
				data[i] = image.getPixel(x, y).red;
				data[i + 1] = image.getPixel(x, y).green;
				data[i + 2] = image.getPixel(x, y).blue;
				data[i + 3] = 255;
			}
		}
		ctx.putImageData(imageData, 0, 0);
		c.style.padding = "10px";
		Browser.document.body.appendChild(c);
		#end
	}
}

package;

import vision.tools.MathUtils;
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
import vision.algorithms.HoughTransform;
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
		printIm(image);
		start = haxe.Timer.stamp();
		printIm(Vision.blackAndWhite(image.clone()));
		end = haxe.Timer.stamp();
		trace("Black and white took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(Vision.grayscale(image.clone()));
		end = haxe.Timer.stamp();
		trace("Grayscale took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(image.clone().sobelEdgeDetection());
		end = haxe.Timer.stamp();
		trace("Sobel edge detection took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		var hough = HoughTransform.toHoughSpace(Vision.perwittEdgeDetection(image.clone()));
		printIm(hough.image);
		end = haxe.Timer.stamp();
		trace("Hough transform took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(hough.image.clone().invert());
		end = haxe.Timer.stamp();
		trace("Invertion took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(Vision.perwittEdgeDetection(image.clone()));
		end = haxe.Timer.stamp();
		trace("Perwitt edge detection took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(Vision.nearestNeighborBlur(image.clone(), 1));
		end = haxe.Timer.stamp();
		trace("Nearest neighbor blur took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(image.clone().contrast());
		end = haxe.Timer.stamp();
		trace("Contrast took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(image.clone().gaussianBlur(1, 2));
		end = haxe.Timer.stamp();
		trace("Gaussian blur took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		printIm(image.clone());
		end = haxe.Timer.stamp();
		trace("Image Cloning took: " + MathUtils.turnicate(end - start, 4) + " seconds");
		start = haxe.Timer.stamp();
		var canny = Vision.cannyEdgeDetection(image.clone());
		printIm(canny);
		end = haxe.Timer.stamp();
		trace("Canny edge detection took: " + MathUtils.turnicate(end - start, 4) + " seconds");
	}

	public static function printIm(image:Image) {
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

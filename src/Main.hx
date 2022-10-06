package;

import vision.ds.Kernal2D;
import haxe.ds.ArraySort;
import vision.algorithms.Radix;
import vision.ds.Histogram;
import vision.exceptions.MultithreadFaliure;
import vision.tools.ImageTools;

using vision.tools.ImageTools;

import format.tga.Data.ImageType;
import vision.ds.Queue;
import vision.ds.Line2D;
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
import js.html.File;
import js.html.FileSystem;
import js.html.Document;
import js.Browser;
#end
import vision.algorithms.Hough;
import vision.ds.Image;

using vision.Vision;
using vision.tools.MathTools;

class Main {
	static function main() {
		var start:Float, end:Float;

		ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG",
			image -> {
				printImage(image);
				#if simple_tests
				start = haxe.Timer.stamp();
				printImage(Vision.blackAndWhite(image.clone()));
				end = haxe.Timer.stamp();
				trace("Black and white took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(Vision.grayscale(image.clone()));
				end = haxe.Timer.stamp();
				trace("Grayscale took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().contrast());
				end = haxe.Timer.stamp();
				trace("Contrast took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone());
				end = haxe.Timer.stamp();
				trace("Image Cloning took: " + MathTools.turnicate(end - start, 4) + " seconds");
				#end
				#if convolve_tests
				start = haxe.Timer.stamp();
				printImage(image.clone().convolve(Identity));
				end = haxe.Timer.stamp();
				trace("Identity Convolution took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().convolve(BoxBlur));
				end = haxe.Timer.stamp();
				trace("BoxBlur Convolution took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().convolve(RidgeDetection));
				end = haxe.Timer.stamp();
				trace("Ridge Detection Convolution took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().convolve(RidgeDetectionAggresive));
				end = haxe.Timer.stamp();
				trace("Aggresive Ridge Detection Convolution took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().convolve(Sharpen));
				end = haxe.Timer.stamp();
				trace("Shaprening Convolution took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().convolve(UnsharpMasking));
				end = haxe.Timer.stamp();
				trace("Unsharp Masking Convolution took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().deepfry());
				end = haxe.Timer.stamp();
				trace("Deepfrying took: " + MathTools.turnicate(end - start, 4) + " seconds");
				#end

				#if mirror_flip_tests
				start = haxe.Timer.stamp();
				printImage(image.clone().mirror());
				end = haxe.Timer.stamp();
				trace("Image Mirroring took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().flip());
				end = haxe.Timer.stamp();
				trace("Image Flipping took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().mirror().flip());
				end = haxe.Timer.stamp();
				trace("Image Mirroring & Flipping took: " + MathTools.turnicate(end - start, 4) + " seconds");
				#end

				#if filter_tests
				start = haxe.Timer.stamp();
				printImage(image.clone().sobelEdgeDiffOperator());
				end = haxe.Timer.stamp();
				trace("Sobel Filter took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().perwittEdgeDiffOperator());
				end = haxe.Timer.stamp();
				trace("Perwitt Filter took: " + MathTools.turnicate(end - start, 4) + " seconds");
				#end
				
				
				#if blur_tests
				start = haxe.Timer.stamp();
				printImage(Vision.nearestNeighborBlur(image.clone(), 4));
				end = haxe.Timer.stamp();
				trace("Nearest neighbor blur took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().gaussianBlur(1, X9));
				end = haxe.Timer.stamp();
				trace("Gaussian blur took: " + MathTools.turnicate(end - start, 4) + " seconds");
				start = haxe.Timer.stamp();
				printImage(image.clone().medianBlur(7));
				end = haxe.Timer.stamp();
				trace("Median blur took: " + MathTools.turnicate(end - start, 4) + " seconds");
				#end

				#if feature_detection_tests
				start = haxe.Timer.stamp();
				var lines = Vision.simpleLine2DDetection(image.clone(), 50, 30);
				var newI = image.clone();
				for (l in lines) {
					newI.drawLine2D(l, 0x00FFD5);
				}
				printImage(newI);
				end = haxe.Timer.stamp();
				trace("Simple line detection took: " + MathTools.turnicate(end - start, 4) + " seconds");
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
				var canny = Vision.cannyEdgeDetection(image.clone());
				printImage(canny);
				end = haxe.Timer.stamp();
				trace("Canny edge detection took: " + MathTools.turnicate(end - start, 4) + " seconds");
				#end
			});

		#if draw_tests
		var image = new Image(250, 250, 0x000000);
		image.drawLine(12, 53, 54, 15, 0xbd0202);
		image.drawLine(56, 248, 181, 95, 0x000355);
		image.drawLine(110, 15, 121, 131, 0x31f300);
		image.drawLine(248, 53, 15, 231, 0xffffff);
		image.drawRect(34, 12, 33, 53, 0xf0ff46);
		image.fillRect(12, 53, 33, 53, 0xffffff);
		image.drawCircle(100, 100, 50, 0x3c896e);
		image.drawCircle(100, 100, 30, 0xff00d4);
		image.fillCircle(200, 200, 40, Color.YELLOW);
		image.drawCircle(180, 190, 5, Color.BROWN);
		image.fillColor(new Point2D(180, 190), Color.BROWN);
		image.drawCircle(220, 190, 5, Color.BROWN);
		image.fillColor(new Point2D(220, 190), Color.BROWN);
		image.drawCircle(200, 225, 8, Color.BROWN);
		image.fillColor(new Point2D(200, 225), Color.BROWN);
		image.drawQuadraticBezier(new Line2D({x: 100, y: 100}, {x: 200, y: 100}), {x: 200, y: 200}, 0x1900ff);
		image.drawCubicBezier(new Line2D({x: 10, y: 10}, {x: 50, y: 100}), {x: 150, y: 200}, {x: 200, y: 75}, 0xff0000);
		image.drawRay2D(new Ray2D({x: 0, y: 0}, 1), 0x00ff00);
		image.drawEllipse(100, 100, 40, 21, 0x9fff9f);
		image.drawRect(20, 200, 60, 40, 0xFF5432);
		image.fillUntilColor({x: 25, y: 205}, 0xFF48FF, 0xFF5432);
		printImage(image);
		#end

		#if ds_tests
		trace(new Ray2D({x: 0, y: 0}, 1).getPointAtX(8));
		trace(new Ray2D({x: 0, y: 0}, 1).slope);
		trace(new Ray2D({x: 0, y: 0}, 1).degrees);
		trace(new Ray2D({x: 0, y: 0}, 1).radians);
		trace(new Ray2D({x: 0, y: 0}, 1).getPointAtY(8));
		trace(new Ray2D({x: 0, y: 0}, 1).yIntercept);
		trace(new Ray2D({x: 0, y: 0}, 1).xIntercept);
		trace(new Ray2D({x: 0, y: 0}, 1).findPointWithDistance(0, Math.sqrt(2) * 5, true));
		trace(new Ray2D({x: 0, y: 0}, 1).findPointWithDistance(0, Math.sqrt(2) * 5, false));
		var h = new Histogram();
		var queue = new Queue<Int>();
		queue.enqueue(0);
		queue.enqueue(1);
		queue.enqueue(2);
		queue.enqueue(3);
		trace(queue.toString());
		trace(queue.dequeue());
		trace(queue.dequeue());
		trace(queue.dequeue());
		trace(queue.toString());
		#end

		#if radix_test

		function enrich(arr:Array<Int>) {
			var sa:Array<Int> = [];
			for (i in 0...arr.length - 1) {
				sa.push(arr[i]);
				sa.push(Std.int((arr[i] + arr[i + 1]) / 2));
			}

			return sa;
		}
		function sts(f:Float) {
			return if (f == 0) "0.000s" else "" + f + "s";
		}

		var arr = [2,3,41,54,67456,456,34512,34123,667,562,23,124,26,785234,1234,12352,7656,834,5,456,215,76,35,235,745,7568,235234,126,4575,87,6,34,51234,236457,34561345,535,12,45123];
		trace("Radix \t\t\t\t\t| ArraySort.sort");
		trace("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		for (i in 0...16) {
			var s = " \t\t| ";
			var st = "";
			
			start = haxe.Timer.stamp();
			Radix.sort(arr.copy());
			end = haxe.Timer.stamp();
			st += 'length: ${arr.length}, time: ${sts(MathTools.turnicate(end - start, 4))}' + if (i == 15) " \t| " else s;
			start = haxe.Timer.stamp();
			ArraySort.sort(arr.copy(), (a, b) -> a - b);
			end = haxe.Timer.stamp();
			st += 'length: ${arr.length}, time: ${sts(MathTools.turnicate(end - start, 4))}';
			trace(st);
			arr = enrich(arr);
		}
		#end
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

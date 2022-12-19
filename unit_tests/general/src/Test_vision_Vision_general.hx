package;

import vision.ds.Line2D;
import vision.ds.Point2D;
import vision.ds.Color;
import vision.ds.Image;
import vision.tools.MathTools;
import vision.tools.ImageTools;
import vision.ds.Queue;
import vision.ds.Histogram;
import vision.ds.Ray2D;
using vision.Vision;
import vision.ds.Kernal2D;
import vision.ds.figures.*;

class Test_vision_Vision_general
{
    public static function main()
    {
        var start:Float = 0, end:Float = 0;
		ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG", image -> {
			image = image.resize(150, 112, BilinearInterpolation);
			start = haxe.Timer.stamp();
			printImage(Vision.blackAndWhite(image.clone()));
			end = haxe.Timer.stamp();
			trace("Black and white took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.grayscale(image.clone()));
			end = haxe.Timer.stamp();
			trace("Grayscale took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.invert(image.clone()));
			end = haxe.Timer.stamp();
			trace("Inversion took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().contrast());
			end = haxe.Timer.stamp();
			trace("Contrast took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().sharpen());
			end = haxe.Timer.stamp();
			trace("Sharpening took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().deepfry());
			end = haxe.Timer.stamp();
			trace("Deepfrying took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone());
			end = haxe.Timer.stamp();
			trace("Image Cloning took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.saltAndPepperNoise(image.clone()));
			end = haxe.Timer.stamp();
			trace("Salt & pepper took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.dropOutNoise(image.clone()));
			end = haxe.Timer.stamp();
			trace("Dropout Noise took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.whiteNoise(image.clone()));
			end = haxe.Timer.stamp();
			trace("White Noise took: " + MathTools.truncate(end - start, 4) + " seconds");

			start = haxe.Timer.stamp();
			printImage(image.clone().mirror());
			end = haxe.Timer.stamp();
			trace("Image Mirroring took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().flip());
			end = haxe.Timer.stamp();
			trace("Image Flipping took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().mirror().flip());
			end = haxe.Timer.stamp();
			trace("Image Mirroring & Flipping took: " + MathTools.truncate(end - start, 4) + " seconds");

			start = haxe.Timer.stamp();
			printImage(image.clone().sobelEdgeDiffOperator());
			end = haxe.Timer.stamp();
			trace("Sobel Filter took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().perwittEdgeDiffOperator());
			end = haxe.Timer.stamp();
			trace("Perwitt Filter took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().robertEdgeDiffOperator());
			end = haxe.Timer.stamp();
			trace("Robert Filter took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().laplacianEdgeDiffOperator());
			end = haxe.Timer.stamp();
			trace("Laplacian Filter took: " + MathTools.truncate(end - start, 4) + " seconds");

			start = haxe.Timer.stamp();
			printImage(Vision.bilateralDenoise(image.clone().sharpen(), 0.8, 50));
			end = haxe.Timer.stamp();
			trace("Bilateral Denoising took: " + MathTools.truncate(end - start, 4) + " seconds");			
			
			start = haxe.Timer.stamp();
			printImage(Vision.nearestNeighborBlur(image.clone(), 1));
			end = haxe.Timer.stamp();
			trace("Nearest neighbor blur took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().gaussianBlur(1));
			end = haxe.Timer.stamp();
			trace("Gaussian blur took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().medianBlur(5));
			end = haxe.Timer.stamp();
			trace("Median blur took: " + MathTools.truncate(end - start, 4) + " seconds");

			start = haxe.Timer.stamp();
			var lines = Vision.simpleLine2DDetection(image.clone(), 50, 15);
			var newI = image.clone();
			for (l in lines) {
				newI.drawLine2D(l, 0x00FFD5);
			}
			printImage(newI);
			end = haxe.Timer.stamp();
			trace("Simple line detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().sobelEdgeDetection());
			end = haxe.Timer.stamp();
			trace("Sobel edge detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.perwittEdgeDetection(image.clone()));
			end = haxe.Timer.stamp();
			trace("Perwitt edge detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			var canny = Vision.cannyEdgeDetection(image.clone());
			printImage(canny);
			end = haxe.Timer.stamp();
			trace("Canny edge detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.convolutionRidgeDetection(image.clone(), true));
			end = haxe.Timer.stamp();
			trace("Ridge detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().laplacianOfGaussianEdgeDetection());
			end = haxe.Timer.stamp();
			trace("Laplacian edge detection took: " + MathTools.truncate(end - start, 4) + " seconds");
		});
		vision.tools.ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", image ->
		{
			start = haxe.Timer.stamp();
			printImage(image.clone().convolve(Identity));
			end = haxe.Timer.stamp();
			trace("Identity Convolution took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().convolve(BoxBlur));
			end = haxe.Timer.stamp();
			trace("BoxBlur Convolution took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().convolve(RidgeDetection));
			end = haxe.Timer.stamp();
			trace("Ridge Detection Convolution took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().convolve(RidgeDetectionAggressive));
			end = haxe.Timer.stamp();
			trace("Aggressive Ridge Detection Convolution took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().convolve(Sharpen));
			end = haxe.Timer.stamp();
			trace("Sharpening Convolution took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().convolve(UnsharpMasking));
			end = haxe.Timer.stamp();
			trace("Unsharp Masking Convolution took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().deepfry());
			end = haxe.Timer.stamp();
			trace("Deepfrying took: " + MathTools.truncate(end - start, 4) + " seconds");
		});

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
		image.drawLine2D(new Line2D({x: 13, y: 32.2}, {x: 123, y: 40}), Color.FUCHSIA);
		image.drawEllipse(100, 100, 40, 21, 0x9fff9f);
		image.drawRect(20, 200, 60, 40, 0xFF5432);
		image.fillUntilColor({x: 25, y: 205}, 0xFF48FF, 0xFF5432);
		printImage(image);
		var pixelTests = new Image(300, 300);
		for (x in 0...299) {
			pixelTests.paintFloatingPixel(x, x / 3, 0xFFFF0000);
		}
		printImage(pixelTests);

		trace(new Ray2D({x: 0, y: 0}, 1).getPointAtX(8));
		trace(new Ray2D({x: 0, y: 0}, 1).slope);
		trace(new Ray2D({x: 0, y: 0}, 1).degrees);
		trace(new Ray2D({x: 0, y: 0}, 1).radians);
		trace(new Ray2D({x: 0, y: 5}, 2).getPointAtY(8));
		trace(new Ray2D({x: 0, y: 5}, 2).yIntercept);
		trace(new Ray2D({x: 0, y: 5}, 2).xIntercept);
		var h = new Histogram();
		h.increment(1);
		h.increment(1);
		h.increment(1);
		h.increment(2);
		h.increment(2);
		h.increment(24);
		h.increment(32);
		h.decrement(1);
		trace(h.median);
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
	    
	    var roudns:RoundedRectangle = new RoundedRectangle(0, 0, 100, 100, 4);
	   
	    var circle:Circle = new Circle(0, 0, 100, 100, 50);
	    for(x1 in 0...circle.width) {
		    for(y1 in 0...circle.height) {
			    trace('Circle: Trying to see if pixel (' + x1 + ', ' + y1 + ') is in circle');
			    trace('Works?: ' + circle.coordinateExists(x1, y1));
		    }
	    }
    }


    static function printImage(i) {
        trace("passed");
    }
}
        
        

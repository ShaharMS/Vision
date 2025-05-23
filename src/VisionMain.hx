package;

import vision.algorithms.SimpleHough;
import vision.ds.Matrix2D;
import vision.ds.Color;
import vision.ds.Point2D;
import vision.ds.Line2D;
import vision.ds.Ray2D;
import vision.ds.Kernel2D;
using vision.tools.ImageTools;

#if js
import js.html.File;
import js.html.FileSystem;
import js.html.Document;
import js.Browser;
#end
import vision.ds.Image;

using vision.Vision;
using vision.tools.MathTools;

@:noCompletion class VisionMain {
	static function main() {
		var start:Float, end:Float;
		#if (true)
		#if (js || interp)
		#if (!compile_unit_tests)
		ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG", image -> {
			trace(image.width, image.height);
			printSectionDivider("Test image, resized");
			var orgImage = image.clone();
			printImage(image);
			image = image.resize(150, 112, BilinearInterpolation);
			printImage(image);
			printImage(image.filterForColorChannel(RED));
			
			#if simple_tests
			printSectionDivider("Simple image manipulation");
			start = haxe.Timer.stamp();
			printImage(Vision.blackAndWhite(image.clone()));
			end = haxe.Timer.stamp();
			trace("Black and white took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.grayscale(image.clone()));
			end = haxe.Timer.stamp();
			trace("Grayscale took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.sepia(image.clone()));
			end = haxe.Timer.stamp();
			trace("Sepia took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.pixelate(image.clone()));
			end = haxe.Timer.stamp();
			trace("Pixelation took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(Vision.invert(image.clone()));
			end = haxe.Timer.stamp();
			trace("Inversion took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().posterize());
			end = haxe.Timer.stamp();
			trace("Posterization took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().kmeansPosterize(6));
			end = haxe.Timer.stamp();
			trace("Kmeans Posterization took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().contrast());
			end = haxe.Timer.stamp();
			trace("Contrast took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().smooth());
			end = haxe.Timer.stamp();
			trace("Smoothing took: " + MathTools.truncate(end - start, 4) + " seconds");
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
			printImage(image.clone().vignette(true));
			end = haxe.Timer.stamp();
			trace("Vignette filter took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().fisheyeDistortion());
			end = haxe.Timer.stamp();
			trace("Fisheye filter took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().barrelDistortion());
			end = haxe.Timer.stamp();
			trace("Barrel distortion took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().pincushionDistortion());
			end = haxe.Timer.stamp();
			trace("Pincushion distortion took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().mustacheDistortion());
			end = haxe.Timer.stamp();
			trace("Mustache distortion took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().erode());
			end = haxe.Timer.stamp();
			trace("Erosion took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().dilate());
			end = haxe.Timer.stamp();
			trace("Dilation took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			var i = image.clone();
			i.forEachPixel((x, y, color) -> i.setPixel(x, y, color & 0x88FFFFFF));
			//i.saveToFile("test.png");
			printImage(i);
			end = haxe.Timer.stamp();
			trace("Lightening took: " + MathTools.truncate(end - start, 4) + " seconds");
			#end

			#if mirror_flip_tests
			printSectionDivider("Mirror/flip tests");
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
			#end

			#if matrix_tests
			printSectionDivider("Matrix application tests");
			start = haxe.Timer.stamp();
			printImage({var i = image.clone(); i.affineTransform(Matrix2D.ROTATION(40));});
			printImage({var i = image.clone(); i.affineTransform(Matrix2D.ROTATION(40), RESIZE);});
			printImage({var i = image.clone(); i.affineTransform(Matrix2D.SHEAR(0.5, 0.3));});
			printImage({var i = image.clone(); i.affineTransform(Matrix2D.TRANSLATION(60, 55));});
			printImage({var i = image.clone(); i.affineTransform(Matrix2D.REFLECTION(30));});
			printImage({var i = image.clone(); i.affineTransform(Matrix2D.SCALE(5, 1.5));});
			end = haxe.Timer.stamp();
			trace("Simple Matrix Applications took: " + MathTools.truncate(end - start, 4) + " seconds");

			start = haxe.Timer.stamp();
			printImage(image.clone().projectiveTransform(Matrix2D.PERSPECTIVE([
				{from: {x: 0, y: 0}, to: {x: 30, y: 24}},
				{from: {x: image.width, y: 0}, to: {x: image.width, y: 55}},
				{from: {x: 0, y: image.height}, to: {x: 15, y: image.height - 10}},
				{from: {x: image.width, y: image.height}, to: {x: image.width, y: 91}}

			])));
			end = haxe.Timer.stamp();
			trace("Warping took: " + MathTools.truncate(end - start, 4) + " seconds");

			#end

			#if kmeans_tests
			printSectionDivider("Image K-means color clustering tests");
			start = haxe.Timer.stamp();
			printImage(image.clone().kmeansPosterize(4));
			end = haxe.Timer.stamp();
			trace("Kmeans Posterization (4 colors) took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().kmeansPosterize(8));
			end = haxe.Timer.stamp();
			trace("Kmeans Posterization (8 colors) took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().kmeansPosterize(16));
			end = haxe.Timer.stamp();
			trace("Kmeans Posterization (16 colors) took: " + MathTools.truncate(end - start, 4) + " seconds");
			
			start = haxe.Timer.stamp();
			var colors = image.kmeansGroupImageColors(16);
			var newImage = new Image(100, 100);
			for (x in 0...4) {
				for (y in 0...4) {
					newImage.fillRect(x * 25, y * 25, 25, 25, colors[y * 4 + x].centroid);
				}
			}
			printImage(newImage);
			end = haxe.Timer.stamp();
			trace("Kmeans grouping (16 colors) took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			var colors = image.kmeansGroupImageColors(8);
			var newImage = new Image(100, 100);
			for (x in 0...4) {
				for (y in 0...2) {
					newImage.fillRect(x * 25, y * 50, 25, 50, colors[y * 2 + x].centroid);
				}
			}
			printImage(newImage);
			end = haxe.Timer.stamp();
			trace("Kmeans grouping (8 colors) took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			var colors = image.kmeansGroupImageColors(4);
			var newImage = new Image(100, 100);
			for (x in 0...2) {
				for (y in 0...2) {
					newImage.fillRect(x * 50, y * 50, 50, 50, colors[y * 2 + x].centroid);
				}
			}
			printImage(newImage);
			end = haxe.Timer.stamp();
			trace("Kmeans grouping (4 colors) took: " + MathTools.truncate(end - start, 4) + " seconds");

			start = haxe.Timer.stamp();
			final __i2 = image.clone();
			__i2.tint(Color.AMETHYST, 20);
			printImage(__i2);
			end = haxe.Timer.stamp();
			trace("Similarity check took: " + MathTools.truncate(end - start, 4) + " seconds, Result: " + image.simpleImageSimilarity(__i2, HIGHEST_COLOR_DIFFERENCE));
			#end

			#if filter_tests
			printSectionDivider("Image filtering tests");
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
			#end

			#if noise_tests
			printSectionDivider("Noising/denoising tests");
			start = haxe.Timer.stamp();
			printImage(Vision.bilateralDenoise(image.clone().contrast(), 0.8, 50));
			end = haxe.Timer.stamp();
			trace("Bilateral Denoising of Dropout noise took: " + MathTools.truncate(end - start, 4) + " seconds");
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
			#end
			
			
			#if blur_tests
			printSectionDivider("Blur tests");
			start = haxe.Timer.stamp();
			printImage(Vision.nearestNeighborBlur(image.clone(), 1));
			end = haxe.Timer.stamp();
			trace("Nearest neighbor blur took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().gaussianBlur(1));
			end = haxe.Timer.stamp();
			trace("Gaussian blur took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().gaussianBlur(1, true));
			end = haxe.Timer.stamp();
			trace("Fast Gaussian blur took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			printImage(image.clone().medianBlur(5));
			end = haxe.Timer.stamp();
			trace("Median blur took: " + MathTools.truncate(end - start, 4) + " seconds");
			#end

			#if feature_detection_tests
			printSectionDivider("Feature detection tests");
			start = haxe.Timer.stamp();
			var lines = Vision.simpleLine2DDetection(orgImage.clone(), 50, 10);
			var newI = orgImage.clone();
			for (l in lines) {
				newI.drawLine2D(l, 0x00FFD5);
			}
			printImage(newI);
			end = haxe.Timer.stamp();
			trace("Simple line detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			var lines = SimpleHough.detectLines(orgImage.clone().cannyEdgeDetection(1, X5, 0.05, 0.16), 40);
			var newI = orgImage.clone();
			for (l in lines) {
				newI.drawRay2D(l, 0x00FFD5);
			}
			printImage(newI);
			end = haxe.Timer.stamp();
			trace("Hough Style Line detection took: " + MathTools.truncate(end - start, 4) + " seconds");
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
			#end
		});
		ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", image -> {
			#if convolve_tests
			printSectionDivider("Convolution tests");
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
			#end
		});
		#if draw_tests
		printSectionDivider("Draw tests");
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
		image.fillEllipse(100, 100, 40, 21, 0x9fff9f);
		image.drawRect(20, 200, 60, 40, 0xFF5432);
		image.fillUntilColor({x: 25, y: 205}, 0xFF48FF, 0xFF5432);
		printImage(image);
		var pixelTests = new Image(300, 300);
		for (x in 0...299) {
			pixelTests.paintFloatingPixel(x, x / 3, 0xFFFF0000);
		}
		//pixelTests.resize(100, 100, NearestNeighbor);
		printImage(pixelTests);
		#end
		#if copy_paste_tests
		ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Valve_original_%281%29.PNG/300px-Valve_original_%281%29.PNG", valve -> {
			ImageTools.loadFromFile("https://upload.wikimedia.org/wikipedia/commons/5/50/Vd-Orig.png", test -> {
				printSectionDivider("copy/paste tests");
				var image = valve.clone();
				var sip = image.clone();
				sip.setImagePortion({x: 20, y: 20, width: test.width, height: test.width}, test);
				printImage(sip);
				var stamped = image.clone();
				var st = test.clone();
				st.forEachPixel((x, y, color) -> {color.alpha = 200; st.setPixel(x, y, color);});
				stamped.stamp(10, 30, st);
				printImage(stamped); 
			});
		});
		#end

		#if (feature_detection_tests && js)
		ImageTools.loadFromFile("./sudoku.jpg", sudoku -> {
			printSectionDivider("Line detection tests");
			var image = sudoku.resize(400);
			printImage(image);
			start = haxe.Timer.stamp();
			var lines = Vision.simpleLine2DDetection(image.clone(), 50, 30);
			var newI = image.clone();
			for (l in lines) {
				newI.drawLine2D(l, 0x00FFD5);
			}
			printImage(newI);
			end = haxe.Timer.stamp();
			trace("Simple line detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			start = haxe.Timer.stamp();
			var lines = SimpleHough.detectLines(image.clone().cannyEdgeDetection(1, X5, 0.05, 0.16), 100);
			var newI = image.clone();
			for (l in lines) {
				newI.drawRay2D(l, 0x00FFD5);
			}
			printImage(image.clone().cannyEdgeDetection(1, X5, 0.05, 0.16));
			printImage(newI);
			end = haxe.Timer.stamp();
			trace("Hough Style Line detection took: " + MathTools.truncate(end - start, 4) + " seconds");
			
		});
		#end
		#end

		#if ds_tests
		trace(new Ray2D({x: 0, y: 0}, 1).getPointAtX(8));
		trace(new Ray2D({x: 0, y: 0}, 1).slope);
		trace(new Ray2D({x: 0, y: 0}, 1).degrees);
		trace(new Ray2D({x: 0, y: 0}, 1).radians);
		trace(new Ray2D({x: 0, y: 0}, 1).getPointAtY(8));
		trace(new Ray2D({x: 0, y: 0}, 1).yIntercept);
		trace(new Ray2D({x: 0, y: 0}, 1).xIntercept);
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

		var arr = [-2,3,41,54,67456,-456,34512,-34123,667,-562,-23,-124,26,785234,-1234,-12352,7656,-834,-5,456,-215,76,-35,-235,745,7568,-235234,126,-4575,-87,6,34,-51234,-236457,34561345,535,12,45123];
		var c = arr.copy();
		ArraySort.sort(c, (a, b) -> a - b);
		trace(Radix.sort(arr.copy()), c);
		trace("Radix \t\t\t\t\t| ArraySort.sort");
		trace("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
		for (i in 0...16) {
			var s = " \t\t| ";
			var st = "";
			
			start = haxe.Timer.stamp();
			Radix.sort(arr.copy());
			end = haxe.Timer.stamp();
			st += 'length: ${arr.length}, time: ${sts(MathTools.truncate(end - start, 4))}' + if (i == 15) " \t| " else s;
			start = haxe.Timer.stamp();
			ArraySort.sort(arr.copy(), (a, b) -> a - b);
			end = haxe.Timer.stamp();
			st += 'length: ${arr.length}, time: ${sts(MathTools.truncate(end - start, 4))}';
			trace(st);
			arr = enrich(arr);
		}
		#end

		#elseif (sys && compile_unit_tests)
		//var s = Type.getClassFields(Vision);
		//var st = "[";
		//for (t in s) {
		//	st += "'" + t + "', ";
		//}
		//trace(st.substring(0, st.length - 2) + "]");
		var cases = TestCaseGenerator.generateFromClass(Vision);
		for (i in 0...cases.length) {
			/*PC: */ 
			try {
				cases[i].writeCrossPlatformHaxeProject("C:\\Users\\Marcus\\Documents\\Github\\Vision\\unit_tests", cases[i].method);
			} catch (e) {
				trace("Working on laptop, path changed...");
				cases[i].writeCrossPlatformHaxeProject("C:\\Users\\shahar\\Documents\\GitHub\\Vision\\unit_tests", cases[i].method);

			}
		}
		try {
			TestCaseGenerator.generateHaxeProjectOfMultipleTestCases(cases, "C:\\Users\\Marcus\\Documents\\Github\\Vision", "main_test");
		} catch (e) {
			trace("Working on laptop, path changed...");
			TestCaseGenerator.generateHaxeProjectOfMultipleTestCases(cases, "C:\\Users\\shahar\\Documents\\GitHub\\Vision", "main_test");
		}
		#end
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
				data[i + 3] = 255; //image.getPixel(x, y).alpha;
			}
		}
		ctx.putImageData(imageData, 0, 0);
		c.style.padding = "10px";
		Browser.document.body.appendChild(c);
	#end
	}

	public static function printSectionDivider(title:String) {
	#if js
	var div = Browser.document.createDivElement();
	div.style.overflow = "hidden";
	div.style.whiteSpace = "nowrap";
	div.textContent = title + ":";
	div.style.fontWeight = "bold";
	var hr = Browser.document.createHRElement();
	Browser.document.body.appendChild(div);
	var divW = title.length * 9;
	hr.style.float = "right";
	hr.style.display = "inline-block";
	hr.style.width = 'calc(100% - ${divW}px)';
	div.appendChild(hr);
	Browser.console.log(title + ":\n----------------------------------------------------------------");
	#else
	trace(title + ":\n----------------------------------------------------------------");
	#end
	}
}

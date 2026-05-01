package;

using StringTools;

import utest.Runner;
import PrettyReporter;
import tests.*;

#if nodejs
import js.Node;
#end

class Main {
	static function main() {
		var runner = new Runner();

		var rawFilter:String = null;
		#if sys
		rawFilter = Sys.getEnv("VISION_TESTS");
		if (rawFilter == null || rawFilter.trim().length == 0) rawFilter = Sys.getEnv("VISION_TEST_CLASSES");
		#elseif nodejs
		var env = Node.process.env;
		if (env != null) {
			rawFilter = env.get("VISION_TESTS");
			if (rawFilter == null || rawFilter.trim().length == 0) rawFilter = env.get("VISION_TEST_CLASSES");
		}
		#end

		var args:Array<String> = [];
		#if sys
		args = Sys.args();
		#elseif nodejs
		args = Node.process.argv;
		#end
		for (i in 0...args.length) {
			if (args[i] == "--tests" && i + 1 < args.length) {
				rawFilter = args[i + 1];
				break;
			}
		}

		var filter:Array<String> = [];
		if (rawFilter != null && rawFilter.trim().length > 0) {
			for (part in rawFilter.split(",")) {
				var name = part.trim();
				if (name.length > 0) filter.push(name);
			}
		}

		function includeTest(name:String):Bool {
			return filter.length == 0 || filter.indexOf(name) != -1;
		}

		if (includeTest("Array2DTest")) runner.addCase(new Array2DTest());
		if (includeTest("ArrayToolsTest")) runner.addCase(new ArrayToolsTest());
		if (includeTest("BicubicInterpolationTest")) runner.addCase(new BicubicInterpolationTest());
		if (includeTest("BilateralFilterTest")) runner.addCase(new BilateralFilterTest());
		if (includeTest("BilinearInterpolationTest")) runner.addCase(new BilinearInterpolationTest());
		if (includeTest("ByteArrayTest")) runner.addCase(new ByteArrayTest());
		if (includeTest("CannyTest")) runner.addCase(new CannyTest());
		if (includeTest("CatmullRomInterpolationTest")) runner.addCase(new CatmullRomInterpolationTest());
		if (includeTest("ColorClusterTest")) runner.addCase(new ColorClusterTest());
		if (includeTest("ColorTest")) runner.addCase(new ColorTest());
		if (includeTest("CramerTest")) runner.addCase(new CramerTest());
		if (includeTest("FromBytesTest")) runner.addCase(new FromBytesTest());
		if (includeTest("FromTest")) runner.addCase(new FromTest());
		if (includeTest("GaussJordanTest")) runner.addCase(new GaussJordanTest());
		if (includeTest("GaussTest")) runner.addCase(new GaussTest());
		if (includeTest("HistogramTest")) runner.addCase(new HistogramTest());
		if (includeTest("ImageFormatTest")) runner.addCase(new ImageFormatTest());
		if (includeTest("ImageHashingTest")) runner.addCase(new ImageHashingTest());
		if (includeTest("ImageIOTest")) runner.addCase(new ImageIOTest());
		if (includeTest("ImageTest")) runner.addCase(new ImageTest());
		if (includeTest("ImageToolsTest")) runner.addCase(new ImageToolsTest());
		if (includeTest("ImageViewTest")) runner.addCase(new ImageViewTest());
		if (includeTest("Int16Point2DTest")) runner.addCase(new Int16Point2DTest());
		if (includeTest("IntPoint2DTest")) runner.addCase(new IntPoint2DTest());
		if (includeTest("KMeansTest")) runner.addCase(new KMeansTest());
		if (includeTest("KernelResamplerTest")) runner.addCase(new KernelResamplerTest());
		if (includeTest("LanczosInterpolationTest")) runner.addCase(new LanczosInterpolationTest());
		if (includeTest("LaplaceTest")) runner.addCase(new LaplaceTest());
		if (includeTest("Line2DTest")) runner.addCase(new Line2DTest());
		if (includeTest("MathToolsTest")) runner.addCase(new MathToolsTest());
		if (includeTest("Matrix2DTest")) runner.addCase(new Matrix2DTest());
		if (includeTest("MitchellNetravaliInterpolationTest")) runner.addCase(new MitchellNetravaliInterpolationTest());
		if (includeTest("PerspectiveWarpTest")) runner.addCase(new PerspectiveWarpTest());
		if (includeTest("PerwittTest")) runner.addCase(new PerwittTest());
		if (includeTest("PixelFormatTest")) runner.addCase(new PixelFormatTest());
		if (includeTest("PixelTest")) runner.addCase(new PixelTest());
		if (includeTest("Point2DTest")) runner.addCase(new Point2DTest());
		if (includeTest("Point3DTest")) runner.addCase(new Point3DTest());
		if (includeTest("PointTransformationPairTest")) runner.addCase(new PointTransformationPairTest());
		if (includeTest("QueueCellTest")) runner.addCase(new QueueCellTest());
		if (includeTest("QueueTest")) runner.addCase(new QueueTest());
		if (includeTest("RadixTest")) runner.addCase(new RadixTest());
		if (includeTest("Ray2DTest")) runner.addCase(new Ray2DTest());
		if (includeTest("RectangleTest")) runner.addCase(new RectangleTest());
		if (includeTest("RobertsCrossTest")) runner.addCase(new RobertsCrossTest());
		if (includeTest("SimpleHoughTest")) runner.addCase(new SimpleHoughTest());
		if (includeTest("SimpleLineDetectorTest")) runner.addCase(new SimpleLineDetectorTest());
		if (includeTest("SobelTest")) runner.addCase(new SobelTest());
		if (includeTest("ToBytesTest")) runner.addCase(new ToBytesTest());
		if (includeTest("ToTest")) runner.addCase(new ToTest());
		if (includeTest("TransformationMatrix2DTest")) runner.addCase(new TransformationMatrix2DTest());
		if (includeTest("UInt16Point2DTest")) runner.addCase(new UInt16Point2DTest());
		if (includeTest("VisionTest")) runner.addCase(new VisionTest());
		if (includeTest("VisionThreadTest")) runner.addCase(new VisionThreadTest());

		new PrettyReporter(runner);
		runner.run();
	}
}

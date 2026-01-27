package;

import utest.Runner;
import PrettyReporter;
import tests.*;
using StringTools;

class Main {
    static function main() {
        var runner = new Runner();

        var rawFilter = Sys.getEnv("VISION_TESTS");
        if (rawFilter == null || rawFilter.trim().length == 0) {
            rawFilter = Sys.getEnv("VISION_TEST_CLASSES");
        }
        var args = Sys.args();
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

        inline function includeTest(name:String):Bool {
            return filter.length == 0 || filter.indexOf(name) != -1;
        }

        if (includeTest("BilateralFilterTest")) runner.addCase(new BilateralFilterTest());
        if (includeTest("BilinearInterpolationTest")) runner.addCase(new BilinearInterpolationTest());
        if (includeTest("BicubicInterpolationTest")) runner.addCase(new BicubicInterpolationTest());
        if (includeTest("CatmullRomInterpolationTest")) runner.addCase(new CatmullRomInterpolationTest());
        if (includeTest("MitchellNetravaliInterpolationTest")) runner.addCase(new MitchellNetravaliInterpolationTest());
        if (includeTest("LanczosInterpolationTest")) runner.addCase(new LanczosInterpolationTest());
        if (includeTest("CannyTest")) runner.addCase(new CannyTest());
        if (includeTest("CramerTest")) runner.addCase(new CramerTest());
        if (includeTest("GaussTest")) runner.addCase(new GaussTest());
        if (includeTest("GaussJordanTest")) runner.addCase(new GaussJordanTest());
        if (includeTest("ImageHashingTest")) runner.addCase(new ImageHashingTest());
        if (includeTest("KMeansTest")) runner.addCase(new KMeansTest());
        if (includeTest("LaplaceTest")) runner.addCase(new LaplaceTest());
        if (includeTest("PerspectiveWarpTest")) runner.addCase(new PerspectiveWarpTest());
        if (includeTest("PerwittTest")) runner.addCase(new PerwittTest());
        if (includeTest("RadixTest")) runner.addCase(new RadixTest());
        if (includeTest("RobertsCrossTest")) runner.addCase(new RobertsCrossTest());
        if (includeTest("SimpleHoughTest")) runner.addCase(new SimpleHoughTest());
        if (includeTest("SimpleLineDetectorTest")) runner.addCase(new SimpleLineDetectorTest());
        if (includeTest("SobelTest")) runner.addCase(new SobelTest());
        if (includeTest("ByteArrayTest")) runner.addCase(new ByteArrayTest());
        if (includeTest("CannyObjectTest")) runner.addCase(new CannyObjectTest());
        if (includeTest("ColorTest")) runner.addCase(new ColorTest());
        if (includeTest("HistogramTest")) runner.addCase(new HistogramTest());
        if (includeTest("ImageTest")) runner.addCase(new ImageTest());
        if (includeTest("ImageFormatTest")) runner.addCase(new ImageFormatTest());
        if (includeTest("ColorClusterTest")) runner.addCase(new ColorClusterTest());
        if (includeTest("PixelTest")) runner.addCase(new PixelTest());
        if (includeTest("PixelFormatTest")) runner.addCase(new PixelFormatTest());
        if (includeTest("Point2DTest")) runner.addCase(new Point2DTest());
        if (includeTest("Point3DTest")) runner.addCase(new Point3DTest());
        if (includeTest("QueueTest")) runner.addCase(new QueueTest());
        if (includeTest("QueueCellTest")) runner.addCase(new QueueCellTest());
        if (includeTest("RectangleTest")) runner.addCase(new RectangleTest());
        if (includeTest("PointTransformationPairTest")) runner.addCase(new PointTransformationPairTest());
        if (includeTest("FromTest")) runner.addCase(new FromTest());
        if (includeTest("FromBytesTest")) runner.addCase(new FromBytesTest());
        if (includeTest("ImageIOTest")) runner.addCase(new ImageIOTest());
        if (includeTest("ToTest")) runner.addCase(new ToTest());
        if (includeTest("ToBytesTest")) runner.addCase(new ToBytesTest());
        if (includeTest("ArrayToolsTest")) runner.addCase(new ArrayToolsTest());
        if (includeTest("ImageToolsTest")) runner.addCase(new ImageToolsTest());
        if (includeTest("MathToolsTest")) runner.addCase(new MathToolsTest());
        if (includeTest("VisionTest")) runner.addCase(new VisionTest());

        new PrettyReporter(runner);
        runner.run();
    }
}

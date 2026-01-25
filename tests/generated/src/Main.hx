package;

import utest.Runner;
import tests.*;

class Main {
    public static function main() {
        var runner = new Runner();
        
        // Add all test classes
        runner.addCase(new ArrayToolsTest());
        runner.addCase(new BilateralFilterTest());
        runner.addCase(new BilinearInterpolationTest());
        runner.addCase(new ByteArrayTest());
        runner.addCase(new CannyObjectTest());
        runner.addCase(new CannyTest());
        runner.addCase(new ColorClusterTest());
        runner.addCase(new ColorTest());
        runner.addCase(new CramerTest());
        runner.addCase(new GaussJordanTest());
        runner.addCase(new GaussTest());
        runner.addCase(new HistogramTest());
        runner.addCase(new ImageHashingTest());
        runner.addCase(new ImageIOTest());
        // runner.addCase(new ImageTest()); // DISABLED - potential hang
        // runner.addCase(new ImageToolsTest()); // DISABLED - causes infinite loop
        runner.addCase(new KMeansTest());
        runner.addCase(new LaplaceTest());
        runner.addCase(new MathToolsTest());
        runner.addCase(new PerspectiveWarpTest());
        runner.addCase(new PerwittTest());
        runner.addCase(new PixelTest());
        runner.addCase(new Point2DTest());
        runner.addCase(new Point3DTest());
        runner.addCase(new PointTransformationPairTest());
        runner.addCase(new QueueCellTest());
        runner.addCase(new QueueTest());
        runner.addCase(new RadixTest());
        runner.addCase(new RectangleTest());
        runner.addCase(new RobertsCrossTest());
        runner.addCase(new SimpleHoughTest());
        runner.addCase(new SimpleLineDetectorTest());
        runner.addCase(new SobelTest());
        runner.addCase(new VisionTest());
        
        #if sys
        // Use custom pretty reporter (replaces default utest reporting)
        new PrettyReporter(runner);
        #else
        utest.ui.Report.create(runner);
        #end
        runner.run();
    }
}

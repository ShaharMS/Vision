package;

import utest.Runner;
import PrettyReporter;
import tests.*;

class Main {
    static function main() {
        var runner = new Runner();

        runner.addCase(new BilateralFilterTest());
        runner.addCase(new BilinearInterpolationTest());
        runner.addCase(new CannyTest());
        runner.addCase(new CramerTest());
        runner.addCase(new GaussTest());
        runner.addCase(new GaussJordanTest());
        runner.addCase(new ImageHashingTest());
        runner.addCase(new KMeansTest());
        runner.addCase(new LaplaceTest());
        runner.addCase(new PerspectiveWarpTest());
        runner.addCase(new PerwittTest());
        runner.addCase(new RadixTest());
        runner.addCase(new RobertsCrossTest());
        runner.addCase(new SimpleHoughTest());
        runner.addCase(new SimpleLineDetectorTest());
        runner.addCase(new SobelTest());
        runner.addCase(new ByteArrayTest());
        runner.addCase(new CannyObjectTest());
        runner.addCase(new ColorTest());
        runner.addCase(new HistogramTest());
        runner.addCase(new ImageTest());
        runner.addCase(new ImageFormatTest());
        runner.addCase(new ColorClusterTest());
        runner.addCase(new PixelTest());
        runner.addCase(new PixelFormatTest());
        runner.addCase(new Point2DTest());
        runner.addCase(new Point3DTest());
        runner.addCase(new QueueTest());
        runner.addCase(new QueueCellTest());
        runner.addCase(new RectangleTest());
        runner.addCase(new PointTransformationPairTest());
        runner.addCase(new FromTest());
        runner.addCase(new FromBytesTest());
        runner.addCase(new ImageIOTest());
        runner.addCase(new ToTest());
        runner.addCase(new ToBytesTest());
        runner.addCase(new ArrayToolsTest());
        runner.addCase(new ImageToolsTest());
        runner.addCase(new MathToolsTest());
        runner.addCase(new VisionTest());

        new PrettyReporter(runner);
        runner.run();
    }
}

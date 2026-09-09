package tests.support;

import utest.Runner;
import tests.*;

class ManualSuites {
	public static function addCases(runner:Runner, includeTest:String->Bool, ?casePattern:EReg):Void {
		#if (!neko || !vision_neko_batched || vision_neko_batch_1)
		if (includeTest("Array2DTest")) runner.addCase(new Array2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ArrayToolsTest")) runner.addCase(new ArrayToolsTest(), "setup", "teardown", "test", casePattern);
		// Neko cannot load these image-heavy test modules: its VM rejects their generated function scope before tests start.
		// They remain part of the full suite on every other target.
		#if !neko
		if (includeTest("BicubicInterpolationTest")) runner.addCase(new BicubicInterpolationTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("BilateralFilterTest")) runner.addCase(new BilateralFilterTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("BilinearInterpolationTest")) runner.addCase(new BilinearInterpolationTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("ByteArrayTest")) runner.addCase(new ByteArrayTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("CannyTest")) runner.addCase(new CannyTest(), "setup", "teardown", "test", casePattern);
		#end
		#if !neko
		if (includeTest("CatmullRomInterpolationTest")) runner.addCase(new CatmullRomInterpolationTest(), "setup", "teardown", "test", casePattern);
		#end
		#end

		#if (!neko || !vision_neko_batched || vision_neko_batch_2)
		if (includeTest("ColorClusterTest")) runner.addCase(new ColorClusterTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ColorTest")) runner.addCase(new ColorTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("CramerTest")) runner.addCase(new CramerTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("FromBytesTest")) runner.addCase(new FromBytesTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("FromTest")) runner.addCase(new FromTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("GaussJordanTest")) runner.addCase(new GaussJordanTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("GaussTest")) runner.addCase(new GaussTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("HarrisTest")) runner.addCase(new HarrisTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("HistogramTest")) runner.addCase(new HistogramTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("HoughCircleTest")) runner.addCase(new HoughCircleTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("HoughProbabilisticTest")) runner.addCase(new HoughProbabilisticTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("HoughStandardTest")) runner.addCase(new HoughStandardTest(), "setup", "teardown", "test", casePattern);
		#end
		#end

		#if (!neko || !vision_neko_batched || vision_neko_batch_3)
		if (includeTest("ImageLoadingFailedTest")) runner.addCase(new ImageLoadingFailedTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ImageSavingFailedTest")) runner.addCase(new ImageSavingFailedTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ImageFormatTest")) runner.addCase(new ImageFormatTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("ImageHashingTest")) runner.addCase(new ImageHashingTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ImageIOTest")) runner.addCase(new ImageIOTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ImageTest")) runner.addCase(new ImageTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ImageToolsTest")) runner.addCase(new ImageToolsTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ImageViewTest")) runner.addCase(new ImageViewTest(), "setup", "teardown", "test", casePattern);
		#end
		#end

		#if (!neko || !vision_neko_batched || vision_neko_batch_4)
		if (includeTest("Int16Point2DTest")) runner.addCase(new Int16Point2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("IntPoint2DTest")) runner.addCase(new IntPoint2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("InvalidCramerCoefficientsMatrixTest")) runner.addCase(new InvalidCramerCoefficientsMatrixTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("InvalidCramerSetupTest")) runner.addCase(new InvalidCramerSetupTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("InvalidGaussianKernelSizeTest")) runner.addCase(new InvalidGaussianKernelSizeTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("InvalidHeapsPixelFormatTest")) runner.addCase(new InvalidHeapsPixelFormatTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("KMeansTest")) runner.addCase(new KMeansTest(), "setup", "teardown", "test", casePattern);
		#end
		#end

		#if (!neko || !vision_neko_batched || vision_neko_batch_5)
		#if !neko
		if (includeTest("KernelResamplerTest")) runner.addCase(new KernelResamplerTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("LanczosInterpolationTest")) runner.addCase(new LanczosInterpolationTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("LaplaceTest")) runner.addCase(new LaplaceTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("LibraryRequiredTest")) runner.addCase(new LibraryRequiredTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("Line2DTest")) runner.addCase(new Line2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("MathToolsTest")) runner.addCase(new MathToolsTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("Matrix2DTest")) runner.addCase(new Matrix2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("MatrixOperationErrorTest")) runner.addCase(new MatrixOperationErrorTest(), "setup", "teardown", "test", casePattern);
		#end

		#if (!neko || !vision_neko_batched || vision_neko_batch_6)
		#if !neko
		if (includeTest("MitchellNetravaliInterpolationTest")) runner.addCase(new MitchellNetravaliInterpolationTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("MultithreadFailureTest")) runner.addCase(new MultithreadFailureTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("OutOfBoundsTest")) runner.addCase(new OutOfBoundsTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("PerspectiveWarpTest")) runner.addCase(new PerspectiveWarpTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("PerwittTest")) runner.addCase(new PerwittTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("PixelFormatTest")) runner.addCase(new PixelFormatTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("PixelTest")) runner.addCase(new PixelTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("Point2DTest")) runner.addCase(new Point2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("Point3DTest")) runner.addCase(new Point3DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("PointTransformationPairTest")) runner.addCase(new PointTransformationPairTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("QueueCellTest")) runner.addCase(new QueueCellTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("QueueTest")) runner.addCase(new QueueTest(), "setup", "teardown", "test", casePattern);
		#end

		#if (!neko || !vision_neko_batched || vision_neko_batch_7)
		if (includeTest("RadixTest")) runner.addCase(new RadixTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("Ray2DTest")) runner.addCase(new Ray2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("RectangleTest")) runner.addCase(new RectangleTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("RobertsCrossTest")) runner.addCase(new RobertsCrossTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("SimpleHoughTest")) runner.addCase(new SimpleHoughTest(), "setup", "teardown", "test", casePattern);
		#end
		#end

		#if (!neko || !vision_neko_batched || vision_neko_batch_8)
		#if !neko
		if (includeTest("SimpleLineDetectorTest")) runner.addCase(new SimpleLineDetectorTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("SingularMatrixErrorTest")) runner.addCase(new SingularMatrixErrorTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("SobelTest")) runner.addCase(new SobelTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ToBytesTest")) runner.addCase(new ToBytesTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("ToTest")) runner.addCase(new ToTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("TransformationMatrix2DTest")) runner.addCase(new TransformationMatrix2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("UInt16Point2DTest")) runner.addCase(new UInt16Point2DTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("UnimplementedTest")) runner.addCase(new UnimplementedTest(), "setup", "teardown", "test", casePattern);
		#if !neko
		if (includeTest("VisionTest")) runner.addCase(new VisionTest(), "setup", "teardown", "test", casePattern);
		#end
		if (includeTest("VisionExceptionTest")) runner.addCase(new VisionExceptionTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("VisionThreadTest")) runner.addCase(new VisionThreadTest(), "setup", "teardown", "test", casePattern);
		if (includeTest("WebResponseErrorTest")) runner.addCase(new WebResponseErrorTest(), "setup", "teardown", "test", casePattern);
		#end
	}
}

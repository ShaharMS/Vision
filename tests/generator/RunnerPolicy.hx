package;

import TestModel.PlannedSuite;

class RunnerPolicy {
	static final activeLegacyClasses = [
		"ArrayToolsTest",
		"BicubicInterpolationTest",
		"BilateralFilterTest",
		"BilinearInterpolationTest",
		"ByteArrayTest",
		"CannyObjectTest",
		"CannyTest",
		"CatmullRomInterpolationTest",
		"ColorClusterTest",
		"ColorTest",
		"CramerTest",
		"FromBytesTest",
		"FromTest",
		"GaussJordanTest",
		"GaussTest",
		"HistogramTest",
		"ImageFormatTest",
		"ImageHashingTest",
		"ImageIOTest",
		"ImageTest",
		"ImageToolsTest",
		"KMeansTest",
		"LanczosInterpolationTest",
		"LaplaceTest",
		"MathToolsTest",
		"MitchellNetravaliInterpolationTest",
		"PerspectiveWarpTest",
		"PerwittTest",
		"PixelFormatTest",
		"PixelTest",
		"Point2DTest",
		"Point3DTest",
		"PointTransformationPairTest",
		"QueueCellTest",
		"QueueTest",
		"RadixTest",
		"RectangleTest",
		"RobertsCrossTest",
		"SimpleHoughTest",
		"SimpleLineDetectorTest",
		"SobelTest",
		"ToBytesTest",
		"ToTest",
		"VisionTest"
	];

	public static function applyLifecycle(suite:PlannedSuite):Void {
		var lifecycle = isRunnable(suite) ? "active" : "draft";
		suite.lifecycle = lifecycle;
		for (testCase in suite.cases) {
			testCase.lifecycle = lifecycle;
		}
	}

	public static function runnableClasses(suites:Array<PlannedSuite>):Array<String> {
		var classes:Array<String> = [];
		for (suite in suites) {
			if (isRunnable(suite)) classes.push(suite.testClassName);
		}
		return classes;
	}

	static function isRunnable(suite:PlannedSuite):Bool {
		return suite.provenance == "generated" || activeLegacyClasses.indexOf(suite.testClassName) != -1;
	}
}
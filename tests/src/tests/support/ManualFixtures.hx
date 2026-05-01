package tests.support;

import vision.ds.Image;

class ManualFixtures {
	public static function tinyGradientImage():Image {
		return Factories.gradientImage(3, 3);
	}

	public static function tinyCheckerboardImage():Image {
		return Factories.checkerboardImage(4, 4, 1);
	}
}
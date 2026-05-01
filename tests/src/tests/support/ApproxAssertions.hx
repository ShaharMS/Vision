package tests.support;

import utest.Assert;

class ApproxAssertions {
	public static function equalsFloat(expected:Float, actual:Float, tolerance:Float = 0.0001):Void {
		var delta = Math.abs(expected - actual);
		Assert.isTrue(delta <= tolerance);
	}
}
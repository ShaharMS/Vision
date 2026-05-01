package tests.support;

import utest.Assert;

class ExceptionAssertions {
	public static function throwsAny(callback:Void->Void):Void {
		var threw = false;
		try {
			callback();
		} catch (error:Dynamic) {
			threw = true;
		}
		Assert.isTrue(threw);
	}

	public static function throwsType(callback:Void->Void, expectedType:Class<Dynamic>):Void {
		var caught:Dynamic = null;
		try {
			callback();
		} catch (error:Dynamic) {
			caught = error;
		}
		Assert.notNull(caught);
		Assert.isTrue(Std.isOfType(caught, expectedType));
	}
}
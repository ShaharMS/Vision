package tests.support;

import haxe.Exception;
import utest.Assert;

class ExceptionAssertions {
	public static function capture(callback:Void->Void):Dynamic {
		try {
			callback();
		} catch (error:Dynamic) {
			return error;
		}
		Assert.isTrue(false);
		return null;
	}

	public static function messageOf(error:Dynamic):String {
		return Std.isOfType(error, Exception) ? cast(error, Exception).message : Std.string(error);
	}

	public static function expectMessage<T>(callback:Void->Void, expectedType:Class<T>, expectedMessage:String):T {
		var error = capture(callback);
		Assert.isTrue(Std.isOfType(error, expectedType));
		Assert.equals(expectedMessage, messageOf(error));
		return cast error;
	}

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
		var caught = capture(callback);
		Assert.notNull(caught);
		Assert.isTrue(Std.isOfType(caught, expectedType));
	}
}
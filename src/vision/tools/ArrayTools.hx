package vision.tools;

import haxe.Int64;
import haxe.extern.EitherType;
import haxe.ds.ArraySort;
import vision.algorithms.Radix;

using vision.tools.MathTools;
import vision.tools.MathTools.*;

class ArrayTools {
	/**
		Takes a 2D array and flattens it to a regular, 1D array.
		@param array
		@return Array<T>
	**/
	public static function flatten<T>(array:Array<Array<T>>):Array<T> {
		var flat = [];
		for (item in array)
			flat = flat.concat(item);
		return flat;
	}

	/**
		Takes a 1D array and turns it into a 2D array, while splitting into arrays every `delimiter` indexes
		@param array An array of elements
		@param delimiter The number of elements in each subarray
		@return An array of one higer dimension.
	**/
	overload extern public static inline function raise<T>(array:Array<T>, delimiter:Int):Array<Array<T>> {
		var raised = [];
		for (i in 0...array.length) {
			if (raised[floor(i / delimiter)] == null) raised[floor(i / delimiter)] = [];
			raised[floor(i / delimiter)][i % delimiter] = array[i];
		}
		return raised;
	}

	/**
		Takes a 1D array and turns it into a 2D array, while splitting into arrays every time the predicate returns true
		@param array An array of elements
		@param predicateOpensArray If true, subarrays will open with elements for which the predicate returns true.
		@param predicate A function that takes an element and returns true if the element should be used as a delimiter.
		@return An array of one higer dimension.
	**/
	overload extern public static inline function raise<T>(array:Array<T>, predicateOpensArray:Bool, predicate:T->Bool):Array<Array<T>> {
		var raised:Array<Array<T>> = [];
		var temp:Array<T> = [];

		for (i in 0...array.length) {
			if (!predicateOpensArray) temp.push(array[i]);
			if (predicate(array[i])) {
				if (temp.length > 0) raised.push(temp);
				temp = [];
			}
			if (predicateOpensArray) temp.push(array[i]);
		}

		if (temp.length > 0) raised.push(temp);
		return raised;
	}

	overload extern public static inline function min<T:EitherType<Int ,Float>>(values:Array<T>):T {
		var min = values[0];
		for (i in 0...values.length) {
			if ((values[i] - min) < 0) min = values[i];
		}
		return min;
	}

	overload extern public static inline function min(values:Array<Int64>):Int64 {
		var min = values[0];
		for (i in 0...values.length) {
			if ((values[i] - min) < 0) min = values[i];
		}
		return min;
	}

	overload extern public static inline function min<T>(values:Array<T>, valueFunction:T->Float):T {
		var min = values[0];
		var minValue = valueFunction(min);
		for (i in 0...values.length) {
			var currentValue = valueFunction(values[i]);
			if (currentValue < minValue) {
				min = values[i];
				minValue = currentValue;
			}
		}

		return min;
	}

	overload extern public static inline function max<T:EitherType<Int ,Float>>(values:Array<T>):T {
		var max = values[0];
		for (i in 0...values.length) {
			if ((values[i] - max) > 0) max = values[i];
		}
		return max;
	}

	overload extern public static inline function max(values:Array<Int64>):Int64 {
		var max = values[0];
		for (i in 0...values.length) {
			if ((values[i] - max) > 0) max = values[i];
		}
		return max;
	}

	overload extern public static inline function max<T>(values:Array<T>, valueFunction:T->Float):T {
		var max = values[0];
		var maxValue = valueFunction(max);
		for (i in 0...values.length) {
			var currentValue = valueFunction(values[i]);
			if (currentValue > maxValue) {
				max = values[i];
				maxValue = currentValue;
			}
		}

		return max;
	}

	overload extern public static inline function average<T:EitherType<Int, Float>>(values:Array<T>):Float {
		var sum = 0.;
		for (v in values) {
			sum += cast v;
		}
		return sum / values.length;
	}

	overload extern public static inline function average(values:Array<Int64>):Float {
		var sum = Int64.make(0, 0);
		for (v in values) {
			sum += v;
		}
		
		final result = Int64.divMod(sum, values.length);
		return result.quotient.toFloat() + result.modulus.toFloat() / values.length;
	}

	/**
		Gets the median of the given values. For large arrays, Radix sort is used to boost performance (5000 elements or above)
	**/
	extern overload public static inline function median(values:Array<Int>):Int {
		if (values.length > 5000) {
			return Radix.sort(values.copy())[floor(values.length / 2)];
		}
		var s = values.copy();
		ArraySort.sort(s, (a, b) -> a - b);
		return s[floor(values.length / 2)];
	}

	extern overload public static inline function median(values:Array<Int64>):Int64 {
		if (values.length > 5000) {
			return Radix.sort(values.copy())[floor(values.length / 2)];
		}
		var s = values.copy();
		ArraySort.sort(s, (a, b) -> a.low - b.low);
		ArraySort.sort(s, (a, b) -> a.high - b.high);
		return s[floor(values.length / 2)];
	}

	/**
		Gets the median of the given values.
	**/
	extern overload public static inline function median(values:Array<Float>):Float {
		var s = values.copy();
		ArraySort.sort(s, (a, b) -> Std.int(a - b));
		return s[floor(values.length / 2)];
	}

	public static function distanceTo<T>(array:Array<T>, to:Array<T>, distanceFunction:(T, T) -> Float):Float {
		var sum = 0.;
		for (i in 0...array.length - 1) {
			sum += distanceFunction(array[i], array[i + 1]);
		}
		return sum;
	}

	public static function flatMap<T, K>(array:Array<T>, mappingFunction:(T) -> Array<K>):Array<K> {
		var result = [];
		for (i in 0...array.length) {
			result = result.concat(mappingFunction(array[i]));
		}
		return result;
	}

	public static function distinct<T>(array:Array<T>):Array<T> {
		var result = [];
		for (i in 0...array.length) {
			if (!result.contains(array[i])) result.push(array[i]);
		}
		return result;
	}
}

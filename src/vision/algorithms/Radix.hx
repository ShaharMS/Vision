package vision.algorithms;

/**
 * An implementation of radix sort in Haxe, by [Shahar Marcus](https://www.github.com/ShaharMS).
 */
class Radix {
	/**
	 * Gets the maximum in array `array`.
	 * @param array an array of type `Int`, `Int64` or `UInt`
	 * @param endIndex optional, an index after which we stop checking for a maximum
	 */
	static function getMax<T:Int, UInt, Int64>(array:Array<T>, ?endIndex:Int) {
		if (endIndex == null)
			endIndex = array.length;

		var potential = array[0];
		for (i in 1...endIndex)
			if (array[i] > potential)
				potential = array[i];
		return potential;
	}

	/**
	 * Does a counting sort on `array` according to the digit's placement represented by `exp`
	 * @param array an array of type `Int`, `Int64` or `UInt`
	 * @param exp Represents the digit's "place" on which were going to count - `10` will count on the last digit, `100` will count on the second-to-last, etc.
	 * @param endIndex optional, an index after which we stop sorting
	 */
	static function countingSort<T:Int, UInt, Int64>(array:Array<T>, exp:Int, ?endIndex:Int) {
		if (endIndex == null)
			endIndex = array.length;

		var output:Array<T> = [];
		var i:Int = -1;
		var count = [for (i in 0...10) 0];

		// Store count of occurrences in `count`
		while (++i < endIndex)
			count[Std.int(array[i] / exp) % 10]++;

		i = 0;

		// Change `count[i]` so that `count[i]` now contains
		// actual position of this digit in `output`
		while (++i < 10)
			count[i] += count[i - 1];

		i = endIndex;
		
		// Build the output array
		while (--i >= 0) {
			output[count[Std.int(array[i] / exp) % 10] - 1] = array[i];
			count[Std.int(array[i] / exp) % 10]--;
		}

		i = -1;
		// Copy `output` to `array`, so that `array` now
		// contains sorted numbers according to current digit
		while (++i < endIndex)
			array[i] = output[i];

		return output;
	}

	// The main function to that sorts array[] of
	// size n using Radix Sort
	public static function sort<T:Int, UInt, Int64>(array:Array<T>) {
		// Find the maximum number to know number of digits
		final max = getMax(array, array.length);
		var exp = 1;

		// Do counting sort for every digit. Note that
		// instead of passing digit number, exp is passed.
		// exp is 10^i where i is current digit number
		while (max / exp > 0) {
			array = countingSort(array, exp, array.length);
			exp *= 10;
		}

		return array;
	}
}

package vision.algorithms;

/**
	An implementation of radix sort in Haxe, by [Shahar Marcus](https://www.github.com/ShaharMS).

	Radix vs. ArraySort.sort:

	|Radix                                 | ArraySort.sort                |
	|:------------------------------------:|:-----------------------------:|
	|length: 38, time: 0.000s              | length: 38, time: 0.000s      |
	|length: 74, time: 0.000s              | length: 74, time: 0.000s      |
	|length: 146, time: 0.001s             | length: 146, time: 0.001s     |
	|length: 290, time: 0.001s             | length: 290, time: 0.002s     |
	|length: 578, time: 0.003s             | length: 578, time: 0.003s     |
	|length: 1154, time: 0.005s            | length: 1154, time: 0.006s    |
	|length: 2306, time: 0.01s             | length: 2306, time: 0.012s    |
	|length: 4610, time: 0.02s             | length: 4610, time: 0.022s    |
	|length: 9218, time: 0.0591s           | length: 9218, time: 0.048s    |
	|length: 18434, time: 0.0701s          | length: 18434, time: 0.0961s  |
	|length: 36866, time: 0.1614s          | length: 36866, time: 0.1882s  |
	|length: 73730, time: 0.3123s          | length: 73730, time: 0.3856s  |
	|length: 147458, time: 0.5837s         | length: 147458, time: 0.7417s |
	|length: 294914, time: 1.1621s         | length: 294914, time: 1.6143s |
	|length: 589826, time: 2.3471s         | length: 589826, time: 3.0588s |
	|length: 1179650, time: 4.7839s        | length: 1179650, time: 6.1441s|
**/
class Radix {
	/**
	 * Gets the maximum in array `array`.
	 * @param array an array of type `Int`, `Int64` or `UInt`
	 * @param endIndex optional, an index after which we stop checking for a maximum 
	 * (useful if the range in which the maximum value is present is known)
	 */
	static function getMax<T:Int, #if !cs Uint, #end Int64>(array:Array<T>, ?endIndex:Int) {
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
	static function countingSort<T:Int, #if !cs Uint, #end Int64>(array:Array<T>, exp:Int, ?endIndex:Int) {
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

	/**
		Sorts an array of `Int`s / `UInt`s / `Int64` using **Radix Sort**.
	**/
	public static function sort<T:Int, #if !cs Uint, #end Int64>(array:Array<T>) {
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

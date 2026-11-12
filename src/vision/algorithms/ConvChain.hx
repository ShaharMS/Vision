package vision.algorithms;

import haxe.ds.IntMap;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageStorage;
import vision.exceptions.VisionException;

/** Samples textures from local pattern frequencies using the ConvChain model. **/
class ConvChain {
	static final unseenLogWeight = Math.log(0.1);

	public static function synthesize(sample:Image, width:Int, height:Int, patternSize:Int = 3, iterations:Int = 20, temperature:Float = 1):Image {
		if (patternSize < 1 || patternSize > sample.width || patternSize > sample.height || patternSize > width || patternSize > height
			|| iterations < 1 || !Math.isFinite(temperature) || temperature <= 0)
			throw new VisionException("The images must fit the pattern, and iterations and temperature must be positive.", "ConvChain Error");
		if (width * 1.0 * height * 4 > 0x7fffffff - ImageStorage.PIXEL_OFFSET #if !vision_higher_width_cap || width > 0xffff #end)
			throw new VisionException("The output image is too large.", "ConvChain Error");

		final palette:Array<Color> = [];
		final indices = new IntMap<Int>();
		final source:Array<Int> = [];
		for (y in 0...sample.height)
			for (x in 0...sample.width) {
				final color = sample.getUnsafePixel(x, y);
				var index = indices.get(color);
				if (index == null) {
					index = palette.length;
					indices.set(color, index);
					palette.push(color);
				}
				source.push(index);
			}

		if (palette.length == 1) return new Image(width, height, palette[0]);
		final frequencies = new Map<String, Int>();
		for (y in 0...sample.height)
			for (x in 0...sample.width) {
				final key = patternKey(source, sample.width, sample.height, x, y, patternSize);
				final count = frequencies.get(key);
				frequencies.set(key, count == null ? 1 : count + 1);
			}
		final weights = new Map<String, Float>();
		for (key => count in frequencies) weights.set(key, Math.log(count));

		final area = width * height;
		final field:Array<Int> = [for (_ in 0...area) Std.random(palette.length)];
		final scores = [
			for (y in 0...height)
				for (x in 0...width) score(weights, field, width, height, x, y, patternSize)
		];
		final changed:Array<Int> = [];
		final proposed:Array<Float> = [];
		for (_ in 0...iterations)
			for (_ in 0...area) {
				final x = Std.random(width), y = Std.random(height);
				final index = y * width + x;
				final original = field[index];
				final replacement = Std.random(palette.length - 1);
				field[index] = replacement < original ? replacement : replacement + 1;

				var improvement = 0.0;
				var position = 0;
				for (dy in 0...patternSize)
					for (dx in 0...patternSize) {
						final px = (x - dx + width) % width, py = (y - dy + height) % height;
						final anchor = py * width + px;
						final value = score(weights, field, width, height, px, py, patternSize);
						improvement += value - scores[anchor];
						changed[position] = anchor;
						proposed[position] = value;
						position++;
					}
				if (improvement >= 0 || Math.random() < Math.exp(improvement / temperature)) {
					for (i in 0...position) scores[changed[i]] = proposed[i];
				} else {
					field[index] = original;
				}
			}

		final result = new Image(width, height);
		for (y in 0...height)
			for (x in 0...width) result.setUnsafePixel(x, y, palette[field[y * width + x]]);
		return result;
	}

	static function score(weights:Map<String, Float>, field:Array<Int>, width:Int, height:Int, x:Int, y:Int, size:Int):Float {
		final weight = weights.get(patternKey(field, width, height, x, y, size));
		return weight == null ? unseenLogWeight : weight;
	}

	static function patternKey(field:Array<Int>, width:Int, height:Int, x:Int, y:Int, size:Int):String {
		final key = new StringBuf();
		for (dy in 0...size) {
			final row = (y + dy) % height * width;
			for (dx in 0...size) {
				key.add(field[row + (x + dx) % width]);
				key.add(",");
			}
		}
		return key.toString();
	}
}

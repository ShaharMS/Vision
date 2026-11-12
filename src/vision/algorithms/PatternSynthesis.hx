package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.exceptions.VisionException;

private typedef Pattern = {
	final pixels:Array<Color>;
	final edges:Array<String>;
	var frequency:Int;
}

/** Overlapping-pattern synthesis from a sample image. **/
class PatternSynthesis {
	static final offsets = [[1, 0], [0, 1], [-1, 0], [0, -1]];

	public static function synthesize(sample:Image, width:Int, height:Int, patternSize:Int = 2, attempts:Int = 8):Image {
		if (patternSize < 1 || attempts < 1 || patternSize > sample.width || patternSize > sample.height
			|| patternSize > width || patternSize > height)
			throw new VisionException("The sample and output must fit the pattern, and attempts must be positive.", "Pattern Synthesis Error");

		final patterns = learn(sample, patternSize);
		final columns = width - patternSize + 1;
		final rows = height - patternSize + 1;
		if (columns * 1.0 * rows * patterns.length > 8000000)
			throw new VisionException("Too many pattern candidates for the output dimensions.", "Pattern Synthesis Error");

		for (_ in 0...attempts) {
			final domains = solve(patterns, columns, rows);
			if (domains == null) continue;
			final result = new Image(width, height);
			for (y in 0...rows)
				for (x in 0...columns) {
					final pixels = patterns[domains[y * columns + x][0]].pixels;
					final patchWidth = x == columns - 1 ? patternSize : 1;
					final patchHeight = y == rows - 1 ? patternSize : 1;
					for (dy in 0...patchHeight)
						for (dx in 0...patchWidth)
							result.setUnsafePixel(x + dx, y + dy, pixels[dy * patternSize + dx]);
				}
			return result;
		}
		throw new VisionException("Pattern constraints could not be satisfied in the requested attempts.", "Pattern Synthesis Error");
	}

	static function learn(sample:Image, size:Int):Array<Pattern> {
		final patterns = [];
		final byPixels = new Map<String, Pattern>();
		for (y in 0...(sample.height - size + 1))
			for (x in 0...(sample.width - size + 1)) {
				final pixels = [];
				for (dy in 0...size)
					for (dx in 0...size)
						pixels.push(sample.getUnsafePixel(x + dx, y + dy));
				final key = pixels.join(",");
				final known = byPixels.get(key);
				if (known != null) {
					known.frequency++;
					continue;
				}
				final edges = [[], [], [], []];
				for (dy in 0...size)
					for (dx in 0...size) {
						final color = pixels[dy * size + dx];
						if (dx > 0) edges[0].push(color);
						if (dy > 0) edges[1].push(color);
						if (dx < size - 1) edges[2].push(color);
						if (dy < size - 1) edges[3].push(color);
					}
				final pattern:Pattern = {pixels: pixels, edges: [for (edge in edges) edge.join(",")], frequency: 1};
				patterns.push(pattern);
				byPixels.set(key, pattern);
			}
		return patterns;
	}

	static function solve(patterns:Array<Pattern>, width:Int, height:Int):Null<Array<Array<Int>>> {
		final all = [for (i in 0...patterns.length) i];
		final domains = [for (_ in 0...width * height) all];
		final initial = [for (i in 0...domains.length) i];
		if (!propagate(patterns, domains, width, height, initial)) return null;

		while (true) {
			var cell = -1;
			var minimum = Math.POSITIVE_INFINITY;
			for (i in 0...domains.length) {
				final domain = domains[i];
				if (domain.length < 2) continue;
				var total = 0.0;
				var weightedLog = 0.0;
				for (id in domain) {
					final weight = patterns[id].frequency;
					total += weight;
					weightedLog += weight * Math.log(weight);
				}
				final entropy = Math.log(total) - weightedLog / total + Math.random() * 1e-8;
				if (entropy < minimum) {
					minimum = entropy;
					cell = i;
				}
			}
			if (cell < 0) return domains;
			final domain = domains[cell];
			var total = 0.0;
			for (id in domain) total += patterns[id].frequency;
			var ticket = Math.random() * total;
			for (id in domain) {
				ticket -= patterns[id].frequency;
				if (ticket < 0) {
					domains[cell] = [id];
					break;
				}
			}
			if (!propagate(patterns, domains, width, height, [cell])) return null;
		}
	}

	static function propagate(patterns:Array<Pattern>, domains:Array<Array<Int>>, width:Int, height:Int, pending:Array<Int>):Bool {
		while (pending.length > 0) {
			final cell = pending.pop();
			final x = cell % width;
			final y = Std.int(cell / width);
			for (direction in 0...4) {
				final nx = x + offsets[direction][0];
				final ny = y + offsets[direction][1];
				if (nx < 0 || ny < 0 || nx >= width || ny >= height) continue;
				final neighbor = ny * width + nx;
				final supports = new Map<String, Bool>();
				for (id in domains[cell]) supports.set(patterns[id].edges[direction], true);
				final opposite = (direction + 2) % 4;
				final previous = domains[neighbor];
				final next = [for (id in previous) if (supports.exists(patterns[id].edges[opposite])) id];
				if (next.length == 0) return false;
				if (next.length == previous.length) continue;
				domains[neighbor] = next;
				pending.push(neighbor);
			}
		}
		return true;
	}
}

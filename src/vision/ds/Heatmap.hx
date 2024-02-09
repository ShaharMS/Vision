package vision.ds;

import vision.tools.MathTools;
using vision.tools.MathTools;

/**
	A class used both for matrix data visualization using colors, and for finding
	certain elements in a matrix, e.g. finding local maximums/minimums.
**/
class Heatmap {
	
	public var data:Array2D<Float>;

	/**
		The value each pixel in the heatmap will be set to.
	**/
	public var baseValue:Float = 0;

	/**
		A value representing the upper bound of each element in the heatmap.  
		To disable this, set it to `null`.
	**/
	public var upperBound:Null<Float> = null;

	/**
		A value representing the lower bound of each element in the heatmap.  
		To disable this, set it to `null`.
	**/
	public var lowerBound:Null<Float> = null;


	public function new(width:Int, height:Int, baseValue:Float = 0) {

		this.baseValue = baseValue;
		this.data = new Array2D<Float>(width, height, baseValue);
	}

	public function set(x:Int, y:Int, value:Float) {
		data.set(x, y, value);
	}

	public function get(x:Int, y:Int):Float {
		return data.get(x, y);
	}

	public function getDataRange():{min:Float, max:Float} {
		var min = MathTools.POSITIVE_INFINITY, max = MathTools.NEGATIVE_INFINITY;
		for (v in this.data.iterator()) {
			if (v < min) min = v;
			if (v > max) max = v;
		}

		return {min: min, max: max};
	}

	public function getLocalMaximums(?threshold:Float = null, windowSize:Int = 3):Array<IntPoint2D> {
		var maximums:Array<IntPoint2D> = [];
		var avg = Std.int((windowSize - 1) / 2);
		for (x in 0...this.data.width) {
			for (y in 0...this.data.height) {
				if (threshold != null && this.data.get(x, y) < threshold) continue;
				var neighbors:Array<Null<Float>> = [
					for (offX in x - avg...x + avg + 1) 
						for (offY in y - avg...y + avg + 1) 
							(offX.isBetweenRange(0, data.width) && offY.isBetweenRange(0, data.height) && offX != 0 && offY != 0) ? this.data.get(offX, offY) : null
				];
				neighbors = neighbors.filter(n -> n != null);
				var isLocalMaximum = true;
				for (n in neighbors) {
					if (n < data.get(x, y)) continue;
					isLocalMaximum = false;
					break;
				}
				if (isLocalMaximum) maximums.push(new IntPoint2D(x, y));
			}
		}

		return maximums;
	}

	public function getLocalMinimums(?threshold:Float = null, windowSize:Int = 3):Array<IntPoint2D> {
		var maximums:Array<IntPoint2D> = [];
		var avg = Std.int((windowSize - 1) / 2);
		for (x in 0...this.data.width) {
			for (y in 0...this.data.height) {
				if (threshold != null && this.data.get(x, y) > threshold) continue;
				var neighbors:Array<Null<Float>> = [
					for (offX in x - avg...x + avg + 1) 
						for (offY in y - avg...y + avg + 1) 
							(offX.isBetweenRange(0, data.width) && offY.isBetweenRange(0, data.height) && offX != 0 && offY != 0) ? this.data.get(offX, offY) : null
				];
				neighbors = neighbors.filter(n -> n != null);
				var isLocalMaximum = true;
				for (n in neighbors) {
					if (n > data.get(x, y)) continue;
					isLocalMaximum = false;
					break;
				}
				if (isLocalMaximum) maximums.push(new IntPoint2D(x, y));
			}
		}

		return maximums;
	}
	
	public function normalize(minValue:Float = 0, maxValue:Float = 1) {
		var range = getDataRange();
		var delta = range.max - range.min;
		for (x in 0...this.data.width) {
			for (y in 0...this.data.height) {
				this.data.set(x, y, (this.data.get(x, y) - minValue) / delta);
			}
		}
	}

	public function visualize(lowerColor:Color = Color.BLACK, upperColor:Color = Color.WHITE) {
		var range = getDataRange();
		var delta = range.max - range.min;
		var image = new Image(this.data.width, this.data.height);
		for (x in 0...this.data.width) {
			for (y in 0...this.data.height) {
				image.setPixel(x, y, Color.interpolate(lowerColor, upperColor, (this.data.get(x, y) - range.min) / delta));
			}
		}
		
		return image;
	}
}
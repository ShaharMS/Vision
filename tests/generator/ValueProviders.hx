package;

#if macro
import MacroDetector.ParamInfo;
import TestModel.PlannedValue;

using StringTools;

class ValueProviders {
	public static function planValue(param:ParamInfo, ?scenario:String):PlannedValue {
		return {
			name: param.name,
			type: param.type,
			expression: expressionFor(param.type, param.name, scenario),
			label: scenario == null || scenario.length == 0 ? "default" : scenario
		};
	}

	public static function expressionFor(typeName:String, name:String, ?scenario:String):String {
		if (typeName == null) return "null";
		if (scenario == "line" && typeName == "Image") return "Factories.whiteLineImage(8, 8)";
		if (typeName.startsWith("Rest<{end: Float, start: Float}>")) return "{start: 0.0, end: 2.0}";
		if (typeName.startsWith("Rest<Array<Float>")) return "[1.0, 0.0, 0.0]";
		if (typeName.startsWith("Rest<Int>")) return "1";
		if (typeName.startsWith("Rest<Float>")) return "1.0";
		if (scenario == "empty" && typeName.startsWith("Array")) return "[]";
		if (scenario == "tiny" && typeName == "Image") return "Factories.gradientImage(3, 3)";
		if (scenario == "checkerboard" && typeName == "Image") return "Factories.checkerboardImage(8, 8, 2)";
		if (scenario == "tiny" && typeName == "Rectangle") return "({x: 0, y: 0, width: 3, height: 3} : vision.ds.Rectangle)";
		if (scenario == "checkerboard" && typeName == "Rectangle") return "({x: 0, y: 0, width: 8, height: 8} : vision.ds.Rectangle)";

		if (typeName.startsWith("Null<")) return nullableExpression(typeName, name, scenario);
		if (typeName == "String") return stringExpression(name, scenario);
		if (typeName == "Int" || typeName == "UInt") return intExpression(name);
		if (typeName == "Int64") return "haxe.Int64.make(0, 42)";
		if (typeName == "Float") return floatExpression(name);
		if (typeName == "Bool") return boolExpression(name);
		if (typeName == "Image") return "Factories.gradientImage(3, 3)";
		if (typeName == "ImageFormat") return "vision.ds.ImageFormat.PNG";
		if (typeName == "PixelFormat") return "vision.ds.PixelFormat.ARGB";
		if (typeName == "CannyObject") return "Factories.gradientImage(16, 16)";
		if (typeName == "ByteArray") return byteArrayExpression(name, scenario);
		if (typeName == "Color") return "(0xFF336699 : vision.ds.Color)";
		if (typeName == "Point2D") return point2DExpression(name);
		if (typeName == "IntPoint2D") return intPoint2DExpression(name);
		if (typeName == "Int16Point2D") return scenario == "line" ? "new vision.ds.Int16Point2D(0, 1)" : "new vision.ds.Int16Point2D(1, 1)";
		if (typeName == "Line2D") return line2DExpression(name);
		if (typeName == "Ray2D") return scenario == "intersect" ? "new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 1.0), -1.0)" : ray2DExpression(name);
		if (typeName == "Queue") return "(function() { var queue = new vision.ds.Queue<Int>(); queue.enqueue(1); queue.enqueue(2); return queue; })()";
		if (typeName == "QueueCell") return "new vision.ds.QueueCell(cast 1, new vision.ds.QueueCell(cast 2, null, null), new vision.ds.QueueCell(cast 0, null, null))";
		if (typeName == "Histogram") return "(function() { var histogram = new vision.ds.Histogram(); histogram.increment(1); histogram.increment(2); histogram.increment(2); return histogram; })()";
		if (typeName == "Rectangle") return "({x: 0, y: 0, width: 3, height: 3} : vision.ds.Rectangle)";
		if (typeName == "Array2D") return "new vision.ds.Array2D<Float>(3, 3, 0.0)";
		if (typeName == "Matrix2D") return "vision.ds.Matrix2D.createFilled([1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0])";
		if (typeName == "TransformationMatrix2D") return "vision.ds.Matrix2D.IDENTITY()";
		if (typeName.startsWith("Array<IntPoint2D")) return scenario == "duplicates" ? "[new vision.ds.IntPoint2D(1, 1), new vision.ds.IntPoint2D(1, 1)]" : "[new vision.ds.IntPoint2D(0, 0), new vision.ds.IntPoint2D(1, 1)]";
		if (typeName.startsWith("Array<Point2D")) return point2DArrayExpression(scenario);
		if (typeName.startsWith("Array<PointTransformationPair")) return pointTransformationPairsExpression(scenario);
		if (typeName.startsWith("Array<Line2D")) return line2DArrayExpression(scenario);
		if (typeName.startsWith("Array<Ray2D")) return ray2DArrayExpression(scenario);
		if (typeName.startsWith("Array<{rangeEnd: Color, rangeStart: Color, replacement: Color}>")) return colorRangesExpression(scenario);
		if (typeName.startsWith("Array<Array<Color>")) return scenario == "duplicates" ? "[[(0xFF336699 : vision.ds.Color), (0xFF336699 : vision.ds.Color)], [(0xFFCC8844 : vision.ds.Color), (0xFFCC8844 : vision.ds.Color)]]" : "[[(0xFF336699 : vision.ds.Color), (0xFF669933 : vision.ds.Color)], [(0xFF993366 : vision.ds.Color), (0xFFCC8844 : vision.ds.Color)]]";
		if (typeName.startsWith("Array<Array<Int>") || typeName.startsWith("Array<Array<T>")) return scenario == "duplicates" ? "[[1, 1], [2, 2]]" : "[[1, 2], [3, 4]]";
		if (typeName.startsWith("Array<Array<Float>")) return scenario == "duplicates" ? "[[1.0, 1.0], [2.0, 2.0]]" : "[[1.0, 2.0], [3.0, 4.0]]";
		if (typeName.startsWith("Array<Int") || typeName.startsWith("Array<UInt") || typeName == "Array<T>") return scenario == "radix" ? "[-3, -1, 2, 4]" : (scenario == "duplicates" ? "[1, 2, 2, 4]" : "[1, 2, 3, 4]");
		if (typeName.startsWith("Array<Float")) return name != null && name.toLowerCase().contains("solution") ? (scenario == "duplicates" ? "[1.0, 1.0, 2.0]" : "[1.0, 2.0, 3.0]") : (scenario == "duplicates" ? "[1.0, 2.0, 2.0, 4.0]" : "[1.0, 2.0, 3.0, 4.0]");
		if (typeName.startsWith("Array<String")) return '["alpha", "beta"]';
		if (typeName.startsWith("Array<Bool")) return "[true, false]";
		if (typeName.startsWith("Array")) return scenario == "duplicates" ? "[cast 1, cast 1, cast 2]" : "[cast 1, cast 2, cast 3]";
		if (typeName.contains("->")) return functionExpression(typeName, name);

		return MacroDetector.getDefaultForType(typeName);
	}

	static function nullableExpression(typeName:String, name:String, ?scenario:String):String {
		var inner = typeName.substr(5, typeName.length - 6);
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered == "fillwith" || lowered == "defaultvalue" || lowered == "fallback") return "cast 0";
		if (inner == "Int" && (lowered == "width" || lowered == "height")) return intExpression(name);
		if (inner == "Float" && lowered == "m") return "1.0";
		if (inner == "Image" || inner == "Point2D" || inner == "Matrix2D" || inner == "TransformationMatrix2D" || inner == "Color" || inner == "ImageFormat" || inner == "PixelFormat") {
			return expressionFor(inner, name, scenario);
		}
		if (inner.startsWith("Array")) return expressionFor(inner, name, scenario);
		return "null";
	}

	static function byteArrayExpression(name:String, ?scenario:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("png") || scenario == "png") return "vision.formats.ImageIO.to.bytes.png(Factories.checkerboardImage(2, 2, 1))";
		if (lowered.contains("bmp") || scenario == "bmp") return "vision.formats.ImageIO.to.bytes.bmp(Factories.checkerboardImage(2, 2, 1))";
		return "vision.ds.ByteArray.from([1, 2, 3, 4])";
	}

	static function pointTransformationPairsExpression(?scenario:String):String {
		var secondTarget = scenario == "duplicates" ? "new vision.ds.Point2D(1.0, 0.0)" : "new vision.ds.Point2D(2.0, 0.0)";
		return "["
			+ "new vision.ds.specifics.PointTransformationPair(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(0.0, 0.0)), "
			+ "new vision.ds.specifics.PointTransformationPair(new vision.ds.Point2D(1.0, 0.0), " + secondTarget + "), "
			+ "new vision.ds.specifics.PointTransformationPair(new vision.ds.Point2D(0.0, 1.0), new vision.ds.Point2D(0.0, 2.0)), "
			+ "new vision.ds.specifics.PointTransformationPair(new vision.ds.Point2D(1.0, 1.0), new vision.ds.Point2D(2.0, 2.0))]";
	}

	static function point2DArrayExpression(?scenario:String):String {
		return "[new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(1.0, 0.0), new vision.ds.Point2D(1.0, 1.0), new vision.ds.Point2D(0.0, 1.0)]";
	}

	static function line2DArrayExpression(?scenario:String):String {
		return "["
			+ "new vision.ds.Line2D(new vision.ds.Point2D(0.0, 1.0), new vision.ds.Point2D(7.0, 1.0)), "
			+ "new vision.ds.Line2D(new vision.ds.Point2D(0.0, 2.0), new vision.ds.Point2D(7.0, 2.0))]";
	}

	static function ray2DArrayExpression(?scenario:String):String {
		return "[new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0), new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 1.0), -1.0)]";
	}

	static function colorRangesExpression(?scenario:String):String {
		return "[{rangeStart: (0xFF000000 : vision.ds.Color), rangeEnd: (0xFFFFFFFF : vision.ds.Color), replacement: (0xFF336699 : vision.ds.Color)}]";
	}

	static function point2DExpression(name:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("end")) return "new vision.ds.Point2D(10.0, 0.0)";
		if (lowered.contains("start")) return "new vision.ds.Point2D(0.0, 0.0)";
		return "new vision.ds.Point2D(1.0, 1.0)";
	}

	static function intPoint2DExpression(name:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("end")) return "new vision.ds.IntPoint2D(10, 0)";
		if (lowered.contains("start")) return "new vision.ds.IntPoint2D(0, 0)";
		return "new vision.ds.IntPoint2D(1, 1)";
	}

	static function line2DExpression(name:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("2") || lowered.contains("other")) return "new vision.ds.Line2D(new vision.ds.Point2D(0.0, 10.0), new vision.ds.Point2D(10.0, 0.0))";
		return "new vision.ds.Line2D(new vision.ds.Point2D(0.0, 0.0), new vision.ds.Point2D(10.0, 10.0))";
	}

	static function ray2DExpression(name:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("2") || lowered.contains("other")) return "new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 1.0), -1.0)";
		return "new vision.ds.Ray2D(new vision.ds.Point2D(0.0, 0.0), 1.0)";
	}

	static function functionExpression(typeName:String, name:String):String {
		var parts = typeName.split("->");
		var argsPart = parts[0].trim().replace("(", "").replace(")", "");
		var argTypes = argsPart.length == 0 ? [] : argsPart.split(",");
		var args = [for (i in 0...argTypes.length) "arg" + i].join(", ");
		var returnType = parts[parts.length - 1].trim();
		var lowered = name == null ? "" : name.toLowerCase();
		var body = if (returnType == "Void") {
			"{}";
		} else if (returnType == "Bool") {
			lowered.contains("predicate") ? "arg0 == 2" : "true";
		} else if (returnType == "Float") {
			if (argTypes.length >= 2) "Math.abs((cast arg1 : Float) - (cast arg0 : Float))" else "1.0";
		} else if (returnType == "Int" || returnType == "UInt") {
			"1";
		} else if (returnType == "T" || returnType == "K") {
			"arg0[0]";
		} else if (returnType.startsWith("Array")) {
			"[arg0]";
		} else {
			"null";
		};
		return "(" + args + ") -> " + body;
	}

	static function stringExpression(name:String, ?scenario:String):String {
		if (scenario == "parseBool") return '"true"';
		if (scenario == "parseFloat") return '"42.5"';
		if (scenario == "parseInt") return '"42"';
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("path") || lowered.contains("file")) return '"fixture.png"';
		if (lowered.contains("format")) return '"png"';
		return '"42"';
	}

	static function intExpression(name:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("hash") && lowered.contains("size")) return "16";
		if (lowered == "min" || lowered == "mi") return "0";
		if (lowered == "max" || lowered == "ma") return "10";
		if (lowered == "centerx" || lowered == "centery") return "5";
		if (lowered == "width" || lowered == "w" || lowered == "height" || lowered == "h") return "3";
		if (lowered.contains("radius") || lowered.contains("size")) return "3";
		if (lowered == "x" || lowered == "y" || lowered == "x1" || lowered == "y1" || lowered == "x2" || lowered == "y2" || lowered == "x0" || lowered == "y0") return "1";
		return "1";
	}

	static function floatExpression(name:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered == "min" || lowered == "mi") return "0.0";
		if (lowered == "max" || lowered == "ma") return "10.0";
		if (lowered.contains("angle")) return "0.0";
		if (lowered.contains("scale") || lowered.contains("ratio") || lowered.contains("amount")) return "1.0";
		return "1.0";
	}

	static function boolExpression(name:String):String {
		var lowered = name == null ? "" : name.toLowerCase();
		if (lowered.contains("alpha") || lowered.contains("preserve")) return "true";
		return "false";
	}
}
#end
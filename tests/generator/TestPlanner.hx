package;

#if macro
import MacroDetector.TestableFunction;
import MacroDetector.TestableKind;
import MacroDetector.ParamInfo;
import TestModel.PlannedAssertion;
import TestModel.PlannedSuite;
import TestModel.PlannedTestCase;
import TestModel.PlannedValue;
#end

using StringTools;

class TestPlanner {
	public static inline var GENERATOR_VERSION:Int = 2;

	#if macro
	public static function planSuite(sourceClassPath:String, outputPath:String, testables:Array<TestableFunction>, provenance:String):PlannedSuite {
		var className = classNameFromPath(sourceClassPath);
		var testClassName = className + "Test";
		var cases:Array<PlannedTestCase> = [];
		var memberCounts = new Map<String, Int>();

		for (testable in testables) {
			var overloadIndex = memberCounts.exists(testable.name) ? memberCounts.get(testable.name) : 0;
			memberCounts.set(testable.name, overloadIndex + 1);
			for (scenario in chooseScenarios(testable)) {
				var caseScenario = overloadIndex == 0 ? scenario : "overload_" + overloadIndex + "_" + scenario;
				cases.push(planCase(sourceClassPath, testClassName, testable, provenance, caseScenario));
			}
		}

		return {
			id: sourceClassPath,
			sourceClassPath: sourceClassPath,
			testClassName: testClassName,
			outputPath: outputPath,
			provenance: provenance,
			maturity: summarizeMaturity(cases),
			lifecycle: "active",
			cases: cases
		};
	}

	static function planCase(sourceClassPath:String, testClassName:String, testable:TestableFunction, provenance:String, scenario:String):PlannedTestCase {
		var assertion = planAssertion(sourceClassPath, testable);
		var requirements = planRequirements(testable, assertion);
		var valueScenario = valueScenarioFor(sourceClassPath, testable, scenario);
		var parameters = planValues(testable.params, valueScenario);
		var constructorParameters = planValues(testable.constructorParams, valueScenario);
		return {
			id: sourceClassPath + "." + testable.name + "#" + scenario,
			source: sourceClassPath + "." + testable.name,
			suite: testClassName,
			member: testable.name,
			methodName: "test_" + sanitizeIdentifier(testable.name) + "__" + sanitizeIdentifier(scenario),
			displayName: testable.name + " " + scenario,
			provenance: provenance,
			maturity: assertion.maturity,
			lifecycle: "active",
			requirements: requirements,
			ignoreReason: planIgnoreReason(sourceClassPath, testable),
			skipTargets: [],
			skipReasons: [],
			functionInfo: testable,
			parameters: parameters,
			constructorParameters: constructorParameters,
			assertion: assertion
		};
	}

	static function chooseScenarios(testable:TestableFunction):Array<String> {
		if (testable.kind == TKProperty) return ["default"];
		var scenarios = ["default"];
		if (hasType(testable, "Image")) {
			scenarios.push("tiny");
			scenarios.push("checkerboard");
		}
		if (hasArrayParam(testable)) {
			scenarios.push("duplicates");
			if (testable.name == "flatten" || testable.name == "distinct" || testable.name == "flatMap") scenarios.push("empty");
		}
		return scenarios;
	}

	static function valueScenarioFor(sourceClassPath:String, testable:TestableFunction, scenario:String):String {
		if (sourceClassPath == "vision.formats.from.FromBytes" && (testable.name == "png" || testable.name == "bmp")) return testable.name;
		if (sourceClassPath == "vision.formats.to.ToBytes" && testable.name == "jpeg") return "checkerboard";
		if (sourceClassPath == "vision.tools.MathTools" && testable.name.startsWith("parse")) return testable.name;
		if (sourceClassPath == "vision.algorithms.Radix") return "radix";
		if (sourceClassPath == "vision.algorithms.SimpleLineDetector" && testable.name == "findLineFromPoint") return "line";
		if (sourceClassPath == "vision.ds.Ray2D" && testable.name == "intersect") return "intersect";
		return scenario;
	}

	static function planValues(params:Array<ParamInfo>, scenario:String):Array<PlannedValue> {
		var values:Array<PlannedValue> = [];
		var usedNames = new Map<String, Int>();
		for (index in 0...params.length) {
			var value = ValueProviders.planValue(params[index], scenario);
			value.name = uniqueLocalName(value.name, index, usedNames);
			values.push(value);
		}
		return values;
	}

	static function planAssertion(sourceClassPath:String, testable:TestableFunction):PlannedAssertion {
		if (sourceClassPath == "vision.formats.from.FromBytes" && testable.name == "jpeg") return {strategy: "throws", maturity: "semantic"};
		if (sourceClassPath == "vision.tools.MathTools" && testable.name == "NaN") return {strategy: "is_nan", maturity: "semantic"};
		var returnType = normalizeType(testable.returnType);
		if (returnType == "Void") return {strategy: "void_runs", maturity: "smoke"};
		if (returnType.startsWith("Null<")) return {strategy: "nullable_access", maturity: "smoke"};
		if (returnType == "Image") return {strategy: "image_structural", maturity: "structural"};
		if (returnType == "ByteArray") return {strategy: "bytearray_structural", maturity: "structural"};
		if (returnType.indexOf("Iterator") != -1) return {strategy: "non_null", maturity: "smoke"};
		if (returnType.startsWith("Array")) return {strategy: "array_structural", maturity: "structural"};
		if (returnType == "Bool") return {strategy: "bool_structural", maturity: "structural"};
		if (returnType == "Float") return {strategy: "float_structural", maturity: "structural"};
		if (returnType == "Int" || returnType == "UInt") return {strategy: "numeric_smoke", maturity: "smoke"};
		return {strategy: "non_null", maturity: "smoke"};
	}

	static function planRequirements(testable:TestableFunction, assertion:PlannedAssertion):Array<String> {
		var requirements:Array<String> = [];
		for (param in testable.params) {
			if (param.type == "Image") pushUnique(requirements, "image_fixture");
		}
		if (normalizeType(testable.returnType) == "Image") pushUnique(requirements, "image_fixture");
		return requirements;
	}

	static function planIgnoreReason(sourceClassPath:String, testable:TestableFunction):String {
		for (param in testable.params) {
			var lowered = param.name == null ? "" : param.name.toLowerCase();
			if (lowered.contains("url")) return "requires network fixture";
			if (lowered.contains("path") || lowered.contains("file")) return "requires filesystem fixture";
		}
		if (sourceClassPath == "vision.ds.Image" && testable.name == "toString") return "image string conversion is target-specific";
		if (sourceClassPath == "vision.algorithms.SimpleLineDetector" && testable.name == "image") return "static image cache is unset until detection runs";
		if (sourceClassPath == "vision.formats.from.FromBytes" && (testable.name == "png" || testable.name == "bmp")) return null;
		if (sourceClassPath.indexOf("vision.formats.__internal") == 0) return "internal format adapter needs explicit fixtures";
		return null;
	}

	static function hasType(testable:TestableFunction, typeName:String):Bool {
		if (normalizeType(testable.returnType).indexOf(typeName) != -1) return true;
		for (param in testable.params) if (param.type.indexOf(typeName) != -1) return true;
		for (param in testable.constructorParams) if (param.type.indexOf(typeName) != -1) return true;
		return false;
	}

	static function hasArrayParam(testable:TestableFunction):Bool {
		for (param in testable.params) if (param.type.startsWith("Array")) return true;
		return false;
	}

	static function summarizeMaturity(cases:Array<PlannedTestCase>):String {
		for (testCase in cases) {
			if (testCase.maturity != "smoke") return "mixed";
		}
		return "smoke";
	}

	static function pushUnique(values:Array<String>, value:String):Void {
		if (values.indexOf(value) == -1) values.push(value);
	}

	static function normalizeType(typeName:String):String {
		if (typeName == null) return "Dynamic";
		return typeName.trim();
	}

	static function classNameFromPath(sourceClassPath:String):String {
		var parts = sourceClassPath.split(".");
		return parts[parts.length - 1];
	}

	static function sanitizeIdentifier(value:String):String {
		var result = new StringBuf();
		for (i in 0...value.length) {
			var code = value.charCodeAt(i);
			var isAlpha = (code >= "A".code && code <= "Z".code) || (code >= "a".code && code <= "z".code);
			var isDigit = code >= "0".code && code <= "9".code;
			result.add(isAlpha || isDigit || value.charAt(i) == "_" ? value.charAt(i) : "_");
		}
		var sanitized = result.toString();
		if (sanitized.length == 0) return "case";
		var first = sanitized.charCodeAt(0);
		if (first >= "0".code && first <= "9".code) return "_" + sanitized;
		return sanitized;
	}

	static function uniqueLocalName(name:String, index:Int, usedNames:Map<String, Int>):String {
		var sanitized = sanitizeIdentifier(name == null || name.length == 0 ? "arg" + index : name);
		if (isReserved(sanitized)) sanitized = sanitized + "Value";
		var count = usedNames.exists(sanitized) ? usedNames.get(sanitized) : 0;
		usedNames.set(sanitized, count + 1);
		return count == 0 ? sanitized : sanitized + count;
	}

	static function isReserved(name:String):Bool {
		return [
			"break", "case", "cast", "catch", "class", "continue", "default", "do", "dynamic", "else", "enum", "extends", "extern",
			"false", "final", "for", "function", "if", "implements", "import", "in", "inline", "interface", "macro", "new", "null",
			"operator", "overload", "override", "package", "private", "public", "return", "static", "super", "switch", "this", "throw",
			"true", "try", "typedef", "untyped", "using", "var", "while"
		].indexOf(name) != -1;
	}
	#end
}
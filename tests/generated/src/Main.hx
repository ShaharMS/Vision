package;

import vision.ds.ByteArray;
import haxe.io.Bytes;
import tests.*;

using vision.tools.ArrayTools;

import TestStatus;
import TestResult;
import TestConclusion;
import TestsToRun;

class Main {

	// ANSI colors
	static var RED = "\033[31m";
	static var GREEN = "\033[32m";
	static var YELLOW = "\033[33m";
	static var BLUE = "\033[34m";
	static var MAGENTA = "\033[35m";
	static var CYAN = "\033[36m";
	static var WHITE = "\033[37m";
	static var BLACK = "\033[30m";
	static var LIGHT_BLUE = "\033[94m";
	static var GRAY = "\033[90m";
	static var RESET = "\033[0m";

	static var BOLD = "\033[1m";
	static var ITALIC = "\033[3m";
	static var UNDERLINE = "\033[4m";

	static var bulk = true;

	public static function main() {
		var i = 0;
		var conclusionMap = new Map<TestStatus, Array<TestResult>>();

		for (statusType in [Success, Failure, Skipped, Unimplemented]) {
			conclusionMap.set(statusType, []);
		}

		for (cls in TestsToRun.tests) {
			var testFunctions:Array<() -> TestResult> = Type.getClassFields(cls).map(func -> Reflect.field(cls, func));
			for (func in testFunctions) {
				i++;
				var result:TestResult = func();
				Sys.println('$CYAN$BOLD Unit Test $i:$RESET $BOLD$ITALIC${getTestPassColor(result.status)}${result.testName}$RESET');
				Sys.println('    - $RESET$BOLD$WHITE Result: $ITALIC${getTestPassColor(result.status)}${result.status}$RESET');
				if (result.status == Failure) {
					Sys.println('        - $RESET$BOLD$WHITE Expected:$RESET $ITALIC$GREEN${safeStringify(result.expected)}$RESET');
					Sys.println('        - $RESET$BOLD$WHITE Returned:$RESET $ITALIC$RED${safeStringify(result.returned)}$RESET');
				}

				conclusionMap.get(result.status).push(result);
				if (result.status != Success && !bulk) Sys.exit(1);
				Sys.sleep(bulk ? 0.01 : 0.2);
			}
		}
		
		if (conclusionMap.get(Success).length == i) {
			Sys.println('$GREEN$BOLD🥳 🥳 🥳 All tests passed! 🥳 🥳 🥳$RESET');
		} else {
			Sys.println('$RED$BOLD Final Test Status:$RESET');
			Sys.println('    - $RESET$BOLD${getTestPassColor(Success)} ${conclusionMap.get(Success).length}$RESET $BOLD$WHITE Tests $RESET$BOLD${getTestPassColor(Success)} Passed 🥳$RESET');
			Sys.println('    - $RESET$BOLD${getTestPassColor(Failure)} ${conclusionMap.get(Failure).length}$RESET $BOLD$WHITE Tests $RESET$BOLD${getTestPassColor(Failure)} Failed 🥺$RESET');
			Sys.println('    - $RESET$BOLD${getTestPassColor(Skipped)} ${conclusionMap.get(Skipped).length}$RESET $BOLD$WHITE Tests $RESET$BOLD${getTestPassColor(Skipped)} Skipped 🤷$RESET');
			Sys.println('    - $RESET$BOLD${getTestPassColor(Unimplemented)} ${conclusionMap.get(Unimplemented).length}$RESET $BOLD$WHITE Tests $RESET$BOLD${getTestPassColor(Unimplemented)} Unimplemented 😬$RESET');
		}
	}

	static function getTestPassColor(status:TestStatus):String {
		return switch status {
			case Success: GREEN;
			case Failure: RED;
			case Skipped: LIGHT_BLUE;
			case Unimplemented: GRAY;

		}
	}

	static function safeStringify(value:Dynamic):String {
		if (Std.isOfType(value, Bytes)) {
			var hex = (value : ByteArray).toHex();
			return "[" + [for (i in 0...hex.length) hex.charAt(i)].raise(2).map(array -> "0x" + array.join("")).join(", ") + "]";
		}

		return Std.string(value);
	}
}

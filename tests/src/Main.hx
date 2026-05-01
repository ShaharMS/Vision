package;

using StringTools;

import utest.Runner;
import PrettyReporter;
import tests.support.ManualSuites;

#if nodejs
import js.Node;
#end

class Main {
	static function main() {
		var runner = new Runner();

		var rawSuiteFilter:String = null;
		var rawCaseFilter:String = null;
		#if sys
		rawSuiteFilter = Sys.getEnv("VISION_TESTS");
		if (rawSuiteFilter == null || rawSuiteFilter.trim().length == 0) rawSuiteFilter = Sys.getEnv("VISION_TEST_CLASSES");
		rawCaseFilter = Sys.getEnv("VISION_TEST_CASES");
		#elseif nodejs
		var env = Node.process.env;
		if (env != null) {
			rawSuiteFilter = env.get("VISION_TESTS");
			if (rawSuiteFilter == null || rawSuiteFilter.trim().length == 0) rawSuiteFilter = env.get("VISION_TEST_CLASSES");
			rawCaseFilter = env.get("VISION_TEST_CASES");
		}
		#end

		var args:Array<String> = [];
		#if sys
		args = Sys.args();
		#elseif nodejs
		args = Node.process.argv;
		#end
		for (i in 0...args.length) {
			if (args[i] == "--tests" && i + 1 < args.length) {
				rawSuiteFilter = args[i + 1];
			}
			if (args[i] == "--cases" && i + 1 < args.length) {
				rawCaseFilter = args[i + 1];
			}
		}

		var suiteFilter:Array<String> = [];
		if (rawSuiteFilter != null && rawSuiteFilter.trim().length > 0) {
			for (part in rawSuiteFilter.split(",")) {
				var name = part.trim();
				if (name.length > 0) suiteFilter.push(name);
			}
		}

		var casePattern:EReg = null;
		if (rawCaseFilter != null) {
			var trimmedCaseFilter = rawCaseFilter.trim();
			if (trimmedCaseFilter.length > 0) casePattern = new EReg(trimmedCaseFilter, "");
		}

		function includeTest(name:String):Bool {
			return suiteFilter.length == 0 || suiteFilter.indexOf(name) != -1;
		}

		ManualSuites.addCases(runner, includeTest, casePattern);

		new PrettyReporter(runner);
		runner.run();
	}
}

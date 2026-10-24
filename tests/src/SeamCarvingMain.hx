package;

import utest.Runner;
import tests.SeamCarvingTest;

/** Standalone runtime check, without loading unrelated algorithm suites. **/
class SeamCarvingMain {
	static function main() {
		var runner = new Runner();
		runner.addCase(new SeamCarvingTest());
		new PrettyReporter(runner);
		runner.run();
	}
}

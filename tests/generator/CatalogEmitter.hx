package;

import sys.FileSystem;
import sys.io.File;
import TestModel.GenerationResult;
import TestModel.PlannedSuite;
import TestModel.PlannedTestCase;
import TestModel.PlannedValue;

using StringTools;

class CatalogEmitter {
	public static function writeManifest(path:String, suites:Array<PlannedSuite>, result:GenerationResult):Void {
		ensureDirectory(haxe.io.Path.directory(path));
		var manifest:Dynamic = {
			schemaVersion: 1,
			generatorVersion: TestPlanner.GENERATOR_VERSION,
			generatedAt: Date.now().toString(),
			summary: summarize(suites, result),
			suites: suites.map(suiteToJson)
		};
		File.saveContent(path, haxe.Json.stringify(manifest, null, "  "));
	}

	public static function writeHealthIfMissing(path:String):Void {
		if (FileSystem.exists(path)) return;
		ensureDirectory(haxe.io.Path.directory(path));
		var health:Dynamic = {
			schemaVersion: 1,
			generatorVersion: TestPlanner.GENERATOR_VERSION,
			updatedAt: Date.now().toString(),
			cases: []
		};
		File.saveContent(path, haxe.Json.stringify(health, null, "  "));
	}

	public static function writeReport(path:String, suites:Array<PlannedSuite>, result:GenerationResult):Void {
		ensureDirectory(haxe.io.Path.directory(path));
		var summary = summarize(suites, result);
		var generatedSuites = [for (suite in suites) if (suite.provenance == "generated") suite];
		var draftSuites = [for (suite in suites) if (suite.lifecycle == "draft") suite];
		var buf = new StringBuf();
		buf.add('# Vision Test Catalog Report\n\n');
		buf.add('Generated: ' + Date.now().toString() + '\n\n');
		buf.add('## Summary\n\n');
		buf.add('- Suites cataloged: ' + summary.suites + '\n');
		buf.add('- Cases cataloged: ' + summary.cases + '\n');
		buf.add('- Active suites: ' + summary.activeSuites + '\n');
		buf.add('- Draft suites: ' + summary.draftSuites + '\n');
		buf.add('- Legacy mixed suites: ' + summary.legacyMixedSuites + '\n');
		buf.add('- Generated files written: ' + summary.generatedFiles + '\n');
		buf.add('- Existing files skipped: ' + summary.skippedFiles + '\n');
		buf.add('- Manual files protected: ' + summary.protectedFiles + '\n\n');
		buf.add('## Generated Suites\n\n');
		if (generatedSuites.length == 0) {
			buf.add('- None\n');
		} else {
			for (suite in generatedSuites) {
				buf.add('- ' + suite.testClassName + ' (' + suite.cases.length + ' cases, ' + suite.lifecycle + ')\n');
			}
		}
		buf.add('\n## Draft Legacy Suites\n\n');
		if (draftSuites.length == 0) {
			buf.add('- None\n');
		} else {
			for (suite in draftSuites) {
				buf.add('- ' + suite.testClassName + ' from ' + suite.sourceClassPath + '\n');
			}
		}
		File.saveContent(path, buf.toString());
	}

	static function suiteToJson(suite:PlannedSuite):Dynamic {
		return {
			id: suite.id,
			source: suite.sourceClassPath,
			suite: suite.testClassName,
			outputPath: normalizePath(suite.outputPath),
			provenance: suite.provenance,
			maturity: suite.maturity,
			lifecycle: suite.lifecycle,
			caseCount: suite.cases.length,
			cases: suite.cases.map(caseToJson)
		};
	}

	static function caseToJson(testCase:PlannedTestCase):Dynamic {
		return {
			id: testCase.id,
			source: testCase.source,
			suite: testCase.suite,
			member: testCase.member,
			methodName: testCase.methodName,
			displayName: testCase.displayName,
			provenance: testCase.provenance,
			maturity: testCase.maturity,
			lifecycle: testCase.lifecycle,
			ignoreReason: testCase.ignoreReason,
			requirements: testCase.requirements,
			targets: {
				skip: testCase.skipTargets,
				reasons: testCase.skipReasons
			},
			assertion: testCase.assertion,
			parameters: testCase.parameters.map(valueToJson),
			constructorParameters: testCase.constructorParameters.map(valueToJson),
			generatorVersion: TestPlanner.GENERATOR_VERSION,
			signatureHash: signatureHash(testCase)
		};
	}

	static function valueToJson(value:PlannedValue):Dynamic {
		return {
			name: value.name,
			type: value.type,
			label: value.label
		};
	}

	static function summarize(suites:Array<PlannedSuite>, result:GenerationResult):Dynamic {
		var cases = 0;
		var smoke = 0;
		var structural = 0;
		var legacyMixed = 0;
		var activeSuites = 0;
		var draftSuites = 0;
		for (suite in suites) {
			if (suite.provenance == "legacy_mixed") legacyMixed++;
			if (suite.lifecycle == "active") activeSuites++;
			if (suite.lifecycle == "draft") draftSuites++;
			for (testCase in suite.cases) {
				cases++;
				if (testCase.maturity == "smoke") smoke++;
				if (testCase.maturity == "structural") structural++;
			}
		}
		return {
			suites: suites.length,
			cases: cases,
			smokeCases: smoke,
			structuralCases: structural,
			activeSuites: activeSuites,
			draftSuites: draftSuites,
			legacyMixedSuites: legacyMixed,
			generatedFiles: result.generatedFiles.length,
			skippedFiles: result.skippedFiles.length,
			protectedFiles: result.protectedFiles.length,
			failed: result.failed.length
		};
	}

	static function signatureHash(testCase:PlannedTestCase):String {
		var raw = testCase.source + "(" + testCase.parameters.map(param -> param.name + ":" + param.type).join(",") + "):" + testCase.functionInfo.returnType;
		return haxe.crypto.Md5.encode(raw);
	}

	static function normalizePath(path:String):String {
		return path == null ? "" : path.replace("\\", "/");
	}

	static function ensureDirectory(path:String):Void {
		if (path == null || path.length == 0 || FileSystem.exists(path)) return;
		var parent = haxe.io.Path.directory(path);
		if (parent != null && parent.length > 0 && parent != path) ensureDirectory(parent);
		FileSystem.createDirectory(path);
	}
}
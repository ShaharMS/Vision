package;

import haxe.Json;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class ManualInventoryBuilder {
	static inline var MANIFEST_PATH = "tests/catalog/manual-test-inventory.json";
	static inline var SOURCE_ROOT = "src/vision";
	static inline var TEST_ROOT = "tests/src/tests";
	static inline var TEST_ROOT_DISPLAY = "tests/src";
	static inline var REFERENCE_ROOT = "tests/generated/src";
	static inline var PROMOTED_NOTE = "Promoted into tests/src during cutover, but the suite still needs manual semantic migration.";
	static inline var MISSING_NOTE = "No authored suite exists under tests/src yet.";
	static inline var EXCLUDED_NOTE = "Internal, macro-only, or target-specific support module intentionally kept out of the manual utest migration scope.";

	public static function main():Void {
		var inventory = buildInventory(loadExistingInventory());
		writeInventory(inventory);
		validateInventory(inventory);
		var moduleCount = Reflect.fields(Reflect.field(inventory, "modules")).length;
		Sys.println('Wrote ${MANIFEST_PATH} (${moduleCount} modules)');
	}

	static function buildInventory(existingInventory:Dynamic):Dynamic {
		var modules = {};
		var sourceFiles = listFiles(SOURCE_ROOT, ".hx");
		sourceFiles.sort(compareStrings);
		for (sourceFile in sourceFiles) {
			var modulePath = toModulePath(sourceFile);
			var existingEntry = getExistingEntry(existingInventory, modulePath);
			var members = discoverPublicMembers(sourceFile);
			var testFile = resolveTestFile(sourceFile, existingEntry);
			var status = resolveStatus(existingEntry, sourceFile);
			Reflect.setField(modules, modulePath, {
				sourceFile: normalizePath(sourceFile),
				testFile: testFile,
				status: status,
				members: members,
				deferredMembers: resolveDeferredMembers(existingEntry, status, members),
				notes: resolveNotes(existingEntry, status, testFile)
			});
		}
		return {
			generatedAt: Date.now().toString().replace(" ", "T"),
			sourceRoot: SOURCE_ROOT,
			testRoot: TEST_ROOT_DISPLAY,
			referenceRoot: REFERENCE_ROOT,
			statusLegend: buildStatusLegend(),
			modules: modules
		};
	}

	static function loadExistingInventory():Dynamic {
		if (!FileSystem.exists(MANIFEST_PATH)) return null;
		var content = File.getContent(MANIFEST_PATH);
		if (content.length > 0 && content.charCodeAt(0) == 0xFEFF) content = content.substr(1);
		return Json.parse(content);
	}

	static function buildStatusLegend():Dynamic {
		var legend = {};
		Reflect.setField(legend, "manual", "Suite is fully owned and manually maintained in tests/src.");
		Reflect.setField(legend, "needs-migration", "Module has either a promoted scaffold-derived suite or no authored suite yet and still needs manual semantic migration.");
		Reflect.setField(legend, "excluded", EXCLUDED_NOTE);
		return legend;
	}

	static function getExistingEntry(existingInventory:Dynamic, modulePath:String):Dynamic {
		if (existingInventory == null) return null;
		var modules = Reflect.field(existingInventory, "modules");
		return modules == null ? null : Reflect.field(modules, modulePath);
	}

	static function resolveTestFile(sourceFile:String, existingEntry:Dynamic):Null<String> {
		var existingTestFile = existingEntry == null ? null : cast Reflect.field(existingEntry, "testFile");
		if (existingTestFile != null && FileSystem.exists(existingTestFile)) return normalizePath(existingTestFile);
		var defaultTestFile = TEST_ROOT + "/" + classNameFromFile(sourceFile) + "Test.hx";
		return FileSystem.exists(defaultTestFile) ? normalizePath(defaultTestFile) : existingTestFile;
	}

	static function resolveStatus(existingEntry:Dynamic, sourceFile:String):String {
		if (existingEntry != null) return cast Reflect.field(existingEntry, "status");
		return isExcludedSource(sourceFile) ? "excluded" : "needs-migration";
	}

	static function resolveNotes(existingEntry:Dynamic, status:String, testFile:Null<String>):String {
		if (existingEntry != null) return cast Reflect.field(existingEntry, "notes");
		if (status == "excluded") return EXCLUDED_NOTE;
		return testFile == null ? MISSING_NOTE : PROMOTED_NOTE;
	}

	static function resolveDeferredMembers(existingEntry:Dynamic, status:String, members:Array<String>):Array<String> {
		if (status == "excluded") return [];
		if (existingEntry == null) return members.copy();

		var existingDeferred = readStringArray(existingEntry, "deferredMembers");
		if (existingDeferred == null) existingDeferred = readStringArray(existingEntry, "uncoveredMembers");
		if (existingDeferred == null) return members.copy();

		var previousMembers = readStringArray(existingEntry, "members");
		var deferredMembers:Array<String> = [];
		for (member in members) {
			var trackedPreviously = previousMembers != null && previousMembers.indexOf(member) != -1;
			var stillDeferred = existingDeferred.indexOf(member) != -1;
			if (stillDeferred || !trackedPreviously) deferredMembers.push(member);
		}
		return deferredMembers;
	}

	static function readStringArray(entry:Dynamic, fieldName:String):Null<Array<String>> {
		if (entry == null) return null;
		var value:Dynamic = Reflect.field(entry, fieldName);
		if (value == null) return null;

		var result:Array<String> = [];
		for (item in cast(value, Array<Dynamic>)) {
			if (item == null) continue;
			result.push(Std.string(item));
		}
		return result;
	}

	static function discoverPublicMembers(sourceFile:String):Array<String> {
		var members:Array<String> = [];
		for (line in File.getContent(sourceFile).replace("\r\n", "\n").split("\n")) {
			var trimmed = line.trim();
			if (shouldSkipLine(trimmed) || !trimmed.contains("public")) continue;
			var functionName = extractName(trimmed, ~/function\s+([A-Za-z_][A-Za-z0-9_]*)/);
			if (functionName != null) {
				pushUnique(members, functionName);
				continue;
			}
			var fieldName = extractName(trimmed, ~/var\s+([A-Za-z_][A-Za-z0-9_]*)/);
			if (fieldName == null) fieldName = extractName(trimmed, ~/final\s+([A-Za-z_][A-Za-z0-9_]*)/);
			if (fieldName != null) pushUnique(members, fieldName);
		}
		return members;
	}

	static function shouldSkipLine(line:String):Bool {
		return line.length == 0 || line.startsWith("//") || line.startsWith("/*") || line.startsWith("*");
	}

	static function extractName(line:String, pattern:EReg):Null<String> {
		return pattern.match(line) ? pattern.matched(1) : null;
	}

	static function validateInventory(inventory:Dynamic):Void {
		var problems:Array<String> = [];
		validateSourceCoverage(inventory, problems);
		validateDeferredCoverage(inventory, problems);
		validatePromotedTests(inventory, problems);
		if (problems.length == 0) return;
		for (problem in problems) Sys.println('ERROR: $problem');
		Sys.exit(1);
	}

	static function validateSourceCoverage(inventory:Dynamic, problems:Array<String>):Void {
		var modules = Reflect.field(inventory, "modules");
		for (sourceFile in listFiles(SOURCE_ROOT, ".hx")) {
			var modulePath = toModulePath(sourceFile);
			var entry = Reflect.field(modules, modulePath);
			if (entry == null) {
				problems.push('Missing inventory entry for $modulePath');
				continue;
			}
			var expected = discoverPublicMembers(sourceFile);
			var actual:Array<String> = cast Reflect.field(entry, "members");
			if (!arraysEqual(expected, actual)) problems.push('Member mismatch for $modulePath: expected ${expected.join(", ")} but found ${actual.join(", ")}');
		}
	}

	static function validateDeferredCoverage(inventory:Dynamic, problems:Array<String>):Void {
		var modules = Reflect.field(inventory, "modules");
		for (modulePath in Reflect.fields(modules)) {
			var entry = Reflect.field(modules, modulePath);
			var status:String = cast Reflect.field(entry, "status");
			var members = readStringArray(entry, "members");
			var deferredMembers = readStringArray(entry, "deferredMembers");
			if (deferredMembers == null) {
				problems.push('Missing deferredMembers for $modulePath');
				continue;
			}
			if (status == "excluded") {
				if (deferredMembers.length != 0) problems.push('Excluded module $modulePath must not carry deferred members');
				continue;
			}
			for (member in deferredMembers) {
				if (members != null && members.indexOf(member) == -1) {
					problems.push('Deferred member ${modulePath}.${member} is not present in members');
				}
			}
		}
	}

	static function validatePromotedTests(inventory:Dynamic, problems:Array<String>):Void {
		var modules = Reflect.field(inventory, "modules");
		var testFiles = listFiles(TEST_ROOT, "Test.hx");
		testFiles.sort(compareStrings);
		for (testFile in testFiles) {
			for (id in discoverVisionTestIds(testFile)) {
				var entry = Reflect.field(modules, id.modulePath);
				if (entry == null) {
					problems.push('Missing inventory entry for ${id.modulePath} referenced by ${normalizePath(testFile)}');
					continue;
				}
				var members:Array<String> = cast Reflect.field(entry, "members");
				if (members.indexOf(id.member) == -1) problems.push('Inventory missing ${id.modulePath}.${id.member} referenced by ${normalizePath(testFile)}');
			}
		}
	}

	static function discoverVisionTestIds(testFile:String):Array<{modulePath:String, member:String}> {
		var ids:Array<{modulePath:String, member:String}> = [];
		var pattern = ~/@:visionTestId\("([^"]+)"\)/;
		for (line in File.getContent(testFile).replace("\r\n", "\n").split("\n")) {
			if (!pattern.match(line)) continue;
			var identifier = pattern.matched(1);
			var scenarioIndex = identifier.indexOf("#");
			var memberPath = scenarioIndex == -1 ? identifier : identifier.substr(0, scenarioIndex);
			var lastDot = memberPath.lastIndexOf(".");
			if (lastDot == -1) continue;
			ids.push({modulePath: memberPath.substr(0, lastDot), member: memberPath.substr(lastDot + 1)});
		}
		return ids;
	}

	static function writeInventory(inventory:Dynamic):Void {
		File.saveContent(MANIFEST_PATH, Json.stringify(inventory, null, "    ") + "\n");
	}

	static function listFiles(root:String, suffix:String):Array<String> {
		var result:Array<String> = [];
		for (entry in FileSystem.readDirectory(root)) {
			var path = normalizePath(root + "/" + entry);
			if (FileSystem.isDirectory(path)) result = result.concat(listFiles(path, suffix));
			else if (path.endsWith(suffix)) result.push(path);
		}
		return result;
	}

	static function toModulePath(sourceFile:String):String {
		var normalized = normalizePath(sourceFile);
		var visionIndex = normalized.indexOf("/vision/");
		var relative = visionIndex == -1 ? normalized : normalized.substr(visionIndex + 1);
		return stripHaxeExtension(relative).replace("/", ".");
	}

	static function stripHaxeExtension(path:String):String {
		return path.endsWith(".js.hx") ? path.substr(0, path.length - 6) : path.substr(0, path.length - 3);
	}

	static function classNameFromFile(path:String):String {
		var fileName = normalizePath(path).split("/").pop();
		return stripHaxeExtension(fileName);
	}

	static function isExcludedSource(sourceFile:String):Bool {
		var normalized = normalizePath(sourceFile);
		return normalized.contains("/__internal/") || normalized.endsWith(".js.hx");
	}

	static function normalizePath(path:String):String {
		return path.replace("\\", "/");
	}

	static function arraysEqual(left:Array<String>, right:Array<String>):Bool {
		if (left.length != right.length) return false;
		for (index in 0...left.length) if (left[index] != right[index]) return false;
		return true;
	}

	static function pushUnique(values:Array<String>, value:String):Void {
		if (values.indexOf(value) == -1) values.push(value);
	}

	static function compareStrings(left:String, right:String):Int {
		return Reflect.compare(left, right);
	}
}
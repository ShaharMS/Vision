package;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.Process;
import haxe.Json;
import haxe.Http;
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.zip.Reader;
import haxe.zip.Entry;

using StringTools;

class LocalCi {
    static var DEFAULT_TARGETS = [
        "interp",
        "neko",
        "hl",
        "js",
        "cpp",
        "jvm",
        "python",
        "lua",
        "php",
        "cs",
        "java",
        "cppia"
    ];

    static var DEFAULT_LIBS = ["vision", "format", "utest"];
    static var DEFAULT_CLASS_PATH = "tests/generated/src";
    static var EXTRA_CLASS_PATH = "tests/generated";

    static function main() {
        var config = parseArgs(Sys.args());
        if (config.showHelp) {
            printHelp();
            return;
        }

        ensureDirectory("bin");

        if (!config.skipInstall) {
            var libsToInstall = collectRequiredLibs(config.targets);
            installHaxelibs(libsToInstall);
        }

        var failures = 0;
        for (target in config.targets) {
            if (config.compile && !compileTarget(target, config)) {
                failures++;
                continue;
            }
            if (config.run && !runTarget(target, config)) {
                failures++;
            }
        }

        if (failures > 0) {
            Sys.println("\nLocal CI failed with " + failures + " failing target(s).");
            Sys.exit(1);
        }
        Sys.println("\nLocal CI completed successfully.");
    }

    static function parseArgs(args:Array<String>) {
        var targets = DEFAULT_TARGETS.copy();
        var compile = true;
        var run = true;
        var skipInstall = false;
        var allowInline = false;
        var allowInlineTargets:Array<String> = [];
        var skipGolden = false;
        var skipInvalidTests = true;
        var showHelp = false;

        var envTargets = Sys.getEnv("VISION_CI_TARGETS");
        if (envTargets != null && envTargets.length > 0) {
            targets = [for (t in envTargets.split(",")) t.trim()].filter(t -> t.length > 0);
        }
        if (Sys.getEnv("VISION_CI_COMPILE_ONLY") == "1") {
            run = false;
        }
        if (Sys.getEnv("VISION_CI_RUN_ONLY") == "1") {
            compile = false;
        }
        if (Sys.getEnv("VISION_CI_SKIP_INSTALL") == "1") {
            skipInstall = true;
        }
        if (Sys.getEnv("VISION_CI_ALLOW_INLINE") == "1") {
            allowInline = true;
        }
        var allowInlineTargetsEnv = Sys.getEnv("VISION_CI_ALLOW_INLINE_TARGETS");
        if (allowInlineTargetsEnv != null && allowInlineTargetsEnv.length > 0) {
            allowInlineTargets = [for (t in allowInlineTargetsEnv.split(",")) t.trim()].filter(t -> t.length > 0);
        }
        if (Sys.getEnv("VISION_CI_SKIP_GOLDEN") == "1") {
            skipGolden = true;
        }
        if (Sys.getEnv("VISION_CI_SKIP_INVALID_TESTS") == "1") {
            skipInvalidTests = true;
        }

        for (arg in args) {
            if (arg == "--compile-only") {
                run = false;
            } else if (arg == "--run-only") {
                compile = false;
            } else if (arg == "--skip-install") {
                skipInstall = true;
            } else if (arg == "--allow-inline") {
                allowInline = true;
            } else if (StringTools.startsWith(arg, "--allow-inline-targets=")) {
                var list = arg.split("=")[1];
                if (list != null && list.length > 0) {
                    allowInlineTargets = [for (t in list.split(",")) t.trim()].filter(t -> t.length > 0);
                }
            } else if (arg == "--skip-golden") {
                skipGolden = true;
            } else if (arg == "--skip-invalid-tests") {
                skipInvalidTests = true;
            } else if (arg == "--help" || arg == "-h") {
                showHelp = true;
            } else if (StringTools.startsWith(arg, "--targets=")) {
                var list = arg.split("=")[1];
                if (list != null && list.length > 0) {
                    targets = [for (t in list.split(",")) t.trim()].filter(t -> t.length > 0);
                }
            }
        }

        return {
            targets: targets,
            compile: compile,
            run: run,
            skipInstall: skipInstall,
            allowInline: allowInline,
            allowInlineTargets: allowInlineTargets,
            skipGolden: skipGolden,
            skipInvalidTests: skipInvalidTests,
            showHelp: showHelp
        };
    }

    static function printHelp() {
        Sys.println("Local CI runner for Vision tests");
        Sys.println("");
        Sys.println("Usage:");
        Sys.println("  haxe tests/ci/local-ci.hxml -- [options]");
        Sys.println("");
        Sys.println("Options:");
        Sys.println("  --targets=interp,neko,hl,...   Run specific targets");
        Sys.println("  --compile-only                Only compile targets");
        Sys.println("  --run-only                    Only run targets (assumes compiled outputs)");
        Sys.println("  --skip-install                Skip haxelib installs");
        Sys.println("  --skip-golden                 Skip golden image tests (network)");
        Sys.println("  --skip-invalid-tests          Skip invalid/placeholder tests");
        Sys.println("  --allow-inline               Allow inlining on all targets");
        Sys.println("  --allow-inline-targets=lua,java  Allow inlining on specific targets");
        Sys.println("  --help                        Show this help");
    }

    static function installHaxelibs(libs:Array<String>) {
        for (lib in libs) {
            Sys.println("Installing haxelib " + lib + " (if needed)...");
            Sys.command("haxelib", ["install", lib, "--quiet"]);
        }
        Sys.println("Setting haxelib dev vision .");
        Sys.command("haxelib", ["dev", "vision", Sys.getCwd()]);
    }

    static function collectRequiredLibs(targets:Array<String>):Array<String> {
        var libs = DEFAULT_LIBS.copy();
        for (target in targets) {
            switch (target) {
                case "cpp" | "cppia":
                    addUnique(libs, "hxcpp");
                case "java" | "jvm":
                    addUnique(libs, "hxjava");
                case "cs":
                    addUnique(libs, "hxcs");
                default:
            }
        }
        return libs;
    }

    static inline function addUnique(items:Array<String>, value:String) {
        if (items.indexOf(value) == -1) items.push(value);
    }

    static function compileTarget(target:String, config:{targets:Array<String>, compile:Bool, run:Bool, skipInstall:Bool, allowInline:Bool, allowInlineTargets:Array<String>, skipGolden:Bool, skipInvalidTests:Bool, showHelp:Bool}):Bool {
        Sys.println("\n==> Compile " + target);
		if (target == "interp") {
			return true;
		}
        var isWindows = Sys.systemName() == "Windows";
        if (target == "java" && !ensureJavaJar(isWindows)) {
            return false;
        }
        var args = [
            "--class-path", DEFAULT_CLASS_PATH,
            "--class-path", EXTRA_CLASS_PATH,
            "--main", "Main",
            "--library", "vision",
            "--library", "format",
            "--library", "utest",
            "-debug",
            "-D",
            "no-deprecation-warnings"
        ];

        if (target == "lua") {
            args.remove("-debug");
        }

        if (config.skipGolden) {
            args.push("-D");
            args.push("vision_skip_golden");
        }
        if (config.skipInvalidTests) {
            args.push("-D");
            args.push("vision_skip_invalid_tests");
        }

        if (shouldDisableInline(target, config)) {
            args.push("-D");
            args.push("no-inline");
            args.push("-D");
            args.push("vision_no_inline");
        }


        switch (target) {
            case "neko":
                args.push("--neko");
                args.push("bin/neko/tests.n");
            case "hl":
                args.push("--hl");
                args.push("bin/hl/tests.hl");
            case "js":
                args.push("--js");
                args.push("bin/js/tests.js");
            case "cpp":
                args.push("--cpp");
                args.push("bin/cpp");
            case "jvm":
                args.push("--jvm");
                args.push("bin/jvm/tests.jar");
            case "python":
                args.push("--python");
                args.push("bin/python/tests.py");
            case "lua":
                if (isLuaJitAvailable(isWindows)) {
                    args.push("-D");
                    args.push("lua-jit");
                }
                args.push("-D");
                args.push("no-inline");
                args.push("-D");
                args.push("no-opt");
                args.push("-D");
                args.push("lua-vanilla");
                args.push("--lua");
                args.push("bin/lua/tests.lua");
            case "php":
                args.push("--php");
                args.push("bin/php");
            case "cs":
                args.push("--cs");
                args.push("bin/cs");
            case "java":
                args.push("--java");
                args.push("bin/java");
            case "cppia":
                args.push("--cppia");
                args.push("bin/cppia/tests.cppia");
            default:
                Sys.println("Unknown target: " + target);
                return false;
        }

        return Sys.command("haxe", args) == 0;
    }

    static function runTarget(target:String, config:{targets:Array<String>, compile:Bool, run:Bool, skipInstall:Bool, allowInline:Bool, allowInlineTargets:Array<String>, skipGolden:Bool, skipInvalidTests:Bool, showHelp:Bool}):Bool {
        Sys.println("\n==> Run " + target);
        var isWindows = Sys.systemName() == "Windows";

        if (!ensureRuntime(target, isWindows)) {
            return false;
        }

        switch (target) {
            case "interp":
                var interpArgs = [
                    "--class-path", DEFAULT_CLASS_PATH,
                    "--class-path", EXTRA_CLASS_PATH,
                    "--main", "Main",
                    "--library", "vision",
                    "--library", "format",
                    "--library", "utest",
                    "-debug",
                    "-D",
                    "no-deprecation-warnings",
                    "--interp"
                ];
                if (config.skipGolden) {
                    interpArgs.push("-D");
                    interpArgs.push("vision_skip_golden");
                }
                if (config.skipInvalidTests) {
                    interpArgs.push("-D");
                    interpArgs.push("vision_skip_invalid_tests");
                }
                return Sys.command("haxe", interpArgs) == 0;
            case "js":
                return Sys.command("node", ["bin/js/tests.js"]) == 0;
            case "neko":
                return Sys.command(isWindows ? "neko.exe" : "neko", ["bin/neko/tests.n"]) == 0;
            case "hl":
                return Sys.command(isWindows ? "hl.exe" : "hl", ["bin/hl/tests.hl"]) == 0;
            case "cpp":
                var exe = isWindows ? "bin/cpp/Main.exe" : "bin/cpp/Main";
                var debugExe = isWindows ? "bin/cpp/Main-debug.exe" : "bin/cpp/Main-debug";
                var cppPath = FileSystem.exists(exe) ? exe : debugExe;
                return Sys.command(cppPath, []) == 0;
            case "jvm":
                return Sys.command("java", ["-jar", "bin/jvm/tests.jar"]) == 0;
            case "java":
                var jar = "bin/java/Main.jar";
                var debugJar = "bin/java/Main-Debug.jar";
                var jarPath = FileSystem.exists(jar) ? jar : debugJar;
                return Sys.command("java", ["-jar", jarPath]) == 0;
            case "python":
                return Sys.command(isWindows ? "python" : "python3", ["bin/python/tests.py"]) == 0;
            case "lua":
                var luaCmd = getLuaRuntime(isWindows);
                return Sys.command(luaCmd, ["bin/lua/tests.lua"]) == 0;
            case "php":
                var phpArgs = getPhpArgs();
                phpArgs.push("bin/php/index.php");
                return Sys.command("php", phpArgs) == 0;
            case "cs":
                var csExe = "bin/cs/bin/Main.exe";
                var csDebugExe = "bin/cs/bin/Main-Debug.exe";
                var csPath = FileSystem.exists(csExe) ? csExe : csDebugExe;
                if (isWindows) {
                    return Sys.command(csPath, []) == 0;
                }
                return Sys.command("mono", [csPath]) == 0;
            case "cppia":
                var cppiaPath = findCppiaExecutable(isWindows);
                if (cppiaPath == null) {
                    Sys.println("cppia runtime not found. Please install hxcpp/cppia or add cppia.exe to PATH.");
                    return false;
                }
                return Sys.command(cppiaPath, ["bin/cppia/tests.cppia"]) == 0;
            default:
                Sys.println("Unknown target: " + target);
                return false;
        }
    }

    static function ensureRuntime(target:String, isWindows:Bool):Bool {
        switch (target) {
            case "hl":
                return ensureToolOrDownload(isWindows, "hl", ["HaxeFoundation.HashLink"], "hashlink", "HaxeFoundation/hashlink", ~/hashlink-.*-win\.zip$/i, "hl.exe");
            case "lua":
                if (ensureTool(isWindows, "luajit", ["DEVCOM.LuaJIT"], "luajit")) {
                    return ensureLuaPcre(isWindows);
                }
                if (ensureTool(isWindows, "lua", ["DEVCOM.Lua", "rjpcomputing.luaforwindows"], "lua")) {
                    return ensureLuaPcre(isWindows);
                }
                return false;
            case "php":
                return ensureTool(isWindows, "php", ["PHP.PHP.8.3", "PHP.PHP.8.2"], "php");
            case "neko":
                return ensureNekoRuntime(isWindows);
            case "jvm":
                return ensureTool(isWindows, "java", ["EclipseAdoptium.Temurin.17.JDK"], "temurin17");
            case "java":
                if (!ensureTool(isWindows, "java", ["EclipseAdoptium.Temurin.17.JDK"], "temurin17")) return false;
                return ensureJavaJar(isWindows);
            case "cppia":
                return findCppiaExecutable(isWindows) != null;
            case "python" | "js" | "cpp" | "interp":
                return true;
            default:
                return true;
        }
    }

    static function shouldDisableInline(target:String, config:{allowInline:Bool, allowInlineTargets:Array<String>}):Bool {
        if (config.allowInline) return false;
        if (config.allowInlineTargets != null && config.allowInlineTargets.indexOf(target) != -1) return false;
        return false;
    }

    static function ensureTool(isWindows:Bool, command:String, wingetIds:Array<String>, chocoId:String, forceInstall:Bool = false):Bool {
        if (!forceInstall && commandExists(command, isWindows)) return true;

        if (isWindows) {
            var installed = tryInstallWindows(wingetIds, chocoId);
            if (!commandExists(command, isWindows)) {
                var located = findExecutableInCommonLocations(command);
                if (located != null) {
                    prependPath(located);
                }
            }
            if (commandExists(command, isWindows)) {
                return true;
            }
            if (installed) {
                Sys.println("Installed " + command + " but it is still not on PATH.");
            } else {
                Sys.println("Missing " + command + ". Please install it and ensure it's on PATH.");
            }
            return false;
        }

        Sys.println("Missing " + command + ". Please install it via your package manager and retry.");
        return false;
    }

    static function commandExists(command:String, isWindows:Bool):Bool {
        var probe = isWindows ? "where" : "which";
        var cmd = isWindows && command.indexOf(".") == -1 ? command + ".exe" : command;
        if (Sys.command(probe, [cmd]) == 0) return true;
        if (isWindows && Sys.command(probe, [command]) == 0) return true;
        return false;
    }

    static function tryInstallWindows(wingetIds:Array<String>, chocoId:String):Bool {
        if (commandExists("winget", true)) {
            var attempted = false;
            for (wingetId in wingetIds) {
                if (wingetId == null || wingetId.length == 0) continue;
                attempted = true;
                var args = [
                    "install",
                    "--id", wingetId,
                    "-e",
                    "--silent",
                    "--accept-package-agreements",
                    "--accept-source-agreements"
                ];
                if (Sys.command("winget", args) == 0) return true;
            }
            if (attempted) return false;
        }
        if (commandExists("choco", true)) {
            return Sys.command("choco", ["install", chocoId, "-y"]) == 0;
        }
        Sys.println("Neither winget nor choco found. Please install the missing runtime manually.");
        return false;
    }

    static function ensureToolOrDownload(isWindows:Bool, command:String, wingetIds:Array<String>, chocoId:String, repo:String, assetPattern:EReg, exeName:String, forceInstall:Bool = false):Bool {
        if (ensureTool(isWindows, command, wingetIds, chocoId, forceInstall)) return true;
        if (!isWindows) return false;

        var installDir = Path.join([Sys.getCwd(), "tools", command]);
        Sys.println("Attempting direct download for " + command + " from GitHub...");
        if (downloadAndExtractFromGithub(repo, assetPattern, installDir)) {
            var exeDir = findExecutableDir(installDir, exeName);
            if (exeDir != null) {
                prependPath(exeDir);
                return commandExists(command, true) || FileSystem.exists(Path.join([exeDir, exeName]));
            }
        }
        return false;
    }

    static function ensureNekoRuntime(isWindows:Bool):Bool {
        var hasNeko = commandExists("neko", isWindows);
        var versionOk = hasNeko && (isWindows ? isNekoVersionOk() : true);
        if (versionOk) return true;

        if (isWindows) {
            var forceInstall = hasNeko && !versionOk;
            if (ensureToolOrDownload(true, "neko", ["HaxeFoundation.Neko"], "neko", "HaxeFoundation/neko", ~/neko-.*-win64\.zip$/i, "neko.exe", forceInstall)) {
                return isNekoVersionOk();
            }
            if (ensureToolOrDownload(true, "neko", ["HaxeFoundation.Neko"], "neko", "HaxeFoundation/neko", ~/neko-.*-win\.zip$/i, "neko.exe", forceInstall)) {
                return isNekoVersionOk();
            }
            Sys.println("Missing or outdated neko. Please install Neko 2.4+ and ensure it's on PATH.");
            return false;
        }

        Sys.println("Missing or outdated neko. Please install Neko 2.4+ via your package manager and retry.");
        return false;
    }

    static function isNekoVersionOk():Bool {
        try {
            var process = new Process("neko", ["-version"]);
            var output = process.stdout.readAll().toString();
            process.close();
            var parts = output.split(".");
            if (parts.length >= 2) {
                var major = Std.parseInt(parts[0]);
                var minor = Std.parseInt(parts[1]);
                return (major > 2) || (major == 2 && minor >= 4);
            }
        } catch (e:Dynamic) {}
        return false;
    }

    static function ensureJavaJar(isWindows:Bool):Bool {
        if (commandExists("jar", isWindows)) return true;
        var javaHome = getJavaHome();
        if (javaHome != null) {
            var binDir = Path.join([javaHome, "bin"]);
            if (FileSystem.exists(binDir)) {
                prependPath(binDir);
                return commandExists("jar", isWindows);
            }
        }
        if (isWindows) {
            Sys.println("Installed jar but it is still not on PATH.");
            return false;
        }
        Sys.println("Missing jar. Please install a JDK and ensure jar is on PATH.");
        return false;
    }

    static function getJavaHome():Null<String> {
        try {
            var process = new Process("java", ["-XshowSettings:properties", "-version"]);
            var output = process.stderr.readAll().toString();
            process.close();
            for (line in output.split("\n")) {
                var trimmed = line.trim();
                if (trimmed.startsWith("java.home")) {
                    var parts = trimmed.split("=");
                    if (parts.length >= 2) return parts[1].trim();
                }
            }
        } catch (e:Dynamic) {}
        return Sys.getEnv("JAVA_HOME");
    }

    static function prependPath(path:String) {
        var current = Sys.getEnv("PATH");
        if (current == null || current.length == 0) {
            Sys.putEnv("PATH", path);
            return;
        }
        if (current.indexOf(path) == -1) {
            Sys.putEnv("PATH", path + (Sys.systemName() == "Windows" ? ";" : ":") + current);
        }
    }

    static function downloadAndExtractFromGithub(repo:String, assetPattern:EReg, destDir:String):Bool {
        try {
            var apiUrl = "https://api.github.com/repos/" + repo + "/releases/latest";
            var jsonText = httpGetText(apiUrl);
            var data:Dynamic = Json.parse(jsonText);
            var assets:Array<Dynamic> = data.assets;
            if (assets == null) return false;
            var url:String = null;
            for (asset in assets) {
                var name:String = asset.name;
                if (name != null && assetPattern.match(name)) {
                    url = asset.browser_download_url;
                    break;
                }
            }
            if (url == null) return false;

            var bytes = downloadBytes(url);
            if (bytes == null) return false;

            if (!FileSystem.exists(destDir)) FileSystem.createDirectory(destDir);
            var reader = new Reader(new haxe.io.BytesInput(bytes));
            var entries = reader.read();
            for (entry in entries) {
                extractZipEntry(destDir, entry);
            }
            return true;
        } catch (e:Dynamic) {}
        return false;
    }

    static function httpGetText(url:String):String {
        var data:String = null;
        var http = new Http(url);
        http.setHeader("User-Agent", "Vision-LocalCi");
        http.onData = function(text) data = text;
        http.onError = function(_) data = null;
        http.request(false);
        return data;
    }

    static function downloadBytes(url:String):Null<Bytes> {
        var bytes:Bytes = null;
        var http = new Http(url);
        http.setHeader("User-Agent", "Vision-LocalCi");
        http.onBytes = function(b) bytes = b;
        http.onError = function(_) bytes = null;
        http.request(true);
        return bytes;
    }

    static function extractZipEntry(destDir:String, entry:Entry):Void {
        var outPath = Path.join([destDir, entry.fileName]);
        if (entry.fileName.endsWith("/")) {
            if (!FileSystem.exists(outPath)) FileSystem.createDirectory(outPath);
            return;
        }
        var dir = Path.directory(outPath);
        if (dir != null && dir.length > 0 && !FileSystem.exists(dir)) {
            FileSystem.createDirectory(dir);
        }
        var data = Reader.unzip(entry);
        sys.io.File.saveBytes(outPath, data);
    }

    static function findExecutableDir(root:String, exeName:String):Null<String> {
        if (!FileSystem.exists(root)) return null;
        var stack = [root];
        while (stack.length > 0) {
            var current = stack.pop();
            for (entry in FileSystem.readDirectory(current)) {
                var full = Path.join([current, entry]);
                if (FileSystem.isDirectory(full)) {
                    stack.push(full);
                } else if (entry.toLowerCase() == exeName.toLowerCase()) {
                    return Path.directory(full);
                }
            }
        }
        return null;
    }

    static function findExecutableInCommonLocations(command:String):Null<String> {
        var programFiles = Sys.getEnv("ProgramFiles");
        var programFilesX86 = Sys.getEnv("ProgramFiles(x86)");
        var localAppData = Sys.getEnv("LOCALAPPDATA");

        var candidates = new Array<String>();
        switch (command) {
            case "lua":
                if (programFiles != null) candidates.push(Path.join([programFiles, "Lua", "5.4", "lua.exe"]));
                if (programFiles != null) candidates.push(Path.join([programFiles, "Lua", "lua.exe"]));
                if (programFilesX86 != null) candidates.push(Path.join([programFilesX86, "Lua", "5.4", "lua.exe"]));
                if (programFilesX86 != null) candidates.push(Path.join([programFilesX86, "Lua", "lua.exe"]));
            case "php":
                if (programFiles != null) candidates.push(Path.join([programFiles, "PHP", "php.exe"]));
                if (programFiles != null) candidates.push(Path.join([programFiles, "PHP", "8.3", "php.exe"]));
                if (programFiles != null) candidates.push(Path.join([programFiles, "PHP", "8.2", "php.exe"]));
                if (programFilesX86 != null) candidates.push(Path.join([programFilesX86, "PHP", "php.exe"]));
            case "neko":
                if (programFiles != null) candidates.push(Path.join([programFiles, "Neko", "neko.exe"]));
            case "java":
                var javaHome = getJavaHome();
                if (javaHome != null) candidates.push(Path.join([javaHome, "bin", "java.exe"]));
            case "jar":
                var javaHome = getJavaHome();
                if (javaHome != null) candidates.push(Path.join([javaHome, "bin", "jar.exe"]));
            default:
        }

        for (candidate in candidates) {
            if (candidate != null && FileSystem.exists(candidate)) {
                return Path.directory(candidate);
            }
        }

        if (localAppData != null) {
            var tools = Path.join([localAppData, "Programs"]);
            if (FileSystem.exists(tools)) {
                var found = findExecutableDir(tools, command + ".exe");
                if (found != null) return found;
            }
        }
        return null;
    }

    static function findCppiaExecutable(isWindows:Bool):Null<String> {
        var exe = isWindows ? "cppia.exe" : "cppia";
        if (commandExists(exe, isWindows)) return exe;

        var hxcppPath = getHaxelibPath("hxcpp");
        if (hxcppPath == null) return null;

        var candidates = [
            Path.join([hxcppPath, "bin", exe]),
            Path.join([hxcppPath, "bin", "Windows", exe]),
            Path.join([hxcppPath, "bin", "Windows64", "Cppia.exe"]),
            Path.join([hxcppPath, "bin", "Linux", exe])
        ];
        for (candidate in candidates) {
            if (FileSystem.exists(candidate)) return candidate;
        }
        return null;
    }

    static function isLuaJitAvailable(isWindows:Bool):Bool {
        return commandExists(isWindows ? "luajit.exe" : "luajit", isWindows);
    }

    static function getLuaRuntime(isWindows:Bool):String {
        if (isLuaJitAvailable(isWindows)) return isWindows ? "luajit.exe" : "luajit";
        return isWindows ? "lua.exe" : "lua";
    }

    static function ensureLuaPcre(isWindows:Bool):Bool {
        var luaCmd = getLuaRuntime(isWindows);
        configureLuaRocksEnv();
        if (testLuaModule(luaCmd, "rex_pcre2") && testLuaModule(luaCmd, "socket")) return true;
        if (!commandExists("luarocks", isWindows)) {
            if (isWindows) {
                tryInstallWindows(["DEVCOM.Lua", "DEVCOM.LuaJIT"], "luarocks");
            }
        }
        if (commandExists("luarocks", isWindows)) {
            var luaCmdPath = getCommandPath(luaCmd, isWindows);
            var luaDir = luaCmdPath != null ? Path.directory(luaCmdPath) : null;
            var luaRoot = luaDir != null ? Path.directory(luaDir) : null;
            var isLuaJit = luaCmd.toLowerCase().indexOf("luajit") != -1;
            configureLuaBuildEnv();
            if (isLuaJit && luaRoot != null) {
                Sys.command("luarocks", ["--lua-version=5.1", "--lua-dir=" + luaRoot, "install", "lrexlib-pcre2"]);
                Sys.command("luarocks", ["--lua-version=5.1", "--lua-dir=" + luaRoot, "install", "luasocket", "CC=" + getLuaBuildCC()]);
            } else {
                Sys.command("luarocks", ["install", "lrexlib-pcre2"]);
                Sys.command("luarocks", ["install", "luasocket", "CC=" + getLuaBuildCC()]);
            }
            configureLuaRocksEnv();
            if (testLuaModule(luaCmd, "rex_pcre2") && testLuaModule(luaCmd, "socket")) return true;
        }
        Sys.println("Missing Lua modules rex_pcre2 or socket. Please install lrexlib-pcre2 and luasocket via luarocks.");
        return false;
    }

    static function testLuaModule(luaCmd:String, module:String):Bool {
        var args = ["-e", "require('" + module + "')"];
        return Sys.command(luaCmd, args) == 0;
    }

    static function configureLuaRocksEnv() {
        var appData = Sys.getEnv("APPDATA");
        if (appData == null) return;
        var base = Path.join([appData, "luarocks"]);
        var luaPath = Path.join([base, "share", "lua", "5.1", "?.lua"]) + ";" +
            Path.join([base, "share", "lua", "5.1", "?", "init.lua"]);
        var luaCPath = Path.join([base, "lib", "lua", "5.1", "?.dll"]);

        var currentPath = Sys.getEnv("LUA_PATH");
        if (currentPath == null || currentPath.indexOf(luaPath) == -1) {
            Sys.putEnv("LUA_PATH", luaPath + (currentPath != null ? ";" + currentPath : ""));
        }
        var currentCPath = Sys.getEnv("LUA_CPATH");
        if (currentCPath == null || currentCPath.indexOf(luaCPath) == -1) {
            Sys.putEnv("LUA_CPATH", luaCPath + (currentCPath != null ? ";" + currentCPath : ""));
        }
    }

    static function configureLuaBuildEnv() {
        var mingwBin = Path.join(["C:\\", "msys64", "mingw64", "bin"]);
        if (FileSystem.exists(mingwBin)) {
            prependPath(mingwBin);
        }
    }

    static function getLuaBuildCC():String {
        var gcc = Path.join(["C:\\", "msys64", "mingw64", "bin", "gcc.exe"]);
        if (FileSystem.exists(gcc)) return gcc;
        return "gcc";
    }

    static function getCommandPath(command:String, isWindows:Bool):Null<String> {
        try {
            var probe = isWindows ? "where" : "which";
            var process = new Process(probe, [command]);
            var output = process.stdout.readAll().toString();
            process.close();
            for (line in output.split("\n")) {
                var trimmed = line.trim();
                if (trimmed.length > 0) return trimmed;
            }
        } catch (e:Dynamic) {}
        return null;
    }

    static function getHaxelibPath(lib:String):Null<String> {
        var process = new Process("haxelib", ["path", lib]);
        var output = process.stdout.readAll().toString();
        process.close();

        for (line in output.split("\n")) {
            var trimmed = line.trim();
            if (trimmed.length == 0) continue;
            if (trimmed.startsWith("-")) continue;
            return trimmed;
        }
        return null;
    }

    static function ensureDirectory(path:String) {
        if (!FileSystem.exists(path)) {
            FileSystem.createDirectory(path);
        }
    }

    static function getPhpArgs():Array<String> {
        var args:Array<String> = [];
        if (Sys.getEnv("VISION_PHP_DISABLE_MBSTRING") != "1") {
            var extDir = Sys.getEnv("VISION_PHP_EXT_DIR");
            if (extDir != null && extDir.length > 0) {
                args.push("-d");
                args.push("extension_dir=" + extDir);
            }
            args.push("-d");
            args.push("extension=openssl");
            args.push("-d");
            args.push("extension=mbstring");
        }
        return args;
    }
}

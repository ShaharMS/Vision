package;

import haxe.io.Path;
import sys.FileSystem;

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

    static function main() {
        var config = parseArgs(Sys.args());
        if (config.showHelp) {
            printHelp();
            return;
        }

        ensureDirectory("bin");

        if (!config.skipInstall) {
            installHaxelibs(DEFAULT_LIBS);
        }

        var failures = 0;
        for (target in config.targets) {
            if (config.compile && !compileTarget(target, config)) {
                failures++;
                continue;
            }
            if (config.run && !runTarget(target)) {
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
        var noInlineJava = true;
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
        if (Sys.getEnv("VISION_CI_NO_INLINE_JAVA") == "0") {
            noInlineJava = false;
        }

        for (arg in args) {
            if (arg == "--compile-only") {
                run = false;
            } else if (arg == "--run-only") {
                compile = false;
            } else if (arg == "--skip-install") {
                skipInstall = true;
            } else if (arg == "--no-no-inline-java") {
                noInlineJava = false;
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
            noInlineJava: noInlineJava,
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
        Sys.println("  --no-no-inline-java           Allow inlining on java/jvm");
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

    static function compileTarget(target:String, config:{targets:Array<String>, compile:Bool, run:Bool, skipInstall:Bool, noInlineJava:Bool, showHelp:Bool}):Bool {
        Sys.println("\n==> Compile " + target);
        var args = [
            "--class-path", DEFAULT_CLASS_PATH,
            "--main", "Main",
            "--library", "vision",
            "--library", "format",
            "--library", "utest",
            "-debug"
        ];

        if (config.noInlineJava && (target == "java" || target == "jvm")) {
            args.push("--no-inline");
        }

        switch (target) {
            case "interp":
                args.push("--no-output");
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

    static function runTarget(target:String):Bool {
        Sys.println("\n==> Run " + target);
        var isWindows = Sys.systemName() == "Windows";

        switch (target) {
            case "interp":
                return Sys.command("haxe", [
                    "--class-path", DEFAULT_CLASS_PATH,
                    "--main", "Main",
                    "--library", "vision",
                    "--library", "format",
                    "--library", "utest",
                    "-debug",
                    "--interp"
                ]) == 0;
            case "js":
                return Sys.command("node", ["bin/js/tests.js"]) == 0;
            case "neko":
                return Sys.command(isWindows ? "neko.exe" : "neko", ["bin/neko/tests.n"]) == 0;
            case "hl":
                return Sys.command(isWindows ? "hl.exe" : "hl", ["bin/hl/tests.hl"]) == 0;
            case "cpp":
                var exe = isWindows ? "bin/cpp/Main.exe" : "bin/cpp/Main";
                return Sys.command(exe, []) == 0;
            case "jvm":
                return Sys.command("java", ["-jar", "bin/jvm/tests.jar"]) == 0;
            case "java":
                return Sys.command("java", ["-cp", "bin/java/obj", "Main"]) == 0;
            case "python":
                return Sys.command(isWindows ? "python" : "python3", ["bin/python/tests.py"]) == 0;
            case "lua":
                return Sys.command(isWindows ? "lua.exe" : "lua", ["bin/lua/tests.lua"]) == 0;
            case "php":
                var phpArgs = getPhpArgs();
                phpArgs.push("bin/php/index.php");
                return Sys.command("php", phpArgs) == 0;
            case "cs":
                if (isWindows) {
                    return Sys.command("bin/cs/bin/Main.exe", []) == 0;
                }
                return Sys.command("mono", ["bin/cs/bin/Main.exe"]) == 0;
            case "cppia":
                return Sys.command(isWindows ? "cppia.exe" : "cppia", ["bin/cppia/tests.cppia"]) == 0;
            default:
                Sys.println("Unknown target: " + target);
                return false;
        }
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

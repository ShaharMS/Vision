package;

import utest.Runner;
import utest.Assertation;
import utest.TestResult;

/**
 * Pretty-printed test reporter with ANSI colors and status bar
 */
class PrettyReporter {
    // ANSI colors
    static inline var RED = "\033[31m";
    static inline var GREEN = "\033[32m";
    static inline var YELLOW = "\033[33m";
    static inline var BLUE = "\033[34m";
    static inline var MAGENTA = "\033[35m";
    static inline var CYAN = "\033[36m";
    static inline var WHITE = "\033[37m";
    static inline var BLACK = "\033[30m";
    static inline var LIGHT_BLUE = "\033[94m";
    static inline var GRAY = "\033[90m";
    static inline var RESET = "\033[0m";

    static inline var RED_BACKGROUND = "\033[41m";
    static inline var GREEN_BACKGROUND = "\033[42m";
    static inline var YELLOW_BACKGROUND = "\033[43m";
    static inline var BLUE_BACKGROUND = "\033[44m";
    static inline var MAGENTA_BACKGROUND = "\033[45m";
    static inline var CYAN_BACKGROUND = "\033[46m";
    static inline var WHITE_BACKGROUND = "\033[47m";
    static inline var BLACK_BACKGROUND = "\033[40m";
    static inline var LIGHT_BLUE_BACKGROUND = "\033[104m";
    static inline var GRAY_BACKGROUND = "\033[100m";

    static inline var BOLD = "\033[1m";
    static inline var ITALIC = "\033[3m";
    static inline var UNDERLINE = "\033[4m";

    var testNum:Int = 0;
    var mySuccesses:Int = 0;
    var myFailures:Int = 0;
    var myErrors:Int = 0;
    var mySkipped:Int = 0;
    var startTime:Float = 0;

    public function new(runner:Runner) {
        runner.onStart.add(startTests);
        runner.onProgress.add(progress);
        runner.onComplete.add(complete);
    }

    function log(message:String) {
        #if sys
        Sys.println(message);
        #elseif js
        js.Browser.console.log(message);
        #else
        trace(message);
        #end
    }

    function startTests(runner:Runner) {
        startTime = haxe.Timer.stamp();
        log(CYAN + BOLD + "════════════════════════════════════════════════════════════════" + RESET);
        log(CYAN + BOLD + "                    Vision Test Suite                           " + RESET);
        log(CYAN + BOLD + "════════════════════════════════════════════════════════════════" + RESET + "\n");
    }

    function exit(exitCode:Int) {
        #if sys
        Sys.exit(exitCode);
        #else
        log("Exiting with code " + Std.string(exitCode));
        #end
    }

    function progress(e:{result:TestResult, done:Int, totals:Int}) {
        testNum++;
        var result = e.result;
        
        var success = true;
        var isSkipped = false;
        var failureMsg = "";

        for (a in result.assertations) {
            switch (a) {
                case Success(_):
                    // ok
                case Failure(msg, _):
                    success = false;
                    failureMsg = msg;
                case Error(ex, _):
                    success = false;
                    failureMsg = Std.string(ex);
                    myErrors++;
                case Warning(msg):
                    isSkipped = true;
                    mySkipped++;
                case Ignore(reason):
                    isSkipped = true;
                    mySkipped++;
                default:
                    success = false;
                    failureMsg = "Unknown error";
            }
        }

        if (success && !isSkipped) mySuccesses++;
        else if (!isSkipped) myFailures++;

        var statusColor = success ? GREEN : (isSkipped ? LIGHT_BLUE : RED);
        var statusText = success ? "Success" : (isSkipped ? "Skipped" : "Failure");
        var statusEmoji = success ? "✓" : (isSkipped ? "⊘" : "✗");

        // Get current time for debugging stuck tests
        var now = Date.now();
        var timeStr = StringTools.lpad(Std.string(now.getHours()), "0", 2) + ":" + 
                      StringTools.lpad(Std.string(now.getMinutes()), "0", 2) + ":" + 
                      StringTools.lpad(Std.string(now.getSeconds()), "0", 2);

        log(CYAN + BOLD + " Unit Test " + Std.string(testNum) + ":" + RESET + " " + BOLD + ITALIC + statusColor + result.cls + "." + result.method + RESET);
        log("    " + GRAY + "[" + timeStr + "]" + RESET);
        log("    " + statusEmoji + " " + RESET + BOLD + WHITE + "Result: " + ITALIC + statusColor + statusText + RESET);
        
        if (!success && !isSkipped) {
            log("        " + RESET + BOLD + WHITE + "Message:" + RESET + " " + ITALIC + RED + failureMsg + RESET);
        }
    }

    function complete(runner:Runner) {
        var elapsed = haxe.Timer.stamp() - startTime;
        
        log("\n");
        log(getTestStatusBar(mySuccesses, myFailures, mySkipped, myErrors));
        
        var total = mySuccesses + myFailures + mySkipped + myErrors;
        
        if (myFailures == 0 && myErrors == 0) {
            log(GREEN + BOLD + "🥳 🥳 🥳 All tests passed! 🥳 🥳 🥳" + RESET);
            if (mySkipped > 0)
                log("    - " + RESET + BOLD + LIGHT_BLUE + " " + Std.string(mySkipped) + RESET + " " + BOLD + WHITE + "Tests " + RESET + BOLD + LIGHT_BLUE + "Skipped 🤷" + RESET);
        } else {
            log(RED + BOLD + "Final Test Status:" + RESET);
            log("    - " + RESET + BOLD + GREEN + " " + Std.string(mySuccesses) + RESET + " " + BOLD + WHITE + "Tests " + RESET + BOLD + GREEN + "Passed 🥳" + RESET);
            if (myFailures > 0)
                log("    - " + RESET + BOLD + RED + " " + Std.string(myFailures) + RESET + " " + BOLD + WHITE + "Tests " + RESET + BOLD + RED + "Failed 🥺" + RESET);
            if (myErrors > 0)
                log("    - " + RESET + BOLD + YELLOW + " " + Std.string(myErrors) + RESET + " " + BOLD + WHITE + "Tests " + RESET + BOLD + YELLOW + "Errors 💥" + RESET);
            if (mySkipped > 0)
                log("    - " + RESET + BOLD + LIGHT_BLUE + " " + Std.string(mySkipped) + RESET + " " + BOLD + WHITE + "Tests " + RESET + BOLD + LIGHT_BLUE + "Skipped 🤷" + RESET);
        }
        
        log(getTestStatusBar(mySuccesses, myFailures, mySkipped, myErrors));
        log("\n" + CYAN + BOLD + "Total: " + Std.string(total) + " tests in " + Std.string(testNum) + " test methods (" + Std.string(Std.int(elapsed * 100) / 100) + "s)" + RESET);
        
        // Exit with appropriate code
        var exitCode = (myFailures == 0 && myErrors == 0) ? 0 : 1;
        exit(exitCode);
    }

    function getTestStatusBar(successes:Int, failures:Int, skipped:Int, errors:Int):String {
        var consoleWidth = 62;

        var total = successes + failures + skipped + errors;
        if (total == 0) return "";

        var successWidth = Math.ceil((successes / total) * consoleWidth);
        var failureWidth = Math.ceil((failures / total) * consoleWidth);
        var skippedWidth = Math.ceil((skipped / total) * consoleWidth);
        var errorWidth = Math.ceil((errors / total) * consoleWidth);

        // Ensure we fill the bar exactly
        var actualWidth = successWidth + failureWidth + skippedWidth + errorWidth;
        if (actualWidth < consoleWidth) successWidth += (consoleWidth - actualWidth);
        else if (actualWidth > consoleWidth) successWidth -= (actualWidth - consoleWidth);

        var output = "╔";
        for (_ in 0...consoleWidth) output += "═";
        output += "╗\n";

        output += "║" + RESET + BOLD + GREEN_BACKGROUND;
        for (_ in 0...successWidth) output += " ";
        output += RED_BACKGROUND;
        for (_ in 0...failureWidth) output += " ";
        output += LIGHT_BLUE_BACKGROUND;
        for (_ in 0...skippedWidth) output += " ";
        output += YELLOW_BACKGROUND;
        for (_ in 0...errorWidth) output += " ";
        output += RESET + "║\n";

        output += "╚";
        for (_ in 0...consoleWidth) output += "═";
        output += "╝";
        
        return output;
    }
}

package;

import haxe.Timer;

/**
 * Benchmark runner for performance testing.
 * Wraps test functions with timing measurements, tracking best/worst/average times.
 * 
 * Use -D benchmark to enable timing output.
 * Use -D benchmark_iterations=N to change iteration count (default: 5).
 */
class BenchmarkRunner {
    
    public static var iterations:Int = #if benchmark_iterations Std.parseInt(haxe.macro.Compiler.getDefine("benchmark_iterations")) #else 5 #end;
    public static var warmupIterations:Int = 1;
    
    /**
     * Run a function multiple times and measure performance.
     * 
     * @param name Name of the benchmark
     * @param fn Function to benchmark
     * @return BenchmarkResult with timing statistics
     */
    public static function measure<T>(name:String, fn:Void->T):BenchmarkResult {
        var results:Array<Float> = [];
        var best = Math.POSITIVE_INFINITY;
        var worst = 0.0;
        var sum = 0.0;
        var returnValue:T = null;
        
        // Warmup runs (not counted)
        for (i in 0...warmupIterations) {
            fn();
        }
        
        // Measured runs
        for (i in 0...iterations) {
            var start = Timer.stamp();
            returnValue = fn();
            var end = Timer.stamp();
            var elapsed = end - start;
            
            results.push(elapsed);
            sum += elapsed;
            if (elapsed < best) best = elapsed;
            if (elapsed > worst) worst = elapsed;
        }
        
        var avg = sum / iterations;
        
        #if benchmark
        printResult(name, best, worst, avg, iterations);
        #end
        
        return {
            name: name,
            best: best,
            worst: worst,
            average: avg,
            iterations: iterations,
            results: results,
            returnValue: returnValue
        };
    }
    
    /**
     * Run an async function and measure performance.
     * Useful for functions that load images from URLs.
     */
    public static function measureAsync<T>(name:String, fn:(T->Void)->Void, callback:BenchmarkResult->Void):Void {
        var results:Array<Float> = [];
        var best = Math.POSITIVE_INFINITY;
        var worst = 0.0;
        var sum = 0.0;
        var completed = 0;
        var lastValue:T = null;
        
        function runIteration(i:Int) {
            var start = Timer.stamp();
            fn(function(result:T) {
                var end = Timer.stamp();
                var elapsed = end - start;
                
                lastValue = result;
                results.push(elapsed);
                sum += elapsed;
                if (elapsed < best) best = elapsed;
                if (elapsed > worst) worst = elapsed;
                completed++;
                
                if (completed < iterations) {
                    runIteration(completed);
                } else {
                    var avg = sum / iterations;
                    
                    #if benchmark
                    printResult(name, best, worst, avg, iterations);
                    #end
                    
                    callback({
                        name: name,
                        best: best,
                        worst: worst,
                        average: avg,
                        iterations: iterations,
                        results: results,
                        returnValue: lastValue
                    });
                }
            });
        }
        
        runIteration(0);
    }
    
    /**
     * Compare two implementations.
     */
    public static function compare<T>(name1:String, fn1:Void->T, name2:String, fn2:Void->T):ComparisonResult {
        var result1 = measure(name1, fn1);
        var result2 = measure(name2, fn2);
        
        var faster = result1.average < result2.average ? name1 : name2;
        var speedup = if (result1.average < result2.average) {
            result2.average / result1.average;
        } else {
            result1.average / result2.average;
        };
        
        #if benchmark
        Sys.println('');
        Sys.println('=== Comparison ===');
        Sys.println('$faster is ${formatNumber(speedup)}x faster');
        Sys.println('');
        #end
        
        return {
            result1: result1,
            result2: result2,
            faster: faster,
            speedup: speedup
        };
    }
    
    /**
     * Run a suite of benchmarks.
     */
    public static function suite(benchmarks:Array<{name:String, fn:Void->Dynamic}>):Array<BenchmarkResult> {
        #if benchmark
        Sys.println('');
        Sys.println('╔════════════════════════════════════════════════════════════════════╗');
        Sys.println('║                        BENCHMARK SUITE                             ║');
        Sys.println('╠════════════════════════════════════════════════════════════════════╣');
        #end
        
        var results:Array<BenchmarkResult> = [];
        for (b in benchmarks) {
            results.push(measure(b.name, b.fn));
        }
        
        #if benchmark
        Sys.println('╚════════════════════════════════════════════════════════════════════╝');
        Sys.println('');
        #end
        
        return results;
    }
    
    static function printResult(name:String, best:Float, worst:Float, avg:Float, iterations:Int):Void {
        Sys.println('║ $name');
        Sys.println('║   Best:    ${formatTime(best)}');
        Sys.println('║   Worst:   ${formatTime(worst)}');
        Sys.println('║   Average: ${formatTime(avg)} (${iterations} iterations)');
        Sys.println('╟────────────────────────────────────────────────────────────────────╢');
    }
    
    static function formatTime(seconds:Float):String {
        if (seconds < 0.000001) {
            return '${formatNumber(seconds * 1000000000)} ns';
        } else if (seconds < 0.001) {
            return '${formatNumber(seconds * 1000000)} µs';
        } else if (seconds < 1) {
            return '${formatNumber(seconds * 1000)} ms';
        } else {
            return '${formatNumber(seconds)} s';
        }
    }
    
    static function formatNumber(n:Float):String {
        var str = Std.string(Math.round(n * 100) / 100);
        if (str.indexOf(".") == -1) str += ".00";
        while (str.length - str.indexOf(".") < 3) str += "0";
        return str;
    }
}

typedef BenchmarkResult = {
    name:String,
    best:Float,
    worst:Float,
    average:Float,
    iterations:Int,
    results:Array<Float>,
    returnValue:Dynamic
}

typedef ComparisonResult = {
    result1:BenchmarkResult,
    result2:BenchmarkResult,
    faster:String,
    speedup:Float
}

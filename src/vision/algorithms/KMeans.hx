package vision.algorithms;

import vision.exceptions.Unimplemented;
using vision.tools.MathTools;
using vision.tools.ArrayTools;
class KMeans {
    public static function generateClustersUsingConvergence<T>(values:Array<T>, clusterAmount:Int, distanceFunction:(T, T) -> Float, conversionFunction:T -> Float):Array<Array<T>> {
        var clusterCenters = pickElementsAtRandom(values, clusterAmount, true);

        // We don't use clusterAmount in case where the image doesnt have enough distinct colors to satisfy
        // the requested amount
        var clusters = [for (i in 0...clusterCenters.length) new Array<T>()];

        var converged = false;
        while (!converged) {
            for (i in 0... clusters.length) clusters[i] = [];

            for (value in values) {
                var distancesToClusterCenters = [for (j in 0...clusterCenters.length) distanceFunction(value, clusterCenters[j])];
                var smallestDistanceIndex = distancesToClusterCenters.indexOf(distancesToClusterCenters.min());
                clusters[smallestDistanceIndex].push(value);
            }

            var newClusterCenters = [for (array in clusters) array.average(conversionFunction)];
            
        }

        return clusters;
    }


    public static function pickElementsAtRandom<T>(values:Array<T>, amount:Int, distinct:Bool = false):Array<T> {
        if (!distinct) return [for (i in 0...amount) values[(Math.random() * values.length).round()]];

        var result:Array<T> = [];
        while (result.length < amount && values.length != 0) {
            var value = values[(Math.random() * values.length).round()];
            if (result.contains(value)) {
                values.remove(value);
                continue;
            }
            result.push(value);
        }
        return result;
    }
}
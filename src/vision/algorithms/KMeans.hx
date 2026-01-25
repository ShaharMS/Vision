package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.kmeans.ColorCluster;
import vision.exceptions.Unimplemented;

using vision.tools.MathTools;
using vision.tools.ArrayTools;

class KMeans {
	static inline var MAX_ITERATIONS:Int = 1000;

	public static function generateClustersUsingConvergence<T>(values:Array<T>, clusterAmount:Int, distanceFunction:(T, T) -> Float, averageFunction:Array<T>->T):Array<Array<T>> {
		if (values.length == 0) throw "Cannot cluster empty array";
		if (clusterAmount <= 0) throw "Cluster amount must be positive";

		var clusterCenters = pickElementsAtRandom(values.copy(), clusterAmount, true);

		// We don't use clusterAmount in case where the image doesnt have enough distinct colors to satisfy
		// the requested amount
		var clusters = [for (i in 0...clusterCenters.length) new Array<T>()];

		var converged = false;
		var iterations = 0;
		while (!converged) {
			iterations++;
			if (iterations > MAX_ITERATIONS) throw "KMeans failed to converge after " + MAX_ITERATIONS + " iterations";

			for (i in 0...clusters.length)
				clusters[i] = [];

			for (value in values) {
				var distancesToClusterCenters = [for (j in 0...clusterCenters.length) distanceFunction(value, clusterCenters[j])];
				var smallestDistanceIndex = distancesToClusterCenters.indexOf(distancesToClusterCenters.min());
				clusters[smallestDistanceIndex].push(value);
			}

			// Compute new cluster centers, keeping old center if cluster is empty
			var newClusterCenters:Array<T> = [];
			for (i in 0...clusters.length) {
				if (clusters[i].length == 0) {
					newClusterCenters.push(clusterCenters[i]); // Keep old center for empty cluster
				} else {
					newClusterCenters.push(averageFunction(clusters[i]));
				}
			}

			converged = true;
			for (i in 0...newClusterCenters.length) {
				if (distanceFunction(clusterCenters[i], newClusterCenters[i]) > 0.01) converged = false;
			}
			clusterCenters = newClusterCenters;
		}

		return clusters;
	}

	public static function getImageColorClusters(image:Image, clusterAmount:Int = 16):Array<ColorCluster> {
        var imageColors = image.toArray().distinct();
        if (imageColors.length == 0) throw "Cannot cluster image with no colors";

        var clusterCenters = pickElementsAtRandom(imageColors.copy(), clusterAmount, true);

		// We don't use clusterAmount in case where the image doesnt have enough distinct colors to satisfy
		// the requested amount
		var clusters = [for (i in 0...clusterCenters.length) new ColorCluster(clusterCenters[i], [])];

		var converged = false;
		var iterations = 0;
		while (!converged) {
			iterations++;
			if (iterations > MAX_ITERATIONS) throw "KMeans failed to converge after " + MAX_ITERATIONS + " iterations";

            // Reset cluster items
			for (i in 0...clusters.length)
				clusters[i].items = [];

            // Add colors to different clusters, depending on their similarity to the centroid.
			for (color in imageColors) {
				var distancesToClusterCenters = [for (j in 0...clusters.length) Color.distanceBetween(color, clusters[j].centroid)];
				var smallestDistanceIndex = distancesToClusterCenters.indexOf(distancesToClusterCenters.min());
				clusters[smallestDistanceIndex].items.push(color);
			}

            // Recalculate centroids, keeping old centroid if cluster is empty
            converged = true;
            for (cluster in clusters) {
                var oldCentroid = cluster.centroid;
                if (cluster.items.length > 0) {
                    cluster.centroid = Color.getAverage(cluster.items);
                }
                if (Color.distanceBetween(oldCentroid, cluster.centroid) > 0.01) converged = false;
            }
		}

		return clusters;
    }

	public static function pickElementsAtRandom<T>(values:Array<T>, amount:Int, distinct:Bool = false):Array<T> {
		if (values.length == 0) return [];

		// Use floor to avoid index out of bounds (round can produce values.length)
		if (!distinct) return [for (i in 0...amount) values[Std.int(Math.random() * values.length)]];

		var result:Array<T> = [];
		while (result.length < amount && values.length != 0) {
			var idx = Std.int(Math.random() * values.length);
			var value = values[idx];
			if (result.contains(value)) {
				values.remove(value);
				continue;
			}
			result.push(value);
		}
		return result;
	}
}

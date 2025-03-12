package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.kmeans.ColorCluster;
import vision.exceptions.Unimplemented;

using vision.tools.MathTools;
using vision.tools.ArrayTools;

class KMeans {
	public static function generateClustersUsingConvergence<T>(values:Array<T>, clusterAmount:Int, distanceFunction:(T, T) -> Float,
			averageFunction:Array<T>->T):Array<Array<T>> {
		var clusterCenters = pickElementsAtRandom(values, clusterAmount, true);

		// We don't use clusterAmount in case where the image doesnt have enough distinct colors to satisfy
		// the requested amount
		var clusters = [for (i in 0...clusterCenters.length) new Array<T>()];

		var converged = false;
		while (!converged) {
			for (i in 0...clusters.length)
				clusters[i] = [];

			for (value in values) {
				var distancesToClusterCenters = [for (j in 0...clusterCenters.length) distanceFunction(value, clusterCenters[j])];
				var smallestDistanceIndex = distancesToClusterCenters.indexOf(distancesToClusterCenters.min());
				clusters[smallestDistanceIndex].push(value);
			}

			var newClusterCenters = [for (array in clusters) averageFunction(array)];
			converged = true;
			for (i in 0...newClusterCenters.length)
				if (distanceFunction(clusterCenters[i], newClusterCenters[i]) > 0.01) converged = false;
		}

		return clusters;
	}

	public static function getImageColorClusters(image:Image, clusterAmount:Int = 16):Array<ColorCluster> {
        var imageColors = image.toArray().distinct();
        var clusterCenters = pickElementsAtRandom(imageColors, clusterAmount, true);

		// We don't use clusterAmount in case where the image doesnt have enough distinct colors to satisfy
		// the requested amount
		var clusters = [for (i in 0...clusterCenters.length) new ColorCluster(clusterCenters[i], [])];

		var converged = false;
		while (!converged) {
            // Reset cluster items
			for (i in 0...clusters.length)
				clusters[i].items = [];

            // Add colors to different clusters, depending on their similarity to the centroid.
			for (color in imageColors) {
				var distancesToClusterCenters = [for (j in 0...clusters.length) Color.distanceBetween(color, clusters[j].centroid)];
				var smallestDistanceIndex = distancesToClusterCenters.indexOf(distancesToClusterCenters.min());
				clusters[smallestDistanceIndex].items.push(color);
			}

            // Recalculate centroids
            converged = true;
            for (cluster in clusters) {
                var oldCentroid = cluster.centroid;
                cluster.centroid = Color.getAverage(cluster.items);
                if (Color.distanceBetween(oldCentroid, cluster.centroid) > 0.01) converged = false;
            }
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

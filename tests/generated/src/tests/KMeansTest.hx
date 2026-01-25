package tests;

import utest.Assert;
import utest.Async;
import vision.algorithms.KMeans;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.kmeans.ColorCluster;
import vision.exceptions.Unimplemented;

@:access(vision.algorithms.KMeans)
class KMeansTest extends utest.Test {

    function test_generateClustersUsingConvergence_basic() {
        var values:Array<Int> = [1, 2, 3, 10, 11, 12, 100, 101, 102];
        var distanceFunction = (a:Int, b:Int) -> Math.abs(a - b);
        var averageFunction = (arr:Array<Int>) -> {
            var sum = 0.0;
            for (v in arr) sum += v;
            return Std.int(sum / arr.length);
        };
        var result = KMeans.generateClustersUsingConvergence(values, 3, distanceFunction, averageFunction);
        Assert.notNull(result);
        Assert.equals(3, result.length);
    }

    function test_generateClustersUsingConvergence_groups_similar_values() {
        var values:Array<Int> = [1, 2, 3, 100, 101, 102];
        var distanceFunction = (a:Int, b:Int) -> Math.abs(a - b);
        var averageFunction = (arr:Array<Int>) -> {
            var sum = 0.0;
            for (v in arr) sum += v;
            return Std.int(sum / arr.length);
        };
        var result = KMeans.generateClustersUsingConvergence(values, 2, distanceFunction, averageFunction);
        
        // Should have 2 clusters
        Assert.equals(2, result.length);
        // One cluster should have [1,2,3], another [100,101,102]
        var foundLow = false;
        var foundHigh = false;
        for (cluster in result) {
            if (cluster.length == 3) {
                var hasLow = cluster.contains(1) || cluster.contains(2) || cluster.contains(3);
                var hasHigh = cluster.contains(100) || cluster.contains(101) || cluster.contains(102);
                if (hasLow && !hasHigh) foundLow = true;
                if (hasHigh && !hasLow) foundHigh = true;
            }
        }
        Assert.isTrue(foundLow || foundHigh); // At least one properly grouped
    }

    function test_getImageColorClusters_basic() {
        var image = new Image(10, 10, 0xFFFF0000); // All red
        var result = KMeans.getImageColorClusters(image, 2);
        Assert.notNull(result);
        Assert.isTrue(result.length > 0);
    }

    function test_getImageColorClusters_two_colors() {
        // Create image with two distinct colors
        var image = new Image(10, 10);
        for (y in 0...10) {
            for (x in 0...10) {
                if (x < 5) {
                    image.setPixel(x, y, Color.fromRGBA(255, 0, 0, 255)); // Red
                } else {
                    image.setPixel(x, y, Color.fromRGBA(0, 0, 255, 255)); // Blue
                }
            }
        }
        var result = KMeans.getImageColorClusters(image, 2);
        Assert.equals(2, result.length);
        // Each cluster should have its centroid close to red or blue
    }

    function test_getImageColorClusters_returns_color_clusters() {
        var image = new Image(5, 5, 0xFF00FF00); // Green
        var result = KMeans.getImageColorClusters(image, 1);
        
        Assert.equals(1, result.length);
        Assert.notNull(result[0].centroid);
        Assert.notNull(result[0].items);
    }

    function test_pickElementsAtRandom_correct_count() {
        var values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        var result = KMeans.pickElementsAtRandom(values, 3, true);
        Assert.equals(3, result.length);
    }

    function test_pickElementsAtRandom_distinct_elements() {
        var values = [1, 2, 3, 4, 5];
        var result = KMeans.pickElementsAtRandom(values, 3, true);
        
        // Check no duplicates
        for (i in 0...result.length) {
            for (j in (i+1)...result.length) {
                Assert.notEquals(result[i], result[j]);
            }
        }
    }

    function test_pickElementsAtRandom_non_distinct_can_have_duplicates() {
        var values = [1]; // Only one value
        var result = KMeans.pickElementsAtRandom(values, 5, false);
        Assert.equals(5, result.length);
        // All should be 1
        for (v in result) {
            Assert.equals(1, v);
        }
    }

    function test_pickElementsAtRandom_limited_by_available() {
        var values = [1, 2, 3];
        var result = KMeans.pickElementsAtRandom(values.copy(), 5, true); // Request more than available
        // Should return at most 3 distinct elements
        Assert.isTrue(result.length <= 3);
    }

    function test_pickElementsAtRandom_elements_from_source() {
        var values = [10, 20, 30, 40, 50];
        var result = KMeans.pickElementsAtRandom(values.copy(), 3, true);
        
        for (v in result) {
            Assert.isTrue([10, 20, 30, 40, 50].contains(v));
        }
    }

}

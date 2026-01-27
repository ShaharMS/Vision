package tests;

import utest.Assert;
import utest.Async;
import vision.ds.kmeans.ColorCluster;
import vision.ds.Color;

@:access(vision.ds.kmeans.ColorCluster)
class ColorClusterTest extends utest.Test {

    function test_constructor_sets_centroid() {
        var centroid = Color.fromRGBA(128, 64, 32, 255);
        var items:Array<Color> = [];
        var cluster = new ColorCluster(centroid, items);
        Assert.equals(centroid, cluster.centroid);
    }

    function test_constructor_sets_items() {
        var centroid = Color.fromRGBA(128, 64, 32, 255);
        var items:Array<Color> = [
            Color.fromRGBA(100, 50, 25, 255),
            Color.fromRGBA(150, 75, 40, 255)
        ];
        var cluster = new ColorCluster(centroid, items);
        Assert.equals(2, cluster.items.length);
    }

    function test_constructor_empty_items() {
        var centroid = Color.fromRGBA(0, 0, 0, 255);
        var items:Array<Color> = [];
        var cluster = new ColorCluster(centroid, items);
        Assert.equals(0, cluster.items.length);
    }

    function test_centroid_is_mutable() {
        var centroid = Color.fromRGBA(100, 100, 100, 255);
        var cluster = new ColorCluster(centroid, []);
        var newCentroid = Color.fromRGBA(200, 200, 200, 255);
        cluster.centroid = newCentroid;
        Assert.equals(newCentroid, cluster.centroid);
    }

    function test_items_can_be_added() {
        var cluster = new ColorCluster(Color.fromRGBA(0, 0, 0, 255), []);
        cluster.items.push(Color.fromRGBA(255, 0, 0, 255));
        cluster.items.push(Color.fromRGBA(0, 255, 0, 255));
        Assert.equals(2, cluster.items.length);
    }

    function test_items_preserves_color_values() {
        var red = Color.fromRGBA(255, 0, 0, 255);
        var green = Color.fromRGBA(0, 255, 0, 255);
        var blue = Color.fromRGBA(0, 0, 255, 255);
        var cluster = new ColorCluster(red, [red, green, blue]);
        
        Assert.equals(255, cluster.items[0].red);
        Assert.equals(0, cluster.items[0].green);
        Assert.equals(0, cluster.items[0].blue);
        
        Assert.equals(0, cluster.items[1].red);
        Assert.equals(255, cluster.items[1].green);
        
        Assert.equals(0, cluster.items[2].red);
        Assert.equals(0, cluster.items[2].green);
        Assert.equals(255, cluster.items[2].blue);
    }

}

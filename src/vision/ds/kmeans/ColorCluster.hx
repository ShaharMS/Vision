package vision.ds.kmeans;

class ColorCluster {
	public var centroid(default, null):Color;
	public var items(default, null):Array<Color>;

	public function new(centroid:Color, items:Array<Color>) {
        this.centroid = centroid;
        this.items = items;
    }
}

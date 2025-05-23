package vision.ds.kmeans;


class ColorCluster {
	public var centroid:Color;
	public var items:Array<Color>;

	public function new(centroid:Color, items:Array<Color>) {
        this.centroid = centroid;
        this.items = items;
    }
}

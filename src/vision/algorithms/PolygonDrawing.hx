package vision.algorithms;

import vision.ds.Color;
import vision.ds.Image;
import vision.ds.Point2D;
import vision.ds.Polygon;

/** Rasterizes polygon outlines and scanline spans in image coordinates. **/
class PolygonDrawing {
	public static function draw(image:Image, polygon:Polygon, color:Color) {
		drawRing(image, polygon.points, color);
		for (hole in polygon.holes) drawRing(image, hole, color);
	}

	static function drawRing(image:Image, ring:Array<Point2D>, color:Color) {
		if (ring.length == 0) return;
		var previous = ring[ring.length - 1];
		for (current in ring) {
			if (Math.abs(current.x - previous.x) >= Math.abs(current.y - previous.y))
				drawEdge(image, previous.x, previous.y, current.x, current.y, false, color);
			else
				drawEdge(image, previous.y, previous.x, current.y, current.x, true, color);
			previous = current;
		}
	}

	static function drawEdge(image:Image, a:Float, b:Float, c:Float, d:Float, transpose:Bool, color:Color) {
		final length = transpose ? image.height : image.width;
		final start = Math.round(Math.min(length, Math.max(0, Math.min(a, c))));
		final end = Math.round(Math.max(-1, Math.min(length - 1, Math.max(a, c))));
		for (major in start...end + 1) {
			final t = a == c ? 0 : Math.max(0, Math.min(1, (major - a) / (c - a)));
			final minor = b + (d - b) * t;
			final limit = transpose ? image.width : image.height;
			if (minor >= -0.5 && minor < limit - 0.5) {
				final rounded = Math.round(minor);
				image.setPixel(transpose ? rounded : major, transpose ? major : rounded, color);
			}
		}
	}

	public static function fill(image:Image, polygon:Polygon, color:Color) {
		if (polygon.points.length < 3) return;
		var minY = Math.POSITIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;
		for (point in polygon.points) {
			minY = Math.min(minY, point.y);
			maxY = Math.max(maxY, point.y);
		}
		final intersections:Array<Float> = [];
		final top = Math.ceil(Math.min(image.height, Math.max(0, minY - 0.5)));
		final bottom = Math.ceil(Math.max(0, Math.min(image.height, maxY - 0.5)));
		for (y in top...bottom) {
			intersections.resize(0);
			crossings(polygon.points, y + 0.5, intersections);
			for (hole in polygon.holes) crossings(hole, y + 0.5, intersections);
			intersections.sort(function(a, b) return a < b ? -1 : (a > b ? 1 : 0));
			var i = 0;
			while (i + 1 < intersections.length) {
				final left = Math.ceil(Math.min(image.width, Math.max(0, intersections[i] - 0.5)));
				final right = Math.ceil(Math.max(0, Math.min(image.width, intersections[i + 1] - 0.5)));
				for (x in left...right) image.setPixel(x, y, color);
				i += 2;
			}
		}
	}

	static function crossings(ring:Array<Point2D>, y:Float, output:Array<Float>) {
		if (ring.length < 3) return;
		var previous = ring[ring.length - 1];
		for (current in ring) {
			if ((previous.y > y) != (current.y > y))
				output.push(previous.x + (y - previous.y) / (current.y - previous.y) * (current.x - previous.x));
			previous = current;
		}
	}
}

package;

import sys.FileSystem;
import sys.io.File;
import vision.ds.Color;
import vision.ds.Image;
import vision.ds.ImageResizeAlgorithm;
import vision.formats.ImageIO;

using vision.Vision;

/** Creates four PNGs using the regular Image API. **/
class ImageExamples {
	static function main() {
		final args = Sys.args();
		if (args.length != 1) throw "Usage: ImageExamples <output-directory>";

		final directory = args[0];
		FileSystem.createDirectory(directory);

		final original = new Image(96, 64, 0xFF20304A);
		original.fillRect(12, 12, 32, 20, 0xFF54AB92);
		original.drawLine(4, 4, 92, 60, Color.WHITE);
		original.fillRect(64, 16, 20, 20, 0xFFFFAA44);
		save(directory, "original", original);

		final region = original.clone();
		region.setView({
			x: 8,
			y: 8,
			width: 38,
			height: 24
		});
		region.invert();
		region.removeView();
		save(directory, "region", region);

		final preview = original.clone();
		preview.grayscale(true);
		preview.blackAndWhite(128);
		save(directory, "threshold", preview);

		var small = original.clone();
		small = small.resize(48, -1, ImageResizeAlgorithm.NearestNeighbor);
		save(directory, "small", small);
	}

	static function save(directory:String, name:String, image:Image):Void {
		File.saveBytes('$directory/$name.png', ImageIO.to.bytes.png(image));
	}
}

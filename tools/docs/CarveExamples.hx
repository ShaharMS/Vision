package;

import sys.io.File;
import sys.FileSystem;
import vision.Vision;
import vision.formats.ImageIO;

/** Reproduce the documentation images using the public API, not another implementation. **/
class CarveExamples {
	static function main() {
		var args = Sys.args();
		if (args.length != 2) throw "Usage: CarveExamples <valve-original.png> <output-directory>";
		var image = ImageIO.from.bytes.png(File.getBytes(args[0]));
		FileSystem.createDirectory(args[1]);
		var narrowWidth = Std.int(image.width * 0.75);
		var shortHeight = Std.int(image.height * 0.75);
		File.saveBytes(args[1] + "/valve-carve-width.png", ImageIO.to.bytes.png(Vision.carve(image, narrowWidth, image.height)));
		File.saveBytes(args[1] + "/valve-carve-height.png", ImageIO.to.bytes.png(Vision.carve(image, image.width, shortHeight)));
		Sys.println('Original: ${image.width}x${image.height}; width: ${narrowWidth}x${image.height}; height: ${image.width}x${shortHeight}');
	}
}

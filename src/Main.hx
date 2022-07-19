package;

import vision.ds.Point2D;
import vision.ds.Line2D;
import haxe.display.Display.Package;
#if js
import js.html.Document;
import js.Browser;
#end
import vision.algorithms.HoughTransform;
import vision.Vision;
import vision.ds.Image;

class Main {
	static function main() {
		var image = new Image(300, 300, 0x000000);
		image.drawLine(12, 53, 54, 15, 0xffffff);
		image.drawLine(56, 271, 181, 95, 0xffffff);
		image.drawLine(110, 15, 221, 231, 0xffffff);
		Vision.blackAndWhite(image);
		printIm(image);
		var hough = HoughTransform.toHoughSpace(image);
		printIm(hough);
	}

	static function printIm(image:Image) {
		#if js
		var c = Browser.document.createCanvasElement();
		c.width = image.width;
		c.height = image.height;
		var ctx = c.getContext2d();
		var imageData = ctx.getImageData(0, 0, image.width, image.height);
		var data = imageData.data;
		for (x in 0...image.width) {
			for (y in 0...image.height) {
				var i = (y * image.width + x) * 4;
				data[i] = image.getPixel(x, y).red;
				data[i + 1] = image.getPixel(x, y).green;
				data[i + 2] = image.getPixel(x, y).blue;
				data[i + 3] = 255;
			}
		}
		ctx.putImageData(imageData, 0, 0);
		c.style.padding = "10px";
		Browser.document.body.appendChild(c);
		#end
	}
}
